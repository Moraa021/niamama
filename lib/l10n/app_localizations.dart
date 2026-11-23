import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sw.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('sw')
  ];

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navTimeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get navTimeline;

  /// No description provided for @navCareMap.
  ///
  /// In en, this message translates to:
  /// **'Care Map'**
  String get navCareMap;

  /// No description provided for @navSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get navSupport;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the app language for this mother\'s profile'**
  String get languageSubtitle;

  /// No description provided for @dailyCareTrackers.
  ///
  /// In en, this message translates to:
  /// **'Daily Care Trackers'**
  String get dailyCareTrackers;

  /// No description provided for @wetDiapers.
  ///
  /// In en, this message translates to:
  /// **'Wet diapers'**
  String get wetDiapers;

  /// No description provided for @soiledDiapers.
  ///
  /// In en, this message translates to:
  /// **'Soiled diapers'**
  String get soiledDiapers;

  /// No description provided for @waterGlasses.
  ///
  /// In en, this message translates to:
  /// **'Mama\'s water (glasses)'**
  String get waterGlasses;

  /// No description provided for @wetDiaperGoal.
  ///
  /// In en, this message translates to:
  /// **'Aim for {target}+ heavy wet diapers per 24 hours.'**
  String wetDiaperGoal(int target);

  /// No description provided for @wetDiaperGood.
  ///
  /// In en, this message translates to:
  /// **'Great: {count} wet diapers today shows good milk intake.'**
  String wetDiaperGood(int count);

  /// No description provided for @partnerModeButton.
  ///
  /// In en, this message translates to:
  /// **'Partner Mode: How to Help Right Now'**
  String get partnerModeButton;

  /// No description provided for @partnerTitle.
  ///
  /// In en, this message translates to:
  /// **'How to Help Right Now'**
  String get partnerTitle;

  /// No description provided for @partnerBriefingTitle.
  ///
  /// In en, this message translates to:
  /// **'30-second briefing'**
  String get partnerBriefingTitle;

  /// No description provided for @partnerChecklistTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s support checklist ({done}/{total})'**
  String partnerChecklistTitle(int done, int total);

  /// No description provided for @redFlagTitle.
  ///
  /// In en, this message translates to:
  /// **'Red-flag watchlist'**
  String get redFlagTitle;

  /// No description provided for @redFlagCall.
  ///
  /// In en, this message translates to:
  /// **'If you notice any of these, call the maternal helpline 1190 or go to the nearest facility now.'**
  String get redFlagCall;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @partnerTaskWater.
  ///
  /// In en, this message translates to:
  /// **'Refill a 1L water bottle at the nursing station'**
  String get partnerTaskWater;

  /// No description provided for @partnerTaskSleep.
  ///
  /// In en, this message translates to:
  /// **'Protect Mama\'s 4-hour unbroken sleep block'**
  String get partnerTaskSleep;

  /// No description provided for @partnerTaskBurp.
  ///
  /// In en, this message translates to:
  /// **'Handle burping & diaper change after each feed'**
  String get partnerTaskBurp;

  /// No description provided for @partnerTaskMeal.
  ///
  /// In en, this message translates to:
  /// **'Prepare a warm meal and a snack she can eat one-handed'**
  String get partnerTaskMeal;

  /// No description provided for @partnerTaskNight.
  ///
  /// In en, this message translates to:
  /// **'Take one night feed handover (bring baby, then settle baby)'**
  String get partnerTaskNight;

  /// No description provided for @partnerTaskVisitors.
  ///
  /// In en, this message translates to:
  /// **'Gently manage visitors so Mama can rest'**
  String get partnerTaskVisitors;

  /// No description provided for @redFlag1.
  ///
  /// In en, this message translates to:
  /// **'Severe headache that will not go away, or blurred vision (possible postpartum pre-eclampsia)'**
  String get redFlag1;

  /// No description provided for @redFlag2.
  ///
  /// In en, this message translates to:
  /// **'Soaking a pad in under an hour, or passing large clots (heavy bleeding)'**
  String get redFlag2;

  /// No description provided for @redFlag3.
  ///
  /// In en, this message translates to:
  /// **'Fever of 38°C or higher, or foul-smelling discharge'**
  String get redFlag3;

  /// No description provided for @redFlag4.
  ///
  /// In en, this message translates to:
  /// **'Chest pain, trouble breathing, or one swollen painful leg'**
  String get redFlag4;

  /// No description provided for @redFlag5.
  ///
  /// In en, this message translates to:
  /// **'Hopelessness, withdrawal, not eating, or talk of self-harm (needs support today)'**
  String get redFlag5;

  /// No description provided for @briefingEarly.
  ///
  /// In en, this message translates to:
  /// **'Week {week}. The first two weeks are the hardest: {baby} feeds very often and {mama} is recovering from birth. Your job right now: take the load off, so she can feed, heal and sleep.'**
  String briefingEarly(int week, String baby, String mama);

  /// No description provided for @briefingMid.
  ///
  /// In en, this message translates to:
  /// **'Week {week}. {baby} is feeding very often (cluster feeding is normal) and {mama}\'s body is still healing, so she is tired and her mood can swing. Your job right now: take the load off, so she can feed, heal and sleep.'**
  String briefingMid(int week, String baby, String mama);

  /// No description provided for @briefingLate.
  ///
  /// In en, this message translates to:
  /// **'Week {week}. {baby} is settling into a rhythm, but {mama} is still recovering and may be running on little sleep. Your job right now: take the load off, so she can feed, heal and sleep.'**
  String briefingLate(int week, String baby, String mama);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'sw'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sw':
      return AppLocalizationsSw();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
