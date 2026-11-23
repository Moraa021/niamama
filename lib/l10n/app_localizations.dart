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

  /// No description provided for @gpsLive.
  ///
  /// In en, this message translates to:
  /// **'GPS Live'**
  String get gpsLive;

  /// No description provided for @offlineReady.
  ///
  /// In en, this message translates to:
  /// **'Offline Ready'**
  String get offlineReady;

  /// No description provided for @sosButton.
  ///
  /// In en, this message translates to:
  /// **'SOS'**
  String get sosButton;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

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

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name}'**
  String goodMorning(String name);

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon, {name}'**
  String goodAfternoon(String name);

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening, {name}'**
  String goodEvening(String name);

  /// No description provided for @howAreYouFeeling.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling right now?'**
  String get howAreYouFeeling;

  /// No description provided for @moodResting.
  ///
  /// In en, this message translates to:
  /// **'Resting OK'**
  String get moodResting;

  /// No description provided for @moodTired.
  ///
  /// In en, this message translates to:
  /// **'A Bit Tired'**
  String get moodTired;

  /// No description provided for @moodMidwife.
  ///
  /// In en, this message translates to:
  /// **'Ask Midwife'**
  String get moodMidwife;

  /// No description provided for @dailyBreathTitle.
  ///
  /// In en, this message translates to:
  /// **'DAILY BREATH'**
  String get dailyBreathTitle;

  /// No description provided for @dailyBreathQuote.
  ///
  /// In en, this message translates to:
  /// **'“You are doing enough today. Every feed, cuddle, and quiet breath matters.”'**
  String get dailyBreathQuote;

  /// No description provided for @careHorizon.
  ///
  /// In en, this message translates to:
  /// **'Care Horizon'**
  String get careHorizon;

  /// No description provided for @sixWeeksReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'6-Week Postnatal Review'**
  String get sixWeeksReviewTitle;

  /// No description provided for @sixWeeksReviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'WHO Recommended Maternal Checkup'**
  String get sixWeeksReviewSubtitle;

  /// No description provided for @sixWeeksReviewDesc.
  ///
  /// In en, this message translates to:
  /// **'Uterine involution, mood screening, and pelvic healing assessment.'**
  String get sixWeeksReviewDesc;

  /// No description provided for @babyVaccinesHorizonTitle.
  ///
  /// In en, this message translates to:
  /// **'Baby {babyName} 6-Week Immunizations'**
  String babyVaccinesHorizonTitle(String babyName);

  /// No description provided for @babyVaccinesHorizonSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Penta 1, PCV 1, OPV 1, Rotavirus 1'**
  String get babyVaccinesHorizonSubtitle;

  /// No description provided for @babyVaccinesHorizonDesc.
  ///
  /// In en, this message translates to:
  /// **'Gentle protection boosters for tiny lungs, digestion, and resilience.'**
  String get babyVaccinesHorizonDesc;

  /// No description provided for @lastFeed.
  ///
  /// In en, this message translates to:
  /// **'Last Feed'**
  String get lastFeed;

  /// No description provided for @log.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get log;

  /// No description provided for @essentialCareSupport.
  ///
  /// In en, this message translates to:
  /// **'Essential Care & Support'**
  String get essentialCareSupport;

  /// No description provided for @whenToSeeDoctor.
  ///
  /// In en, this message translates to:
  /// **'When to See Doctor'**
  String get whenToSeeDoctor;

  /// No description provided for @whenToSeeDoctorDesc.
  ///
  /// In en, this message translates to:
  /// **'WHO Red-Flag Triage Guidance'**
  String get whenToSeeDoctorDesc;

  /// No description provided for @pediatricCenters.
  ///
  /// In en, this message translates to:
  /// **'Pediatric Centers'**
  String get pediatricCenters;

  /// No description provided for @pediatricCentersDesc.
  ///
  /// In en, this message translates to:
  /// **'Emergency Wings & Child Welfare'**
  String get pediatricCentersDesc;

  /// No description provided for @talkWithMidwife.
  ///
  /// In en, this message translates to:
  /// **'Talk with a Midwife'**
  String get talkWithMidwife;

  /// No description provided for @talkWithMidwifeDesc.
  ///
  /// In en, this message translates to:
  /// **'Safe, Confidential & Offline'**
  String get talkWithMidwifeDesc;

  /// No description provided for @whoVaccineCard.
  ///
  /// In en, this message translates to:
  /// **'WHO Vaccine Card'**
  String get whoVaccineCard;

  /// No description provided for @whoVaccineCardDesc.
  ///
  /// In en, this message translates to:
  /// **'Digital Immunization Pass'**
  String get whoVaccineCardDesc;

  /// No description provided for @nearestReadyFacility.
  ///
  /// In en, this message translates to:
  /// **'NEAREST READY FACILITY'**
  String get nearestReadyFacility;

  /// No description provided for @callMidwifeTriage.
  ///
  /// In en, this message translates to:
  /// **'Call Midwife Triage Desk'**
  String get callMidwifeTriage;

  /// No description provided for @viewRouteNav.
  ///
  /// In en, this message translates to:
  /// **'View Route & Navigation'**
  String get viewRouteNav;

  /// No description provided for @communityWisdom.
  ///
  /// In en, this message translates to:
  /// **'Community Wisdom • Tap to Read Guide'**
  String get communityWisdom;

  /// No description provided for @firstSmileMilestone.
  ///
  /// In en, this message translates to:
  /// **'First smile milestones: What to notice at 6 to 8 weeks'**
  String get firstSmileMilestone;

  /// No description provided for @quickFeedLoggerTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Feed & Sleep Logger'**
  String get quickFeedLoggerTitle;

  /// No description provided for @quickFeedLoggerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Single-hand nursing tracker • Saved offline'**
  String get quickFeedLoggerSubtitle;

  /// No description provided for @nursingSide.
  ///
  /// In en, this message translates to:
  /// **'Nursing Side'**
  String get nursingSide;

  /// No description provided for @nursingDuration.
  ///
  /// In en, this message translates to:
  /// **'Nursing Duration'**
  String get nursingDuration;

  /// No description provided for @minutesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} mins'**
  String minutesCount(int count);

  /// No description provided for @sleepStretch.
  ///
  /// In en, this message translates to:
  /// **'Baby {babyName} Sleep Stretch'**
  String sleepStretch(String babyName);

  /// No description provided for @hoursMins.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {mins}m'**
  String hoursMins(int hours, int mins);

  /// No description provided for @saveToOfflineVault.
  ///
  /// In en, this message translates to:
  /// **'Save to Offline Vault'**
  String get saveToOfflineVault;

  /// No description provided for @leftSide.
  ///
  /// In en, this message translates to:
  /// **'Left Side'**
  String get leftSide;

  /// No description provided for @rightSide.
  ///
  /// In en, this message translates to:
  /// **'Right Side'**
  String get rightSide;

  /// No description provided for @facilityDistDrive.
  ///
  /// In en, this message translates to:
  /// **'{dist} km away • Approx. {mins} mins drive'**
  String facilityDistDrive(String dist, int mins);

  /// No description provided for @open247LowWait.
  ///
  /// In en, this message translates to:
  /// **'Open 24/7 • Low Wait'**
  String get open247LowWait;

  /// No description provided for @securityVaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Private Maternal Vault'**
  String get securityVaultTitle;

  /// No description provided for @securityVaultDescription.
  ///
  /// In en, this message translates to:
  /// **'Your nursing logs, vaccines, calendar reminders, emergency speed-dial contacts, and midwife chats are stored privately in your personal encrypted session.'**
  String get securityVaultDescription;

  /// No description provided for @requirePinTitle.
  ///
  /// In en, this message translates to:
  /// **'Require PIN on Every Access'**
  String get requirePinTitle;

  /// No description provided for @requirePinSubtitleOn.
  ///
  /// In en, this message translates to:
  /// **'ON: You will be asked for your 4-digit PIN every time you open or resume Niamama.'**
  String get requirePinSubtitleOn;

  /// No description provided for @requirePinSubtitleOff.
  ///
  /// In en, this message translates to:
  /// **'OFF: Your login session stays saved so you open straight to your dashboard.'**
  String get requirePinSubtitleOff;

  /// No description provided for @securityPinTitle.
  ///
  /// In en, this message translates to:
  /// **'4-digit PIN'**
  String get securityPinTitle;

  /// No description provided for @securityPinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Used to unlock your maternal vault and sensitive records'**
  String get securityPinSubtitle;

  /// No description provided for @changePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePin;

  /// No description provided for @savePin.
  ///
  /// In en, this message translates to:
  /// **'Save PIN'**
  String get savePin;

  /// No description provided for @lockVaultNow.
  ///
  /// In en, this message translates to:
  /// **'Lock Vault Now'**
  String get lockVaultNow;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @enterNewPinHint.
  ///
  /// In en, this message translates to:
  /// **'Enter new 4-digit numeric PIN'**
  String get enterNewPinHint;

  /// No description provided for @whoCard.
  ///
  /// In en, this message translates to:
  /// **'WHO Card'**
  String get whoCard;

  /// No description provided for @childProfileActive.
  ///
  /// In en, this message translates to:
  /// **'Child profile active: Baby {babyName} ({weeks} weeks)'**
  String childProfileActive(String babyName, int weeks);

  /// No description provided for @nextStepInDays.
  ///
  /// In en, this message translates to:
  /// **'Next Step in {days} Days'**
  String nextStepInDays(int days);

  /// No description provided for @sixWeekImmunizations.
  ///
  /// In en, this message translates to:
  /// **'6-Week Immunizations'**
  String get sixWeekImmunizations;

  /// No description provided for @sixWeekImmDesc.
  ///
  /// In en, this message translates to:
  /// **'Gentle protection boosters for tiny lungs, digestion, and resilience.'**
  String get sixWeekImmDesc;

  /// No description provided for @tummyTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Tummy Time & Social Smiles'**
  String get tummyTimeTitle;

  /// No description provided for @tummyTimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Building neck strength and connection'**
  String get tummyTimeSubtitle;

  /// No description provided for @tummyTimeWindow.
  ///
  /// In en, this message translates to:
  /// **'Week {week} Window'**
  String tummyTimeWindow(int week);

  /// No description provided for @startTummyTimer.
  ///
  /// In en, this message translates to:
  /// **'Start 2-Min Timer'**
  String get startTummyTimer;

  /// No description provided for @pauseTimer.
  ///
  /// In en, this message translates to:
  /// **'Pause Timer'**
  String get pauseTimer;

  /// No description provided for @captureSmileMemory.
  ///
  /// In en, this message translates to:
  /// **'Capture First Smile Memory'**
  String get captureSmileMemory;

  /// No description provided for @smilesLogged.
  ///
  /// In en, this message translates to:
  /// **'{count} Smiles Logged'**
  String smilesLogged(int count);

  /// No description provided for @cuesToNotice.
  ///
  /// In en, this message translates to:
  /// **'Cues {babyName} is trying to engage:'**
  String cuesToNotice(String babyName);

  /// No description provided for @cueGaze.
  ///
  /// In en, this message translates to:
  /// **'Bright, wide-eyed gaze'**
  String get cueGaze;

  /// No description provided for @cueMouth.
  ///
  /// In en, this message translates to:
  /// **'Softening mouth & opening lips'**
  String get cueMouth;

  /// No description provided for @cueBrows.
  ///
  /// In en, this message translates to:
  /// **'Relaxed brows & turning toward voice'**
  String get cueBrows;

  /// No description provided for @immunizationTimeline.
  ///
  /// In en, this message translates to:
  /// **'Immunization Timeline'**
  String get immunizationTimeline;

  /// No description provided for @globalStandard.
  ///
  /// In en, this message translates to:
  /// **'Global Standard'**
  String get globalStandard;

  /// No description provided for @birthDosesTitle.
  ///
  /// In en, this message translates to:
  /// **'Birth Doses (Week 0)'**
  String get birthDosesTitle;

  /// No description provided for @birthDosesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Given at delivery facility'**
  String get birthDosesSubtitle;

  /// No description provided for @week6DosesTitle.
  ///
  /// In en, this message translates to:
  /// **'Week 6 Doses'**
  String get week6DosesTitle;

  /// No description provided for @week6DosesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Primary immunization series'**
  String get week6DosesSubtitle;

  /// No description provided for @week10DosesTitle.
  ///
  /// In en, this message translates to:
  /// **'Week 10 Boosters'**
  String get week10DosesTitle;

  /// No description provided for @week10DosesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Second round of protection'**
  String get week10DosesSubtitle;

  /// No description provided for @week14DosesTitle.
  ///
  /// In en, this message translates to:
  /// **'Week 14 Doses'**
  String get week14DosesTitle;

  /// No description provided for @week14DosesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Final infant foundation series'**
  String get week14DosesSubtitle;

  /// No description provided for @comfortTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Comfort tips for {babyName}'**
  String comfortTipsTitle(String babyName);

  /// No description provided for @tipBreastfeed.
  ///
  /// In en, this message translates to:
  /// **'Breastfeed right after shots for natural pain relief'**
  String get tipBreastfeed;

  /// No description provided for @tipSkinToSkin.
  ///
  /// In en, this message translates to:
  /// **'Hold skin-to-skin upright to regulate heart rate'**
  String get tipSkinToSkin;

  /// No description provided for @tipCoolCloth.
  ///
  /// In en, this message translates to:
  /// **'Apply a clean, cool damp cloth if thigh feels warm'**
  String get tipCoolCloth;

  /// No description provided for @trustedCareNearYou.
  ///
  /// In en, this message translates to:
  /// **'Trusted Care Near You'**
  String get trustedCareNearYou;

  /// No description provided for @trustedCareSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Verified maternal wings, neonatal care, and gentle walk-in clinics.'**
  String get trustedCareSubtitle;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All Facilities'**
  String get filterAll;

  /// No description provided for @filterMaternity.
  ///
  /// In en, this message translates to:
  /// **'24/7 Maternity'**
  String get filterMaternity;

  /// No description provided for @filterPediatric.
  ///
  /// In en, this message translates to:
  /// **'Pediatric Wings'**
  String get filterPediatric;

  /// No description provided for @filterVaccine.
  ///
  /// In en, this message translates to:
  /// **'Vaccine Clinics'**
  String get filterVaccine;

  /// No description provided for @filterMidwife.
  ///
  /// In en, this message translates to:
  /// **'Midwife Run'**
  String get filterMidwife;

  /// No description provided for @filterPharmacy.
  ///
  /// In en, this message translates to:
  /// **'24h Chemists'**
  String get filterPharmacy;

  /// No description provided for @allowGps.
  ///
  /// In en, this message translates to:
  /// **'Allow GPS'**
  String get allowGps;

  /// No description provided for @locatingGps.
  ///
  /// In en, this message translates to:
  /// **'Locating GPS...'**
  String get locatingGps;

  /// No description provided for @emergencyGuidanceTitle.
  ///
  /// In en, this message translates to:
  /// **'When to seek immediate emergency care'**
  String get emergencyGuidanceTitle;

  /// No description provided for @emergencyInstinctQuote.
  ///
  /// In en, this message translates to:
  /// **'You know your baby best. If you ever feel uneasy, trust your maternal instinct—care teams are here without judgment.'**
  String get emergencyInstinctQuote;

  /// No description provided for @openEmergencySpeedDialSos.
  ///
  /// In en, this message translates to:
  /// **'Open Emergency Speed-Dial & GPS SOS'**
  String get openEmergencySpeedDialSos;

  /// No description provided for @lateNightPharmaciesTitle.
  ///
  /// In en, this message translates to:
  /// **'Looking for late-night pharmacies?'**
  String get lateNightPharmaciesTitle;

  /// No description provided for @lateNightPharmaciesDesc.
  ///
  /// In en, this message translates to:
  /// **'We have mapped verified 24-hour chemists stocking infant rehydration, sterile water, and pump supplies.'**
  String get lateNightPharmaciesDesc;

  /// No description provided for @viewOpenChemists.
  ///
  /// In en, this message translates to:
  /// **'View Open Chemists'**
  String get viewOpenChemists;

  /// No description provided for @callHelpline.
  ///
  /// In en, this message translates to:
  /// **'Call 24/7 National Maternal Helpline (Free)'**
  String get callHelpline;

  /// No description provided for @supportCircleTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Support Circle'**
  String get supportCircleTitle;

  /// No description provided for @supportCircleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have to navigate postpartum alone. Your midwives, fellow mothers, and care team are right here with you.'**
  String get supportCircleSubtitle;

  /// No description provided for @midwifeSarahTitle.
  ///
  /// In en, this message translates to:
  /// **'Registered Midwife Sarah'**
  String get midwifeSarahTitle;

  /// No description provided for @midwifeOnline.
  ///
  /// In en, this message translates to:
  /// **'Online now • Typical reply < 5 mins'**
  String get midwifeOnline;

  /// No description provided for @free247.
  ///
  /// In en, this message translates to:
  /// **'Free • 24/7'**
  String get free247;

  /// No description provided for @midwifeSarahQuote.
  ///
  /// In en, this message translates to:
  /// **'“Thinking about late-night feeding pain, healing changes, or baby sleep cues? No question is too small or silly. We are here to listen.”'**
  String get midwifeSarahQuote;

  /// No description provided for @privateAdvice.
  ///
  /// In en, this message translates to:
  /// **'Private, confidential & offline-capable clinical advice'**
  String get privateAdvice;

  /// No description provided for @startSafeChat.
  ///
  /// In en, this message translates to:
  /// **'Start Safe Chat'**
  String get startSafeChat;

  /// No description provided for @voiceCall.
  ///
  /// In en, this message translates to:
  /// **'Voice Call'**
  String get voiceCall;

  /// No description provided for @immediateLovedOnes.
  ///
  /// In en, this message translates to:
  /// **'Immediate Loved Ones & Care'**
  String get immediateLovedOnes;

  /// No description provided for @speedDialButton.
  ///
  /// In en, this message translates to:
  /// **'Speed-Dial'**
  String get speedDialButton;

  /// No description provided for @communityCirclesTitle.
  ///
  /// In en, this message translates to:
  /// **'Safe Community Circles'**
  String get communityCirclesTitle;

  /// No description provided for @communityCirclesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Peer support moderated by maternal health champions'**
  String get communityCirclesSubtitle;

  /// No description provided for @circleNewbornTitle.
  ///
  /// In en, this message translates to:
  /// **'Newborn 0–3 Months Mamas'**
  String get circleNewbornTitle;

  /// No description provided for @circleNewbornSubtitle.
  ///
  /// In en, this message translates to:
  /// **'1.4k active mothers • 87 sharing tonight'**
  String get circleNewbornSubtitle;

  /// No description provided for @circleBreastfeedingTitle.
  ///
  /// In en, this message translates to:
  /// **'Breastfeeding Sanctuary'**
  String get circleBreastfeedingTitle;

  /// No description provided for @circleBreastfeedingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'IBCLC Lactation Specialist moderated'**
  String get circleBreastfeedingSubtitle;

  /// No description provided for @circleHealingTitle.
  ///
  /// In en, this message translates to:
  /// **'Fourth Trimester Healing'**
  String get circleHealingTitle;

  /// No description provided for @circleHealingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pelvic recovery, mood, and gentle rest'**
  String get circleHealingSubtitle;

  /// No description provided for @joinCircle.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get joinCircle;

  /// No description provided for @joinedCircle.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get joinedCircle;

  /// No description provided for @helpfulReadsTitle.
  ///
  /// In en, this message translates to:
  /// **'Grounded Guidance & Articles'**
  String get helpfulReadsTitle;

  /// No description provided for @enterPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}'**
  String enterPinTitle(String name);

  /// No description provided for @enterPinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your 4-digit PIN to open your private maternal vault'**
  String get enterPinSubtitle;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to Niamama'**
  String get signInTitle;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered phone number or name and 4-digit PIN'**
  String get signInSubtitle;

  /// No description provided for @newMotherTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Mother Profile'**
  String get newMotherTitle;

  /// No description provided for @newMotherSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Private, offline-first vault for you and your baby'**
  String get newMotherSubtitle;

  /// No description provided for @phoneOrNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number or your name'**
  String get phoneOrNameLabel;

  /// No description provided for @mamaNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Mother\'s Full Name'**
  String get mamaNameLabel;

  /// No description provided for @babyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Baby\'s Name'**
  String get babyNameLabel;

  /// No description provided for @babyAgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Baby\'s Age (weeks)'**
  String get babyAgeLabel;

  /// No description provided for @babyDobLabel.
  ///
  /// In en, this message translates to:
  /// **'Baby\'s Date of Birth'**
  String get babyDobLabel;

  /// No description provided for @setPinLabel.
  ///
  /// In en, this message translates to:
  /// **'Create 4-Digit Numeric PIN'**
  String get setPinLabel;

  /// No description provided for @signInBtn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInBtn;

  /// No description provided for @newMotherBtn.
  ///
  /// In en, this message translates to:
  /// **'New Mother? Create Your Private Account'**
  String get newMotherBtn;

  /// No description provided for @haveAccountBtn.
  ///
  /// In en, this message translates to:
  /// **'Already registered? Sign In'**
  String get haveAccountBtn;

  /// No description provided for @createAccountBtn.
  ///
  /// In en, this message translates to:
  /// **'Create Account & Sign In'**
  String get createAccountBtn;

  /// No description provided for @switchProfile.
  ///
  /// In en, this message translates to:
  /// **'Switch Profile'**
  String get switchProfile;

  /// No description provided for @incorrectPin.
  ///
  /// In en, this message translates to:
  /// **'Incorrect 4-digit PIN. Please try again.'**
  String get incorrectPin;

  /// No description provided for @speedDialTitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency Speed-Dial'**
  String get speedDialTitle;

  /// No description provided for @speedDialSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Works 100% Offline • One-Tap Call & GPS SOS'**
  String get speedDialSubtitle;

  /// No description provided for @sendSosToAll.
  ///
  /// In en, this message translates to:
  /// **'Send SOS to All Primary Contacts'**
  String get sendSosToAll;

  /// No description provided for @addEmergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Add Emergency Contact'**
  String get addEmergencyContact;

  /// No description provided for @contactNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact Name'**
  String get contactNameLabel;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number (+254...)'**
  String get phoneNumberLabel;

  /// No description provided for @roleLabel.
  ///
  /// In en, this message translates to:
  /// **'Relationship / Role'**
  String get roleLabel;

  /// No description provided for @saveContact.
  ///
  /// In en, this message translates to:
  /// **'Save Contact'**
  String get saveContact;

  /// No description provided for @midwifeSafeChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Midwife Safe Chat'**
  String get midwifeSafeChatTitle;

  /// No description provided for @midwifeSafeChatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sarah is ready • Saved to offline vault'**
  String get midwifeSafeChatSubtitle;

  /// No description provided for @selectTopics.
  ///
  /// In en, this message translates to:
  /// **'Select what you\'d like to talk through:'**
  String get selectTopics;

  /// No description provided for @chatInputHint.
  ///
  /// In en, this message translates to:
  /// **'Share what feels heavy right now...'**
  String get chatInputHint;

  /// No description provided for @connectWithSarah.
  ///
  /// In en, this message translates to:
  /// **'Connect with Sarah'**
  String get connectWithSarah;

  /// No description provided for @topicFeeding.
  ///
  /// In en, this message translates to:
  /// **'Feeding / Latch'**
  String get topicFeeding;

  /// No description provided for @topicSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep / Waking'**
  String get topicSleep;

  /// No description provided for @topicHealing.
  ///
  /// In en, this message translates to:
  /// **'Physical Healing'**
  String get topicHealing;

  /// No description provided for @topicMood.
  ///
  /// In en, this message translates to:
  /// **'Mood & Tears'**
  String get topicMood;

  /// No description provided for @whoPassTitle.
  ///
  /// In en, this message translates to:
  /// **'WHO Digital Health Pass'**
  String get whoPassTitle;

  /// No description provided for @whoPassSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Offline Immunization Verification'**
  String get whoPassSubtitle;

  /// No description provided for @saveToWallet.
  ///
  /// In en, this message translates to:
  /// **'Save to Wallet / Offline Pass'**
  String get saveToWallet;

  /// No description provided for @closePreview.
  ///
  /// In en, this message translates to:
  /// **'Close Preview'**
  String get closePreview;

  /// No description provided for @calendarReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar Reminder'**
  String get calendarReminderTitle;

  /// No description provided for @addToCalendar.
  ///
  /// In en, this message translates to:
  /// **'Add to Device Calendar'**
  String get addToCalendar;

  /// No description provided for @reminderSaved.
  ///
  /// In en, this message translates to:
  /// **'Reminder Saved Offline'**
  String get reminderSaved;

  /// No description provided for @tapForGps.
  ///
  /// In en, this message translates to:
  /// **'Care Map Active • Tap for Live GPS'**
  String get tapForGps;
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
