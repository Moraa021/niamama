import 'neo4j_knowledge_service.dart';

/// Kiswahili translations of the 6 core WHO-grounded clinical triage pathways.
/// Keyed by [GroundedTriageNode.id]. Clinical codes and Cypher paths stay unchanged.
class TriageTranslationSw {
  final String symptomTitle;
  final String urgencyLevel;
  final String clinicalExplanation;
  final List<String> immediateActions;
  final String recommendedFacilityTag;

  const TriageTranslationSw({
    required this.symptomTitle,
    required this.urgencyLevel,
    required this.clinicalExplanation,
    required this.immediateActions,
    required this.recommendedFacilityTag,
  });
}

const Map<String, String> urgencyLabelsSw = {
  'URGENT ER': 'DHARURA - HOSPITALI SASA',
  'SAME-DAY CLINIC': 'KLINIKI SIKU HIYO HIYO',
  'HOME CARE': 'HUDUMA NYUMBANI',
};

const Map<String, String> categoryLabelsSw = {
  'Infant': 'Mtoto',
  'Maternal': 'Mama',
  'All': 'Zote',
};

const Map<String, TriageTranslationSw> triageTranslationsSw = {
  'infant-fever-38': TriageTranslationSw(
    symptomTitle: 'Homa ya Mtoto Mchanga ya Kwapani ≥ 38.0°C (100.4°F)',
    urgencyLevel: 'DHARURA - HOSPITALI SASA',
    clinicalExplanation:
        'Kwa watoto wachanga chini ya miezi 3, homa yoyote ya 38.0°C au zaidi inahitaji uchunguzi wa haraka wa daktari wa watoto ili kuondoa uwezekano wa maambukizi makali ya damu au homa baada ya chanjo.',
    immediateActions: [
      'Mvue mtoto abaki na nguo moja nyepesi ya pamba; usimwogeshe kwa maji baridi.',
      'Endelea kumnyonyesha mara kwa mara ili asikose maji mwilini.',
      'Nenda hospitali ya Ngazi ya 4/5 yenye huduma za watoto au piga 1190 / 0800 720 000 mara moja.',
    ],
    recommendedFacilityTag:
        'Hospitali ya Rufaa ya Kaunti Ndogo (Wodi ya Watoto Wachanga na Dharura ya Watoto)',
  ),
  'infant-breathing': TriageTranslationSw(
    symptomTitle: 'Kupumua Haraka (>60 kwa dakika) au Kifua Kuvutika Ndani',
    urgencyLevel: 'DHARURA - HOSPITALI SASA',
    clinicalExplanation:
        'Kifua kuvutika ndani, puani kupanuka, au kutoa sauti ya kukoroma ni dalili za shida kali ya kupumua zinazohitaji oksijeni na huduma ya haraka ya watoto.',
    immediateActions: [
      'Mshike mtoto wima kifuani kwako ngozi kwa ngozi.',
      'Safisha pua kwa upole kama imeziba; usimnyonyeshe ikiwa anapata shida kupumua.',
      'Bonyeza SOS Ambulansi (999 / 112) au nenda kitengo cha dharura kilicho karibu.',
    ],
    recommendedFacilityTag:
        'Hospitali ya Rufaa ya Kaunti Ndogo (Dharura ya Saa 24)',
  ),
  'maternal-bleeding-pph': TriageTranslationSw(
    symptomTitle:
        'Kutokwa na Damu Nyingi Baada ya Kujifungua au Mabonge Makubwa',
    urgencyLevel: 'DHARURA - HOSPITALI SASA',
    clinicalExplanation:
        'Kulowesha zaidi ya pedi moja kwa saa kwa saa 2 mfululizo, au kutoa mabonge makubwa kuliko plamu, kunaweza kuwa dalili ya kutokwa na damu nyingi baada ya kujifungua.',
    immediateActions: [
      'Lala chali miguu ikiwa juu kidogo na mwombe mwenzako abaki nawe.',
      'Mnyonyeshe mtoto ikiwezekana (oksitosini husaidia mfuko wa uzazi kubana).',
      'Piga simu ya msaada wa uzazi 1190 au dharura ya hospitali (0800 720 000) mara moja.',
    ],
    recommendedFacilityTag:
        'Hospitali ya Rufaa ya Kaunti Ndogo (Wodi ya Uzazi)',
  ),
  'maternal-preeclampsia-postnatal': TriageTranslationSw(
    symptomTitle:
        'Maumivu Makali ya Kichwa, Kutoona Vizuri, au Maumivu ya Mbavu za Juu',
    urgencyLevel: 'DHARURA - HOSPITALI SASA',
    clinicalExplanation:
        'Shinikizo la juu la damu baada ya kujifungua linaweza kutokea hadi wiki 6 baada ya kujifungua. Maumivu makali ya kichwa yasiyopungua kwa kupumzika au paracetamol, au kuona madoa, yanahitaji kupimwa shinikizo la damu haraka.',
    immediateActions: [
      'Pumzika katika chumba tulivu chenye mwanga hafifu na epuka kujichosha.',
      'Usijiendeshe mwenyewe—tumia SOS ya ujumbe wa GPS kumwarifu mwenzako au kliniki.',
      'Pima shinikizo la damu na protini kwenye mkojo kwenye kitengo cha uzazi ndani ya saa 1–2.',
    ],
    recommendedFacilityTag:
        'Hospitali ya Rufaa ya Kaunti Ndogo (Uchunguzi wa Uzazi)',
  ),
  'lactation-mastitis-latch': TriageTranslationSw(
    symptomTitle:
        'Kunyonyesha kwa Maumivu, Matiti Kujaa, au Eneo Jekundu na Joto Kwenye Titi',
    urgencyLevel: 'KLINIKI SIKU HIYO HIYO',
    clinicalExplanation:
        'Chuchu kuuma au eneo lenye joto na maumivu kwenye titi huashiria mtoto hashiki titi vizuri au uvimbe wa mwanzo wa titi. Kurekebisha mkao mapema huzuia maambukizi.',
    immediateActions: [
      'Weka kitambaa baridi baada ya kunyonyesha kupunguza uvimbe wa mirija (mwongozo wa WHO/ABM).',
      'Nyonyesha ukiwa umeegemea nyuma ili mtoto ashike titi kwa kina.',
      "Mwandikie Mkunga Sarah kwenye Gumzo Salama au tembelea mtaalamu wa unyonyeshaji ukipata homa.",
    ],
    recommendedFacilityTag:
        'Kituo cha Mama na Mtoto cha St. Jude (Kliniki ya Unyonyeshaji)',
  ),
  'vaccine-mild-reaction': TriageTranslationSw(
    symptomTitle:
        'Kuwa na Kinyongo Kidogo au Joto Paja Baada ya Chanjo za Wiki 6',
    urgencyLevel: 'HUDUMA NYUMBANI',
    clinicalExplanation:
        'Baada ya sindano za Penta 1 na PCV 1, kuwa na kinyongo kidogo na uvimbe mdogo mahali pa sindano kwa saa 24–48 ni dalili kuwa kinga ya mtoto inajengwa.',
    immediateActions: [
      'Mpe faraja ya ziada kwa kumnyonyesha—kunyonya hupunguza maumivu kwa asili.',
      'Weka kitambaa safi chenye maji baridi taratibu juu ya paja mahali pa sindano.',
      'Pima joto mtoto akihisi moto; tafuta huduma ya afya homa ikifikia ≥ 38.0°C.',
    ],
    recommendedFacilityTag:
        'Kituo cha Jamii na Ustawi wa Mtoto (Dawati la Chanjo)',
  ),
};

/// Returns [node] translated into [languageCode] ('sw'); English otherwise.
GroundedTriageNode localizeTriageNode(
  GroundedTriageNode node,
  String languageCode,
) {
  if (languageCode != 'sw') return node;
  final t = triageTranslationsSw[node.id];
  if (t == null) return node;
  return GroundedTriageNode(
    id: node.id,
    category: node.category,
    symptomTitle: t.symptomTitle,
    urgencyLevel: t.urgencyLevel,
    clinicalExplanation: t.clinicalExplanation,
    immediateActions: t.immediateActions,
    recommendedFacilityTag: t.recommendedFacilityTag,
    whoCitationCode: node.whoCitationCode,
    cypherPathSummary: node.cypherPathSummary,
  );
}
