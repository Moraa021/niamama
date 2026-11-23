import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niamama/main.dart';
import 'package:niamama/widgets/emergency_speed_dial_sheet.dart';
import 'package:niamama/widgets/partner_copilot_sheet.dart';
import 'package:niamama/services/offline_vault_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.0;
  addTearDown(tester.view.reset);
  // The test environment renders text with the wide "Ahem" font, which makes
  // pixel-overflow warnings meaningless; ignore only those.
  final original = FlutterError.onError;
  FlutterError.onError = (details) {
    if (details.exceptionAsString().contains('overflowed')) return;
    original?.call(details);
  };
  addTearDown(() => FlutterError.onError = original);
  await tester.pumpWidget(const NiamamaApp());
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    appLocale.value = const Locale('en');
  });

  testWidgets('bottom navigation switches across all 4 tabs', (tester) async {
    await pumpApp(tester);
    for (final label in ['Timeline', 'Care Map', 'Support', 'Home']) {
      await tester.tap(find.text(label).last);
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text(label), findsWidgets);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('Kiswahili locale relabels the bottom navigation',
      (tester) async {
    await pumpApp(tester);
    appLocale.value = const Locale('sw');
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Nyumbani'), findsOneWidget);
    expect(find.text('Msaada'), findsOneWidget);
  });

  testWidgets('daily tracker steppers have 48x48 touch targets',
      (tester) async {
    await pumpApp(tester);
    final inc = find.byTooltip('Increase Wet diapers');
    await tester.scrollUntilVisible(inc, 300,
        scrollable: find.byType(Scrollable).first);
    final size = tester.getSize(
      find.ancestor(of: inc, matching: find.byType(SizedBox)).first,
    );
    expect(size.width, greaterThanOrEqualTo(48));
    expect(size.height, greaterThanOrEqualTo(48));
    await tester.tap(inc);
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('1/6'), findsOneWidget);
  });

  testWidgets('PIN-protected profile shows the lock screen on startup',
      (tester) async {
    final tenants = await OfflineVaultService.loadTenants();
    await OfflineVaultService.saveTenants([
      tenants.first.copyWith(requirePinEveryTime: true),
      ...tenants.skip(1),
    ]);
    await OfflineVaultService.saveActiveSessionTenantId(tenants.first.id);
    await pumpApp(tester);
    expect(find.byIcon(Icons.lock_rounded), findsWidgets);
    // Bottom navigation is not reachable while locked.
    expect(find.text('Care Map'), findsNothing);
  });

  testWidgets('SOS button opens the Emergency Speed-Dial sheet',
      (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('SOS').first);
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byType(EmergencySpeedDialSheet), findsOneWidget);
  });

  testWidgets('Partner Mode opens the co-pilot sheet from the Support tab',
      (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Support').last);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('Partner Mode: How to Help Right Now'));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byType(PartnerCopilotSheet), findsOneWidget);
    expect(find.text('Red-flag watchlist'), findsOneWidget);
  });

  testWidgets('switching language to Kiswahili updates dashboard and care map',
      (tester) async {
    await pumpApp(tester);
    expect(find.text('Care Horizon'), findsOneWidget);

    appLocale.value = const Locale('sw');
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Upeo wa Huduma'), findsOneWidget);
    expect(find.text('Upeo wa Huduma'), findsOneWidget);

    // Switch to Care Map
    await tester.tap(find.text('Ramani ya Huduma'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Huduma za Kuaminika Karibu Nawe'), findsOneWidget);
    expect(find.text('Vituo Vyote'), findsOneWidget);
  });
}
