import 'package:intl/intl.dart';

class CurrencyFormatter {
  static const String defaultSymbol = '₹';

  static final NumberFormat _integerFormat = NumberFormat('#,##0');
  static final NumberFormat _decimalFormat = NumberFormat('#,##0.00');

  /// Formats amount with thousands separator and 2 decimals only when needed.
  /// Examples:
  ///   format(12) => "₹12"
  ///   format(12.5) => "₹12.50"
  ///   format(1250) => "₹1,250"
  ///   format(1250.75) => "₹1,250.75"
  static String format(num amount, {String symbol = defaultSymbol}) {
    final bool hasDecimals = amount % 1 != 0;
    final String formattedNumber = hasDecimals
        ? _decimalFormat.format(amount)
        : _integerFormat.format(amount);

    return '$symbol$formattedNumber';
  }

  /// Formats without symbol.
  static String formatValue(num amount) {
    final bool hasDecimals = amount % 1 != 0;
    return hasDecimals
        ? _decimalFormat.format(amount)
        : _integerFormat.format(amount);
  }
}
