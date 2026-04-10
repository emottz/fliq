import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/question_model.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/primary_button.dart';

class ExamListScreen extends ConsumerWidget {
  const ExamListScreen({super.key});

  static const _categories = [
    (QuestionCategory.grammar, Icons.spellcheck, 'Gramer'),
    (QuestionCategory.vocabulary, Icons.translate, 'Kelime Bilgisi'),
    (QuestionCategory.translation, Icons.swap_horiz, 'Çeviri'),
    (QuestionCategory.reading, Icons.menu_book, 'Okuma'),
    (QuestionCategory.fillBlanks, Icons.edit_outlined, 'Boşluk Doldur'),
    (QuestionCategory.sentenceCompletion, Icons.format_quote, 'Cümle Tamamlama'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weakCategories = ref.watch(userProfileProvider).value?.weakCategories ?? [];
    final isPremium = ref.watch(isPremiumProvider).value ?? false;

    void goPaywall() => context.push('/subscription');

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Sınavlar', style: AppTextStyles.heading2),
              const SizedBox(height: 16),
              _DailyExamCard(
                isPremium: isPremium,
                onTap: isPremium
                    ? () => context.go('/exam/session', extra: {'count': 20, 'mode': 'daily'})
                    : goPaywall,
              ),
              const SizedBox(height: 24),
              const Text('Kategoriye Göre Pratik', style: AppTextStyles.heading3),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.15,
                children: _categories.map((c) => _CategoryCard(
                  category: c.$1,
                  icon: c.$2,
                  label: c.$3,
                  isWeak: weakCategories.contains(c.$1.id),
                  isPremium: isPremium,
                  onTap: isPremium
                      ? () => context.go('/exam/session', extra: {
                            'count': 15,
                            'category': c.$1.id,
                            'mode': 'category',
                          })
                      : goPaywall,
                )).toList(),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: '⚡  Hızlı Pratik (10 Soru)',
                outlined: true,
                onPressed: () => context.go('/exam/session', extra: {'count': 10, 'mode': 'quick'}),
              ),
              if (!isPremium) ...[
                const SizedBox(height: 8),
                const Text(
                  'Ücretsiz: Hızlı Pratik · Premium: Günlük Sınav + Kategori',
                  style: AppTextStyles.caption,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DailyExamCard extends StatelessWidget {
  final VoidCallback onTap;
  final bool isPremium;
  const _DailyExamCard({required this.onTap, required this.isPremium});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isPremium
                ? [AppColors.primary, AppColors.primaryLight]
                : [const Color(0xFF6B7280), const Color(0xFF9CA3AF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isPremium ? 'Bugünün Sınavı' : '👑 Premium Özellik',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Günlük Karma Sınav',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _chip(Icons.timer_outlined, '20 dk'),
                      const SizedBox(width: 10),
                      _chip(Icons.quiz_outlined, '20 soru'),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              isPremium ? Icons.arrow_forward_ios : Icons.lock_outline,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 14),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final QuestionCategory category;
  final IconData icon;
  final String label;
  final bool isWeak;
  final bool isPremium;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.icon,
    required this.label,
    required this.isWeak,
    required this.isPremium,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: !isPremium
              ? AppColors.surfaceVariant
              : isWeak
                  ? const Color(0xFFFFFBEB)
                  : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: !isPremium
                ? AppColors.divider
                : isWeak
                    ? AppColors.warning
                    : AppColors.divider,
            width: isWeak && isPremium ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: !isPremium
                        ? AppColors.divider
                        : isWeak
                            ? const Color(0xFFFEF3C7)
                            : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isPremium ? icon : Icons.lock_outline,
                    color: !isPremium
                        ? AppColors.textHint
                        : isWeak
                            ? AppColors.warning
                            : AppColors.primary,
                    size: 20,
                  ),
                ),
                const Spacer(),
                if (!isPremium)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '👑',
                      style: TextStyle(fontSize: 10),
                    ),
                  )
                else if (isWeak)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.warning,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.white, size: 10),
                        SizedBox(width: 2),
                        Text(
                          'Zayıf',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            Text(
              label,
              style: AppTextStyles.bodyBold.copyWith(
                color: isPremium ? AppColors.textPrimary : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
