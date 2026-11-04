import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/niamama_models.dart';

class CalendarService {
  /// Opens the native Android Calendar Intent / iOS EventKit sheet (works 100% offline).
  static Future<bool> addToNativePhoneCalendar(
    CalendarReminderTarget target,
  ) async {
    try {
      final endDate = target.startDate.add(
        Duration(minutes: target.durationMinutes),
      );
      final event = Event(
        title: 'Niamama: ${target.title}',
        description:
            '${target.description}\n\nScheduled via Niamama Offline Maternal & Infant Care Companion.',
        location: target.location,
        startDate: target.startDate,
        endDate: endDate,
        iosParams: const IOSParams(
          reminder: Duration(hours: 2),
        ),
      );
      return await Add2Calendar.addEvent2Cal(event);
    } catch (_) {
      return false;
    }
  }

  /// Opens Google Calendar template URL as an online alternative.
  static Future<void> openGoogleCalendarTemplate(
    CalendarReminderTarget target,
  ) async {
    final endDate = target.startDate.add(
      Duration(minutes: target.durationMinutes),
    );
    String formatUtc(DateTime dt) {
      final utc = dt.toUtc().toIso8601String();
      return '${utc.replaceAll(RegExp(r'[-:]'), '').split('.').first}Z';
    }

    final dates = '${formatUtc(target.startDate)}/${formatUtc(endDate)}';
    final uri = Uri.https('calendar.google.com', '/calendar/render', {
      'action': 'TEMPLATE',
      'text': 'Niamama: ${target.title}',
      'dates': dates,
      'details': target.description,
      'location': target.location,
    });

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
