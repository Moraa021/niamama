// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navTimeline => 'Timeline';

  @override
  String get navCareMap => 'Care Map';

  @override
  String get navSupport => 'Support';

  @override
  String get gpsLive => 'GPS Live';

  @override
  String get offlineReady => 'Offline Ready';

  @override
  String get sosButton => 'SOS';

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Cancel';

  @override
  String get languageLabel => 'Language';

  @override
  String get languageSubtitle =>
      'Choose the app language for this mother\'s profile';

  @override
  String get dailyCareTrackers => 'Daily Care Trackers';

  @override
  String get wetDiapers => 'Wet diapers';

  @override
  String get soiledDiapers => 'Soiled diapers';

  @override
  String get waterGlasses => 'Mama\'s water (glasses)';

  @override
  String wetDiaperGoal(int target) {
    return 'Aim for $target+ heavy wet diapers per 24 hours.';
  }

  @override
  String wetDiaperGood(int count) {
    return 'Great: $count wet diapers today shows good milk intake.';
  }

  @override
  String get partnerModeButton => 'Partner Mode: How to Help Right Now';

  @override
  String get partnerTitle => 'How to Help Right Now';

  @override
  String get partnerBriefingTitle => '30-second briefing';

  @override
  String partnerChecklistTitle(int done, int total) {
    return 'Today\'s support checklist ($done/$total)';
  }

  @override
  String get redFlagTitle => 'Red-flag watchlist';

  @override
  String get redFlagCall =>
      'If you notice any of these, call the maternal helpline 1190 or go to the nearest facility now.';

  @override
  String get partnerTaskWater =>
      'Refill a 1L water bottle at the nursing station';

  @override
  String get partnerTaskSleep => 'Protect Mama\'s 4-hour unbroken sleep block';

  @override
  String get partnerTaskBurp =>
      'Handle burping & diaper change after each feed';

  @override
  String get partnerTaskMeal =>
      'Prepare a warm meal and a snack she can eat one-handed';

  @override
  String get partnerTaskNight =>
      'Take one night feed handover (bring baby, then settle baby)';

  @override
  String get partnerTaskVisitors => 'Gently manage visitors so Mama can rest';

  @override
  String get redFlag1 =>
      'Severe headache that will not go away, or blurred vision (possible postpartum pre-eclampsia)';

  @override
  String get redFlag2 =>
      'Soaking a pad in under an hour, or passing large clots (heavy bleeding)';

  @override
  String get redFlag3 => 'Fever of 38°C or higher, or foul-smelling discharge';

  @override
  String get redFlag4 =>
      'Chest pain, trouble breathing, or one swollen painful leg';

  @override
  String get redFlag5 =>
      'Hopelessness, withdrawal, not eating, or talk of self-harm (needs support today)';

  @override
  String briefingEarly(int week, String baby, String mama) {
    return 'Week $week. The first two weeks are the hardest: $baby feeds very often and $mama is recovering from birth. Your job right now: take the load off, so she can feed, heal and sleep.';
  }

  @override
  String briefingMid(int week, String baby, String mama) {
    return 'Week $week. $baby is feeding very often (cluster feeding is normal) and $mama\'s body is still healing, so she is tired and her mood can swing. Your job right now: take the load off, so she can feed, heal and sleep.';
  }

  @override
  String briefingLate(int week, String baby, String mama) {
    return 'Week $week. $baby is settling into a rhythm, but $mama is still recovering and may be running on little sleep. Your job right now: take the load off, so she can feed, heal and sleep.';
  }

  @override
  String goodMorning(String name) {
    return 'Good morning, $name';
  }

  @override
  String goodAfternoon(String name) {
    return 'Good afternoon, $name';
  }

  @override
  String goodEvening(String name) {
    return 'Good evening, $name';
  }

  @override
  String get howAreYouFeeling => 'How are you feeling right now?';

  @override
  String get moodResting => 'Resting OK';

  @override
  String get moodTired => 'A Bit Tired';

  @override
  String get moodMidwife => 'Ask Midwife';

  @override
  String get dailyBreathTitle => 'DAILY BREATH';

  @override
  String get dailyBreathQuote =>
      '“You are doing enough today. Every feed, cuddle, and quiet breath matters.”';

  @override
  String get careHorizon => 'Care Horizon';

  @override
  String get sixWeeksReviewTitle => '6-Week Postnatal Review';

  @override
  String get sixWeeksReviewSubtitle => 'WHO Recommended Maternal Checkup';

  @override
  String get sixWeeksReviewDesc =>
      'Uterine involution, mood screening, and pelvic healing assessment.';

  @override
  String babyVaccinesHorizonTitle(String babyName) {
    return 'Baby $babyName 6-Week Immunizations';
  }

  @override
  String get babyVaccinesHorizonSubtitle =>
      'Penta 1, PCV 1, OPV 1, Rotavirus 1';

  @override
  String get babyVaccinesHorizonDesc =>
      'Gentle protection boosters for tiny lungs, digestion, and resilience.';

  @override
  String get lastFeed => 'Last Feed';

  @override
  String get log => 'Log';

  @override
  String get essentialCareSupport => 'Essential Care & Support';

  @override
  String get whenToSeeDoctor => 'When to See Doctor';

  @override
  String get whenToSeeDoctorDesc => 'WHO Red-Flag Triage Guidance';

  @override
  String get pediatricCenters => 'Pediatric Centers';

  @override
  String get pediatricCentersDesc => 'Emergency Wings & Child Welfare';

  @override
  String get talkWithMidwife => 'Talk with a Midwife';

  @override
  String get talkWithMidwifeDesc => 'Safe, Confidential & Offline';

  @override
  String get whoVaccineCard => 'WHO Vaccine Card';

  @override
  String get whoVaccineCardDesc => 'Digital Immunization Pass';

  @override
  String get nearestReadyFacility => 'NEAREST READY FACILITY';

  @override
  String get callMidwifeTriage => 'Call Midwife Triage Desk';

  @override
  String get viewRouteNav => 'View Route & Navigation';

  @override
  String get communityWisdom => 'Community Wisdom • Tap to Read Guide';

  @override
  String get firstSmileMilestone =>
      'First smile milestones: What to notice at 6 to 8 weeks';

  @override
  String get quickFeedLoggerTitle => 'Quick Feed & Sleep Logger';

  @override
  String get quickFeedLoggerSubtitle =>
      'Single-hand nursing tracker • Saved offline';

  @override
  String get nursingSide => 'Nursing Side';

  @override
  String get nursingDuration => 'Nursing Duration';

  @override
  String minutesCount(int count) {
    return '$count mins';
  }

  @override
  String sleepStretch(String babyName) {
    return 'Baby $babyName Sleep Stretch';
  }

  @override
  String hoursMins(int hours, int mins) {
    return '${hours}h ${mins}m';
  }

  @override
  String get saveToOfflineVault => 'Save to Offline Vault';

  @override
  String get leftSide => 'Left Side';

  @override
  String get rightSide => 'Right Side';

  @override
  String facilityDistDrive(String dist, int mins) {
    return '$dist km away • Approx. $mins mins drive';
  }

  @override
  String get open247LowWait => 'Open 24/7 • Low Wait';

  @override
  String get securityVaultTitle => 'Private Maternal Vault';

  @override
  String get securityVaultDescription =>
      'Your nursing logs, vaccines, calendar reminders, emergency speed-dial contacts, and midwife chats are stored privately in your personal encrypted session.';

  @override
  String get requirePinTitle => 'Require PIN on Every Access';

  @override
  String get requirePinSubtitleOn =>
      'ON: You will be asked for your 4-digit PIN every time you open or resume Niamama.';

  @override
  String get requirePinSubtitleOff =>
      'OFF: Your login session stays saved so you open straight to your dashboard.';

  @override
  String get securityPinTitle => '4-digit PIN';

  @override
  String get securityPinSubtitle =>
      'Used to unlock your maternal vault and sensitive records';

  @override
  String get changePin => 'Change PIN';

  @override
  String get savePin => 'Save PIN';

  @override
  String get lockVaultNow => 'Lock Vault Now';

  @override
  String get signOut => 'Sign Out';

  @override
  String get enterNewPinHint => 'Enter new 4-digit numeric PIN';

  @override
  String get whoCard => 'WHO Card';

  @override
  String childProfileActive(String babyName, int weeks) {
    return 'Child profile active: Baby $babyName ($weeks weeks)';
  }

  @override
  String nextStepInDays(int days) {
    return 'Next Step in $days Days';
  }

  @override
  String get sixWeekImmunizations => '6-Week Immunizations';

  @override
  String get sixWeekImmDesc =>
      'Gentle protection boosters for tiny lungs, digestion, and resilience.';

  @override
  String get tummyTimeTitle => 'Tummy Time & Social Smiles';

  @override
  String get tummyTimeSubtitle => 'Building neck strength and connection';

  @override
  String tummyTimeWindow(int week) {
    return 'Week $week Window';
  }

  @override
  String get startTummyTimer => 'Start 2-Min Timer';

  @override
  String get pauseTimer => 'Pause Timer';

  @override
  String get captureSmileMemory => 'Capture First Smile Memory';

  @override
  String smilesLogged(int count) {
    return '$count Smiles Logged';
  }

  @override
  String cuesToNotice(String babyName) {
    return 'Cues $babyName is trying to engage:';
  }

  @override
  String get cueGaze => 'Bright, wide-eyed gaze';

  @override
  String get cueMouth => 'Softening mouth & opening lips';

  @override
  String get cueBrows => 'Relaxed brows & turning toward voice';

  @override
  String get immunizationTimeline => 'Immunization Timeline';

  @override
  String get globalStandard => 'Global Standard';

  @override
  String get birthDosesTitle => 'Birth Doses (Week 0)';

  @override
  String get birthDosesSubtitle => 'Given at delivery facility';

  @override
  String get week6DosesTitle => 'Week 6 Doses';

  @override
  String get week6DosesSubtitle => 'Primary immunization series';

  @override
  String get week10DosesTitle => 'Week 10 Boosters';

  @override
  String get week10DosesSubtitle => 'Second round of protection';

  @override
  String get week14DosesTitle => 'Week 14 Doses';

  @override
  String get week14DosesSubtitle => 'Final infant foundation series';

  @override
  String comfortTipsTitle(String babyName) {
    return 'Comfort tips for $babyName';
  }

  @override
  String get tipBreastfeed =>
      'Breastfeed right after shots for natural pain relief';

  @override
  String get tipSkinToSkin =>
      'Hold skin-to-skin upright to regulate heart rate';

  @override
  String get tipCoolCloth =>
      'Apply a clean, cool damp cloth if thigh feels warm';

  @override
  String get trustedCareNearYou => 'Trusted Care Near You';

  @override
  String get trustedCareSubtitle =>
      'Verified maternal wings, neonatal care, and gentle walk-in clinics.';

  @override
  String get filterAll => 'All Facilities';

  @override
  String get filterMaternity => '24/7 Maternity';

  @override
  String get filterPediatric => 'Pediatric Wings';

  @override
  String get filterVaccine => 'Vaccine Clinics';

  @override
  String get filterMidwife => 'Midwife Run';

  @override
  String get filterPharmacy => '24h Chemists';

  @override
  String get allowGps => 'Allow GPS';

  @override
  String get locatingGps => 'Locating GPS...';

  @override
  String get emergencyGuidanceTitle => 'When to seek immediate emergency care';

  @override
  String get emergencyInstinctQuote =>
      'You know your baby best. If you ever feel uneasy, trust your maternal instinct—care teams are here without judgment.';

  @override
  String get openEmergencySpeedDialSos => 'Open Emergency Speed-Dial & GPS SOS';

  @override
  String get lateNightPharmaciesTitle => 'Looking for late-night pharmacies?';

  @override
  String get lateNightPharmaciesDesc =>
      'We have mapped verified 24-hour chemists stocking infant rehydration, sterile water, and pump supplies.';

  @override
  String get viewOpenChemists => 'View Open Chemists';

  @override
  String get callHelpline => 'Call 24/7 National Maternal Helpline (Free)';

  @override
  String get supportCircleTitle => 'Your Support Circle';

  @override
  String get supportCircleSubtitle =>
      'You don\'t have to navigate postpartum alone. Your midwives, fellow mothers, and care team are right here with you.';

  @override
  String get midwifeSarahTitle => 'Registered Midwife Sarah';

  @override
  String get midwifeOnline => 'Online now • Typical reply < 5 mins';

  @override
  String get free247 => 'Free • 24/7';

  @override
  String get midwifeSarahQuote =>
      '“Thinking about late-night feeding pain, healing changes, or baby sleep cues? No question is too small or silly. We are here to listen.”';

  @override
  String get privateAdvice =>
      'Private, confidential & offline-capable clinical advice';

  @override
  String get startSafeChat => 'Start Safe Chat';

  @override
  String get voiceCall => 'Voice Call';

  @override
  String get immediateLovedOnes => 'Immediate Loved Ones & Care';

  @override
  String get speedDialButton => 'Speed-Dial';

  @override
  String get communityCirclesTitle => 'Safe Community Circles';

  @override
  String get communityCirclesSubtitle =>
      'Peer support moderated by maternal health champions';

  @override
  String get circleNewbornTitle => 'Newborn 0–3 Months Mamas';

  @override
  String get circleNewbornSubtitle =>
      '1.4k active mothers • 87 sharing tonight';

  @override
  String get circleBreastfeedingTitle => 'Breastfeeding Sanctuary';

  @override
  String get circleBreastfeedingSubtitle =>
      'IBCLC Lactation Specialist moderated';

  @override
  String get circleHealingTitle => 'Fourth Trimester Healing';

  @override
  String get circleHealingSubtitle => 'Pelvic recovery, mood, and gentle rest';

  @override
  String get joinCircle => 'Join';

  @override
  String get joinedCircle => 'Joined';

  @override
  String get helpfulReadsTitle => 'Grounded Guidance & Articles';

  @override
  String enterPinTitle(String name) {
    return 'Welcome back, $name';
  }

  @override
  String get enterPinSubtitle =>
      'Enter your 4-digit PIN to open your private maternal vault';

  @override
  String get signInTitle => 'Sign in to Niamama';

  @override
  String get signInSubtitle =>
      'Enter your registered phone number or name and 4-digit PIN';

  @override
  String get newMotherTitle => 'Create Mother Profile';

  @override
  String get newMotherSubtitle =>
      'Private, offline-first vault for you and your baby';

  @override
  String get phoneOrNameLabel => 'Phone number or your name';

  @override
  String get mamaNameLabel => 'Mother\'s Full Name';

  @override
  String get babyNameLabel => 'Baby\'s Name';

  @override
  String get babyAgeLabel => 'Baby\'s Age (weeks)';

  @override
  String get babyDobLabel => 'Baby\'s Date of Birth';

  @override
  String get setPinLabel => 'Create 4-Digit Numeric PIN';

  @override
  String get signInBtn => 'Sign In';

  @override
  String get newMotherBtn => 'New Mother? Create Your Private Account';

  @override
  String get haveAccountBtn => 'Already registered? Sign In';

  @override
  String get createAccountBtn => 'Create Account & Sign In';

  @override
  String get switchProfile => 'Switch Profile';

  @override
  String get incorrectPin => 'Incorrect 4-digit PIN. Please try again.';

  @override
  String get speedDialTitle => 'Emergency Speed-Dial';

  @override
  String get speedDialSubtitle => 'Works 100% Offline • One-Tap Call & GPS SOS';

  @override
  String get sendSosToAll => 'Send SOS to All Primary Contacts';

  @override
  String get addEmergencyContact => 'Add Emergency Contact';

  @override
  String get contactNameLabel => 'Contact Name';

  @override
  String get phoneNumberLabel => 'Phone Number (+254...)';

  @override
  String get roleLabel => 'Relationship / Role';

  @override
  String get saveContact => 'Save Contact';

  @override
  String get midwifeSafeChatTitle => 'Midwife Safe Chat';

  @override
  String get midwifeSafeChatSubtitle =>
      'Sarah is ready • Saved to offline vault';

  @override
  String get selectTopics => 'Select what you\'d like to talk through:';

  @override
  String get chatInputHint => 'Share what feels heavy right now...';

  @override
  String get connectWithSarah => 'Connect with Sarah';

  @override
  String get topicFeeding => 'Feeding / Latch';

  @override
  String get topicSleep => 'Sleep / Waking';

  @override
  String get topicHealing => 'Physical Healing';

  @override
  String get topicMood => 'Mood & Tears';

  @override
  String get whoPassTitle => 'WHO Digital Health Pass';

  @override
  String get whoPassSubtitle => 'Offline Immunization Verification';

  @override
  String get saveToWallet => 'Save to Wallet / Offline Pass';

  @override
  String get closePreview => 'Close Preview';

  @override
  String get calendarReminderTitle => 'Calendar Reminder';

  @override
  String get addToCalendar => 'Add to Device Calendar';

  @override
  String get reminderSaved => 'Reminder Saved Offline';

  @override
  String get tapForGps => 'Care Map Active • Tap for Live GPS';
}
