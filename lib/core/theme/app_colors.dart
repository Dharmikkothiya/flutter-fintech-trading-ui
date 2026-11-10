import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF0B0E14);
  static const Color surface = Color(0xFF151922);
  static const Color surfaceLight = Color(0xFF1E2430);
  static const Color card = Color(0xFF181D27);

  // Accents & Brand
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color secondary = Color(0xFF06B6D4); // Cyan

  // Trading States
  static const Color green = Color(0xFF10B981); // Bullish / Buy
  static const Color greenLight = Color(0x2010B981);
  static const Color red = Color(0xFFF43F5E); // Bearish / Sell
  static const Color redLight = Color(0x20F43F5E);

  // Neutrals & Text
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color divider = Color(0xFF262E3D);
  static const Color border = Color(0xFF2E384D);

  // Gradients
  static const LinearGradient portfolioGradient = LinearGradient(
    colors: [Color(0xFF312E81), Color(0xFF1E1B4B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyberGradient = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
