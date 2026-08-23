import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// إدارة System UI وEdge-to-Edge لتطبيقات HomiGo.
///
/// الهدف:
/// - Edge-to-Edge
/// - Status Bar شفافة
/// - Navigation Bar شفافة
/// - ضبط ألوان الأيقونات تلقائيًا حسب Light / Dark
abstract final class HomiGoSystemUI {
  /// تشغيل إعدادات HomiGo الافتراضية للـSystem UI.
  ///
  /// يفضل استدعاؤها مرة واحدة داخل main()
  /// قبل runApp().
  static Future<void> initialize() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    await applyBrightness(Brightness.light);
  }

  /// تحديث لون أيقونات الـSystem Bars حسب الثيم الحالي.
  static Future<void> applyBrightness(Brightness brightness) async {
    final isDark = brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarContrastEnforced: false,
      ),
    );
  }
}

/// Widget يزامن ألوان الـSystem UI تلقائيًا مع الثيم.
///
/// يوضع عادةً حول التطبيق أو الصفحة الرئيسية.
class HomiGoSystemUIRegion extends StatelessWidget {
  final Widget child;

  const HomiGoSystemUIRegion({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarContrastEnforced: false,
      ),
      child: child,
    );
  }
}
