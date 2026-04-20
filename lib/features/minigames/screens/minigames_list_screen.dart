import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/hearts_service.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/hearts_display.dart';

class MiniGamesListScreen extends ConsumerWidget {
  const MiniGamesListScreen({super.key});

  static const _games = [
    _GameInfo(
      route: '/minigame/wordmatch',
      emoji: '🃏',
      title: 'Kelime Eşleştirme',
      description: 'Havacılık terimini doğru tanımıyla eşleştir. Kartları aç, çiftleri bul!',
      color1: Color(0xFF7C3AED),
      color2: Color(0xFF9F67F2),
      badge: '8 çift',
      difficulty: 'Orta',
    ),
    _GameInfo(
      route: '/minigame/quickquiz',
      emoji: '⚡',
      title: 'Hızlı Quiz',
      description: '8 saniyede doğru tanımı seç! Hız ve doğruluk puanı etkiler.',
      color1: Color(0xFFB45309),
      color2: Color(0xFFF59E0B),
      badge: '10 soru',
      difficulty: 'Zor',
    ),
    _GameInfo(
      route: '/minigame/scramble',
      emoji: '🔀',
      title: 'Kelime Karıştır',
      description: 'Karışık harfleri doğru sıraya diz, havacılık terimini bul!',
      color1: Color(0xFF065F46),
      color2: Color(0xFF10B981),
      badge: '10 kelime',
      difficulty: 'Kolay',
    ),
    _GameInfo(
      route: '/minigame/hangman',
      emoji: '✈️',
      title: 'Adam Asmaca',
      description: 'Teknik havacılık terimini harf harf tahmin et. 6 hakkın var!',
      color1: Color(0xFF991B1B),
      color2: Color(0xFFEF4444),
      badge: '6 hak',
      difficulty: 'Orta',
    ),
  ];

  Future<void> _startGame(BuildContext context, WidgetRef ref, String route) async {
    final isPremium = ref.read(isPremiumProvider).value ?? false;
    if (!isPremium) {
      final ok = await showNoHeartsDialog(context, ref, HeartsService.miniGameCost);
      if (!ok || !context.mounted) return;
      await ref.read(heartsProvider.notifier).use(HeartsService.miniGameCost);
      if (!context.mounted) return;
    }
    context.go(route);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumProvider).value ?? false;

    return Column(
      children: [
        const HeartsEmptyBanner(),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Mini Oyunlar', style: AppTextStyles.heading2),
                    const SizedBox(height: 4),
                    Text(
                      'Havacılık teknik İngilizcesini oynayarak öğren.',
                      style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ..._games.map((g) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _GameCard(
                        game: g,
                        isPremium: isPremium,
                        onTap: () => _startGame(context, ref, g.route),
                      ),
                    )),
                    const SizedBox(height: 8),
                    if (!isPremium)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Her oyun ', style: AppTextStyles.caption),
                          Text(
                            '❤️ 5',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.error,
                            ),
                          ),
                          const Text(' hak kullanır', style: AppTextStyles.caption),
                        ],
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GameInfo {
  final String route;
  final String emoji;
  final String title;
  final String description;
  final Color color1;
  final Color color2;
  final String badge;
  final String difficulty;

  const _GameInfo({
    required this.route,
    required this.emoji,
    required this.title,
    required this.description,
    required this.color1,
    required this.color2,
    required this.badge,
    required this.difficulty,
  });
}

class _GameCard extends StatelessWidget {
  final _GameInfo game;
  final bool isPremium;
  final VoidCallback onTap;

  const _GameCard({
    required this.game,
    required this.isPremium,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [game.color1, game.color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: game.color1.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _chip(game.badge),
                      const SizedBox(width: 8),
                      _chip('🎯 ${game.difficulty}'),
                      if (!isPremium) ...[
                        const SizedBox(width: 8),
                        _chip('❤️ 5'),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    game.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    game.description,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(game.emoji, style: const TextStyle(fontSize: 26)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
