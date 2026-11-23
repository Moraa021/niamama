import 'package:flutter/material.dart';
import '../models/niamama_models.dart';
import '../theme/nurture_bloom_theme.dart';

class PartnerTask {
  final String id;
  final String text;
  const PartnerTask(this.id, this.text);
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
    PartnerTask('water', 'Refill a 1L water bottle at the nursing station'),
    PartnerTask('sleep', "Protect Mama's 4-hour unbroken sleep block"),
    PartnerTask('burp', 'Handle burping & diaper change after each feed'),
    PartnerTask(
        'meal', 'Prepare a warm meal and a snack she can eat one-handed'),
    PartnerTask(
        'night', 'Take one night feed handover (bring baby, then settle baby)'),
    PartnerTask('visitors', 'Gently manage visitors so Mama can rest'),
  ];

  static const List<String> redFlags = [
    'Severe headache that will not go away, or blurred vision (possible postpartum pre-eclampsia)',
    'Soaking a pad in under an hour, or passing large clots (heavy bleeding)',
    'Fever of 38°C or higher, or foul-smelling discharge',
    'Chest pain, trouble breathing, or one swollen painful leg',
    'Hopelessness, withdrawal, not eating, or talk of self-harm (needs support today)',
  ];

  @override
  State<PartnerCopilotSheet> createState() => _PartnerCopilotSheetState();
}

class _PartnerCopilotSheetState extends State<PartnerCopilotSheet> {
  late final Map<String, bool> _checked =
      Map<String, bool>.from(widget.checklist);

  String get _briefing {
    final w = widget.tenant.babyAgeWeeks;
    final mama = widget.tenant.mamaFirstName;
    final baby = widget.tenant.babyName;
    final phase = w <= 2
        ? 'The first two weeks are the hardest: $baby feeds very often and $mama is recovering from birth.'
        : w <= 8
            ? '$baby is feeding very often (cluster feeding is normal) and $mama\'s body is still healing, so she is tired and her mood can swing.'
            : '$baby is settling into a rhythm, but $mama is still recovering and may be running on little sleep.';
    return 'Week $w. $phase Your job right now: take the load off, so she can feed, heal and sleep.';
  }

  @override
  Widget build(BuildContext context) {
    final done =
        PartnerCopilotSheet.tasks.where((t) => _checked[t.id] ?? false).length;
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (ctx, scroll) => Container(
        decoration: const BoxDecoration(
          color: NurtureBloomColors.surfaceContainerLowest,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: ListView(
          controller: scroll,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'How to Help Right Now',
                    style: NurtureBloomTextStyles.headlineSm,
                  ),
                ),
                SizedBox(
                  width: 48,
                  height: 48,
                  child: IconButton(
                    tooltip: 'Close',
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
                  Text('30-second briefing',
                      style: NurtureBloomTextStyles.labelMd),
                  const SizedBox(height: 4),
                  Text(_briefing, style: NurtureBloomTextStyles.bodyMd),
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
                title: Text(t.text, style: NurtureBloomTextStyles.bodyMd),
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
                      Text('Red-flag watchlist',
                          style: NurtureBloomTextStyles.labelMd.copyWith(
                              color: NurtureBloomColors.onErrorContainer)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  for (final f in PartnerCopilotSheet.redFlags)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Text('• $f',
                          style: NurtureBloomTextStyles.bodySm.copyWith(
                              color: NurtureBloomColors.onErrorContainer)),
                    ),
                  const SizedBox(height: 6),
                  Text(
                    'If you notice any of these, call the maternal helpline 1190 or go to the nearest facility now.',
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
