import 'package:intl/intl.dart';

class PresentationUtils {
  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  static String getFormattedTime(DateTime time) {
    DateTime now = DateTime.now();
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      final f = DateFormat('hh:mm');
      return f.format(time);
    }
    if (time.year == now.year) {
      final f = DateFormat('hh:mm');
      return '${_months[time.month]} ${time.day}, ${f.format(time)}';
    }
    final f = DateFormat('hh:mm');
    return '${_months[time.month]} ${time.day}, ${f.format(time)}, ${time.year}';
  }
}
