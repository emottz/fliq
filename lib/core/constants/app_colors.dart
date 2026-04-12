import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand blues ──────────────────────────────────────────────────────────────
  static const Color primary     = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark  = Color(0xFF1D4ED8);
  /// Deep navy — used in gradient headers (lesson path, AMT card).
  static const Color primaryDeep  = Color(0xFF1E3A8A);

  // ── Surfaces ─────────────────────────────────────────────────────────────────
  static const Color background    = Color(0xFFFFFFFF);
  static const Color surface       = Color(0xFFF8FAFF);
  static const Color surfaceVariant = Color(0xFFEFF4FF);

  // ── Semantic — success ───────────────────────────────────────────────────────
  static const Color success      = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color successDark  = Color(0xFF15803D);

  // ── Semantic — error ─────────────────────────────────────────────────────────
  static const Color error       = Color(0xFFEF4444);
  static const Color errorLight  = Color(0xFFFEE2E2);
  static const Color errorDark   = Color(0xFFB91C1C);
  static const Color errorBorder = Color(0xFFFCA5A5);

  // ── Semantic — warning ───────────────────────────────────────────────────────
  static const Color warning      = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFFFBEB);
  static const Color warningBg    = Color(0xFFFEF3C7);

  // ── Text & borders ───────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint      = Color(0xFF9CA3AF);
  static const Color divider       = Color(0xFFE5E7EB);
  /// Locked / disabled element fill.
  static const Color locked        = Color(0xFFD1D5DB);

  // ── Gamification accents ─────────────────────────────────────────────────────
  static const Color xpOrange    = Color(0xFFF97316);
  static const Color streakFlame = Color(0xFFEF4444);
  static const Color rankGold    = Color(0xFFEAB308);

  // ── Lesson level colors ──────────────────────────────────────────────────────
  /// Başlangıç (Beginner) — green.
  static const Color levelGreen  = Color(0xFF10B981);
  // Temel (Elementary) — reuse primaryLight (0xFF3B82F6).
  // İleri (Advanced)   — reuse warning     (0xFFF59E0B).
  /// Orta (Intermediate) — purple.
  static const Color levelPurple = Color(0xFF8B5CF6);

  // ── Streak celebration (dark overlay) ────────────────────────────────────────
  static const Color streakOrange      = Color(0xFFFF6B00);
  static const Color streakOrangeLight = Color(0xFFFF9A3C);
  static const Color streakDarkBg      = Color(0xFF1C1C2E);
}
