import 'package:flutter/material.dart';
import '../services/location_service.dart';
import '../services/neo4j_knowledge_service.dart';
import '../theme/nurture_bloom_theme.dart';

class Neo4jClinicalTriageSheet extends StatefulWidget {
  final Neo4jGraphStatus graphStatus;
  final VoidCallback onRefreshGraph;
  final VoidCallback onOpenSpeedDial;
  final VoidCallback onOpenSafeChat;
  final void Function(String message) onShowToast;

  const Neo4jClinicalTriageSheet({
    super.key,
    required this.graphStatus,
    required this.onRefreshGraph,
    required this.onOpenSpeedDial,
    required this.onOpenSafeChat,
    required this.onShowToast,
  });

  @override
  State<Neo4jClinicalTriageSheet> createState() =>
      _Neo4jClinicalTriageSheetState();
}

class _Neo4jClinicalTriageSheetState extends State<Neo4jClinicalTriageSheet> {
  String _selectedCategory = 'All'; // 'All' | 'Infant' | 'Maternal'

  @override
  Widget build(BuildContext context) {
    final nodes = Neo4jKnowledgeGraphService.clinicalTriageGraph.where((n) {
      if (_selectedCategory == 'All') return true;
      return n.category == _selectedCategory;
    }).toList();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: NurtureBloomColors.surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: NurtureBloomColors.primaryFixed,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.hub_rounded,
                        color: NurtureBloomColors.onPrimaryFixed,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'When to See a Doctor',
                            style: NurtureBloomTextStyles.headlineSm,
                          ),
                          Text(
                            widget.graphStatus.statusLabel,
                            style: NurtureBloomTextStyles.labelSm.copyWith(
                              color: NurtureBloomColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                style: IconButton.styleFrom(
                  backgroundColor: NurtureBloomColors.surfaceContainerLow,
                ),
                icon: const Icon(Icons.close_rounded, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Neo4j Grounded Intelligence Status Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: NurtureBloomColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: NurtureBloomColors.outlineVariant),
            ),
            child: Row(
              children: [
                Icon(
                  widget.graphStatus.isConnectedLive
                      ? Icons.cloud_done_rounded
                      : Icons.offline_bolt_rounded,
                  size: 18,
                  color: NurtureBloomColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.graphStatus.isConnectedLive
                        ? 'Live Neo4j Knowledge Graph connected (${widget.graphStatus.endpoint}) • WHO & MOH Triage Pathways verified'
                        : 'Offline Knowledge Graph Mirror active • Syncs automatically with Neo4j (${widget.graphStatus.endpoint})',
                    style: NurtureBloomTextStyles.bodySm.copyWith(fontSize: 12),
                  ),
                ),
                TextButton(
                  onPressed: widget.onRefreshGraph,
                  child: const Text('Sync Graph'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Category Filter Chips
          Row(
            children: ['All', 'Infant', 'Maternal'].map((cat) {
              final isSelected = _selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () => setState(() => _selectedCategory = cat),
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? NurtureBloomColors.primary
                          : NurtureBloomColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      cat == 'All' ? 'All Pathways (6)' : '$cat Care',
                      style: NurtureBloomTextStyles.labelSm.copyWith(
                        color: isSelected
                            ? NurtureBloomColors.onPrimary
                            : NurtureBloomColors.onSurface,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // Triage Nodes List
          Expanded(
            child: ListView.separated(
              itemCount: nodes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                final node = nodes[idx];
                final isUrgent = node.urgencyLevel == 'URGENT ER';
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: NurtureBloomColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isUrgent
                          ? NurtureBloomColors.tertiaryFixedDim
                          : NurtureBloomColors.outlineVariant,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isUrgent
                                  ? NurtureBloomColors.tertiaryFixed
                                  : NurtureBloomColors.primaryFixed,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '${node.category.toUpperCase()} • ${node.urgencyLevel}',
                              style: NurtureBloomTextStyles.labelSm.copyWith(
                                color: isUrgent
                                    ? NurtureBloomColors.onTertiaryFixed
                                    : NurtureBloomColors.onPrimaryFixed,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              node.whoCitationCode,
                              style: NurtureBloomTextStyles.labelSm.copyWith(
                                fontSize: 10,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        node.symptomTitle,
                        style: NurtureBloomTextStyles.labelLg,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        node.clinicalExplanation,
                        style: NurtureBloomTextStyles.bodySm,
                      ),
                      const SizedBox(height: 10),
                      ...node.immediateActions.map(
                        (action) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check_circle_outline_rounded,
                                size: 15,
                                color: NurtureBloomColors.primary,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  action,
                                  style: NurtureBloomTextStyles.bodySm.copyWith(
                                    color: NurtureBloomColors.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: NurtureBloomColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Cypher Path: ${node.cypherPathSummary}',
                          style: NurtureBloomTextStyles.labelSm.copyWith(
                            fontSize: 10,
                            color: NurtureBloomColors.secondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pop();
                                widget.onOpenSafeChat();
                              },
                              style: OutlinedButton.styleFrom(
                                shape: const StadiumBorder(),
                              ),
                              icon: const Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: 16,
                              ),
                              label: const Text('Ask Midwife Sarah'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                LocationService.dialNumber('0800720000');
                                widget.onShowToast(
                                  'Calling ${node.recommendedFacilityTag}...',
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isUrgent
                                    ? NurtureBloomColors.tertiary
                                    : NurtureBloomColors.primary,
                                foregroundColor: Colors.white,
                                shape: const StadiumBorder(),
                                elevation: 0,
                              ),
                              icon: const Icon(Icons.call_rounded, size: 16),
                              label: Text(
                                isUrgent ? 'Call ER Triage' : 'Call Clinic',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Neo4jCareGuideReaderSheet extends StatefulWidget {
  final GroundedCareGuide guide;
  final Neo4jGraphStatus graphStatus;
  final VoidCallback onOpenSafeChat;
  final void Function(String message) onShowToast;

  const Neo4jCareGuideReaderSheet({
    super.key,
    required this.guide,
    required this.graphStatus,
    required this.onOpenSafeChat,
    required this.onShowToast,
  });

  @override
  State<Neo4jCareGuideReaderSheet> createState() =>
      _Neo4jCareGuideReaderSheetState();
}

class _Neo4jCareGuideReaderSheetState extends State<Neo4jCareGuideReaderSheet> {
  final Set<int> _checkedItems = {0};

  @override
  Widget build(BuildContext context) {
    final g = widget.guide;
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.86,
      ),
      decoration: const BoxDecoration(
        color: NurtureBloomColors.surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: NurtureBloomColors.primaryFixed,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${g.tag} • ${g.timeWindow}',
                  style: NurtureBloomTextStyles.labelSm.copyWith(
                    color: NurtureBloomColors.onPrimaryFixed,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                style: IconButton.styleFrom(
                  backgroundColor: NurtureBloomColors.surfaceContainerLow,
                ),
                icon: const Icon(Icons.close_rounded, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(g.title, style: NurtureBloomTextStyles.headlineMd),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: NurtureBloomColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: NurtureBloomColors.outlineVariant),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.hub_rounded,
                  size: 15,
                  color: NurtureBloomColors.primary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Grounded in Neo4j: ${g.whoSourceNode}',
                    style: NurtureBloomTextStyles.labelSm.copyWith(
                      fontSize: 11,
                      color: NurtureBloomColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView(
              children: [
                Text(
                  g.summary,
                  style: NurtureBloomTextStyles.bodyMd.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 14),
                ...g.sections.map(
                  (sec) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: NurtureBloomColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(sec.heading, style: NurtureBloomTextStyles.labelLg),
                        const SizedBox(height: 6),
                        Text(sec.body, style: NurtureBloomTextStyles.bodySm),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Grounded Action Checklist',
                  style: NurtureBloomTextStyles.headlineSm,
                ),
                const SizedBox(height: 8),
                ...List.generate(g.actionableChecklist.length, (idx) {
                  final isChecked = _checkedItems.contains(idx);
                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (isChecked) {
                          _checkedItems.remove(idx);
                        } else {
                          _checkedItems.add(idx);
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Icon(
                            isChecked
                                ? Icons.check_box_rounded
                                : Icons.check_box_outline_blank_rounded,
                            color: NurtureBloomColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              g.actionableChecklist[idx],
                              style: NurtureBloomTextStyles.bodySm.copyWith(
                                color: NurtureBloomColors.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: NurtureBloomColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Neo4j Graph Relation: ${g.cypherRelation}',
                    style: NurtureBloomTextStyles.labelSm.copyWith(
                      fontSize: 10,
                      color: NurtureBloomColors.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onOpenSafeChat();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: NurtureBloomColors.primary,
                foregroundColor: NurtureBloomColors.onPrimary,
                shape: const StadiumBorder(),
                elevation: 0,
              ),
              icon: const Icon(Icons.chat_bubble_rounded, size: 18),
              label: const Text('Discuss This Guide with Midwife Sarah'),
            ),
          ),
        ],
      ),
    );
  }
}
