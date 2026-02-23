import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary Gradient - Premium Purple/Blue
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryLight = Color(0xFFA29BFE);
  static const Color primaryDark = Color(0xFF5A4FCF);

  // Accent - Warm Gold
  static const Color accent = Color(0xFFFFEAA7);
  static const Color accentDark = Color(0xFFFDCB6E);

  // Background
  static const Color bgPrimary = Color(0xFF0D0D0D);
  static const Color bgSecondary = Color(0xFF1A1A2E);
  static const Color bgTertiary = Color(0xFF16213E);
  static const Color bgCard = Color(0xFF1E1E3A);

  // Surface (Glassmorphism)
  static const Color surfaceGlass = Color(0x0DFFFFFF);
  static const Color surfaceBorder = Color(0x1AFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0C3);
  static const Color textTertiary = Color(0xFF6C6C80);

  // Semantic
  static const Color success = Color(0xFF00B894);
  static const Color error = Color(0xFFFF6B6B);
  static const Color warning = Color(0xFFFFEAA7);

  // Gradients
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [accent, accentDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [bgPrimary, bgSecondary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF2D2D5E), Color(0xFF1E1E3A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
