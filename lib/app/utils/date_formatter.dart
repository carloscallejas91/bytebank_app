import 'package:intl/intl.dart';

class DateFormatter {
  static const String _locale = 'pt_BR';

  static String formatSimpleDate(DateTime date) {
    return DateFormat('dd/MM/yyyy', _locale).format(date);
  }

  static String formatDayOfWeekWithDate() {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, dd/MM/yyyy', _locale).format(now);

    return formattedDate[0].toUpperCase() + formattedDate.substring(1);
  }

  static String formatFriendlyDate(DateTime date) {
    final timeFormat = DateFormat('\'às\' HH\'h\'mm', _locale);
    final timePart = timeFormat.format(date);

    return '${formatSimpleDate(date)} $timePart';
  }
}
