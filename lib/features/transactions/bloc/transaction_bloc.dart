import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/transaction_model.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial()) {
    on<LoadTransactionsEvent>(_onLoadTransactions);
    on<FilterTransactionsEvent>(_onFilterTransactions);
  }

  final List<TransactionModel> _mockHistory = [
    TransactionModel(
      id: "tx-9941",
      type: TransactionType.buy,
      assetSymbol: "BTC",
      amount: 0.1500,
      priceUsd: 88120.00,
      timestamp: DateTime.now().subtract(const Duration(minutes: 42)),
      status: "Completed",
    ),
    TransactionModel(
      id: "tx-9940",
      type: TransactionType.sell,
      assetSymbol: "SOL",
      amount: 15.0000,
      priceUsd: 212.50,
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      status: "Completed",
    ),
    TransactionModel(
      id: "tx-9939",
      type: TransactionType.deposit,
      assetSymbol: "USDT",
      amount: 5000.0000,
      priceUsd: 1.00,
      timestamp: DateTime.now().subtract(const Duration(hours: 12)),
      status: "Completed",
    ),
    TransactionModel(
      id: "tx-9938",
      type: TransactionType.buy,
      assetSymbol: "ETH",
      amount: 2.5000,
      priceUsd: 3410.20,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      status: "Completed",
    ),
    TransactionModel(
      id: "tx-9937",
      type: TransactionType.withdraw,
      assetSymbol: "USDC",
      amount: 1200.0000,
      priceUsd: 1.00,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      status: "Completed",
    ),
  ];

  void _onLoadTransactions(LoadTransactionsEvent event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading());
    await Future.delayed(const Duration(milliseconds: 200));
    emit(TransactionLoaded(transactions: _mockHistory));
  }

  void _onFilterTransactions(FilterTransactionsEvent event, Emitter<TransactionState> emit) {
    if (event.filterType == null) {
      emit(TransactionLoaded(transactions: _mockHistory, activeFilter: null));
    } else {
      final filtered = _mockHistory.where((t) => t.type == event.filterType).toList();
      emit(TransactionLoaded(transactions: filtered, activeFilter: event.filterType));
    }
  }
}
