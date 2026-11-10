import 'package:equatable/equatable.dart';
import '../models/crypto_asset.dart';

abstract class PortfolioState extends Equatable {
  const PortfolioState();

  @override
  List<Object?> get props => [];
}

class PortfolioInitial extends PortfolioState {}

class PortfolioLoading extends PortfolioState {}

class PortfolioLoaded extends PortfolioState {
  final List<CryptoAsset> assets;
  final double totalBalance;
  final double total24hProfit;
  final double profitPercentage;

  const PortfolioLoaded({
    required this.assets,
    required this.totalBalance,
    required this.total24hProfit,
    required this.profitPercentage,
  });

  @override
  List<Object?> get props => [assets, totalBalance, total24hProfit, profitPercentage];
}

class PortfolioError extends PortfolioState {
  final String message;

  const PortfolioError(this.message);

  @override
  List<Object?> get props => [message];
}
