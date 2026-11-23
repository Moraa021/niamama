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
  String get close => 'Funga';

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
}
