import 'package:flutter_test/flutter_test.dart';
import 'package:niamama/models/niamama_models.dart';
import 'package:niamama/services/neo4j_knowledge_service.dart';
import 'package:niamama/services/offline_vault_service.dart';
import 'package:niamama/services/triage_translations_sw.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test(
    'Multi-tenant isolation: two mothers have completely independent offline vaults',
    () async {
      final tenants = await OfflineVaultService.loadTenants();
      expect(tenants.length, greaterThanOrEqualTo(2));

      final amara = tenants[0]; // tenant-amara (Baby Leo)
      final wanjiku = tenants[1]; // tenant-wanjiku (Baby Zuri)

      // Load initial states for both mothers
      final amaraInitial = await OfflineVaultService.loadState(tenant: amara);
      final wanjikuInitial =
          await OfflineVaultService.loadState(tenant: wanjiku);

      expect(amaraInitial.smileMemoriesCount, 1);
      expect(wanjikuInitial.smileMemoriesCount, 3);

      // Amara logs a new feed and increments smile memories to 9
      final amaraUpdated = amaraInitial.copyWith(
        smileMemoriesCount: 9,
        lastMood: 'resting',
      );
      await OfflineVaultService.saveState(amaraUpdated, tenantId: amara.id);

      // Reload both vaults and verify Wanjiku's data was untouched
      final amaraReloaded = await OfflineVaultService.loadState(tenant: amara);
      final wanjikuReloaded =
          await OfflineVaultService.loadState(tenant: wanjiku);

      expect(amaraReloaded.smileMemoriesCount, 9);
      expect(amaraReloaded.lastMood, 'resting');
      expect(wanjikuReloaded.smileMemoriesCount, 3);
      expect(wanjikuReloaded.lastMood, isNull);
    },
  );

  test(
    'Session persistence & PIN requirement toggle persist across restarts',
    () async {
      final tenants = await OfflineVaultService.loadTenants();
      final amara = tenants.first;

      // Save Amara as the active logged-in session
      await OfflineVaultService.saveActiveSessionTenantId(amara.id);
      expect(await OfflineVaultService.loadActiveSessionTenantId(), amara.id);

      // Enable "Require PIN on every access" for Amara
      final updatedAmara =
          amara.copyWith(requirePinEveryTime: true, pinCode: '4321');
      await OfflineVaultService.saveTenants([updatedAmara, tenants[1]]);

      final reloadedTenants = await OfflineVaultService.loadTenants();
      expect(reloadedTenants.first.requirePinEveryTime, isTrue);
      expect(reloadedTenants.first.pinCode, isNot('4321'));
      expect(reloadedTenants.first.verifyPin('4321'), isTrue);
      expect(reloadedTenants.first.verifyPin('0000'), isFalse);
    },
  );

  test(
    'Neo4j Grounded Intelligence returns WHO-cited clinical guidance & triage pathways',
    () async {
      expect(Neo4jKnowledgeGraphService.clinicalTriageGraph.length, 6);
      expect(Neo4jKnowledgeGraphService.careGuidesGraph.length, 3);

      final guidance =
          await Neo4jKnowledgeGraphService.queryGroundedMidwifeGuidance(
        topics: ['Feeding / Latch'],
        userText: 'Baby has fever 38.5',
        mamaFirstName: 'Amara',
        babyName: 'Leo',
      );

      expect(guidance.replyText, contains('URGENT ER'));
      expect(guidance.replyText, contains('WHO-IMCI-2024'));
      expect(guidance.cypherCitation, contains(':Symptom'));
    },
  );

  test('Daily diaper/water trackers and partner checklist persist per tenant',
      () async {
    final tenants = await OfflineVaultService.loadTenants();
    final amara = tenants[0];
    final wanjiku = tenants[1];

    final base = await OfflineVaultService.loadState(tenant: amara);
    await OfflineVaultService.saveState(
      base.copyWith(
        wetDiapers: 6,
        soiledDiapers: 2,
        waterGlasses: 5,
        partnerChecklist: {'water': true},
      ),
      tenantId: amara.id,
    );

    final reloaded = await OfflineVaultService.loadState(tenant: amara);
    expect(reloaded.wetDiapers, 6);
    expect(reloaded.soiledDiapers, 2);
    expect(reloaded.waterGlasses, 5);
    expect(reloaded.partnerChecklist['water'], isTrue);

    final other = await OfflineVaultService.loadState(tenant: wanjiku);
    expect(other.wetDiapers, 0);
    expect(other.partnerChecklist, isEmpty);
  });

  test('Daily trackers reset on a new calendar day', () async {
    final amara = (await OfflineVaultService.loadTenants())[0];
    final base = await OfflineVaultService.loadState(tenant: amara);
    await OfflineVaultService.saveState(
      base.copyWith(wetDiapers: 7, countsDate: '2000-01-01'),
      tenantId: amara.id,
    );
    final reloaded = await OfflineVaultService.loadState(tenant: amara);
    expect(reloaded.wetDiapers, 0);
    expect(reloaded.countsDate, NiamamaState.todayKey());
  });

  test('All 6 core triage pathways have Kiswahili translations', () {
    final nodes = Neo4jKnowledgeGraphService.clinicalTriageGraph.take(6);
    for (final n in nodes) {
      expect(triageTranslationsSw.containsKey(n.id), isTrue, reason: n.id);
      final sw = localizeTriageNode(n, 'sw');
      expect(sw.symptomTitle, isNot(n.symptomTitle));
      expect(sw.immediateActions.length, n.immediateActions.length);
      expect(sw.whoCitationCode, n.whoCitationCode); // clinical code unchanged
      expect(localizeTriageNode(n, 'en').symptomTitle, n.symptomTitle);
    }
  });

  test('Tenant language preference persists per tenant', () async {
    final tenants = await OfflineVaultService.loadTenants();
    expect(tenants[0].languageCode, 'en');
    await OfflineVaultService.saveTenants(
      [tenants[0].copyWith(languageCode: 'sw'), tenants[1]],
    );
    final reloaded = await OfflineVaultService.loadTenants();
    expect(reloaded[0].languageCode, 'sw');
    expect(reloaded[1].languageCode, 'en');
  });
}
