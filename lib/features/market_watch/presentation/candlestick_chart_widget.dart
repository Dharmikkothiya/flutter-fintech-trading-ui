import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/candlestick_data.dart';

class CandlestickChartWidget extends StatelessWidget {
  final List<CandlestickData> candles;
  final double height;

  const CandlestickChartWidget({
    super.key,
    required this.candles,
    this.height = 240,
  });

  @override
  Widget build(BuildContext context) {
    if (candles.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(child: Text("No market data")),
      );
    }

    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CustomPaint(
          size: Size.infinite,
          painter: _CandlestickPainter(candles: candles),
        ),
      ),
    );
  }
}

class _CandlestickPainter extends CustomPainter {
  final List<CandlestickData> candles;

  _CandlestickPainter({required this.candles});

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

    // Find min and max
    double minPrice = candles.map((c) => c.low).reduce(min);
    double maxPrice = candles.map((c) => c.high).reduce(max);
    double priceRange = maxPrice - minPrice;
    if (priceRange == 0) priceRange = 1.0;

    // Grid lines
    final gridPaint = Paint()
      ..color = AppColors.divider.withOpacity(0.5)
      ..strokeWidth = 0.8;

    const int gridSteps = 4;
    for (int i = 0; i <= gridSteps; i++) {
      double y = (size.height / gridSteps) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final int count = candles.length;
    final double candleWidth = (size.width / count) * 0.65;
    final double spacing = size.width / count;

    final bullPaint = Paint()
      ..color = AppColors.green
      ..style = PaintingStyle.fill;

    final bearPaint = Paint()
      ..color = AppColors.red
      ..style = PaintingStyle.fill;

    final bullWickPaint = Paint()
      ..color = AppColors.green
      ..strokeWidth = 1.2;

    final bearWickPaint = Paint()
      ..color = AppColors.red
      ..strokeWidth = 1.2;

    // Moving average path
    final maPaint = Paint()
      ..color = AppColors.secondary.withOpacity(0.85)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final Path maPath = Path();
    bool maStarted = false;

    for (int i = 0; i < count; i++) {
      final candle = candles[i];
      final double xCenter = (i * spacing) + (spacing / 2);

      // Y coordinates (inverted)
      final double yHigh = size.height - ((candle.high - minPrice) / priceRange) * size.height;
      final double yLow = size.height - ((candle.low - minPrice) / priceRange) * size.height;
      final double yOpen = size.height - ((candle.open - minPrice) / priceRange) * size.height;
      final double yClose = size.height - ((candle.close - minPrice) / priceRange) * size.height;

      final bool isBullish = candle.isBullish;
      final Paint wickPaint = isBullish ? bullWickPaint : bearWickPaint;
      final Paint bodyPaint = isBullish ? bullPaint : bearPaint;

      // Draw wick
      canvas.drawLine(Offset(xCenter, yHigh), Offset(xCenter, yLow), wickPaint);

      // Draw body
      final double top = min(yOpen, yClose);
      final double bottom = max(yOpen, yClose);
      final double bodyHeight = max(2.0, bottom - top);

      final Rect bodyRect = Rect.fromCenter(
        center: Offset(xCenter, top + (bodyHeight / 2)),
        width: candleWidth,
        height: bodyHeight,
      );

      canvas.drawRRect(RRect.fromRectAndRadius(bodyRect, const Radius.circular(2)), bodyPaint);

      // MA point
      final double yMa = (yHigh + yLow) / 2;
      if (!maStarted) {
        maPath.moveTo(xCenter, yMa);
        maStarted = true;
      } else {
        maPath.lineTo(xCenter, yMa);
      }
    }

    // Draw MA curve
    canvas.drawPath(maPath, maPaint);
  }

  @override
  bool shouldRepaint(covariant _CandlestickPainter oldDelegate) => true;
}
