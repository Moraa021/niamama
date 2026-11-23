import 'package:flutter/material.dart';
import '../models/niamama_models.dart';
import '../theme/nurture_bloom_theme.dart';

/// Single-handed daily trackers: wet/soiled diapers and maternal water intake.
/// All stepper buttons meet the 48x48px minimum touch target (DESIGN.md).
class DailyTrackersCard extends StatelessWidget {
  final NiamamaState state;
  final void Function({int? wet, int? soiled, int? water}) onChanged;

  const DailyTrackersCard({
    super.key,
    required this.state,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final wetOk = state.wetDiapers >= NiamamaState.wetDiaperTarget;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NurtureBloomColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: NurtureBloomColors.ambientWarmShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Daily Care Trackers', style: NurtureBloomTextStyles.headlineSm),
          const SizedBox(height: 4),
          Text(
            wetOk
                ? 'Great: ${state.wetDiapers} wet diapers today shows good milk intake.'
                : 'Aim for ${NiamamaState.wetDiaperTarget}+ heavy wet diapers per 24 hours.',
            style: NurtureBloomTextStyles.bodySm.copyWith(
              color: wetOk
                  ? NurtureBloomColors.primary
                  : NurtureBloomColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          _Stepper(
            label: 'Wet diapers',
            icon: Icons.water_drop_rounded,
            value: state.wetDiapers,
            target: NiamamaState.wetDiaperTarget,
            onChanged: (v) => onChanged(wet: v),
          ),
          _Stepper(
            label: 'Soiled diapers',
            icon: Icons.baby_changing_station_rounded,
            value: state.soiledDiapers,
            onChanged: (v) => onChanged(soiled: v),
          ),
          _Stepper(
            label: "Mama's water (glasses)",
            icon: Icons.local_drink_rounded,
            value: state.waterGlasses,
            target: NiamamaState.waterGlassTarget,
            onChanged: (v) => onChanged(water: v),
          ),
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  final String label;
  final IconData icon;
  final int value;
  final int? target;
  final void Function(int) onChanged;

  const _Stepper({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.target,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: NurtureBloomColors.primary),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: NurtureBloomTextStyles.labelMd)),
        SizedBox(
          width: 48,
          height: 48,
          child: IconButton(
            tooltip: 'Decrease $label',
            onPressed: value > 0 ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove_circle_outline_rounded),
          ),
        ),
        SizedBox(
          width: 44,
          child: Text(
            target != null ? '$value/$target' : '$value',
            textAlign: TextAlign.center,
            style: NurtureBloomTextStyles.labelMd,
          ),
        ),
        SizedBox(
          width: 48,
          height: 48,
          child: IconButton(
            tooltip: 'Increase $label',
            onPressed: () => onChanged(value + 1),
            icon: const Icon(Icons.add_circle_rounded),
          ),
        ),
      ],
    );
  }
}
