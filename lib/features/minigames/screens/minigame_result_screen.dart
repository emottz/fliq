import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/primary_button.dart';

/// Tüm mini-oyunlar için ortak sonuç ekranı.
///
/// extra map formatı:
/// {
///   'title':       String,              // "Tebrikler!" vs
///   'subtitle':    String,              // "8 / 10 doğru" vs
///   'emoji':       String,              // büyük emoji
///   'score':       int,                 // toplam puan
///   'color1':      int (ARGB),          // gradient başlangıç rengi
///   'color2':      int (ARGB),          // gradient bitiş rengi
///   'stats':       List<Map>,           // [{icon, label, value}]
///   'sourceRoute': String,              // tekrar oyna route'u
/// }
class MiniGameResultScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> result;
  const MiniGameResultScreen({super.key, required this.result});

  @override
  ConsumerState<MiniGameResultScreen> createState() => _MiniGameResultScreenState();
}

class _MiniGameResultScreenState extends ConsumerState<MiniGameResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeIn = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();

    // XP ver
    final xp = widget.result['xp'] as int? ?? 10;
    ref.read(userProfileProvider.notifier).addXp(xp);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.result;
    final title = r['title'] as String? ?? 'Sonuç';
    final subtitle = r['subtitle'] as String? ?? '';
    final emoji = r['emoji'] as String? ?? '🎮';
    final score = r['score'] as int? ?? 0;
    final xp = r['xp'] as int? ?? 10;
    final color1 = Color(r['color1'] as int? ?? 0xFF2563EB);
    final color2 = Color(r['color2'] as int? ?? 0xFF1D4ED8);
    final stats = (r['stats'] as List?)
            ?.map((e) => Map<String, String>.from(e as Map))
            .toList() ??
        [];
    final sourceRoute = r['sourceRoute'] as String? ?? '/home/minigames';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Gradient başlık ────────────────────────────────────────────────
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color1, color2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: FadeTransition(
                opacity: _fadeIn,
                child: SlideTransition(
                  position: _slideUp,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                    child: Column(
                      children: [
                        // Büyük emoji
                        Text(emoji,
                            style: const TextStyle(fontSize: 72)),
                        const SizedBox(height: 12),
                        // Başlık
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Alt başlık (doğru/toplam)
                        Text(
                          subtitle,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        // Chip satırı: Puan + XP
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _HeaderChip(
                              icon: Icons.star_rounded,
                              iconColor: const Color(0xFFFCD34D),
                              label: '$score puan',
                            ),
                            const SizedBox(width: 10),
                            _HeaderChip(
                              icon: Icons.bolt,
                              iconColor: const Color(0xFFFBBF24),
                              label: '+$xp XP',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── İstatistik kartları ────────────────────────────────────────────
          Expanded(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        if (stats.isNotEmpty) ...[
                          _StatsGrid(stats: stats),
                          const SizedBox(height: 28),
                        ],
                        // Butonlar
                        PrimaryButton(
                          label: '🔁  Tekrar Oyna',
                          onPressed: () => context.go(sourceRoute),
                        ),
                        const SizedBox(height: 12),
                        PrimaryButton(
                          label: 'Oyunlara Dön',
                          outlined: true,
                          onPressed: () => context.go('/home/minigames'),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── İstatistik grid ───────────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  final List<Map<String, String>> stats;
  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('İstatistikler', style: AppTextStyles.heading3),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: stats.length >= 4 ? 2 : stats.length == 3 ? 3 : 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.6,
          ),
          itemCount: stats.length,
          itemBuilder: (_, i) {
            final s = stats[i];
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.divider),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(s['icon'] ?? '',
                      style: const TextStyle(fontSize: 22)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s['value'] ?? '',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        s['label'] ?? '',
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

// ── Header chip (puan / XP) ───────────────────────────────────────────────────

class _HeaderChip extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;

  const _HeaderChip({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
