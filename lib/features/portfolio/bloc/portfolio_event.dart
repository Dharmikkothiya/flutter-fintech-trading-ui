import 'package:equatable/equatable.dart';

abstract class PortfolioEvent extends Equatable {
  const PortfolioEvent();

  @override
  List<Object?> get props => [];
}

class LoadPortfolioEvent extends PortfolioEvent {}

class RefreshPortfolioEvent extends PortfolioEvent {}

class UpdateAssetPriceEvent extends PortfolioEvent {
  final String assetId;
  final double newPrice;
  final double change24h;

  const UpdateAssetPriceEvent({
    required this.assetId,
    required this.newPrice,
    required this.change24h,
  });

  @override
  List<Object?> get props => [assetId, newPrice, change24h];
}
