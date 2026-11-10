import 'dart:math';

class MathHelpers {
  /// Computes a Simple Moving Average (SMA) over a sliding window
  static List<double> computeSMA(List<double> prices, int period) {
    if (prices.length < period) return [];
    List<double> sma = [];
    double windowSum = 0;

    for (int i = 0; i < prices.length; i++) {
      windowSum += prices[i];
      if (i >= period) {
        windowSum -= prices[i - period];
      }
      if (i >= period - 1) {
        sma.add(windowSum / period);
      }
    }
    return sma;
  }

  /// Calculates percentage difference between two prices
  static double calculatePriceChange(double oldPrice, double newPrice) {
    if (oldPrice == 0) return 0.0;
    return ((newPrice - oldPrice) / oldPrice) * 100.0;
  }

  /// Generates random micro-jitter for simulated live tick WebSockets
  static double randomTickJitter(double currentPrice, double volatilityRatio) {
    final random = Random();
    final delta = (random.nextDouble() - 0.49) * (currentPrice * volatilityRatio);
    return max(0.01, currentPrice + delta);
  }
}
