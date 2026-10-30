import 'package:flutter/material.dart';

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;

  // Standard Screen Paddings
  static const EdgeInsets screenPadding = EdgeInsets.all(16.0);
  static const EdgeInsets screenPaddingHorizontal = EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets cardPadding = EdgeInsets.all(12.0);

  // Dynamic bottom navigation bar inset derived from real bar height + system bottom safe area
  static double bottomNavInset(BuildContext context, {double navBarHeight = 64.0}) {
    return navBarHeight + MediaQuery.paddingOf(context).bottom;
  }
}
