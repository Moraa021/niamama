import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/niamama_models.dart';
import '../theme/nurture_bloom_theme.dart';

class PartnerTask {
  final String id;
  const PartnerTask(this.id);

  String label(AppLocalizations l) => switch (id) {
        'water' => l.partnerTaskWater,
        'sleep' => l.partnerTaskSleep,
        'burp' => l.partnerTaskBurp,
        'meal' => l.partnerTaskMeal,
        'night' => l.partnerTaskNight,
        _ => l.partnerTaskVisitors,
      };
}

/// "How to Help Right Now" companion for partners / family members.
class PartnerCopilotSheet extends StatefulWidget {
  final MotherTenantProfile tenant;
  final Map<String, bool> checklist;
  final void Function(String taskId, bool done) onToggleTask;

  const PartnerCopilotSheet({
    super.key,
    required this.tenant,
    required this.checklist,
    required this.onToggleTask,
  });

  static const List<PartnerTask> tasks = [
    PartnerTask('water'),
    PartnerTask('sleep'),
    PartnerTask('burp'),
    PartnerTask('meal'),
    PartnerTask('night'),
    PartnerTask('visitors'),
  ];

  static List<String> redFlags(AppLocalizations l) =>
      [l.redFlag1, l.redFlag2, l.redFlag3, l.redFlag4, l.redFlag5];

  @override
  State<PartnerCopilotSheet> createState() => _PartnerCopilotSheetState();
}

class _PartnerCopilotSheetState extends State<PartnerCopilotSheet> {
  late final Map<String, bool> _checked =
      Map<String, bool>.from(widget.checklist);

  String _briefing(AppLocalizations l) {
    final w = widget.tenant.babyAgeWeeks;
    final mama = widget.tenant.mamaFirstName;
    final baby = widget.tenant.babyName;
    if (w <= 2) return l.briefingEarly(w, baby, mama);
    if (w <= 8) return l.briefingMid(w, baby, mama);
    return l.briefingLate(w, baby, mama);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final done =
        PartnerCopilotSheet.tasks.where((t) => _checked[t.id] ?? false).length;
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (ctx, scroll) => Material(
        color: NurtureBloomColors.surfaceContainerLowest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        clipBehavior: Clip.antiAlias,
        child: ListView(
          controller: scroll,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l.partnerTitle,
                    style: NurtureBloomTextStyles.headlineSm,
                  ),
                ),
                SizedBox(
                  width: 48,
                  height: 48,
                  child: IconButton(
                    tooltip: l.close,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: NurtureBloomColors.primaryFixed,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.partnerBriefingTitle,
                      style: NurtureBloomTextStyles.labelMd),
                  const SizedBox(height: 4),
                  Text(_briefing(l), style: NurtureBloomTextStyles.bodyMd),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
                'Today\'s support checklist ($done/${PartnerCopilotSheet.tasks.length})',
                style: NurtureBloomTextStyles.labelMd),
            for (final t in PartnerCopilotSheet.tasks)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: _checked[t.id] ?? false,
                title: Text(t.label(l), style: NurtureBloomTextStyles.bodyMd),
                onChanged: (v) {
                  setState(() => _checked[t.id] = v ?? false);
                  widget.onToggleTask(t.id, v ?? false);
                },
              ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: NurtureBloomColors.errorContainer,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: NurtureBloomColors.onErrorContainer),
                      const SizedBox(width: 8),
                      Text(l.redFlagTitle,
                          style: NurtureBloomTextStyles.labelMd.copyWith(
                              color: NurtureBloomColors.onErrorContainer)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  for (final f in PartnerCopilotSheet.redFlags(l))
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Text('• $f',
                          style: NurtureBloomTextStyles.bodySm.copyWith(
                              color: NurtureBloomColors.onErrorContainer)),
                    ),
                  const SizedBox(height: 6),
                  Text(
                    l.redFlagCall,
                    style: NurtureBloomTextStyles.labelMd
                        .copyWith(color: NurtureBloomColors.onErrorContainer),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
