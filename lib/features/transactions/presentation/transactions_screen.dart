import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';
import '../bloc/transaction_state.dart';
import '../models/transaction_model.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction History"),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            tooltip: "Export CSV",
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.secondary));
          }

          if (state is TransactionLoaded) {
            final transactions = state.transactions;

            return Column(
              children: [
                // Filter Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(context, "All", null, state.activeFilter),
                        _buildFilterChip(context, "Buy", TransactionType.buy, state.activeFilter),
                        _buildFilterChip(context, "Sell", TransactionType.sell, state.activeFilter),
                        _buildFilterChip(context, "Deposit", TransactionType.deposit, state.activeFilter),
                        _buildFilterChip(context, "Withdraw", TransactionType.withdraw, state.activeFilter),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1),

                // Transactions List
                Expanded(
                  child: transactions.isEmpty
                      ? const Center(child: Text("No transactions found", style: TextStyle(color: AppColors.textMuted)))
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: transactions.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            return _buildTransactionCard(transactions[index]);
                          },
                        ),
                ),
              ],
            );
          }

          return const Center(child: Text("No transactions data"));
        },
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, TransactionType? type, TransactionType? current) {
    final isSelected = type == current;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (val) {
          context.read<TransactionBloc>().add(FilterTransactionsEvent(type));
        },
        selectedColor: AppColors.primary,
        backgroundColor: AppColors.surface,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textSecondary,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildTransactionCard(TransactionModel tx) {
    IconData icon;
    Color color;
    String prefix;

    switch (tx.type) {
      case TransactionType.buy:
        icon = Icons.add_shopping_cart_rounded;
        color = AppColors.green;
        prefix = "+";
        break;
      case TransactionType.sell:
        icon = Icons.sell_rounded;
        color = AppColors.red;
        prefix = "-";
        break;
      case TransactionType.deposit:
        icon = Icons.arrow_downward_rounded;
        color = AppColors.secondary;
        prefix = "+";
        break;
      case TransactionType.withdraw:
        icon = Icons.arrow_upward_rounded;
        color = Colors.amber;
        prefix = "-";
        break;
    }

    final dateStr = DateFormat("MMM dd, yyyy · HH:mm").format(tx.timestamp);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${tx.type.name.toUpperCase()} ${tx.assetSymbol}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  dateStr,
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "$prefix${tx.amount.toStringAsFixed(4)} ${tx.assetSymbol}",
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                CurrencyFormatter.formatUsd(tx.totalValueUsd),
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
