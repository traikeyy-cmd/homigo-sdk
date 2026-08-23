import 'package:flutter/widgets.dart';

abstract final class HomiGoLocalization {
  static const Set<String> rtlLanguageCodes = {'ar', 'fa', 'he', 'ur'};

  static bool isRtlLocale(Locale locale) {
    return rtlLanguageCodes.contains(locale.languageCode.toLowerCase());
  }

  static TextDirection textDirectionFor(Locale locale) {
    return isRtlLocale(locale) ? TextDirection.rtl : TextDirection.ltr;
  }

  static Locale localeOf(BuildContext context) {
    return Localizations.localeOf(context);
  }

  static bool isRtl(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl;
  }

  static AlignmentDirectional startAlignment(BuildContext context) {
    return const AlignmentDirectional(-1, 0);
  }

  static AlignmentDirectional endAlignment(BuildContext context) {
    return const AlignmentDirectional(1, 0);
  }
}
