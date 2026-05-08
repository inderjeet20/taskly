import 'package:intl/intl.dart';

class AppFormatters {
  static final DateFormat _dateFormatter = DateFormat('MMM d, yyyy');
  static final DateFormat _shortDateFormatter = DateFormat('MMM d');
  static final DateFormat _timeFormatter = DateFormat('hh:mm a');
  static final DateFormat _dayHeaderFormatter = DateFormat('EEEE, MMM d');

  static String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  static String formatDate(DateTime date) => _dateFormatter.format(date);

  static String shortDate(DateTime date) => _shortDateFormatter.format(date);

  static String formatTime(DateTime date) => _timeFormatter.format(date);

  static String dayHeader(DateTime date) =>
      'Tasks for ${_dayHeaderFormatter.format(date)}';

  static String initials(String name) {
    final parts = name
        .trim()
        .split(' ')
        .where((part) => part.isNotEmpty)
        .take(2)
        .toList();
    if (parts.isEmpty) {
      return 'TU';
    }
    return parts.map((part) => part[0].toUpperCase()).join();
  }

  static bool isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}
