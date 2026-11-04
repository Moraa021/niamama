import 'package:flutter/material.dart';
import '../models/niamama_models.dart';
import '../services/calendar_service.dart';
import '../theme/nurture_bloom_theme.dart';

class CalendarReminderSheet extends StatefulWidget {
  final CalendarReminderTarget target;
  final void Function(String reminderId, String formattedDate) onSaved;
  final void Function(String message) onShowToast;

  const CalendarReminderSheet({
    super.key,
    required this.target,
    required this.onSaved,
    required this.onShowToast,
  });

  @override
  State<CalendarReminderSheet> createState() => _CalendarReminderSheetState();
}

class _CalendarReminderSheetState extends State<CalendarReminderSheet> {
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.target.startDate;
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (date == null) return;
    if (!mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  String _formatDateTime(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final month = months[dt.month - 1];
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final min = dt.minute.toString().padLeft(2, '0');
    final amPm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$month ${dt.day}, ${dt.year} • $hour:$min $amPm';
  }

  CalendarReminderTarget _updatedTarget() => CalendarReminderTarget(
        id: widget.target.id,
        title: widget.target.title,
        subtitle: widget.target.subtitle,
        location: widget.target.location,
        description: widget.target.description,
        startDate: _selectedDateTime,
        durationMinutes: widget.target.durationMinutes,
      );

  @override
  Widget build(BuildContext context) {
    final formatted = _formatDateTime(_selectedDateTime);

    return Container(
      decoration: const BoxDecoration(
        color: NurtureBloomColors.surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
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
                      Icons.calendar_month_rounded,
                      color: NurtureBloomColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Calendar & Reminder',
                        style: NurtureBloomTextStyles.headlineSm,
                      ),
                      Text(
                        widget.target.subtitle,
                        style: NurtureBloomTextStyles.labelSm.copyWith(
                          color: NurtureBloomColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                style: IconButton.styleFrom(
                  backgroundColor: NurtureBloomColors.surfaceContainerLow,
                ),
                icon: const Icon(
                  Icons.close_rounded,
                  color: NurtureBloomColors.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Event Details Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: NurtureBloomColors.surface,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.target.title,
                  style: NurtureBloomTextStyles.labelLg,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 16,
                      color: NurtureBloomColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.target.location,
                        style: NurtureBloomTextStyles.bodySm,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  widget.target.description,
                  style: NurtureBloomTextStyles.bodySm,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Date & Time Selector
          InkWell(
            onTap: _pickDate,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: NurtureBloomColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_filled_rounded,
                        size: 20,
                        color: NurtureBloomColors.primary,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Appointment Time',
                            style: NurtureBloomTextStyles.labelSm,
                          ),
                          Text(
                            formatted,
                            style: NurtureBloomTextStyles.labelMd,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    'Change',
                    style: NurtureBloomTextStyles.labelSm.copyWith(
                      color: NurtureBloomColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Native Phone Calendar CTA (Offline capable via Add2Calendar)
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () async {
                final target = _updatedTarget();
                await CalendarService.addToNativePhoneCalendar(target);
                widget.onSaved(target.id, formatted);
                widget.onShowToast(
                  'Saved "${target.title}" to phone calendar',
                );
                if (mounted) Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: NurtureBloomColors.primary,
                foregroundColor: NurtureBloomColors.onPrimary,
                shape: const StadiumBorder(),
                elevation: 0,
              ),
              icon: const Icon(Icons.event_available_rounded, size: 20),
              label: Text(
                'Add to Phone Calendar (Offline)',
                style: NurtureBloomTextStyles.labelLg.copyWith(
                  color: NurtureBloomColors.onPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Google Calendar Sync CTA
          SizedBox(
            width: double.infinity,
            height: 46,
            child: TextButton.icon(
              onPressed: () async {
                final target = _updatedTarget();
                await CalendarService.openGoogleCalendarTemplate(target);
                widget.onSaved(target.id, formatted);
                widget.onShowToast('Opened Google Calendar reminder');
                if (mounted) Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: NurtureBloomColors.secondaryFixed,
                foregroundColor: NurtureBloomColors.onSecondaryFixed,
                shape: const StadiumBorder(),
              ),
              icon: const Icon(Icons.open_in_new_rounded, size: 18),
              label: Text(
                'Open in Google Calendar',
                style: NurtureBloomTextStyles.labelMd.copyWith(
                  color: NurtureBloomColors.onSecondaryFixed,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
