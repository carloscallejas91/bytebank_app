import 'package:get/get.dart';
import 'package:mobile_app/app/utils/date_formatter.dart';

class DashboardController extends GetxController {
  final String now = DateFormatter.formatDayOfWeekWithDate();

  final Map<String, double> sampleSpending = {
    'PIX': 1200.0,
    'Cartão de Crédito': 800.0,
    'Boleto': 450.0,
    'Cartão de Débito': 60.0,
    'Vale Alimentação': 40.0,
  };
}
