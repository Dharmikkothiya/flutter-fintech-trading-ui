import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/math_helpers.dart';
import '../models/candlestick_data.dart';
import '../models/ticker_model.dart';
import 'market_event.dart';
import 'market_state.dart';

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  Timer? _tickerTimer;

  MarketBloc() : super(MarketInitial()) {
    on<SelectTradingPairEvent>(_onSelectTradingPair);
    on<SelectTimeframeEvent>(_onSelectTimeframe);
    on<TickReceivedEvent>(_onTickReceived);

    // Initial load
    add(const SelectTradingPairEvent("BTC/USDT"));

    // Simulate high-frequency 60fps / tick updates
    _tickerTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (state is MarketLoaded) {
        final currentPrice = (state as MarketLoaded).ticker.lastPrice;
        final nextPrice = MathHelpers.randomTickJitter(currentPrice, 0.0015);
        add(TickReceivedEvent(nextPrice));
      }
    });
  }

  @override
  Future<void> close() {
    _tickerTimer?.cancel();
    return super.close();
  }

  void _onSelectTradingPair(SelectTradingPairEvent event, Emitter<MarketState> emit) {
    emit(MarketLoading());
    final candles = _generateCandles(event.pair);
    final ticker = TickerModel(
      pair: event.pair,
      lastPrice: candles.last.close,
      change24h: 3.45,
      high24h: candles.map((e) => e.high).reduce((a, b) => a > b ? a : b),
      low24h: candles.map((e) => e.low).reduce((a, b) => a < b ? a : b),
      volume24h: 42850.5,
    );

    emit(MarketLoaded(
      ticker: ticker,
      activePair: event.pair,
      activeTimeframe: "1D",
      candles: candles,
      bids: _generateBids(ticker.lastPrice),
      asks: _generateAsks(ticker.lastPrice),
    ));
  }

  void _onSelectTimeframe(SelectTimeframeEvent event, Emitter<MarketState> emit) {
    if (state is MarketLoaded) {
      final current = state as MarketLoaded;
      emit(MarketLoaded(
        ticker: current.ticker,
        activePair: current.activePair,
        activeTimeframe: event.timeframe,
        candles: _generateCandles(current.activePair),
        bids: current.bids,
        asks: current.asks,
      ));
    }
  }

  void _onTickReceived(TickReceivedEvent event, Emitter<MarketState> emit) {
    if (state is MarketLoaded) {
      final current = state as MarketLoaded;
      final candles = List<CandlestickData>.from(current.candles);
      if (candles.isNotEmpty) {
        final last = candles.last;
        final updatedCandle = CandlestickData(
          timestamp: last.timestamp,
          open: last.open,
          high: event.newPrice > last.high ? event.newPrice : last.high,
          low: event.newPrice < last.low ? event.newPrice : last.low,
          close: event.newPrice,
          volume: last.volume + 0.15,
        );
        candles[candles.length - 1] = updatedCandle;
      }

      final updatedTicker = current.ticker.copyWith(
        lastPrice: event.newPrice,
      );

      emit(MarketLoaded(
        ticker: updatedTicker,
        activePair: current.activePair,
        activeTimeframe: current.activeTimeframe,
        candles: candles,
        bids: _generateBids(event.newPrice),
        asks: _generateAsks(event.newPrice),
      ));
    }
  }

  List<CandlestickData> _generateCandles(String pair) {
    double base = pair.startsWith("BTC")
        ? 88000.0
        : pair.startsWith("ETH")
            ? 3400.0
            : 210.0;

    final now = DateTime.now();
    List<CandlestickData> list = [];

    for (int i = 30; i >= 0; i--) {
      final time = now.subtract(Duration(hours: i * 4));
      final delta = (i % 2 == 0 ? 1 : -1) * (base * 0.008);
      final open = base + delta;
      final close = open + ((i % 3 == 0 ? -1 : 1) * (base * 0.006));
      final high = (open > close ? open : close) + (base * 0.004);
      final low = (open < close ? open : close) - (base * 0.004);

      list.add(CandlestickData(
        timestamp: time,
        open: open,
        high: high,
        low: low,
        close: close,
        volume: 120.0 + (i * 5),
      ));
      base = close;
    }
    return list;
  }

  List<OrderBookEntry> _generateBids(double lastPrice) {
    return [
      OrderBookEntry(price: lastPrice - 1.5, amount: 0.452, total: 0.452),
      OrderBookEntry(price: lastPrice - 3.0, amount: 1.250, total: 1.702),
      OrderBookEntry(price: lastPrice - 5.5, amount: 2.800, total: 4.502),
      OrderBookEntry(price: lastPrice - 8.0, amount: 4.100, total: 8.602),
      OrderBookEntry(price: lastPrice - 12.0, amount: 8.500, total: 17.102),
    ];
  }

  List<OrderBookEntry> _generateAsks(double lastPrice) {
    return [
      OrderBookEntry(price: lastPrice + 1.5, amount: 0.620, total: 0.620),
      OrderBookEntry(price: lastPrice + 3.2, amount: 1.150, total: 1.770),
      OrderBookEntry(price: lastPrice + 6.0, amount: 3.420, total: 5.190),
      OrderBookEntry(price: lastPrice + 8.5, amount: 5.200, total: 10.390),
      OrderBookEntry(price: lastPrice + 14.0, amount: 9.300, total: 19.690),
    ];
  }
}
