import 'package:equatable/equatable.dart';

enum TransactionType { buy, sell, deposit, withdraw }

class TransactionModel extends Equatable {
  final String id;
  final TransactionType type;
  final String assetSymbol;
  final double amount;
  final double priceUsd;
  final DateTime timestamp;
  final String status;

  const TransactionModel({
    required this.id,
    required this.type,
    required this.assetSymbol,
    required this.amount,
    required this.priceUsd,
    required this.timestamp,
    required this.status,
  });

  double get totalValueUsd => amount * priceUsd;

  @override
  List<Object?> get props => [id, type, assetSymbol, amount, priceUsd, timestamp, status];
}
