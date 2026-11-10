import 'package:equatable/equatable.dart';

class CandlestickData extends Equatable {
  final DateTime timestamp;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;

  const CandlestickData({
    required this.timestamp,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  bool get isBullish => close >= open;

  @override
  List<Object?> get props => [timestamp, open, high, low, close, volume];
}
