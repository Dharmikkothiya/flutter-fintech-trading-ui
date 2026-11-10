import 'package:equatable/equatable.dart';
import '../models/candlestick_data.dart';
import '../models/ticker_model.dart';

abstract class MarketState extends Equatable {
  const MarketState();

  @override
  List<Object?> get props => [];
}

class MarketInitial extends MarketState {}

class MarketLoading extends MarketState {}

class MarketLoaded extends MarketState {
  final TickerModel ticker;
  final String activePair;
  final String activeTimeframe;
  final List<CandlestickData> candles;
  final List<OrderBookEntry> bids;
  final List<OrderBookEntry> asks;

  const MarketLoaded({
    required this.ticker,
    required this.activePair,
    required this.activeTimeframe,
    required this.candles,
    required this.bids,
    required this.asks,
  });

  @override
  List<Object?> get props => [ticker, activePair, activeTimeframe, candles, bids, asks];
}
