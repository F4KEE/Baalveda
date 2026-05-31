import 'package:intl/intl.dart';

class DateTimeUtils {
  /// Format date to readable format (e.g., "May 31, 2026")
  static String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  /// Format date and time together (e.g., "May 31, 2026 at 2:30 PM")
  static String formatDateTime(DateTime date) {
    return DateFormat('MMM d, yyyy \'at\' h:mm a').format(date);
  }

  /// Format time only (e.g., "2:30 PM")
  static String formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  /// Format for date display in header (e.g., "Thursday, May 31, 2026")
  static String formatDateFull(DateTime date) {
    return DateFormat('EEEE, MMMM d, yyyy').format(date);
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  /// Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day;
  }

  /// Get relative date string (e.g., "Today", "Tomorrow", "May 31")
  static String getRelativeDateString(DateTime date) {
    if (isToday(date)) {
      return 'Today';
    } else if (isTomorrow(date)) {
      return 'Tomorrow';
    } else {
      return DateFormat('MMM d').format(date);
    }
  }

  /// Parse appointment date string safely
  static DateTime? parseAppointmentDate(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }
}
