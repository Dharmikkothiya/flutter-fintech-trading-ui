import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/crypto_asset.dart';
import 'portfolio_event.dart';
import 'portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  PortfolioBloc() : super(PortfolioInitial()) {
    on<LoadPortfolioEvent>(_onLoadPortfolio);
    on<RefreshPortfolioEvent>(_onRefreshPortfolio);
    on<UpdateAssetPriceEvent>(_onUpdateAssetPrice);
  }

  final List<CryptoAsset> _mockAssets = const [
    CryptoAsset(
      id: 'btc',
      name: 'Bitcoin',
      symbol: 'BTC',
      currentPrice: 88450.00,
      holdings: 1.2450,
      change24h: 3.42,
      sparkline: [85000, 85600, 86200, 85900, 87400, 88100, 88450],
      icon: '₿',
    ),
    CryptoAsset(
      id: 'eth',
      name: 'Ethereum',
      symbol: 'ETH',
      currentPrice: 3420.50,
      holdings: 14.8000,
      change24h: -1.15,
      sparkline: [3500, 3480, 3460, 3490, 3440, 3430, 3420],
      icon: 'Ξ',
    ),
    CryptoAsset(
      id: 'sol',
      name: 'Solana',
      symbol: 'SOL',
      currentPrice: 214.80,
      holdings: 65.0000,
      change24h: 8.75,
      sparkline: [195, 198, 202, 200, 208, 210, 214.8],
      icon: '◎',
    ),
    CryptoAsset(
      id: 'bnb',
      name: 'Binance Coin',
      symbol: 'BNB',
      currentPrice: 642.10,
      holdings: 22.5000,
      change24h: 0.85,
      sparkline: [635, 638, 640, 639, 641, 640, 642.1],
      icon: 'B',
    ),
    CryptoAsset(
      id: 'avax',
      name: 'Avalanche',
      symbol: 'AVAX',
      currentPrice: 36.40,
      holdings: 120.0000,
      change24h: -2.40,
      sparkline: [38, 37.5, 37.2, 36.8, 37.0, 36.6, 36.4],
      icon: '🔺',
    ),
  ];

  void _onLoadPortfolio(LoadPortfolioEvent event, Emitter<PortfolioState> emit) async {
    emit(PortfolioLoading());
    await Future.delayed(const Duration(milliseconds: 300));
    _calculateAndEmit(List.from(_mockAssets), emit);
  }

  void _onRefreshPortfolio(RefreshPortfolioEvent event, Emitter<PortfolioState> emit) async {
    _calculateAndEmit(List.from(_mockAssets), emit);
  }

  void _onUpdateAssetPrice(UpdateAssetPriceEvent event, Emitter<PortfolioState> emit) {
    if (state is PortfolioLoaded) {
      final current = (state as PortfolioLoaded).assets;
      final updated = current.map((asset) {
        if (asset.id == event.assetId) {
          final spark = List<double>.from(asset.sparkline)..add(event.newPrice);
          if (spark.length > 10) spark.removeAt(0);
          return asset.copyWith(
            currentPrice: event.newPrice,
            change24h: event.change24h,
            sparkline: spark,
          );
        }
        return asset;
      }).toList();
      _calculateAndEmit(updated, emit);
    }
  }

  void _calculateAndEmit(List<CryptoAsset> assets, Emitter<PortfolioState> emit) {
    double totalBalance = 0;
    double totalProfit24h = 0;

    for (final a in assets) {
      final val = a.totalValue;
      totalBalance += val;
      final asset24hDelta = val * (a.change24h / 100.0);
      totalProfit24h += asset24hDelta;
    }

    final double profitPct = totalBalance > 0 ? (totalProfit24h / totalBalance) * 100 : 0.0;

    emit(PortfolioLoaded(
      assets: assets,
      totalBalance: totalBalance,
      total24hProfit: totalProfit24h,
      profitPercentage: profitPct,
    ));
  }
}
