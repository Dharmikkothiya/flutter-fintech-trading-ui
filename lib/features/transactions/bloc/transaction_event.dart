import 'package:equatable/equatable.dart';
import '../models/transaction_model.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactionsEvent extends TransactionEvent {}

class FilterTransactionsEvent extends TransactionEvent {
  final TransactionType? filterType;

  const FilterTransactionsEvent(this.filterType);

  @override
  List<Object?> get props => [filterType];
}
