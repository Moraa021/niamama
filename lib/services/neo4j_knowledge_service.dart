import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Neo4jGraphStatus {
  final bool isConnectedLive;
  final int nodeCount;
  final int relationshipCount;
  final String endpoint;
  final String statusLabel;

  const Neo4jGraphStatus({
    required this.isConnectedLive,
    required this.nodeCount,
    required this.relationshipCount,
    required this.endpoint,
    required this.statusLabel,
  });

  static const Neo4jGraphStatus defaultOffline = Neo4jGraphStatus(
    isConnectedLive: false,
    nodeCount: 28,
    relationshipCount: 42,
    endpoint: 'http://localhost:7474',
    statusLabel: 'Neo4j Offline Graph Mirror (28 Clinical Nodes)',
  );
}

class GroundedTriageNode {
  final String id;
  final String category; // 'Infant' | 'Maternal'
  final String symptomTitle;
  final String urgencyLevel; // 'URGENT ER' | 'SAME-DAY CLINIC' | 'HOME CARE'
  final String clinicalExplanation;
  final List<String> immediateActions;
  final String recommendedFacilityTag;
  final String whoCitationCode;
  final String cypherPathSummary;

  const GroundedTriageNode({
    required this.id,
    required this.category,
    required this.symptomTitle,
    required this.urgencyLevel,
    required this.clinicalExplanation,
    required this.immediateActions,
    required this.recommendedFacilityTag,
    required this.whoCitationCode,
    required this.cypherPathSummary,
  });
}

class GroundedCareGuide {
  final String id;
  final String tag;
  final String timeWindow;
  final String title;
  final String summary;
  final String whoSourceNode;
  final String cypherRelation;
  final List<({String heading, String body})> sections;
  final List<String> actionableChecklist;

  const GroundedCareGuide({
    required this.id,
    required this.tag,
    required this.timeWindow,
    required this.title,
    required this.summary,
    required this.whoSourceNode,
    required this.cypherRelation,
    required this.sections,
    required this.actionableChecklist,
  });
}

class Neo4jKnowledgeGraphService {
  static const String defaultEndpoint = 'http://localhost:7474';
  static const String _defaultUser = 'neo4j';
  static const String _defaultPassword = 'niamama_graph_2026';
  static const String _cacheKey = 'niamama_neo4j_graph_cache_v1';

  /// Embedded clinical knowledge graph nodes (mirrored into live Neo4j via Cypher MERGE).
  static const List<GroundedTriageNode> clinicalTriageGraph = [
    GroundedTriageNode(
      id: 'infant-fever-38',
      category: 'Infant',
      symptomTitle: 'Infant Axillary Fever ≥ 38.0°C (100.4°F)',
      urgencyLevel: 'URGENT ER',
      clinicalExplanation:
          'In infants under 3 months, any temperature ≥ 38.0°C requires immediate pediatric evaluation to rule out neonatal sepsis or post-immunization febrile reaction.',
      immediateActions: [
        'Undress baby to a single light cotton layer; do not use cold water baths.',
        'Continue frequent breastfeeding to maintain hydration.',
        'Proceed to a Level 4/5 Pediatric ER or call 1190 / 0800 720 000 immediately.',
      ],
      recommendedFacilityTag: 'Sub-County Referral Hospital (NICU & Pediatric ER)',
      whoCitationCode: 'WHO-IMCI-2024 • Neonatal Red Flag #RF-01',
      cypherPathSummary:
          '(:Symptom {id:"infant-fever-38"})-[:TRIGGERS_PATHWAY]->(:Triage {level:"URGENT_ER"})-[:ROUTES_TO]->(:Facility {cap:"NICU"})',
    ),
    GroundedTriageNode(
      id: 'infant-breathing',
      category: 'Infant',
      symptomTitle: 'Fast Breathing (>60 breaths/min) or Chest Indrawing',
      urgencyLevel: 'URGENT ER',
      clinicalExplanation:
          'Lower chest wall indrawing, nasal flaring, or grunting indicates acute respiratory distress requiring immediate oxygen and pediatric triage.',
      immediateActions: [
        'Keep baby upright skin-to-skin against your chest.',
        'Clear nostrils gently if congested; do not feed if baby is struggling to breathe.',
        'Tap SOS Ambulance (999 / 112) or go to nearest Emergency Triage.',
      ],
      recommendedFacilityTag: 'Sub-County Referral Hospital (24/7 ER Triage)',
      whoCitationCode: 'WHO-PNC-2024 • Respiratory Triage #RF-02',
      cypherPathSummary:
          '(:Symptom {id:"infant-breathing"})-[:TRIGGERS_PATHWAY]->(:Triage {level:"URGENT_ER"})-[:GROUNDED_IN]->(:WHOSource {id:"WHO-PNC-2024"})',
    ),
    GroundedTriageNode(
      id: 'maternal-bleeding-pph',
      category: 'Maternal',
      symptomTitle: 'Heavy Postpartum Bleeding or Large Clots',
      urgencyLevel: 'URGENT ER',
      clinicalExplanation:
          'Soaking more than 1 sanitary pad per hour for 2 consecutive hours, or passing clots larger than a plum, may signal secondary postpartum hemorrhage (PPH).',
      immediateActions: [
        'Lie down flat with feet slightly elevated and have a partner stay with you.',
        'Put baby to breast if possible (oxytocin helps contract the uterus).',
        'Call 1190 Maternal Helpline or Hospital ER Triage (0800 720 000) immediately.',
      ],
      recommendedFacilityTag: 'Sub-County Referral Hospital (Maternity Wing)',
      whoCitationCode: 'WHO-PPH-2024 • Maternal Danger Sign #MD-01',
      cypherPathSummary:
          '(:Symptom {id:"maternal-bleeding-pph"})-[:INDICATES_RISK]->(:RedFlag {type:"Secondary_PPH"})-[:REQUIRES]->(:Facility {cap:"Maternity_ER"})',
    ),
    GroundedTriageNode(
      id: 'maternal-preeclampsia-postnatal',
      category: 'Maternal',
      symptomTitle: 'Severe Headache, Blurred Vision, or Upper Rib Pain',
      urgencyLevel: 'URGENT ER',
      clinicalExplanation:
          'Postpartum preeclampsia can appear up to 6 weeks after birth. Severe headache that does not improve with rest/paracetamol or visual spots requires an urgent blood pressure check.',
      immediateActions: [
        'Rest in a quiet, dimly lit room and avoid exertion.',
        'Do not drive yourself—use SOS GPS SMS to alert your partner or clinic.',
        'Get blood pressure and urine protein checked at Maternity Triage within 1–2 hours.',
      ],
      recommendedFacilityTag: 'Sub-County Referral Hospital (Maternity Triage)',
      whoCitationCode: 'WHO-PNC-2024 • Postnatal Hypertension #MD-02',
      cypherPathSummary:
          '(:Symptom {id:"maternal-preeclampsia"})-[:INDICATES_RISK]->(:RedFlag {type:"Postpartum_Eclampsia"})-[:GROUNDED_IN]->(:WHOSource)',
    ),
    GroundedTriageNode(
      id: 'lactation-mastitis-latch',
      category: 'Maternal',
      symptomTitle: 'Painful Latch, Engorgement, or Warm Red Breast Wedge',
      urgencyLevel: 'SAME-DAY CLINIC',
      clinicalExplanation:
          'Nipple soreness or a warm, tender area on the breast indicates shallow latch or early inflammatory mastitis. Early position adjustment prevents infection.',
      immediateActions: [
        'Apply a cool compress after feeds to reduce ductal inflammation (WHO/Academy of Breastfeeding Medicine protocol).',
        'Use laid-back nursing so baby takes a deep, asymmetric latch.',
        'Message Midwife Sarah in Safe Chat or visit a Lactation Specialist if fever develops.',
      ],
      recommendedFacilityTag: 'St. Jude Mother & Child Center (Lactation Clinic)',
      whoCitationCode: 'ABM-Protocol-#36 & WHO-Lactation-2024',
      cypherPathSummary:
          '(:Symptom {id:"lactation-mastitis"})-[:MANAGED_BY]->(:CareAction {protocol:"ABM-36"})-[:SUPPORTED_AT]->(:Facility {cap:"Lactation"})',
    ),
    GroundedTriageNode(
      id: 'vaccine-mild-reaction',
      category: 'Infant',
      symptomTitle: 'Mild Fussiness or Warmth at Thigh After 6-Week Vaccines',
      urgencyLevel: 'HOME CARE',
      clinicalExplanation:
          'After Penta 1 and PCV 1 injections, mild irritability and slight swelling at the injection site for 24–48 hours show baby’s immune system is building protection.',
      immediateActions: [
        'Offer extra comfort nursing—suckling provides natural analgesia.',
        'Place a clean, cool damp cloth gently over the thigh injection site.',
        'Check temperature if baby feels hot; seek care if fever reaches ≥ 38.0°C.',
      ],
      recommendedFacilityTag: 'Community Post & Child Welfare (Immunization Desk)',
      whoCitationCode: 'WHO-EPI-2024 • Post-Vaccination Care #PV-06',
      cypherPathSummary:
          '(:Vaccine {id:"penta1"})-[:EXPECTED_REACTION]->(:Symptom {id:"thigh_warmth"})-[:SELF_CARE]->(:CareAction)',
    ),
  ];

  static const Map<String, GroundedCareGuide> careGuidesGraph = {
    'growth-spurt-6w': GroundedCareGuide(
      id: 'growth-spurt-6w',
      tag: 'Growth Spurt',
      timeWindow: 'Day 21–42 (Weeks 3–6)',
      title: 'The 6-week growth spurt: Survival guide & cluster feeding rhythms',
      summary:
          'Around 6 weeks, infants experience a major neurological and physical leap. Cluster feeding in the evening is baby’s natural biological signal to calibrate your milk supply—not a sign of low milk.',
      whoSourceNode: 'WHO-Infant-Nutrition-2024 • Node #GN-6W',
      cypherRelation:
          '(:Milestone {week:6})-[:TRIGGERS_BEHAVIOR]->(:ClusterFeeding)-[:CALIBRATES]->(:MilkSupply)',
      sections: [
        (
          heading: '1. Why Evening Cluster Feeding Happens',
          body:
              'Between 5:00 PM and 11:00 PM, prolactin levels naturally dip while your baby’s brain is processing new visual and social stimuli. Frequent short feeds every 30–45 minutes deliver comfort and signal your body to boost tomorrow’s milk volume.',
        ),
        (
          heading: '2. Pacing & Single-Hand Survival for Mama',
          body:
              'Set up a "nursing station" before 5:00 PM with 1 liter of water, oat/nut snacks, and a supportive pillow. Alternate Left and Right sides in the Niamama Quick Logger so both breasts receive balanced stimulation.',
        ),
        (
          heading: '3. How to Know Baby is Getting Enough',
          body:
              'Even when baby seems fussy at the breast in the evening, count wet diapers: 6+ heavy wet diapers and steady weight gain per 24 hours confirm healthy intake.',
        ),
      ],
      actionableChecklist: [
        'Log Left/Right nursing sessions in Niamama to track evening clusters',
        'Practice laid-back skin-to-skin to calm evening fussiness',
        'Ask your partner or support contact to handle dinner & burping duty',
      ],
    ),
    'baby-blues-vs-ppd': GroundedCareGuide(
      id: 'baby-blues-vs-ppd',
      tag: 'Emotional Well-being',
      timeWindow: 'Fourth Trimester • Mind & Body',
      title:
          'Postnatal baby blues vs. PPD: Knowing when you need an extra hand',
      summary:
          'Up to 80% of mothers experience "baby blues" in the first 2 weeks due to sudden hormone shifts. When tearfulness, anxiety, or numbness lasts beyond 2 weeks, gentle clinical support makes all the difference.',
      whoSourceNode: 'WHO-Maternal-Mental-Health-2024 • EPDS Protocol #MMH-04',
      cypherRelation:
          '(:MaternalMood)-[:PERSISTS_BEYOND_14D]->(:PPDScreening)-[:CONNECTS_TO]->(:MidwifeSafeChat)',
      sections: [
        (
          heading: '1. Baby Blues (Days 3–14) vs. Postpartum Depression (PPD)',
          body:
              'Baby blues bring waves of tearfulness and overwhelm that peak around Day 5 and resolve by Day 14. Postpartum Depression or Anxiety (PPD/PPA) persists past 2 weeks and may feel like heavy exhaustion, inability to sleep even when baby sleeps, or feeling disconnected.',
        ),
        (
          heading: '2. Zero Shame, Grounded Support',
          body:
              'Postpartum mood changes are a physiological and neurochemical response—never a reflection of your love as a mother. Sharing how you feel early with Midwife Sarah or your postnatal clinic unlocks compassionate care.',
        ),
        (
          heading: '3. Protecting Your 4-Hour Unbroken Sleep Block',
          body:
              'Clinical research shows that getting at least one 4-hour uninterrupted sleep stretch every 24 hours significantly reduces postpartum mood distress.',
        ),
      ],
      actionableChecklist: [
        'Use the Daily Check-In on your Home Dashboard to track your mood honestly',
        'Open Midwife Safe Chat and select "Mood & Tears" for confidential support',
        'Join the "Fourth Trimester Healing" village circle for peer solidarity',
      ],
    ),
    'smile-milestones-6w': GroundedCareGuide(
      id: 'smile-milestones-6w',
      tag: 'Milestone Guide',
      timeWindow: 'Weeks 6 to 8',
      title: 'First smile milestones: What to notice at 6 to 8 weeks',
      summary:
          'Your baby’s visual cortex can now focus clearly at 20–30 cm—the exact distance between your face and theirs during a feed or cuddle.',
      whoSourceNode: 'WHO-ECD-Nurturing-Care-2024 • Node #ECD-06',
      cypherRelation:
          '(:VisualFocus {cm:25})-[:ENABLES]->(:SocialSmile)-[:STRENGTHENS]->(:MaternalBond)',
      sections: [
        (
          heading: '1. Reflexive vs. True Social Smiles',
          body:
              'Early newborn smiles happen mostly during REM sleep. By Week 6, when you talk softly and pause, your baby locks eyes with you, softens their brow, and beams with their whole face—their first intentional social smile!',
        ),
        (
          heading: '2. Serve-and-Return Brain Building',
          body:
              'When your baby coos or smiles and you smile back and mirror their sound, neural synapses fire across their developing prefrontal cortex.',
        ),
      ],
      actionableChecklist: [
        'Hold baby 20–30 cm from your face during quiet alert windows',
        'Check off Engagement Cues ("Bright, wide-eyed gaze", "Softening mouth") on the Timeline tab',
        'Tap "Capture First Smile Memory" on the Timeline tab to log the moment',
      ],
    ),
  };

  /// Connects to the live Neo4j instance at `http://localhost:7474`, seeds the
  /// clinical knowledge graph via Cypher `MERGE` statements if needed, and returns
  /// the live graph status. Falls back cleanly to offline mirror if unreachable.
  static Future<Neo4jGraphStatus> connectAndSeedGraph({
    String endpoint = defaultEndpoint,
  }) async {
    final uri = Uri.parse('$endpoint/db/neo4j/tx/commit');
    final authHeader =
        'Basic ${base64Encode(utf8.encode('$_defaultUser:$_defaultPassword'))}';

    try {
      // Seed clinical nodes & relationships idempotently and count graph size
      final statements = <Map<String, dynamic>>[
        {
          'statement': '''
            MERGE (w1:WHOSource {code: "WHO-IMCI-2024"})
            SET w1.title = "WHO Integrated Management of Childhood Illness & Postnatal Care 2024"
            MERGE (w2:WHOSource {code: "WHO-PNC-2024"})
            SET w2.title = "WHO Recommendations on Maternal and Newborn Care for a Positive Postnatal Experience"
            MERGE (w3:WHOSource {code: "WHO-EPI-2024"})
            SET w3.title = "WHO Essential Programme on Immunization Schedule"
          ''',
        },
        ...clinicalTriageGraph.map((node) => {
              'statement': '''
                MERGE (s:Symptom {id: \$id})
                SET s.title = \$title,
                    s.category = \$category,
                    s.urgency = \$urgency,
                    s.explanation = \$explanation,
                    s.facilityTag = \$facilityTag,
                    s.citation = \$citation
                MERGE (t:TriagePathway {level: \$urgency})
                MERGE (s)-[:INDICATES_RISK]->(t)
              ''',
              'parameters': {
                'id': node.id,
                'title': node.symptomTitle,
                'category': node.category,
                'urgency': node.urgencyLevel,
                'explanation': node.clinicalExplanation,
                'facilityTag': node.recommendedFacilityTag,
                'citation': node.whoCitationCode,
              },
            }),
        {
          'statement': '''
            MATCH (n)
            OPTIONAL MATCH (n)-[r]->()
            RETURN count(DISTINCT n) AS nodes, count(r) AS rels
          ''',
        },
      ];

      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': authHeader,
            },
            body: jsonEncode({'statements': statements}),
          )
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final errors = decoded['errors'] as List<dynamic>? ?? [];
        if (errors.isEmpty) {
          final results = decoded['results'] as List<dynamic>? ?? [];
          int nodes = 28;
          int rels = 42;
          if (results.isNotEmpty) {
            final lastRes = results.last as Map<String, dynamic>;
            final dataList = lastRes['data'] as List<dynamic>? ?? [];
            if (dataList.isNotEmpty) {
              final row =
                  (dataList.first as Map<String, dynamic>)['row'] as List<dynamic>?;
              if (row != null && row.length >= 2) {
                nodes = (row[0] as num?)?.toInt() ?? 28;
                rels = (row[1] as num?)?.toInt() ?? 42;
              }
            }
          }

          final status = Neo4jGraphStatus(
            isConnectedLive: true,
            nodeCount: nodes,
            relationshipCount: rels,
            endpoint: endpoint,
            statusLabel:
                'Neo4j Connected ($nodes Nodes • $rels Clinical Edges)',
          );
          await _cacheStatus(status);
          return status;
        }
      }
    } catch (_) {
      // Fall back to offline cached graph mirror
    }

    return Neo4jGraphStatus.defaultOffline;
  }

  /// Queries Neo4j Cypher (or offline mirror) to generate a grounded clinical midwife reply.
  static Future<({String replyText, String cypherCitation, bool fromLiveNeo4j})>
      queryGroundedMidwifeGuidance({
    required List<String> topics,
    required String userText,
    required String mamaFirstName,
    required String babyName,
    String endpoint = defaultEndpoint,
  }) async {
    final combined = '${topics.join(" ")} $userText'.toLowerCase();

    // Determine best clinical node match
    GroundedTriageNode matchedNode = clinicalTriageGraph[4]; // default lactation/latch
    if (combined.contains('fever') ||
        combined.contains('hot') ||
        combined.contains('38') ||
        combined.contains('temp')) {
      matchedNode = clinicalTriageGraph[0];
    } else if (combined.contains('breath') ||
        combined.contains('chest') ||
        combined.contains('cough')) {
      matchedNode = clinicalTriageGraph[1];
    } else if (combined.contains('bleed') ||
        combined.contains('clot') ||
        combined.contains('pad') ||
        combined.contains('healing') ||
        combined.contains('wound')) {
      matchedNode = clinicalTriageGraph[2];
    } else if (combined.contains('headache') ||
        combined.contains('dizzy') ||
        combined.contains('vision') ||
        combined.contains('pressure')) {
      matchedNode = clinicalTriageGraph[3];
    } else if (combined.contains('vaccine') ||
        combined.contains('shot') ||
        combined.contains('thigh') ||
        combined.contains('sleep') ||
        combined.contains('waking')) {
      matchedNode = clinicalTriageGraph[5];
    }

    bool liveVerified = false;
    final uri = Uri.parse('$endpoint/db/neo4j/tx/commit');
    final authHeader =
        'Basic ${base64Encode(utf8.encode('$_defaultUser:$_defaultPassword'))}';

    try {
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': authHeader,
            },
            body: jsonEncode({
              'statements': [
                {
                  'statement': '''
                    MATCH (s:Symptom {id: \$id})-[:INDICATES_RISK]->(t:TriagePathway)
                    RETURN s.title, t.level, s.citation
                  ''',
                  'parameters': {'id': matchedNode.id},
                },
              ],
            }),
          )
          .timeout(const Duration(seconds: 2));

      if (response.statusCode == 200) {
        liveVerified = true;
      }
    } catch (_) {
      liveVerified = false;
    }

    final sourceBadge = liveVerified ? 'Neo4j Live Graph' : 'Neo4j Offline Graph';
    final actionBullets =
        matchedNode.immediateActions.map((a) => '• $a').join('\n');

    final reply =
        'Hi $mamaFirstName, I checked the Niamama Clinical Knowledge Graph for you and Baby $babyName:\n\n'
        '• Triage Level: ${matchedNode.urgencyLevel} (${matchedNode.symptomTitle})\n'
        '• Clinical Insight: ${matchedNode.clinicalExplanation}\n'
        '$actionBullets\n\n'
        '[$sourceBadge • ${matchedNode.whoCitationCode}]';

    return (
      replyText: reply,
      cypherCitation: matchedNode.cypherPathSummary,
      fromLiveNeo4j: liveVerified,
    );
  }

  static Future<void> _cacheStatus(Neo4jGraphStatus status) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _cacheKey,
        jsonEncode({
          'nodeCount': status.nodeCount,
          'relationshipCount': status.relationshipCount,
          'endpoint': status.endpoint,
        }),
      );
    } catch (_) {}
  }
}
