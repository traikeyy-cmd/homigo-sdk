abstract final class HomiGoValidators {
  static String? required(
    String? value, {
    String message = 'This field is required',
  }) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }

    return null;
  }

  static String? email(
    String? value, {
    bool required = false,
    String requiredMessage = 'This field is required',
    String invalidMessage = 'Invalid email address',
  }) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return required ? requiredMessage : null;
    }

    final pattern = RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

    if (!pattern.hasMatch(text)) {
      return invalidMessage;
    }

    return null;
  }

  static String? phone(
    String? value, {
    bool required = false,
    int minimumDigits = 7,
    int maximumDigits = 15,
    String requiredMessage = 'This field is required',
    String invalidMessage = 'Invalid phone number',
  }) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return required ? requiredMessage : null;
    }

    final digits = text.replaceAll(RegExp(r'\D'), '');

    if (digits.length < minimumDigits || digits.length > maximumDigits) {
      return invalidMessage;
    }

    return null;
  }

  static String? minimumLength(String? value, int length, {String? message}) {
    if (value == null || value.length < length) {
      return message ?? 'Minimum length is $length';
    }

    return null;
  }

  static String? maximumLength(String? value, int length, {String? message}) {
    if (value != null && value.length > length) {
      return message ?? 'Maximum length is $length';
    }

    return null;
  }

  static String? numeric(
    String? value, {
    bool required = false,
    String invalidMessage = 'Invalid number',
  }) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return required ? 'This field is required' : null;
    }

    if (num.tryParse(text) == null) {
      return invalidMessage;
    }

    return null;
  }

  static String? combine(
    String? value,
    List<String? Function(String?)> validators,
  ) {
    for (final validator in validators) {
      final result = validator(value);

      if (result != null) {
        return result;
      }
    }

    return null;
  }
}
