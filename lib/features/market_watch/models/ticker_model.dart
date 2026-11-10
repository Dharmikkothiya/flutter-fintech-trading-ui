import 'package:equatable/equatable.dart';

class TickerModel extends Equatable {
  final String pair; // e.g. "BTC/USDT"
  final double lastPrice;
  final double change24h;
  final double high24h;
  final double low24h;
  final double volume24h;

  const TickerModel({
    required this.pair,
    required this.lastPrice,
    required this.change24h,
    required this.high24h,
    required this.low24h,
    required this.volume24h,
  });

  TickerModel copyWith({
    String? pair,
    double? lastPrice,
    double? change24h,
    double? high24h,
    double? low24h,
    double? volume24h,
  }) {
    return TickerModel(
      pair: pair ?? this.pair,
      lastPrice: lastPrice ?? this.lastPrice,
      change24h: change24h ?? this.change24h,
      high24h: high24h ?? this.high24h,
      low24h: low24h ?? this.low24h,
      volume24h: volume24h ?? this.volume24h,
    );
  }

  @override
  List<Object?> get props => [pair, lastPrice, change24h, high24h, low24h, volume24h];
}

class OrderBookEntry extends Equatable {
  final double price;
  final double amount;
  final double total;

  const OrderBookEntry({
    required this.price,
    required this.amount,
    required this.total,
  });

  @override
  List<Object?> get props => [price, amount, total];
}
