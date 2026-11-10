import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/ticker_model.dart';

class OrderBookWidget extends StatelessWidget {
  final List<OrderBookEntry> bids;
  final List<OrderBookEntry> asks;

  const OrderBookWidget({
    super.key,
    required this.bids,
    required this.asks,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Order Book", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Depth 0.1", style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Expanded(child: Text("Price (USDT)", style: TextStyle(color: AppColors.textMuted, fontSize: 10))),
              Expanded(child: Text("Size", textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted, fontSize: 10))),
              Expanded(child: Text("Total", textAlign: TextAlign.end, style: TextStyle(color: AppColors.textMuted, fontSize: 10))),
            ],
          ),
          const Divider(height: 12),
          // Asks (Red)
          ...asks.take(4).map((entry) => _buildRow(entry, isBid: false)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Spread: 1.50 USDT", style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                Icon(Icons.sync_alt_rounded, size: 12, color: AppColors.textMuted),
              ],
            ),
          ),
          // Bids (Green)
          ...bids.take(4).map((entry) => _buildRow(entry, isBid: true)),
        ],
      ),
    );
  }

  Widget _buildRow(OrderBookEntry entry, {required bool isBid}) {
    final color = isBid ? AppColors.green : AppColors.red;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              entry.price.toStringAsFixed(2),
              style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              entry.amount.toStringAsFixed(3),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 11),
            ),
          ),
          Expanded(
            child: Text(
              entry.total.toStringAsFixed(3),
              textAlign: TextAlign.end,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
