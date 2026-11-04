import 'package:flutter/material.dart';
import '../models/niamama_models.dart';
import '../services/location_service.dart';
import '../services/neo4j_knowledge_service.dart';
import '../services/offline_vault_service.dart';
import '../theme/nurture_bloom_theme.dart';

class HomeDashboardScreen extends StatelessWidget {
  final MotherTenantProfile activeTenant;
  final NiamamaState state;
  final UserCoordinates userCoords;
  final GpsPermissionStatus gpsStatus;
  final Neo4jGraphStatus graphStatus;
  final VoidCallback onToggleProfile;
  final VoidCallback onOpenTenantSecurity;
  final void Function(String mood, String label) onSelectMood;
  final void Function(FeedLogEntry entry) onLogFeed;
  final VoidCallback onRequestLocation;
  final void Function(int tabIndex) onNavigateTab;
  final VoidCallback onOpenWhoPass;
  final VoidCallback onOpenSafeChat;
  final VoidCallback onOpenSpeedDial;
  final VoidCallback onOpenClinicalTriage;
  final void Function(String guideId) onOpenCareGuide;
  final void Function(CalendarReminderTarget target) onOpenCalendarReminder;
  final void Function(String message) onShowToast;

  const HomeDashboardScreen({
    super.key,
    required this.activeTenant,
    required this.state,
    required this.userCoords,
    required this.gpsStatus,
    required this.graphStatus,
    required this.onToggleProfile,
    required this.onOpenTenantSecurity,
    required this.onSelectMood,
    required this.onLogFeed,
    required this.onRequestLocation,
    required this.onNavigateTab,
    required this.onOpenWhoPass,
    required this.onOpenSafeChat,
    required this.onOpenSpeedDial,
    required this.onOpenClinicalTriage,
    required this.onOpenCareGuide,
    required this.onOpenCalendarReminder,
    required this.onShowToast,
  });

  static const String _storyImgUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuA0HygOUrdN8pHw2-ha2BkemX8myGeSknxQfxKF7EO2m1HuOPJtLi895B0cGsUopnPwYtKoH-WLW3HvoX8T3Tv1pqSsfNMHUBWnIQ585KIoPCtgqCYbS-3jdpXlVOAQaV1dkdqjSDTGhy8uHmwN8HXNkR_HuzyJgmKDMHK1JmbcExdSrwD3gFWUAAtyts5lW2L389B4GfTXcrbM-jwNHCEUPqyf95L6JBwvQFCqP-Q';

  void _openQuickFeedModal(BuildContext context) {
    String selectedSide = 'Left';
    int durationMins = 18;
    int sleepMins = 140;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: NurtureBloomColors.surfaceContainerLowest,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(
                              color: NurtureBloomColors.primaryFixed,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.baby_changing_station_rounded,
                              color: NurtureBloomColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quick Feed & Sleep Logger',
                                style: NurtureBloomTextStyles.headlineSm,
                              ),
                              Text(
                                'Single-hand nursing tracker • Saved offline',
                                style: NurtureBloomTextStyles.labelSm,
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Dual-Tracker L/R Segments
                  Row(
                    children: ['Left', 'Right'].map((side) {
                      final isSelected = selectedSide == side;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: side == 'Left' ? 6 : 0,
                            left: side == 'Right' ? 6 : 0,
                          ),
                          child: InkWell(
                            onTap: () =>
                                setModalState(() => selectedSide = side),
                            borderRadius: BorderRadius.circular(999),
                            child: Container(
                              height: 54,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? NurtureBloomColors.primary
                                    : NurtureBloomColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? NurtureBloomColors.primaryFixed
                                          : NurtureBloomColors.outlineVariant,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '$side Side',
                                    style:
                                        NurtureBloomTextStyles.labelLg.copyWith(
                                      color: isSelected
                                          ? NurtureBloomColors.onPrimary
                                          : NurtureBloomColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),

                  // Nursing Duration Stepper
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: NurtureBloomColors.surface,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => setModalState(
                            () => durationMins =
                                durationMins > 1 ? durationMins - 1 : 1,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor:
                                NurtureBloomColors.surfaceContainerLowest,
                          ),
                          icon: const Icon(Icons.remove_rounded),
                        ),
                        Column(
                          children: [
                            Text(
                              '$durationMins mins',
                              style: NurtureBloomTextStyles.headlineMd,
                            ),
                            Text(
                              'Nursing Duration',
                              style: NurtureBloomTextStyles.labelSm,
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () =>
                              setModalState(() => durationMins += 1),
                          style: IconButton.styleFrom(
                            backgroundColor:
                                NurtureBloomColors.surfaceContainerLowest,
                          ),
                          icon: const Icon(Icons.add_rounded),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Baby Sleep Duration Stepper
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: NurtureBloomColors.surface,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => setModalState(
                            () => sleepMins =
                                sleepMins > 15 ? sleepMins - 15 : 15,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor:
                                NurtureBloomColors.surfaceContainerLowest,
                          ),
                          icon: const Icon(Icons.remove_rounded),
                        ),
                        Column(
                          children: [
                            Text(
                              '${sleepMins ~/ 60}h ${sleepMins % 60}m',
                              style: NurtureBloomTextStyles.headlineMd,
                            ),
                            Text(
                              'Baby ${activeTenant.babyName} Sleep Stretch',
                              style: NurtureBloomTextStyles.labelSm,
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () =>
                              setModalState(() => sleepMins += 15),
                          style: IconButton.styleFrom(
                            backgroundColor:
                                NurtureBloomColors.surfaceContainerLowest,
                          ),
                          icon: const Icon(Icons.add_rounded),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        onLogFeed(
                          FeedLogEntry(
                            id: 'feed-${DateTime.now().millisecondsSinceEpoch}',
                            side: selectedSide,
                            durationMinutes: durationMins,
                            sleepMinutes: sleepMins,
                            timestamp: DateTime.now(),
                          ),
                        );
                        Navigator.of(ctx).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NurtureBloomColors.primary,
                        foregroundColor: NurtureBloomColors.onPrimary,
                        shape: const StadiumBorder(),
                      ),
                      icon: const Icon(Icons.check_rounded),
                      label: const Text('Save to Offline Vault'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final latestFeed =
        state.feedLogs.isNotEmpty ? state.feedLogs.first : null;
    final lastFeedAgo = latestFeed != null
        ? OfflineVaultService.formatRelativeTime(latestFeed.timestamp)
        : '1h 45m ago';
    final sleepHours = (latestFeed?.sleepMinutes ?? 140) ~/ 60;
    final sleepRem = (latestFeed?.sleepMinutes ?? 140) % 60;
    final lastFeedSummary = latestFeed != null
        ? '${latestFeed.side} side (${latestFeed.durationMinutes}m) • ${activeTenant.babyName} slept ${sleepHours}h ${sleepRem}m'
        : 'Left side (18m) • ${activeTenant.babyName} slept 2h 20m';

    final now = DateTime.now();
    const weekdays = [
      'MONDAY',
      'TUESDAY',
      'WEDNESDAY',
      'THURSDAY',
      'FRIDAY',
      'SATURDAY',
      'SUNDAY',
    ];
    const months = [
      'JANUARY',
      'FEBRUARY',
      'MARCH',
      'APRIL',
      'MAY',
      'JUNE',
      'JULY',
      'AUGUST',
      'SEPTEMBER',
      'OCTOBER',
      'NOVEMBER',
      'DECEMBER',
    ];
    final formattedDateHeader =
        '${weekdays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}';
    final greetingPrefix = now.hour < 12
        ? 'Good morning'
        : (now.hour < 17 ? 'Good afternoon' : 'Good evening');

    final primaryHospital = LocationService.facilities.first;
    final hospitalDistKm = userCoords.isLiveGps
        ? LocationService.calculateDistanceKm(
            userCoords.lat,
            userCoords.lng,
            primaryHospital.lat,
            primaryHospital.lng,
          )
        : 2.8;
    final hospitalDriveMins = userCoords.isLiveGps
        ? LocationService.estimateTravelMinutes(hospitalDistKm, false)
        : 8;

    final isPentaScheduled =
        state.savedCalendarReminders.containsKey('vaccine-6w');
    final isPostnatalScheduled =
        state.savedCalendarReminders.containsKey('mama-postnatal-6w');

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
      children: [
        // Greeting & Date Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedDateHeader,
                    style: NurtureBloomTextStyles.labelSm.copyWith(
                      color: NurtureBloomColors.secondary,
                      letterSpacing: 0.8,
                    ),
                  ),
                  Text(
                    '$greetingPrefix, ${activeTenant.mamaFirstName}',
                    style: NurtureBloomTextStyles.headlineLgMobile,
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: onToggleProfile,
              borderRadius: BorderRadius.circular(999),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: NurtureBloomColors.secondaryFixed,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: NurtureBloomColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      state.isBabyLeoActive
                          ? '${activeTenant.babyName} • ${activeTenant.babyAgeWeeks}w'
                          : "Mama's Care",
                      style: NurtureBloomTextStyles.labelSm.copyWith(
                        color: NurtureBloomColors.onSecondaryFixed,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.expand_more_rounded,
                      size: 18,
                      color: NurtureBloomColors.onSecondaryFixed,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Multi-Tenant Session & PIN Security Pill Bar
        InkWell(
          onTap: onOpenTenantSecurity,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: NurtureBloomColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: NurtureBloomColors.outlineVariant),
            ),
            child: Row(
              children: [
                Icon(
                  activeTenant.requirePinEveryTime
                      ? Icons.lock_rounded
                      : Icons.verified_user_rounded,
                  size: 18,
                  color: NurtureBloomColors.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    activeTenant.requirePinEveryTime
                        ? 'Vault Security: PIN Required Every Access • ${activeTenant.mamaName}'
                        : 'Session Saved (Auto-Login Active) • ${activeTenant.mamaName}',
                    style: NurtureBloomTextStyles.labelSm.copyWith(
                      color: NurtureBloomColors.onSurface,
                    ),
                  ),
                ),
                Text(
                  'PIN & Session',
                  style: NurtureBloomTextStyles.labelSm.copyWith(
                    color: NurtureBloomColors.primary,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: NurtureBloomColors.primary,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Daily Affirmation Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: NurtureBloomColors.secondaryContainer,
            borderRadius: BorderRadius.circular(20),
            boxShadow: NurtureBloomColors.ambientWarmShadow,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: NurtureBloomColors.surfaceContainerLowest,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.spa_rounded,
                  color: NurtureBloomColors.tertiary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DAILY BREATH',
                      style: NurtureBloomTextStyles.labelSm.copyWith(
                        color: NurtureBloomColors.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '“You are doing enough today. Every feed, cuddle, and quiet breath matters.”',
                      style: NurtureBloomTextStyles.bodyMd.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Gentle Check-in Bar
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: NurtureBloomColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            boxShadow: NurtureBloomColors.ambientWarmShadow,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.favorite_border_rounded,
                        size: 18,
                        color: NurtureBloomColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'How are you feeling right now?',
                        style: NurtureBloomTextStyles.labelMd,
                      ),
                    ],
                  ),
                  Text(
                    'Private & Safe',
                    style: NurtureBloomTextStyles.labelSm.copyWith(
                      color: NurtureBloomColors.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildMoodButton(
                    emoji: '🌿',
                    label: 'Resting OK',
                    id: 'resting',
                  ),
                  const SizedBox(width: 8),
                  _buildMoodButton(
                    emoji: '✨',
                    label: 'A Bit Tired',
                    id: 'tired',
                  ),
                  const SizedBox(width: 8),
                  _buildMoodButton(
                    emoji: '💬',
                    label: 'Ask Midwife',
                    id: 'midwife',
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Care Horizon Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Care Horizon', style: NurtureBloomTextStyles.headlineSm),
            Row(
              children: [
                Text(
                  'WHO Standard Schedule',
                  style: NurtureBloomTextStyles.labelSm.copyWith(
                    color: NurtureBloomColors.primary,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.verified_rounded,
                  size: 16,
                  color: NurtureBloomColors.primary,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Baby Leo's Milestone Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: NurtureBloomColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            boxShadow: NurtureBloomColors.ambientWarmShadow,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: NurtureBloomColors.primaryFixed,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.vaccines_rounded,
                          color: NurtureBloomColors.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "BABY LEO'S MILESTONE",
                            style: NurtureBloomTextStyles.labelSm.copyWith(
                              color: NurtureBloomColors.secondary,
                            ),
                          ),
                          Text(
                            'Penta 1 Vaccine',
                            style: NurtureBloomTextStyles.headlineSm,
                          ),
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => onOpenCalendarReminder(
                      CalendarReminderTarget(
                        id: 'vaccine-6w',
                        title:
                            'Baby Leo 6-Week Immunizations (Penta 1, PCV 1, OPV 1, Rotavirus 1)',
                        subtitle: 'WHO Primary Protection Series',
                        location:
                            'Midtown Child Welfare Clinic • Room 3B with Dr. Aris',
                        description:
                            '6-week routine immunizations: Penta 1 (5-in-1), PCV 1, OPV 1, and Rotavirus 1.',
                        startDate: DateTime.now().add(const Duration(days: 4)),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isPentaScheduled
                            ? NurtureBloomColors.primaryFixed
                            : NurtureBloomColors.tertiaryFixed,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        isPentaScheduled ? 'In Calendar ✓' : 'In 4 Days',
                        style: NurtureBloomTextStyles.labelSm.copyWith(
                          color: isPentaScheduled
                              ? NurtureBloomColors.onPrimaryFixed
                              : NurtureBloomColors.onTertiaryFixed,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: NurtureBloomColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.event_available_rounded,
                          size: 18,
                          color: NurtureBloomColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '6-Weeks Wellness Checkup',
                          style: NurtureBloomTextStyles.bodySm,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => onNavigateTab(1),
                      child: Row(
                        children: [
                          Text(
                            'Prep Tips',
                            style: NurtureBloomTextStyles.labelSm.copyWith(
                              color: NurtureBloomColors.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 15,
                            color: NurtureBloomColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Mama's Health Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: NurtureBloomColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            boxShadow: NurtureBloomColors.ambientWarmShadow,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: NurtureBloomColors.secondaryFixed,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.self_improvement_rounded,
                          color: NurtureBloomColors.secondary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "MAMA'S RECOVERY",
                            style: NurtureBloomTextStyles.labelSm.copyWith(
                              color: NurtureBloomColors.secondary,
                            ),
                          ),
                          Text(
                            '6-Week Postnatal Review',
                            style: NurtureBloomTextStyles.headlineSm,
                          ),
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => onOpenCalendarReminder(
                      CalendarReminderTarget(
                        id: 'mama-postnatal-6w',
                        title: "Mama's 6-Week Postnatal Wellness Review",
                        subtitle: 'Maternal Continuum of Care',
                        location:
                            'Sub-County Referral Hospital • Maternity Wing',
                        description:
                            'Comprehensive 6-week maternal recovery checkup: pelvic floor, blood pressure, and emotional wellbeing.',
                        startDate: DateTime.now().add(const Duration(days: 5)),
                        durationMinutes: 60,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isPostnatalScheduled
                            ? NurtureBloomColors.primaryFixed
                            : NurtureBloomColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        isPostnatalScheduled ? 'Reminder Set ✓' : 'Mon 10:00 AM',
                        style: NurtureBloomTextStyles.labelSm.copyWith(
                          color: isPostnatalScheduled
                              ? NurtureBloomColors.onPrimaryFixed
                              : NurtureBloomColors.onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: NurtureBloomColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            size: 16,
                            color: NurtureBloomColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Healing well',
                            style: NurtureBloomTextStyles.bodySm,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: NurtureBloomColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.nightlight_round,
                            size: 16,
                            color: NurtureBloomColors.secondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Pelvic floor rest',
                            style: NurtureBloomTextStyles.bodySm,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Gentle Sleep & Feeding Micro-Tracker Widget
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: NurtureBloomColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            boxShadow: NurtureBloomColors.ambientWarmShadow,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: NurtureBloomColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.baby_changing_station_rounded,
                        color: NurtureBloomColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Last Feed',
                                style: NurtureBloomTextStyles.labelMd,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                lastFeedAgo,
                                style: NurtureBloomTextStyles.labelSm.copyWith(
                                  color: NurtureBloomColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lastFeedSummary,
                            style: NurtureBloomTextStyles.bodySm,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _openQuickFeedModal(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: NurtureBloomColors.primaryFixed,
                  foregroundColor: NurtureBloomColors.onPrimaryFixed,
                  elevation: 0,
                  shape: const StadiumBorder(),
                ),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Log'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Essential Care & Support 2x2 Grid (Intrinsic-Height, Richly Populated & Neo4j-Grounded)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Essential Care & Support',
              style: NurtureBloomTextStyles.headlineSm,
            ),
            InkWell(
              onTap: onOpenClinicalTriage,
              borderRadius: BorderRadius.circular(999),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: NurtureBloomColors.primaryFixed,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      graphStatus.isConnectedLive
                          ? Icons.hub_rounded
                          : Icons.offline_bolt_rounded,
                      size: 13,
                      color: NurtureBloomColors.onPrimaryFixed,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      graphStatus.isConnectedLive
                          ? 'Neo4j Graph Live'
                          : 'Neo4j Grounded',
                      style: NurtureBloomTextStyles.labelSm.copyWith(
                        fontSize: 10,
                        color: NurtureBloomColors.onPrimaryFixed,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.medical_services_rounded,
                  iconBg: NurtureBloomColors.primaryFixed,
                  iconColor: NurtureBloomColors.primary,
                  badgeText: '6 Red Flags',
                  title: 'When to See Doctor',
                  subtitle:
                      'Neo4j clinical red-flag triage for infant fever, breathing & postpartum recovery',
                  actionLabel: 'Open Triage Guide',
                  onTap: onOpenClinicalTriage,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.local_hospital_rounded,
                  iconBg: NurtureBloomColors.secondaryFixed,
                  iconColor: NurtureBloomColors.secondary,
                  badgeText: '4 Nearby',
                  title: 'Pediatric Centers',
                  subtitle:
                      'Level 4/5 NICU, maternity wings, 24/7 chemists & cold-chain clinics',
                  actionLabel: 'Explore Care Map',
                  onTap: () => onNavigateTab(2),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.support_agent_rounded,
                  iconBg: NurtureBloomColors.primaryFixedDim,
                  iconColor: NurtureBloomColors.onPrimaryFixedVariant,
                  badgeText: 'Neo4j AI + RN',
                  title: 'Talk with a Midwife',
                  subtitle:
                      '24/7 safe chat with Midwife Sarah grounded in WHO postnatal protocols',
                  actionLabel: 'Start Safe Chat',
                  onTap: onOpenSafeChat,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.calendar_month_rounded,
                  iconBg: NurtureBloomColors.tertiaryFixed,
                  iconColor: NurtureBloomColors.onTertiaryFixedVariant,
                  badgeText:
                      '${state.completedVaccines.values.where((v) => v).length}/6 Verified',
                  title: 'WHO Vaccine Card',
                  subtitle:
                      'Official digital QR pass & dose tracker for Baby ${activeTenant.babyName}',
                  actionLabel: 'Open Digital Pass',
                  onTap: onOpenWhoPass,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Near-Me Facility Card (Location & Capability-Aware)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: NurtureBloomColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            boxShadow: NurtureBloomColors.ambientWarmShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.near_me_rounded,
                        size: 18,
                        color: NurtureBloomColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'NEAREST READY FACILITY',
                        style: NurtureBloomTextStyles.labelSm.copyWith(
                          color: NurtureBloomColors.primary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: NurtureBloomColors.primaryFixed,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Open 24/7 • Low Wait',
                      style: NurtureBloomTextStyles.labelSm.copyWith(
                        color: NurtureBloomColors.onPrimaryFixed,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          primaryHospital.name,
                          style: NurtureBloomTextStyles.headlineSm,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.directions_car_rounded,
                              size: 16,
                              color: NurtureBloomColors.secondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$hospitalDistKm km away • Approx. $hospitalDriveMins mins drive',
                              style: NurtureBloomTextStyles.bodySm,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (gpsStatus != GpsPermissionStatus.granted)
                    TextButton.icon(
                      onPressed: onRequestLocation,
                      style: TextButton.styleFrom(
                        backgroundColor: NurtureBloomColors.secondaryFixed,
                        foregroundColor: NurtureBloomColors.onSecondaryFixed,
                        shape: const StadiumBorder(),
                      ),
                      icon: const Icon(Icons.my_location_rounded, size: 14),
                      label: Text(
                        'Live GPS',
                        style: NurtureBloomTextStyles.labelSm.copyWith(
                          color: NurtureBloomColors.onSecondaryFixed,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: const [
                  _CapabilityChip(label: 'Maternity Ward'),
                  _CapabilityChip(label: 'Pediatric Wing'),
                  _CapabilityChip(label: 'Cold-Chain Vaccines'),
                  _CapabilityChip(label: '24/7 ER Triage'),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    LocationService.dialNumber(primaryHospital.phone);
                    onShowToast(
                      'Connecting to Sub-County Midwife Triage Desk...',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NurtureBloomColors.primary,
                    foregroundColor: NurtureBloomColors.onPrimary,
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.call_rounded, size: 20),
                  label: Text(
                    'Call Midwife Triage Desk',
                    style: NurtureBloomTextStyles.labelLg.copyWith(
                      color: NurtureBloomColors.onPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: TextButton.icon(
                  onPressed: () => onNavigateTab(2),
                  style: TextButton.styleFrom(
                    backgroundColor: NurtureBloomColors.surfaceContainerLow,
                    foregroundColor: NurtureBloomColors.onSurface,
                    shape: const StadiumBorder(),
                  ),
                  icon: const Icon(
                    Icons.map_rounded,
                    size: 18,
                    color: NurtureBloomColors.secondary,
                  ),
                  label: Text(
                    'View Route & Navigation',
                    style: NurtureBloomTextStyles.labelMd,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Photo Story Moment of Delight
        GestureDetector(
          onTap: () => onOpenCareGuide('smile-milestones-6w'),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.network(
                  _storyImgUrl,
                  height: 148,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 148,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          NurtureBloomColors.primary,
                          NurtureBloomColors.secondary,
                        ],
                      ),
                    ),
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.all(16),
                    child: Icon(
                      Icons.child_care_rounded,
                      size: 56,
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
                  ),
                ),
                Container(
                  height: 148,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        NurtureBloomColors.inverseSurface.withValues(alpha: 0.75),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Community Wisdom • Tap to Read Guide',
                          style: NurtureBloomTextStyles.labelSm.copyWith(
                            color: NurtureBloomColors.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'First smile milestones: What to notice at 6 to 8 weeks',
                        style: NurtureBloomTextStyles.labelLg.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoodButton({
    required String emoji,
    required String label,
    required String id,
  }) {
    final isSelected = state.lastMood == id;
    return Expanded(
      child: InkWell(
        onTap: () => onSelectMood(id, label),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? NurtureBloomColors.primaryFixed
                : NurtureBloomColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 2),
              Text(
                label,
                style: NurtureBloomTextStyles.labelSm.copyWith(
                  color: isSelected
                      ? NurtureBloomColors.onPrimaryFixed
                      : NurtureBloomColors.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String badgeText,
    required String title,
    required String subtitle,
    required String actionLabel,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: NurtureBloomColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          boxShadow: NurtureBloomColors.ambientWarmShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: NurtureBloomColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    badgeText,
                    style: NurtureBloomTextStyles.labelSm.copyWith(
                      fontSize: 10,
                      color: NurtureBloomColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: NurtureBloomTextStyles.labelLg),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: NurtureBloomTextStyles.bodySm.copyWith(fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    actionLabel,
                    style: NurtureBloomTextStyles.labelSm.copyWith(
                      color: NurtureBloomColors.primary,
                      fontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: NurtureBloomColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CapabilityChip extends StatelessWidget {
  final String label;

  const _CapabilityChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: NurtureBloomColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_rounded,
            size: 14,
            color: NurtureBloomColors.primary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: NurtureBloomTextStyles.labelSm.copyWith(
              color: NurtureBloomColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
