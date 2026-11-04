import 'dart:async';
import 'package:flutter/material.dart';
import '../models/niamama_models.dart';
import '../services/location_service.dart';
import '../theme/nurture_bloom_theme.dart';

class TimelineVaccinesScreen extends StatefulWidget {
  final NiamamaState state;
  final void Function(String cueId) onToggleCue;
  final VoidCallback onCaptureSmileMemory;
  final VoidCallback onCompleteTummyTimeRound;
  final void Function(String doseId, String doseName) onToggleVaccineDose;
  final VoidCallback onOpenWhoPass;
  final VoidCallback onOpenSafeChat;
  final void Function(int tabIndex) onNavigateTab;
  final void Function(CalendarReminderTarget target) onOpenCalendarReminder;
  final void Function(String message) onShowToast;

  const TimelineVaccinesScreen({
    super.key,
    required this.state,
    required this.onToggleCue,
    required this.onCaptureSmileMemory,
    required this.onCompleteTummyTimeRound,
    required this.onToggleVaccineDose,
    required this.onOpenWhoPass,
    required this.onOpenSafeChat,
    required this.onNavigateTab,
    required this.onOpenCalendarReminder,
    required this.onShowToast,
  });

  @override
  State<TimelineVaccinesScreen> createState() => _TimelineVaccinesScreenState();
}

class _TimelineVaccinesScreenState extends State<TimelineVaccinesScreen> {
  static const String _babyLeoAvatar =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuD4vjZpSklZ0coA-VJhOp8f9f-TWxF6o_Wh1j9ys5qqFFG2LBPACkY74YAaYlA93PJnhmJtKtnjH8YW-oSdQxCQyA45eIjMimR3pAWMbIxkKbwjVTS1j7-G7SruKXBW1CZYEAco2FIeJRbuVcaRJpJ2RtDKtewtXSPb75QLO5pcC_PbM_sq9Du3patVdlRpQA1XrNqzT2hMv_qIKFmXGq6TaEKdm8rNQlJdeasFzYY';
  static const String _firstSmileImg =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuB09eabLxpp82fVX6Nl7PNhryVApuaBGSUusXQlOM2Jbt18P8yx4FEZXee_wwV0063C-iD4Uc8cSpwytjMfVYdiswdIMODyi1o4obfNUVZvlT3jcMxsgF6oXUQQe0CD8tXWJMA7EM8mFLHlqpK8qBScCLpaof1_3rjJXxJ7aeuz9varkL02PtwNhk8Uqp9zQ0A37Ogt9NTu-bFh8jhFiBzaOtut3op5qKWJIUxB794';

  bool _isTimerRunning = false;
  int _secondsLeft = 119;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTummyTimer() {
    if (_isTimerRunning) {
      _timer?.cancel();
      setState(() => _isTimerRunning = false);
      return;
    }

    setState(() {
      _secondsLeft = 119;
      _isTimerRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _isTimerRunning = false);
        widget.onCompleteTummyTimeRound();
      } else {
        setState(() => _secondsLeft -= 1);
      }
    });
  }

  String _formatTimer(int secs) {
    final m = secs ~/ 60;
    final s = (secs % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final is6wScheduled =
        widget.state.savedCalendarReminders.containsKey('vaccine-6w');
    final is10wScheduled =
        widget.state.savedCalendarReminders.containsKey('vaccine-10w');
    final is14wScheduled =
        widget.state.savedCalendarReminders.containsKey('vaccine-14w');

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
      children: [
        // Profile & Child Selector Pill
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: NurtureBloomColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(999),
                boxShadow: NurtureBloomColors.ambientWarmShadow,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: NurtureBloomColors.secondaryFixed,
                    backgroundImage: const NetworkImage(_babyLeoAvatar),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Baby Leo',
                            style: NurtureBloomTextStyles.headlineSm,
                          ),
                          const Icon(
                            Icons.expand_more_rounded,
                            size: 18,
                            color: NurtureBloomColors.primary,
                          ),
                        ],
                      ),
                      Text(
                        '6 weeks • 4.8 kg',
                        style: NurtureBloomTextStyles.labelSm,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: widget.onOpenWhoPass,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NurtureBloomColors.surfaceContainerLow,
                    foregroundColor: NurtureBloomColors.primary,
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  icon: const Icon(Icons.badge_rounded, size: 18),
                  label: const Text('WHO Card'),
                ),
                const SizedBox(width: 6),
                IconButton(
                  onPressed: () => widget.onShowToast(
                    'Child profile active: Baby Leo (6 weeks)',
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: NurtureBloomColors.surfaceContainerLow,
                  ),
                  icon: const Icon(
                    Icons.person_add_alt_1_rounded,
                    size: 20,
                    color: NurtureBloomColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Warm Reassuring Status Hero Banner
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                NurtureBloomColors.primaryFixed.withValues(alpha: 0.45),
                NurtureBloomColors.surfaceContainerLowest,
                NurtureBloomColors.secondaryFixed.withValues(alpha: 0.35),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: NurtureBloomColors.ambientWarmShadow,
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
                      color: NurtureBloomColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Next Step in 4 Days',
                      style: NurtureBloomTextStyles.labelSm.copyWith(
                        color: NurtureBloomColors.primary,
                      ),
                    ),
                  ),
                  Text('Fri, Oct 18', style: NurtureBloomTextStyles.labelSm),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '6-Week Immunizations',
                          style: NurtureBloomTextStyles.headlineMd,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Gentle protection boosters for tiny lungs, digestion, and resilience.',
                          style: NurtureBloomTextStyles.bodySm,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: NurtureBloomColors.primaryFixed,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified_user_rounded,
                      color: NurtureBloomColors.primary,
                      size: 26,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Appointment Micro-Capsule
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: NurtureBloomColors.surfaceContainerLowest
                      .withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: NurtureBloomColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.local_hospital_rounded,
                        color: NurtureBloomColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Midtown Child Welfare Clinic',
                            style: NurtureBloomTextStyles.labelMd,
                          ),
                          Text(
                            '9:30 AM • Room 3B with Dr. Aris',
                            style: NurtureBloomTextStyles.bodySm,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        LocationService.dialNumber('5550192');
                        widget.onShowToast(
                          'Calling Midtown Child Welfare Clinic...',
                        );
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: NurtureBloomColors.surfaceContainerLow,
                      ),
                      icon: const Icon(
                        Icons.call_rounded,
                        size: 18,
                        color: NurtureBloomColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Milestones in Bloom
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.spa_rounded,
                  size: 20,
                  color: NurtureBloomColors.tertiary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Milestones in Bloom',
                  style: NurtureBloomTextStyles.headlineSm,
                ),
              ],
            ),
            Text('Week 6 Window', style: NurtureBloomTextStyles.labelSm),
          ],
        ),
        const SizedBox(height: 10),

        // First Smile Bento Card
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      _firstSmileImg,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              NurtureBloomColors.tertiaryFixed,
                              NurtureBloomColors.secondaryContainer,
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.sentiment_very_satisfied_rounded,
                          size: 36,
                          color: NurtureBloomColors.tertiary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Watch For Today',
                              style: NurtureBloomTextStyles.labelMd.copyWith(
                                color: NurtureBloomColors.tertiary,
                              ),
                            ),
                            const Icon(
                              Icons.favorite_rounded,
                              size: 18,
                              color: NurtureBloomColors.tertiaryFixedDim,
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'The First Social Smile',
                          style: NurtureBloomTextStyles.headlineSm,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Leo may beam back when you lean in close and speak softly.',
                          style: NurtureBloomTextStyles.bodySm,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Quick Cues Interactive Pills
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: NurtureBloomColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cues Leo is trying to engage:',
                      style: NurtureBloomTextStyles.labelSm,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _buildCueChip('gaze', 'Fixes gaze on eyes'),
                        _buildCueChip('mouth', 'Tiny mouth twitches'),
                        _buildCueChip('brows', 'Brightened brows'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: widget.onCaptureSmileMemory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NurtureBloomColors.secondaryFixed,
                    foregroundColor: NurtureBloomColors.onSecondaryFixed,
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  icon: const Icon(Icons.photo_camera_rounded, size: 18),
                  label: Text(
                    'Capture Smile Memory (${widget.state.smileMemoriesCount} saved)',
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Tummy Time Mini Habit Widget
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
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: NurtureBloomColors.secondaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.self_improvement_rounded,
                      color: NurtureBloomColors.onSecondaryContainer,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tummy Time Today',
                        style: NurtureBloomTextStyles.labelLg,
                      ),
                      Text(
                        '${widget.state.tummyTimeMinutesToday} of ${widget.state.tummyTimeGoalMinutes} mins • Goal: 2 rounds',
                        style: NurtureBloomTextStyles.bodySm,
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: _toggleTummyTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isTimerRunning
                      ? NurtureBloomColors.tertiaryContainer
                      : NurtureBloomColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const StadiumBorder(),
                ),
                icon: Icon(
                  _isTimerRunning
                      ? Icons.timer_rounded
                      : Icons.play_arrow_rounded,
                  size: 18,
                ),
                label: Text(
                  _isTimerRunning
                      ? '${_formatTimer(_secondsLeft)} left'
                      : 'Start 2m',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Interactive WHO Schedule Tracker
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.medical_information_rounded,
                  size: 20,
                  color: NurtureBloomColors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  'WHO Vaccine Schedule',
                  style: NurtureBloomTextStyles.headlineSm,
                ),
              ],
            ),
            TextButton.icon(
              onPressed: widget.onOpenWhoPass,
              icon: const Icon(Icons.info_outline_rounded, size: 16),
              label: const Text('Global Standard'),
            ),
          ],
        ),

        // 1. AT BIRTH (COMPLETED)
        _buildTimelineNode(
          badgeChild: const Icon(Icons.check_rounded, color: Colors.white),
          badgeColor: NurtureBloomColors.primary,
          cardChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'At Birth • Completed',
                    style: NurtureBloomTextStyles.labelSm.copyWith(
                      color: NurtureBloomColors.primary,
                    ),
                  ),
                  Text('Sep 2, 2024', style: NurtureBloomTextStyles.labelSm),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Newborn Essentials',
                style: NurtureBloomTextStyles.headlineSm,
              ),
              Text(
                'Given at St. Jude Birthing Center by Midwife Sarah.',
                style: NurtureBloomTextStyles.bodySm,
              ),
              const SizedBox(height: 8),
              _buildCompletedDoseRow(
                icon: Icons.shield_rounded,
                title: 'BCG (Tuberculosis)',
                lot: 'Lot #B9921',
              ),
              const SizedBox(height: 6),
              _buildCompletedDoseRow(
                icon: Icons.water_drop_rounded,
                title: 'OPV 0 (Oral Polio)',
                lot: 'Lot #P4018',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 2. 6 WEEKS (DUE IN 4 DAYS)
        _buildTimelineNode(
          badgeChild: Text(
            '6w',
            style: NurtureBloomTextStyles.headlineSm.copyWith(
              color: NurtureBloomColors.primary,
            ),
          ),
          badgeColor: NurtureBloomColors.primaryFixed,
          cardChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: is6wScheduled
                          ? NurtureBloomColors.primaryFixed
                          : NurtureBloomColors.tertiaryFixed,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      is6wScheduled
                          ? 'Reminder Set • Oct 18'
                          : 'Due Soon • Oct 18',
                      style: NurtureBloomTextStyles.labelSm.copyWith(
                        color: is6wScheduled
                            ? NurtureBloomColors.onPrimaryFixed
                            : NurtureBloomColors.onTertiaryFixed,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.alarm_rounded,
                    size: 20,
                    color: NurtureBloomColors.tertiary,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Primary Protection Series',
                style: NurtureBloomTextStyles.headlineSm,
              ),
              Text(
                '4 gentle immunizations administered together. Tap a dose to mark completed:',
                style: NurtureBloomTextStyles.bodySm,
              ),
              const SizedBox(height: 10),
              _buildInteractiveDoseTile(
                id: 'penta1',
                title: 'Penta 1 (5-in-1)',
                subtitle: 'DTP, HepB, Hib',
                route: 'Injection L',
                isOral: false,
              ),
              const SizedBox(height: 6),
              _buildInteractiveDoseTile(
                id: 'pcv1',
                title: 'PCV 1 (Pneumococcal)',
                subtitle: 'Lung & ear protection',
                route: 'Injection R',
                isOral: false,
              ),
              const SizedBox(height: 6),
              _buildInteractiveDoseTile(
                id: 'opv1',
                title: 'OPV 1 (Oral Polio)',
                subtitle: 'Sweet oral drops',
                route: 'Oral',
                isOral: true,
              ),
              const SizedBox(height: 6),
              _buildInteractiveDoseTile(
                id: 'rota1',
                title: 'Rotavirus 1',
                subtitle: 'Tummy viral defense',
                route: 'Oral',
                isOral: true,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: NurtureBloomColors.secondaryFixed.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.favorite_rounded,
                          size: 16,
                          color: NurtureBloomColors.secondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Comfort tips for Leo',
                          style: NurtureBloomTextStyles.labelMd.copyWith(
                            color: NurtureBloomColors.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Nursing or skin-to-skin directly after soothingly eases discomfort within 90 seconds. Loose cotton onesies prevent leg friction.',
                      style: NurtureBloomTextStyles.bodySm,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () => widget.onOpenCalendarReminder(
                          CalendarReminderTarget(
                            id: 'vaccine-6w',
                            title:
                                'Baby Leo 6-Week Immunizations (Penta 1, PCV 1, OPV 1, Rotavirus 1)',
                            subtitle: 'WHO Primary Protection Series',
                            location:
                                'Midtown Child Welfare Clinic • Room 3B with Dr. Aris',
                            description:
                                '6-week routine immunizations: Penta 1 (5-in-1), PCV 1, OPV 1, and Rotavirus 1.',
                            startDate:
                                DateTime.now().add(const Duration(days: 4)),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: NurtureBloomColors.primary,
                          foregroundColor: NurtureBloomColors.onPrimary,
                          elevation: 0,
                          shape: const StadiumBorder(),
                        ),
                        icon: Icon(
                          is6wScheduled
                              ? Icons.event_available_rounded
                              : Icons.calendar_month_rounded,
                          size: 18,
                        ),
                        label: Text(
                          is6wScheduled
                              ? 'Update Reminder'
                              : 'Add to Calendar',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => widget.onNavigateTab(2),
                    style: IconButton.styleFrom(
                      backgroundColor: NurtureBloomColors.surfaceContainerLow,
                      minimumSize: const Size(48, 48),
                    ),
                    icon: const Icon(
                      Icons.near_me_rounded,
                      color: NurtureBloomColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 3. 10 WEEKS (UPCOMING)
        _buildTimelineNode(
          badgeChild: Text('10w', style: NurtureBloomTextStyles.labelLg),
          badgeColor: NurtureBloomColors.surfaceContainer,
          cardChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Scheduled for Nov 15',
                    style: NurtureBloomTextStyles.labelSm,
                  ),
                  GestureDetector(
                    onTap: () => widget.onOpenCalendarReminder(
                      CalendarReminderTarget(
                        id: 'vaccine-10w',
                        title:
                            'Baby Leo 10-Week Boosters (Penta 2, OPV 2, Rotavirus 2)',
                        subtitle: 'WHO 10-Week Series',
                        location: 'Midtown Child Welfare Clinic',
                        description:
                            '10-week booster immunizations: Penta 2, OPV 2, Rotavirus 2.',
                        startDate:
                            DateTime.now().add(const Duration(days: 32)),
                      ),
                    ),
                    child: Text(
                      is10wScheduled ? 'Reminder Set ✓' : '+ Set Reminder',
                      style: NurtureBloomTextStyles.labelSm.copyWith(
                        color: NurtureBloomColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '10-Week Boosters',
                style: NurtureBloomTextStyles.headlineSm,
              ),
              Text(
                'Penta 2, OPV 2, Rotavirus 2.',
                style: NurtureBloomTextStyles.bodySm,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 4. 14 WEEKS (UPCOMING)
        _buildTimelineNode(
          badgeChild: Text('14w', style: NurtureBloomTextStyles.labelLg),
          badgeColor: NurtureBloomColors.surfaceContainer,
          cardChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Scheduled for Dec 13',
                    style: NurtureBloomTextStyles.labelSm,
                  ),
                  GestureDetector(
                    onTap: () => widget.onOpenCalendarReminder(
                      CalendarReminderTarget(
                        id: 'vaccine-14w',
                        title:
                            'Baby Leo 14-Week Protection (Penta 3, PCV 2, IPV)',
                        subtitle: 'WHO 14-Week Series',
                        location: 'Midtown Child Welfare Clinic',
                        description:
                            '14-week immunizations: Penta 3, PCV 2, and IPV (Inactivated Polio).',
                        startDate:
                            DateTime.now().add(const Duration(days: 60)),
                      ),
                    ),
                    child: Text(
                      is14wScheduled ? 'Reminder Set ✓' : '+ Set Reminder',
                      style: NurtureBloomTextStyles.labelSm.copyWith(
                        color: NurtureBloomColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '14-Week Protection',
                style: NurtureBloomTextStyles.headlineSm,
              ),
              Text(
                'Penta 3, PCV 2, IPV (Inactivated Polio).',
                style: NurtureBloomTextStyles.bodySm,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Post-Vaccine Peace of Mind
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: NurtureBloomColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(24),
            boxShadow: NurtureBloomColors.ambientWarmShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      Icons.edit_note_rounded,
                      color: NurtureBloomColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Post-Vaccine Peace of Mind',
                          style: NurtureBloomTextStyles.headlineSm,
                        ),
                        Text(
                          'What is expected vs when to text your care team.',
                          style: NurtureBloomTextStyles.bodySm,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: NurtureBloomColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: NurtureBloomColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Very Normal (Next 24-48h)',
                            style: NurtureBloomTextStyles.labelMd,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Mild sleepiness, low-grade warmth (<38°C / 100.4°F), or slight redness at injection site. Offer extra breastfeeds or hugs.',
                            style: NurtureBloomTextStyles.bodySm,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: NurtureBloomColors.secondaryFixed.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.help_outline_rounded,
                      color: NurtureBloomColors.secondary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'If Fussy or Warm',
                            style: NurtureBloomTextStyles.labelMd,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Cool cotton damp washcloth on thighs. Check with Dr. Aris before infant acetaminophen drops.',
                            style: NurtureBloomTextStyles.bodySm,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: NurtureBloomColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.support_agent_rounded,
                          color: NurtureBloomColors.tertiary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Have a late-night question?',
                          style: NurtureBloomTextStyles.labelMd,
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: widget.onOpenSafeChat,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            NurtureBloomColors.surfaceContainerLowest,
                        foregroundColor: NurtureBloomColors.primary,
                        elevation: 0,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text('Ask Midwife'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCueChip(String id, String label) {
    final selected = widget.state.engagementCues[id] == true;
    return InkWell(
      onTap: () => widget.onToggleCue(id),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? NurtureBloomColors.primaryFixed
              : NurtureBloomColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: 16,
              color: selected
                  ? NurtureBloomColors.onPrimaryFixed
                  : NurtureBloomColors.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: NurtureBloomTextStyles.labelSm.copyWith(
                color: selected
                    ? NurtureBloomColors.onPrimaryFixed
                    : NurtureBloomColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineNode({
    required Widget badgeChild,
    required Color badgeColor,
    required Widget cardChild,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 46,
          height: 46,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            color: badgeColor,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: badgeChild,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NurtureBloomColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(20),
              boxShadow: NurtureBloomColors.ambientWarmShadow,
            ),
            child: cardChild,
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedDoseRow({
    required IconData icon,
    required String title,
    required String lot,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: NurtureBloomColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: NurtureBloomColors.primary),
              const SizedBox(width: 8),
              Text(title, style: NurtureBloomTextStyles.labelMd),
            ],
          ),
          Text(lot, style: NurtureBloomTextStyles.labelSm),
        ],
      ),
    );
  }

  Widget _buildInteractiveDoseTile({
    required String id,
    required String title,
    required String subtitle,
    required String route,
    required bool isOral,
  }) {
    final isDone = widget.state.completedVaccines[id] == true;
    return InkWell(
      onTap: () => widget.onToggleVaccineDose(id, title),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDone
              ? NurtureBloomColors.primaryFixed.withValues(alpha: 0.4)
              : NurtureBloomColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isDone
                        ? NurtureBloomColors.primary
                        : isOral
                            ? NurtureBloomColors.secondaryFixed
                            : NurtureBloomColors.primaryFixed,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isDone
                        ? Icons.check_rounded
                        : isOral
                            ? Icons.water_drop_rounded
                            : Icons.vaccines_rounded,
                    size: 16,
                    color: isDone
                        ? Colors.white
                        : isOral
                            ? NurtureBloomColors.onSecondaryFixed
                            : NurtureBloomColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: NurtureBloomTextStyles.labelMd),
                    Text(subtitle, style: NurtureBloomTextStyles.labelSm),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isDone
                    ? NurtureBloomColors.primary
                    : isOral
                        ? NurtureBloomColors.secondaryFixed
                        : NurtureBloomColors.primaryFixed.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                isDone ? 'Completed ✓' : route,
                style: NurtureBloomTextStyles.labelSm.copyWith(
                  color: isDone
                      ? Colors.white
                      : isOral
                          ? NurtureBloomColors.secondary
                          : NurtureBloomColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
