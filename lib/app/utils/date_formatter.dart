import 'package:intl/intl.dart';

class DateFormatter {
  static const String _locale = 'pt_BR';

  static String formatDayOfWeekWithDate() {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, dd/MM/yyyy', _locale).format(now);

    return formattedDate[0].toUpperCase() + formattedDate.substring(1);
  }
}
