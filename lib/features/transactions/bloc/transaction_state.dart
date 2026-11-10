import 'package:equatable/equatable.dart';
import '../models/transaction_model.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<TransactionModel> transactions;
  final TransactionType? activeFilter;

  const TransactionLoaded({
    required this.transactions,
    this.activeFilter,
  });

  @override
  List<Object?> get props => [transactions, activeFilter];
}
