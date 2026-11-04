import 'package:flutter/material.dart';
import '../models/niamama_models.dart';
import '../theme/nurture_bloom_theme.dart';

class WhoDigitalPassDialog extends StatelessWidget {
  final MotherTenantProfile tenant;
  final Map<String, bool> completedVaccines;
  final void Function(String message) onShowToast;

  const WhoDigitalPassDialog({
    super.key,
    required this.tenant,
    required this.completedVaccines,
    required this.onShowToast,
  });

  @override
  Widget build(BuildContext context) {
    final verifiedBadges = <String>[
      '✓ BCG Verified',
      '✓ OPV0 Verified',
      if (completedVaccines['penta1'] == true) '✓ Penta 1',
      if (completedVaccines['pcv1'] == true) '✓ PCV 1',
      if (completedVaccines['opv1'] == true) '✓ OPV 1',
      if (completedVaccines['rota1'] == true) '✓ Rotavirus 1',
    ];

    return Dialog(
      backgroundColor: NurtureBloomColors.surfaceContainerLowest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      color: NurtureBloomColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'WHO Digital Pass',
                      style: NurtureBloomTextStyles.headlineSm,
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: IconButton.styleFrom(
                    backgroundColor: NurtureBloomColors.surfaceContainerLow,
                  ),
                  icon: const Icon(Icons.close_rounded, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Certificate Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: NurtureBloomColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: NurtureBloomColors.outlineVariant,
                  width: 1.2,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: NurtureBloomColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: NurtureBloomColors.ambientWarmShadow,
                    ),
                    child: const Icon(
                      Icons.qr_code_2_rounded,
                      size: 76,
                      color: NurtureBloomColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Baby ${tenant.babyName} (${tenant.mamaName})',
                    style: NurtureBloomTextStyles.labelLg,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'DOB: ${tenant.babyDob} • ID ${tenant.whoPassId}',
                    style: NurtureBloomTextStyles.bodySm,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: NurtureBloomColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      spacing: 10,
                      runSpacing: 4,
                      children: verifiedBadges
                          .map(
                            (b) => Text(
                              b,
                              style: NurtureBloomTextStyles.labelSm.copyWith(
                                color: NurtureBloomColors.primary,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  onShowToast(
                    'WHO Digital Pass for Baby ${tenant.babyName} cached offline',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: NurtureBloomColors.primary,
                  foregroundColor: NurtureBloomColors.onPrimary,
                  shape: const StadiumBorder(),
                  elevation: 0,
                ),
                icon: const Icon(Icons.download_rounded, size: 18),
                label: const Text('Save to Wallet / Offline Pass'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  backgroundColor: NurtureBloomColors.surfaceContainerLow,
                  foregroundColor: NurtureBloomColors.onSurface,
                  shape: const StadiumBorder(),
                ),
                child: const Text('Close Preview'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
