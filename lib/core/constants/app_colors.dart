import 'package:flutter/material.dart';

abstract class AppColors {
  // ── Primary – Warm Coral / Peach ───────────────────────────────────
  static const Color primary = Color(0xFFE8845A);
  static const Color primaryLight = Color(0xFFF4A87C);
  static const Color primaryDark = Color(0xFFD06B3F);

  // ── Accent – Fresh Teal / Mint ─────────────────────────────────────
  static const Color accent = Color(0xFF4ECDC4);
  static const Color accentDark = Color(0xFF36B5AC);
  static const Color accentLight = Color(0xFF7EDDD6);

  // ── Background – Warm Light Cream ──────────────────────────────────
  static const Color bgPrimary = Color(0xFFFCFAF7);
  static const Color bgSecondary = Color(0xFFFFFFFF);
  static const Color bgTertiary = Color(0xFFF5F1EC);
  static const Color bgCard = Color(0xFFFFFFFF);

  // ── Surface (Glassmorphism – Light) ────────────────────────────────
  static const Color surfaceGlass = Color(0x18000000);
  static const Color surfaceBorder = Color(0x14000000);
  static const Color surfaceGlassLight = Color(0x0C000000);

  // ── Text ───────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);

  // ── Semantic ───────────────────────────────────────────────────────
  static const Color success = Color(0xFF34D399);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFFBBF24);

  // ── Warm Neutrals ──────────────────────────────────────────────────
  static const Color warmGray = Color(0xFFE5E0DA);
  static const Color warmGrayLight = Color(0xFFF0EDE8);
  static const Color cream = Color(0xFFFFF8F0);
  static const Color sand = Color(0xFFE8DDD0);

  // ── Motivational / Energizing Accents ──────────────────────────────
  static const Color energyYellow = Color(0xFFFFD166);
  static const Color softPink = Color(0xFFFFB4B4);
  static const Color lavender = Color(0xFFB8B5FF);
  static const Color skyBlue = Color(0xFF87CEEB);

  // ── Gradients ──────────────────────────────────────────────────────
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [primary, Color(0xFFF4A87C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD166), Color(0xFFF4A87C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient freshGradient = LinearGradient(
    colors: [accent, Color(0xFF7EDDD6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFF8F5F0), Color(0xFFF0EDE8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sageGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sunriseGradient = LinearGradient(
    colors: [Color(0xFFF4A87C), Color(0xFFFFD166), Color(0xFF4ECDC4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
