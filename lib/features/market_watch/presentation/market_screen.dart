import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../bloc/market_bloc.dart';
import '../bloc/market_event.dart';
import '../bloc/market_state.dart';
import 'candlestick_chart_widget.dart';
import 'order_book_widget.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<MarketBloc, MarketState>(
          builder: (context, state) {
            String activePair = "BTC/USDT";
            if (state is MarketLoaded) {
              activePair = state.activePair;
            }
            return Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Text(
                        activePair,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.greenLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "SPOT 10x",
                    style: TextStyle(color: AppColors.green, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_border_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.candlestick_chart_rounded),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<MarketBloc, MarketState>(
        builder: (context, state) {
          if (state is MarketLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.secondary));
          }

          if (state is MarketLoaded) {
            final ticker = state.ticker;
            final isBullish = ticker.change24h >= 0;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Pair Quick Selectors
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ["BTC/USDT", "ETH/USDT", "SOL/USDT"].map((pair) {
                        final isSelected = pair == state.activePair;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(pair),
                            selected: isSelected,
                            onSelected: (val) {
                              if (val) {
                                context.read<MarketBloc>().add(SelectTradingPairEvent(pair));
                              }
                            },
                            selectedColor: AppColors.primary,
                            backgroundColor: AppColors.surface,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textSecondary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Ticker Summary Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            CurrencyFormatter.formatUsd(ticker.lastPrice),
                            style: TextStyle(
                              color: isBullish ? AppColors.green : AppColors.red,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                CurrencyFormatter.formatPercentage(ticker.change24h),
                                style: TextStyle(
                                  color: isBullish ? AppColors.green : AppColors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text("Live Ticks", style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildStatLabel("24h High", CurrencyFormatter.formatUsd(ticker.high24h)),
                          const SizedBox(height: 4),
                          _buildStatLabel("24h Low", CurrencyFormatter.formatUsd(ticker.low24h)),
                          const SizedBox(height: 4),
                          _buildStatLabel("24h Vol", CurrencyFormatter.formatCompact(ticker.volume24h)),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Timeframe selector
                  Row(
                    children: ["15M", "1H", "4H", "1D", "1W"].map((tf) {
                      final isSelected = tf == state.activeTimeframe;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: InkWell(
                          onTap: () {
                            context.read<MarketBloc>().add(SelectTimeframeEvent(tf));
                          },
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.surfaceLight : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isSelected ? AppColors.secondary : Colors.transparent,
                              ),
                            ),
                            child: Text(
                              tf,
                              style: TextStyle(
                                color: isSelected ? AppColors.secondary : AppColors.textMuted,
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Interactive Candlestick Chart
                  CandlestickChartWidget(candles: state.candles),

                  const SizedBox(height: 16),

                  // Order Book
                  OrderBookWidget(bids: state.bids, asks: state.asks),

                  const SizedBox(height: 20),

                  // Action Buttons (Buy & Sell)
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            _showOrderSheet(context, "Buy", state.activePair, ticker.lastPrice, AppColors.green);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("BUY / LONG", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            _showOrderSheet(context, "Sell", state.activePair, ticker.lastPrice, AppColors.red);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("SELL / SHORT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }

          return const Center(child: Text("No market data"));
        },
      ),
    );
  }

  Widget _buildStatLabel(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
        const SizedBox(width: 6),
        Text(value, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _showOrderSheet(BuildContext context, String action, String pair, double price, Color color) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "$action $pair",
                style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                "Execution Price: ${CurrencyFormatter.formatUsd(price)}",
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  backgroundColor: color,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("Confirm $action", style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
