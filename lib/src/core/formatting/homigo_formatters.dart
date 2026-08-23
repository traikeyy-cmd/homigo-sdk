abstract final class HomiGoFormatters {
  static String digitsOnly(String value) {
    return value.replaceAll(RegExp(r'\D'), '');
  }

  static String normalizeWhitespace(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static String capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }

    return value[0].toUpperCase() + value.substring(1);
  }

  static String initials(String value, {int maximum = 2}) {
    final words = normalizeWhitespace(value).split(' ');

    if (words.isEmpty) {
      return '';
    }

    return words
        .where((word) => word.isNotEmpty)
        .take(maximum)
        .map((word) => word[0].toUpperCase())
        .join();
  }

  static String money(num value, {String? currency, int decimalDigits = 2}) {
    final formatted = value.toStringAsFixed(decimalDigits);

    if (currency == null || currency.isEmpty) {
      return formatted;
    }

    return '$formatted $currency';
  }

  static String maskPhone(
    String value, {
    int visibleStart = 3,
    int visibleEnd = 2,
  }) {
    final digits = digitsOnly(value);

    if (digits.length <= visibleStart + visibleEnd) {
      return digits;
    }

    final middleLength = digits.length - visibleStart - visibleEnd;

    return '${digits.substring(0, visibleStart)}'
        '${'*' * middleLength}'
        '${digits.substring(digits.length - visibleEnd)}';
  }
}
