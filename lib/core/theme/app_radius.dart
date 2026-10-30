import 'package:flutter/material.dart';

class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double round = 999.0;

  static final BorderRadius smBorder = BorderRadius.circular(sm);
  static final BorderRadius mdBorder = BorderRadius.circular(md);
  static final BorderRadius lgBorder = BorderRadius.circular(lg);
  static final BorderRadius xlBorder = BorderRadius.circular(xl);
  static final BorderRadius roundBorder = BorderRadius.circular(round);

  static const BorderRadius card = BorderRadius.all(Radius.circular(16.0));
  static const BorderRadius button = BorderRadius.all(Radius.circular(12.0));
  static const BorderRadius bottomSheet = BorderRadius.vertical(top: Radius.circular(24.0));
}
