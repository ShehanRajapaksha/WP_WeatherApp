import 'package:intl/intl.dart';

class DateFormatter {
  /// Format date to "Monday, Jan 1"
  static String formatFullDate(DateTime date) {
    return DateFormat('EEEE, MMM d').format(date);
  }

  /// Format date to "Jan 1"
  static String formatShortDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  /// Format time to "2:30 PM"
  static String formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  /// Format time to "14:30"
  static String formatTime24(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  /// Format to "Monday"
  static String formatDayName(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  /// Format to "Mon"
  static String formatShortDayName(DateTime date) {
    return DateFormat('E').format(date);
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  /// Get relative day name (Today, Tomorrow, or day name)
  static String getRelativeDayName(DateTime date) {
    if (isToday(date)) return 'Today';
    if (isTomorrow(date)) return 'Tomorrow';
    return formatDayName(date);
  }
}
