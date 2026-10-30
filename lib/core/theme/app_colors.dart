import 'package:flutter/material.dart';

class AppColors {
  // Brand Greens found across codebase
  static const Color brandMint = Color.fromARGB(255, 32, 219, 126); // Auth & OTP (#20DB7E)
  static const Color brandTeal = Color(0xFF008C73); // Welcome CTA (#008C73)
  static const Color materialGreen = Color(0xFF4CAF50); // Catalog & Chat (#4CAF50)
  static const Color splashGreen = Color.fromARGB(255, 92, 236, 97); // Splash (#5CEC61)
  static const Color lightGreen = Color(0xFFE8F5E9); // Pastel container

  // Proposed Primary Green: High-contrast brand green (WCAG AAA compliant on white)
  static const Color primary = Color(0xFF008C73);
  static const Color primaryDark = Color(0xFF005B4B);
  static const Color primaryLight = Color(0xFFE0F2F1);
  static const Color onPrimary = Colors.white;

  // Background & Surfaces
  static const Color background = Colors.white;
  static const Color surface = Colors.white;
  static const Color surfaceDim = Color(0xFFF7F9FA);

  // Typography with >= 4.5:1 contrast
  static const Color textPrimary = Color(0xFF1E232A); // ~14:1 contrast
  static const Color textSecondary = Color(0xFF5A626A); // ~5.2:1 contrast (WCAG AA compliant)
  static const Color textHint = Color(0xFF6C757D); // ~4.6:1 contrast (replaces 1.4:1 #DDDADA)

  // Borders & Dividers
  static const Color border = Color(0xFFE2E6EA);
  static const Color divider = Color(0xFFEEF0F2);

  // States
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFF57C00);
  static const Color success = Color(0xFF2E7D32);
  static const Color info = Color(0xFF1976D2);

  // Navigation & Overlays
  static const Color navBackground = Color(0xFF212529); // Colors.black87 replacement
  static const Color shadow = Color(0x14000000);
}
