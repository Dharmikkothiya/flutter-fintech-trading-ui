import 'package:equatable/equatable.dart';

class CryptoAsset extends Equatable {
  final String id;
  final String name;
  final String symbol;
  final double currentPrice;
  final double holdings;
  final double change24h;
  final List<double> sparkline;
  final String icon;

  const CryptoAsset({
    required this.id,
    required this.name,
    required this.symbol,
    required this.currentPrice,
    required this.holdings,
    required this.change24h,
    required this.sparkline,
    required this.icon,
  });

  double get totalValue => currentPrice * holdings;

  CryptoAsset copyWith({
    String? id,
    String? name,
    String? symbol,
    double? currentPrice,
    double? holdings,
    double? change24h,
    List<double>? sparkline,
    String? icon,
  }) {
    return CryptoAsset(
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      currentPrice: currentPrice ?? this.currentPrice,
      holdings: holdings ?? this.holdings,
      change24h: change24h ?? this.change24h,
      sparkline: sparkline ?? this.sparkline,
      icon: icon ?? this.icon,
    );
  }

  @override
  List<Object?> get props => [id, name, symbol, currentPrice, holdings, change24h, sparkline, icon];
}
