import 'package:flutter/material.dart';

class AppColors {
  // Brand Greens
  // Primary Green: Colors.green.shade800 (#2E7D32) - WCAG AA compliant (5.15:1 contrast on white)
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color primaryLight = Color(0xFFE8F5E9);
  static const Color onPrimary = Colors.white;

  // Accent Green: Mint (#20DB7E) - Used as accent only, always with dark text
  static const Color accent = Color.fromARGB(255, 32, 219, 126);
  static const Color onAccent = Color(0xFF1E232A); // Dark text on mint (8.57:1 contrast)

  // Preserved Palette Tokens (replacing raw Colors.green/greenAccent across codebase)
  static const Color catalogGreen = Color(0xFF2E7D32);
  static const Color splashGreen = Color.fromARGB(255, 92, 236, 97);

  // Background & Surfaces
  static const Color background = Colors.white;
  static const Color surface = Colors.white;
  static const Color surfaceDim = Color(0xFFF7F9FA);

  // Typography with >= 4.5:1 contrast against white (#FFFFFF)
  static const Color textPrimary = Color(0xFF1E232A); // Contrast 16.2:1 (WCAG AAA)
  static const Color textSecondary = Color(0xFF4A5568); // Contrast 7.0:1 (WCAG AAA)
  static const Color textHint = Color(0xFF5A626A); // Contrast 5.2:1 (WCAG AA)

  // Borders & Dividers
  static const Color border = Color(0xFFE2E6EA);
  static const Color divider = Color(0xFFEEF0F2);

  // State Feedback
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFF57C00);
  static const Color success = Color(0xFF2E7D32);
  static const Color info = Color(0xFF1976D2);

  // Navigation & Overlays
  static const Color navBackground = Color(0xFF212529); // Contrast on white: 15.4:1
  static const Color navItemUnselected = Color(0xFF9E9E9E);
  static const Color shadow = Color(0x14000000);
}
