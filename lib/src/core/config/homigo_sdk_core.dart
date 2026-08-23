import 'homigo_config.dart';

/// نقطة الدخول المركزية لإعداد HomiGo SDK.
///
/// يجب استدعاء [initialize] مرة واحدة عند تشغيل التطبيق.
abstract final class HomiGoSDK {
  static HomiGoConfig? _config;

  /// هل تم تهيئة الـ SDK أم لا.
  static bool get isInitialized => _config != null;

  /// الإعداد الحالي للـ SDK.
  ///
  /// يرمي خطأ إذا حاول التطبيق استخدام الـ SDK قبل التهيئة.
  static HomiGoConfig get config {
    final currentConfig = _config;

    if (currentConfig == null) {
      throw StateError(
        'HomiGoSDK has not been initialized. '
        'Call HomiGoSDK.initialize(config: ...) before using the SDK.',
      );
    }

    return currentConfig;
  }

  /// تهيئة HomiGo SDK.
  ///
  /// يتم استدعاؤها مرة واحدة عادةً داخل main().
  static Future<void> initialize({required HomiGoConfig config}) async {
    _config = config;
  }

  /// إعادة ضبط الـ SDK.
  ///
  /// مخصصة للاختبارات وبيئات التطوير.
  static void reset() {
    _config = null;
  }
}
