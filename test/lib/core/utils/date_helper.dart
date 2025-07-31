import 'package:intl/intl.dart';

class DateHelper {
  static final DateFormat _displayFormat = DateFormat('MMM dd, yyyy');
  static final DateFormat _shortFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _longFormat = DateFormat('EEEE, MMMM dd, yyyy');
  static final DateFormat _timeFormat = DateFormat('hh:mm a');
  static final DateFormat _dateTimeFormat = DateFormat('MMM dd, yyyy hh:mm a');

  // Format date for display (Jan 15, 2024)
  static String formatDisplayDate(DateTime date) {
    return _displayFormat.format(date);
  }

  // Format date as short format (15/01/2024)
  static String formatShortDate(DateTime date) {
    return _shortFormat.format(date);
  }

  // Format date as long format (Monday, January 15, 2024)
  static String formatLongDate(DateTime date) {
    return _longFormat.format(date);
  }

  // Format time (02:30 PM)
  static String formatTime(DateTime date) {
    return _timeFormat.format(date);
  }

  // Format date and time (Jan 15, 2024 02:30 PM)
  static String formatDateTime(DateTime date) {
    return _dateTimeFormat.format(date);
  }

  // Get relative time (e.g., "2 days ago", "Just now")
  static String getRelativeTime(DateTime date) {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(date);

    if (difference.inDays > 365) {
      final int years = (difference.inDays / 365).floor();
      return years == 1 ? '1 year ago' : '$years years ago';
    } else if (difference.inDays > 30) {
      final int months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else if (difference.inDays > 0) {
      return difference.inDays == 1
          ? '1 day ago'
          : '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return difference.inHours == 1
          ? '1 hour ago'
          : '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes == 1
          ? '1 minute ago'
          : '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  // Check if date is today
  static bool isToday(DateTime date) {
    final DateTime now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  // Get work experience in years and months
  static String getWorkExperience(DateTime joiningDate) {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(joiningDate);
    final int totalDays = difference.inDays;

    if (totalDays < 30) {
      return totalDays == 0 ? 'Joined today' : '$totalDays days';
    }

    final int years = (totalDays / 365).floor();
    final int months = ((totalDays % 365) / 30).floor();

    if (years == 0) {
      return months == 1 ? '1 month' : '$months months';
    } else if (months == 0) {
      return years == 1 ? '1 year' : '$years years';
    } else {
      String yearText = years == 1 ? '1 year' : '$years years';
      String monthText = months == 1 ? '1 month' : '$months months';
      return '$yearText, $monthText';
    }
  }

  // Parse date string to DateTime
  static DateTime? parseDate(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  // Get start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Get end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }
}
