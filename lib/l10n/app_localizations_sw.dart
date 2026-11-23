// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class AppLocalizationsSw extends AppLocalizations {
  AppLocalizationsSw([String locale = 'sw']) : super(locale);

  @override
  String get navHome => 'Nyumbani';

  @override
  String get navTimeline => 'Ratiba';

  @override
  String get navCareMap => 'Ramani ya Huduma';

  @override
  String get navSupport => 'Msaada';

  @override
  String get gpsLive => 'GPS Imewashwa';

  @override
  String get offlineReady => 'Tayari Nje ya Mtandao';

  @override
  String get sosButton => 'SOS';

  @override
  String get close => 'Funga';

  @override
  String get cancel => 'Ghairi';

  @override
  String get languageLabel => 'Lugha';

  @override
  String get languageSubtitle =>
      'Chagua lugha ya programu kwa wasifu wa mama huyu';

  @override
  String get dailyCareTrackers => 'Ufuatiliaji wa Kila Siku';

  @override
  String get wetDiapers => 'Nepi zilizolowa mkojo';

  @override
  String get soiledDiapers => 'Nepi zenye kinyesi';

  @override
  String get waterGlasses => 'Maji ya mama (glasi)';

  @override
  String wetDiaperGoal(int target) {
    return 'Lenga nepi $target+ zilizolowa vizuri kwa saa 24.';
  }

  @override
  String wetDiaperGood(int count) {
    return 'Vizuri: nepi $count zilizolowa leo zinaonyesha mtoto anapata maziwa ya kutosha.';
  }

  @override
  String get partnerModeButton => 'Hali ya Mwenza: Jinsi ya Kusaidia Sasa';

  @override
  String get partnerTitle => 'Jinsi ya Kusaidia Sasa';

  @override
  String get partnerBriefingTitle => 'Muhtasari wa sekunde 30';

  @override
  String partnerChecklistTitle(int done, int total) {
    return 'Orodha ya msaada wa leo ($done/$total)';
  }

  @override
  String get redFlagTitle => 'Orodha ya dalili hatari';

  @override
  String get redFlagCall =>
      'Ukiona dalili yoyote kati ya hizi, piga simu ya msaada wa uzazi 1190 au nenda kituo cha afya cha karibu sasa hivi.';

  @override
  String get partnerTaskWater =>
      'Jaza chupa ya maji ya lita 1 mahali pa kunyonyesha';

  @override
  String get partnerTaskSleep =>
      'Linda usingizi wa mama wa saa 4 bila kukatizwa';

  @override
  String get partnerTaskBurp =>
      'Msaidie mtoto kutoa gesi na kubadilisha nepi baada ya kila kunyonya';

  @override
  String get partnerTaskMeal =>
      'Andaa chakula cha moto na kitafunio anachoweza kula kwa mkono mmoja';

  @override
  String get partnerTaskNight =>
      'Chukua zamu moja ya usiku (mlete mtoto, kisha mlaze mtoto)';

  @override
  String get partnerTaskVisitors =>
      'Dhibiti wageni kwa upole ili mama apumzike';

  @override
  String get redFlag1 =>
      'Maumivu makali ya kichwa yasiyoisha, au kutoona vizuri (huenda ni kifafa cha mimba baada ya kujifungua)';

  @override
  String get redFlag2 =>
      'Kulowesha pedi chini ya saa moja, au kutoa mabonge makubwa ya damu (kutokwa na damu nyingi)';

  @override
  String get redFlag3 => 'Homa ya 38°C au zaidi, au uchafu wenye harufu mbaya';

  @override
  String get redFlag4 =>
      'Maumivu ya kifua, shida ya kupumua, au mguu mmoja uliovimba na wenye maumivu';

  @override
  String get redFlag5 =>
      'Kukata tamaa, kujitenga, kutokula, au kuzungumza kuhusu kujidhuru (anahitaji msaada leo)';

  @override
  String briefingEarly(int week, String baby, String mama) {
    return 'Wiki ya $week. Wiki mbili za kwanza ni ngumu zaidi: $baby ananyonya mara nyingi na $mama anapona baada ya kujifungua. Kazi yako sasa: mpunguzie mzigo ili anyonyeshe, apone na apumzike.';
  }

  @override
  String briefingMid(int week, String baby, String mama) {
    return 'Wiki ya $week. $baby ananyonya mara nyingi sana (kunyonya mfululizo ni kawaida) na mwili wa $mama bado unapona, hivyo amechoka na hisia zake zinaweza kubadilika. Kazi yako sasa: mpunguzie mzigo ili anyonyeshe, apone na apumzike.';
  }

  @override
  String briefingLate(int week, String baby, String mama) {
    return 'Wiki ya $week. $baby ameanza kuwa na ratiba, lakini $mama bado anapona na huenda analala kidogo. Kazi yako sasa: mpunguzie mzigo ili anyonyeshe, apone na apumzike.';
  }

  @override
  String goodMorning(String name) {
    return 'Habari ya asubuhi, $name';
  }

  @override
  String goodAfternoon(String name) {
    return 'Habari ya mchana, $name';
  }

  @override
  String goodEvening(String name) {
    return 'Habari ya jioni, $name';
  }

  @override
  String get howAreYouFeeling => 'Unajisikiaje kwa sasa?';

  @override
  String get moodResting => 'Napumzika Vizuri';

  @override
  String get moodTired => 'Nimechoka Kidogo';

  @override
  String get moodMidwife => 'Uliza Mkunga';

  @override
  String get dailyBreathTitle => 'PUMZIKO LA LEO';

  @override
  String get dailyBreathQuote =>
      '“Unafanya kazi nzuri leo. Kila unyonyeshaji, kumkumbatia mtoto, na kila pumzi tulivu vina thamani kubwa.”';

  @override
  String get careHorizon => 'Upeo wa Huduma';

  @override
  String get sixWeeksReviewTitle => 'Uchunguzi wa Wiki 6 Baada ya Kujifungua';

  @override
  String get sixWeeksReviewSubtitle =>
      'Uchunguzi wa Mama Unaopendekezwa na WHO';

  @override
  String get sixWeeksReviewDesc =>
      'Kurejea kwa mfuko wa uzazi, tathmini ya hisia na uponyaji wa nyonga.';

  @override
  String babyVaccinesHorizonTitle(String babyName) {
    return 'Chanjo za Wiki 6 za Mtoto $babyName';
  }

  @override
  String get babyVaccinesHorizonSubtitle =>
      'Penta 1, PCV 1, OPV 1, Rotavirus 1';

  @override
  String get babyVaccinesHorizonDesc =>
      'Kinga kwa ajili ya mapafu, mmeng\'enyo wa chakula na afya ya mtoto.';

  @override
  String get lastFeed => 'Kunyonyesha Mara ya Mwisho';

  @override
  String get log => 'Rekodi';

  @override
  String get essentialCareSupport => 'Huduma Muhimu na Msaada';

  @override
  String get whenToSeeDoctor => 'Wakati wa Kumuona Daktari';

  @override
  String get whenToSeeDoctorDesc => 'Mwongozo wa WHO wa Dalili Hatari';

  @override
  String get pediatricCenters => 'Vituo vya Watoto';

  @override
  String get pediatricCentersDesc => 'Wodi za Dharura na Ustawi wa Mtoto';

  @override
  String get talkWithMidwife => 'Ongea na Mkunga';

  @override
  String get talkWithMidwifeDesc => 'Salama, Siri na Nje ya Mtandao';

  @override
  String get whoVaccineCard => 'Kadi ya Chanjo ya WHO';

  @override
  String get whoVaccineCardDesc => 'Kadi ya Kidijitali ya Chanjo';

  @override
  String get nearestReadyFacility => 'KITUO CHA KARIBU KILICHO TAYARI';

  @override
  String get callMidwifeTriage => 'Piga Dawati la Mkunga';

  @override
  String get viewRouteNav => 'Angalia Njia na Ramani';

  @override
  String get communityWisdom => 'Hekima ya Jamii • Gusa Kusoma Mwongozo';

  @override
  String get firstSmileMilestone =>
      'Tabasamu la kwanza: Dalili za kuangalia wiki 6 hadi 8';

  @override
  String get quickFeedLoggerTitle => 'Kumbukumbu ya Kunyonyesha na Usingizi';

  @override
  String get quickFeedLoggerSubtitle =>
      'Kufuatilia kunyonyesha kwa mkono mmoja • Imehifadhiwa nje ya mtandao';

  @override
  String get nursingSide => 'Upande wa Kunyonyesha';

  @override
  String get nursingDuration => 'Muda wa Kunyonyesha';

  @override
  String minutesCount(int count) {
    return 'Dakika $count';
  }

  @override
  String sleepStretch(String babyName) {
    return 'Muda wa Usingizi wa Mtoto $babyName';
  }

  @override
  String hoursMins(int hours, int mins) {
    return 'Saa $hours dk $mins';
  }

  @override
  String get saveToOfflineVault => 'Hifadhi Nje ya Mtandao';

  @override
  String get leftSide => 'Upande wa Kushoto';

  @override
  String get rightSide => 'Upande wa Kulia';

  @override
  String facilityDistDrive(String dist, int mins) {
    return 'Umbali wa km $dist • Takriban dk $mins kwa gari';
  }

  @override
  String get open247LowWait => 'Wazi Saa 24/7 • Foleni Ndogo';

  @override
  String get securityVaultTitle => 'Hifadhi Binafsi ya Mama';

  @override
  String get securityVaultDescription =>
      'Kumbukumbu zako za unyonyeshaji, chanjo, vikumbusho, nambari za dharura na mazungumzo na mkunga huhifadhiwa kwa usalama kwenye kipindi chako kilichosimbwa.';

  @override
  String get requirePinTitle => 'Dai PIN Kila Unapofungua';

  @override
  String get requirePinSubtitleOn =>
      'IMEWASHWA: Utaombwa PIN yako ya tarakimu 4 kila unapofungua Niamama.';

  @override
  String get requirePinSubtitleOff =>
      'IMEZIMWA: Kipindi chako kimehifadhiwa ili ufungue dashibodi moja kwa moja.';

  @override
  String get securityPinTitle => 'PIN ya Tarakimu 4';

  @override
  String get securityPinSubtitle =>
      'Hutumika kufungua hifadhi yako na rekodi nyeti';

  @override
  String get changePin => 'Badilisha PIN';

  @override
  String get savePin => 'Hifadhi PIN';

  @override
  String get lockVaultNow => 'Funga Hifadhi Sasa';

  @override
  String get signOut => 'Ondoka';

  @override
  String get enterNewPinHint => 'Weka PIN mpya ya tarakimu 4';

  @override
  String get whoCard => 'Kadi ya WHO';

  @override
  String childProfileActive(String babyName, int weeks) {
    return 'Wasifu wa mtoto: Mtoto $babyName (wiki $weeks)';
  }

  @override
  String nextStepInDays(int days) {
    return 'Hatua Inayofuata Baada ya Siku $days';
  }

  @override
  String get sixWeekImmunizations => 'Chanjo za Wiki 6';

  @override
  String get sixWeekImmDesc =>
      'Kinga kwa ajili ya mapafu, mmeng\'enyo wa chakula na afya ya mtoto.';

  @override
  String get tummyTimeTitle => 'Muda wa Kulala kwa Tumbo na Tabasamu';

  @override
  String get tummyTimeSubtitle =>
      'Kujenga nguvu za shingo na mawasiliano ya hisia';

  @override
  String tummyTimeWindow(int week) {
    return 'Kipindi cha Wiki ya $week';
  }

  @override
  String get startTummyTimer => 'Anzisha Kipima Muda (dk 2)';

  @override
  String get pauseTimer => 'Sitisha Kipima Muda';

  @override
  String get captureSmileMemory => 'Rekodi Tabasamu la Kwanza';

  @override
  String smilesLogged(int count) {
    return 'Tabasamu $count Zimeripotiwa';
  }

  @override
  String cuesToNotice(String babyName) {
    return 'Dalili kwamba $babyName anajaribu kuwasiliana:';
  }

  @override
  String get cueGaze => 'Kukukazia macho kwa uangalifu';

  @override
  String get cueMouth => 'Kulegeza mdomo na kufungua midomo';

  @override
  String get cueBrows => 'Nyusi zilizotulia na kugeukia sauti';

  @override
  String get immunizationTimeline => 'Ratiba ya Chanjo';

  @override
  String get globalStandard => 'Kiwango cha Kimataifa';

  @override
  String get birthDosesTitle => 'Dozi za Kuzaliwa (Wiki 0)';

  @override
  String get birthDosesSubtitle => 'Hupewa mtoto anapozaliwa';

  @override
  String get week6DosesTitle => 'Dozi za Wiki 6';

  @override
  String get week6DosesSubtitle => 'Chanjo kuu za awali';

  @override
  String get week10DosesTitle => 'Dozi za Nyongeza za Wiki 10';

  @override
  String get week10DosesSubtitle => 'Awamu ya pili ya kinga';

  @override
  String get week14DosesTitle => 'Dozi za Wiki 14';

  @override
  String get week14DosesSubtitle => 'Awamu ya mwisho ya msingi ya mtoto';

  @override
  String comfortTipsTitle(String babyName) {
    return 'Vidokezo vya kumfariji $babyName';
  }

  @override
  String get tipBreastfeed =>
      'Mnyonyeshe mtoto mara tu baada ya chanjo ili kutuliza maumivu';

  @override
  String get tipSkinToSkin =>
      'Mshike ngozi kwa ngozi kifuani ili kutuliza mapigo ya moyo';

  @override
  String get tipCoolCloth =>
      'Weka kitambaa safi chenye maji baridi paja likiwa na joto';

  @override
  String get trustedCareNearYou => 'Huduma za Kuaminika Karibu Nawe';

  @override
  String get trustedCareSubtitle =>
      'Wodi za uzazi zilizothibitishwa, huduma ya watoto wachanga, na kliniki.';

  @override
  String get filterAll => 'Vituo Vyote';

  @override
  String get filterMaternity => 'Uzazi Saa 24';

  @override
  String get filterPediatric => 'Wodi za Watoto';

  @override
  String get filterVaccine => 'Kliniki za Chanjo';

  @override
  String get filterMidwife => 'Chini ya Mkunga';

  @override
  String get filterPharmacy => 'Famasi Saa 24';

  @override
  String get allowGps => 'Ruhusu GPS';

  @override
  String get locatingGps => 'Inatafuta GPS...';

  @override
  String get emergencyGuidanceTitle =>
      'Wakati wa kutafuta huduma ya dharura mara moja';

  @override
  String get emergencyInstinctQuote =>
      'Unamjua mtoto wako vizuri zaidi. Ukihisi wasiwasi wowote, amini silika yako ya kimama—wahudumu wa afya wapo kukusaidia bila kukuhukumu.';

  @override
  String get openEmergencySpeedDialSos => 'Fungua Simu za Dharura na GPS SOS';

  @override
  String get lateNightPharmaciesTitle => 'Unatafuta famasi za usiku?';

  @override
  String get lateNightPharmaciesDesc =>
      'Tumekuwekea famasi za saa 24 zenye ORS ya watoto, maji safi na vifaa vya kunyonya maziwa.';

  @override
  String get viewOpenChemists => 'Ona Famasi Zilizofunguliwa';

  @override
  String get callHelpline => 'Piga Simu ya Taifa ya Uzazi Saa 24 (Bure)';

  @override
  String get supportCircleTitle => 'Mzunguko Wako wa Msaada';

  @override
  String get supportCircleSubtitle =>
      'Hauko peke yako baada ya kujifungua. Wakunga wako, akina mama wenzako, na wataalamu wa afya wapo pamoja nawe.';

  @override
  String get midwifeSarahTitle => 'Mkunga Aliyesajiliwa Sarah';

  @override
  String get midwifeOnline => 'Yuko mtandaoni • Majibu chini ya dk 5';

  @override
  String get free247 => 'Bure • Saa 24/7';

  @override
  String get midwifeSarahQuote =>
      '“Una wasiwasi kuhusu maumivu ya kunyonyesha usiku, mabadiliko ya kupona, au usingizi wa mtoto? Hakuna swali dogo au la aibu. Tuko hapa kukusikiliza.”';

  @override
  String get privateAdvice =>
      'Ushauri wa siri na unaofanya kazi hata nje ya mtandao';

  @override
  String get startSafeChat => 'Anzisha Mazungumzo Salama';

  @override
  String get voiceCall => 'Piga Simu ya Sauti';

  @override
  String get immediateLovedOnes => 'Watu wa Karibu na Wanaokujali';

  @override
  String get speedDialButton => 'Simu za Haraka';

  @override
  String get communityCirclesTitle => 'Makundi Salama ya Jamii';

  @override
  String get communityCirclesSubtitle =>
      'Msaada wa kina mama wenzako unaosimamiwa na wataalamu';

  @override
  String get circleNewbornTitle => 'Akina Mama wa Watoto Wachanga (Miezi 0–3)';

  @override
  String get circleNewbornSubtitle =>
      'Akina mama 1.4k • 87 wanashiriki usiku huu';

  @override
  String get circleBreastfeedingTitle => 'Kimbilio la Unyonyeshaji';

  @override
  String get circleBreastfeedingSubtitle =>
      'Linasaidiwa na mtaalamu wa unyonyeshaji';

  @override
  String get circleHealingTitle => 'Uponyaji Baada ya Kujifungua';

  @override
  String get circleHealingSubtitle =>
      'Kupona kwa nyonga, hisia na kupumzika vizuri';

  @override
  String get joinCircle => 'Jiunge';

  @override
  String get joinedCircle => 'Umejiunga';

  @override
  String get helpfulReadsTitle => 'Miongozo na Makala Muhimu';

  @override
  String enterPinTitle(String name) {
    return 'Karibu tena, $name';
  }

  @override
  String get enterPinSubtitle =>
      'Weka PIN yako ya tarakimu 4 kufungua hifadhi yako binafsi';

  @override
  String get signInTitle => 'Ingia kwenye Niamama';

  @override
  String get signInSubtitle =>
      'Weka namba ya simu au jina lako na PIN ya tarakimu 4';

  @override
  String get newMotherTitle => 'Fungua Wasifu wa Mama';

  @override
  String get newMotherSubtitle =>
      'Hifadhi binafsi ya nje ya mtandao kwa ajili yako na mtoto';

  @override
  String get phoneOrNameLabel => 'Namba ya simu au jina lako';

  @override
  String get mamaNameLabel => 'Jina Kamili la Mama';

  @override
  String get babyNameLabel => 'Jina la Mtoto';

  @override
  String get babyAgeLabel => 'Umri wa Mtoto (wiki)';

  @override
  String get babyDobLabel => 'Tarehe ya Kuzaliwa ya Mtoto';

  @override
  String get setPinLabel => 'Weka PIN ya Tarakimu 4';

  @override
  String get signInBtn => 'Ingia';

  @override
  String get newMotherBtn => 'Mama Mpya? Fungua Akaunti Yako Binafsi';

  @override
  String get haveAccountBtn => 'Una akaunti tayari? Ingia';

  @override
  String get createAccountBtn => 'Fungua Akaunti na Uingie';

  @override
  String get switchProfile => 'Badilisha Wasifu';

  @override
  String get incorrectPin =>
      'PIN ya tarakimu 4 si sahihi. Tafadhali jaribu tena.';

  @override
  String get speedDialTitle => 'Simu za Haraka za Dharura';

  @override
  String get speedDialSubtitle =>
      'Inafanya kazi 100% bila intaneti • Piga Simu au Tuma GPS SOS kwa Mguso Mmoja';

  @override
  String get sendSosToAll => 'Tuma SOS kwa Namba Zote Kuu';

  @override
  String get addEmergencyContact => 'Ongeza Mtu wa Dharura';

  @override
  String get contactNameLabel => 'Jina la Mtu';

  @override
  String get phoneNumberLabel => 'Namba ya Simu (+254...)';

  @override
  String get roleLabel => 'Uhusiano / Wajibu (mf. Mwenza, Daktari)';

  @override
  String get saveContact => 'Hifadhi Mtu';

  @override
  String get midwifeSafeChatTitle => 'Gumzo Salama na Mkunga';

  @override
  String get midwifeSafeChatSubtitle =>
      'Sarah yuko tayari • Imehifadhiwa nje ya mtandao';

  @override
  String get selectTopics => 'Chagua mada unayotaka kuongelea:';

  @override
  String get chatInputHint => 'Eleza jambo linalokusumbua kwa sasa...';

  @override
  String get connectWithSarah => 'Wasiliana na Sarah';

  @override
  String get topicFeeding => 'Kunyonyesha / Kushika Titi';

  @override
  String get topicSleep => 'Usingizi / Kuamka';

  @override
  String get topicHealing => 'Kupona Kimwili';

  @override
  String get topicMood => 'Hisia na Machozi';

  @override
  String get whoPassTitle => 'Kadi ya Kidijitali ya Afya ya WHO';

  @override
  String get whoPassSubtitle => 'Uthibitisho wa Chanjo Nje ya Mtandao';

  @override
  String get saveToWallet => 'Hifadhi Nje ya Mtandao';

  @override
  String get closePreview => 'Funga Hakikisho';

  @override
  String get calendarReminderTitle => 'Kikumbusho cha Kalenda';

  @override
  String get addToCalendar => 'Weka Kwenye Kalenda ya Simu';

  @override
  String get reminderSaved => 'Kikumbusho Kimehifadhiwa Nje ya Mtandao';

  @override
  String get tapForGps => 'Ramani Iko Tayari • Gusa Kupata GPS';
}
