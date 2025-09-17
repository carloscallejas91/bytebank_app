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
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    final dateToCompare = DateTime(date.year, date.month, date.day);

    if (dateToCompare == today) {
      return 'Hoje';
    } else if (dateToCompare == yesterday) {
      return 'Ontem';
    } else if (dateToCompare == tomorrow) {
      return 'Amanhã';
    } else {
      return formatSimpleDate(date);
    }
  }
}
