import 'package:flutter/material.dart';

/// Central color tokens used across the HomiGo SDK.
///
/// التطبيقات تستطيع لاحقًا تغيير ألوان الهوية من خلال HomiGoConfig
/// بدون تعديل الـ Widgets نفسها.
abstract final class HomiGoColors {
  // ============================================================
  // Brand defaults
  // ============================================================

  static const Color primary = Color(0xFF2563EB);
  static const Color secondary = Color(0xFF06B6D4);

  // ============================================================
  // Semantic colors
  // ============================================================

  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF0284C7);

  // ============================================================
  // Light mode
  // ============================================================

  static const Color lightBackground = Color(0xFFF7F9FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF1F5F9);

  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  static const Color lightBorder = Color(0xFFE2E8F0);

  // ============================================================
  // Dark mode
  // ============================================================

  static const Color darkBackground = Color(0xFF090E17);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkSurfaceVariant = Color(0xFF1E293B);

  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  static const Color darkBorder = Color(0xFF334155);

  // ============================================================
  // Glass system
  // ============================================================

  static const Color glassLight = Color(0xB3FFFFFF);
  static const Color glassDark = Color(0x99111827);

  static const Color glassBorderLight = Color(0x99FFFFFF);
  static const Color glassBorderDark = Color(0x33475569);

  // ============================================================
  // Utility
  // ============================================================

  static const Color transparent = Colors.transparent;
}
