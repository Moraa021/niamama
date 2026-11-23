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
  String get close => 'Close';

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
}
