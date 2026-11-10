import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_fintech_trading_ui/core/utils/math_helpers.dart';
import 'package:flutter_fintech_trading_ui/core/utils/currency_formatter.dart';
import 'package:flutter_fintech_trading_ui/features/portfolio/bloc/portfolio_bloc.dart';
import 'package:flutter_fintech_trading_ui/features/portfolio/bloc/portfolio_event.dart';
import 'package:flutter_fintech_trading_ui/features/portfolio/bloc/portfolio_state.dart';

void main() {
  group('MathHelpers & CurrencyFormatter Tests', () {
    test('Calculates price change percentage correctly', () {
      final change = MathHelpers.calculatePriceChange(100.0, 110.0);
      expect(change, closeTo(10.0, 0.001));
    });

    test('Computes Simple Moving Average (SMA)', () {
      final prices = [10.0, 20.0, 30.0, 40.0, 50.0];
      final sma = MathHelpers.computeSMA(prices, 3);
      expect(sma.length, 3);
      expect(sma[0], closeTo(20.0, 0.001)); // (10+20+30)/3
      expect(sma[1], closeTo(30.0, 0.001)); // (20+30+40)/3
      expect(sma[2], closeTo(40.0, 0.001)); // (30+40+50)/3
    });

    test('Formats USD and percentage correctly', () {
      expect(CurrencyFormatter.formatUsd(12450.5), '\$12,450.50');
      expect(CurrencyFormatter.formatPercentage(5.25), '+5.25%');
      expect(CurrencyFormatter.formatPercentage(-2.10), '-2.10%');
    });
  });

  group('PortfolioBloc Tests', () {
    late PortfolioBloc bloc;

    setUp(() {
      bloc = PortfolioBloc();
    });

    tearDown(() {
      bloc.close();
    });

    test('Initial state is PortfolioInitial', () {
      expect(bloc.state, equals(PortfolioInitial()));
    });

    test('LoadPortfolioEvent emits [PortfolioLoading, PortfolioLoaded]', () async {
      final expected = [
        isA<PortfolioLoading>(),
        isA<PortfolioLoaded>(),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(LoadPortfolioEvent());
    });
  });
}
