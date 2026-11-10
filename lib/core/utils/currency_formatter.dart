import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _usdFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static final NumberFormat _compactUsd = NumberFormat.compactCurrency(
    symbol: '\$',
  );

  static String formatUsd(double amount) {
    return _usdFormat.format(amount);
  }

  static String formatCompact(double amount) {
    return _compactUsd.format(amount);
  }

  static String formatPercentage(double percent) {
    final prefix = percent >= 0 ? '+' : '';
    return '$prefix${percent.toStringAsFixed(2)}%';
  }

  static String formatCrypto(double amount, String symbol) {
    return '${amount.toStringAsFixed(4)} $symbol';
  }
}
