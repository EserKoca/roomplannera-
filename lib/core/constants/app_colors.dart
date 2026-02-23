import 'package:flutter/material.dart';

abstract class AppColors {
  // ── Primary – Warm Terracotta / Earthy Tones ─────────────────────────
  static const Color primary = Color(0xFFD4845A);
  static const Color primaryLight = Color(0xFFE8A87C);
  static const Color primaryDark = Color(0xFFB86B3F);

  // ── Accent – Sage Green (nature, plants, calm) ───────────────────────
  static const Color accent = Color(0xFF8FAE7E);
  static const Color accentDark = Color(0xFF6B8F5B);
  static const Color accentLight = Color(0xFFB4D4A0);

  // ── Background – Deep warm charcoal ──────────────────────────────────
  static const Color bgPrimary = Color(0xFF111110);
  static const Color bgSecondary = Color(0xFF1C1B19);
  static const Color bgTertiary = Color(0xFF252420);
  static const Color bgCard = Color(0xFF1E1D1B);

  // ── Surface (Glassmorphism) ──────────────────────────────────────────
  static const Color surfaceGlass = Color(0x12FFFFFF);
  static const Color surfaceBorder = Color(0x18FFFFFF);
  static const Color surfaceGlassLight = Color(0x20FFFFFF);

  // ── Text ─────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF5F0EB);
  static const Color textSecondary = Color(0xFFA8A196);
  static const Color textTertiary = Color(0xFF6B665E);

  // ── Semantic ─────────────────────────────────────────────────────────
  static const Color success = Color(0xFF7CB67C);
  static const Color error = Color(0xFFD96B6B);
  static const Color warning = Color(0xFFE8C067);

  // ── Warm Neutrals ────────────────────────────────────────────────────
  static const Color warmGray = Color(0xFF3A3835);
  static const Color warmGrayLight = Color(0xFF4A4744);
  static const Color cream = Color(0xFFF5ECE1);
  static const Color sand = Color(0xFFD4C5B2);

  // ── Gradients ────────────────────────────────────────────────────────
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFD4A56A), Color(0xFFC4915A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [bgPrimary, bgSecondary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF2A2825), Color(0xFF1E1D1B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sageGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
