class MathUtils {
  static double calculatePercentage(double value, double otherValue) {
    final double total = value + otherValue;
    if (total == 0) {
      return 0.0;
    }
    return value / total;
  }
}
