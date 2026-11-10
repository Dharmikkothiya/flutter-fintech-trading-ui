import 'package:equatable/equatable.dart';

abstract class MarketEvent extends Equatable {
  const MarketEvent();

  @override
  List<Object?> get props => [];
}

class SelectTradingPairEvent extends MarketEvent {
  final String pair;

  const SelectTradingPairEvent(this.pair);

  @override
  List<Object?> get props => [pair];
}

class SelectTimeframeEvent extends MarketEvent {
  final String timeframe; // "1H", "4H", "1D", "1W"

  const SelectTimeframeEvent(this.timeframe);

  @override
  List<Object?> get props => [timeframe];
}

class TickReceivedEvent extends MarketEvent {
  final double newPrice;

  const TickReceivedEvent(this.newPrice);

  @override
  List<Object?> get props => [newPrice];
}
