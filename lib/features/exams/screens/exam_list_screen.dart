import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/hearts_service.dart';
import '../../../data/models/question_model.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/hearts_display.dart';
import '../../../shared/widgets/premium_upsell_card.dart';
import '../../../shared/widgets/primary_button.dart';

class ExamListScreen extends ConsumerWidget {
  const ExamListScreen({super.key});

  static const _categories = [
    (QuestionCategory.grammar, Icons.spellcheck, 'Gramer'),
    (QuestionCategory.vocabulary, Icons.translate, 'Kelime Bilgisi'),
    (QuestionCategory.translation, Icons.swap_horiz, 'Çeviri'),
    (QuestionCategory.reading, Icons.menu_book, 'Okuma'),
    (QuestionCategory.fillBlanks, Icons.edit_outlined, 'Boşluk Doldur'),
    (
      QuestionCategory.sentenceCompletion,
      Icons.format_quote,
      'Cümle Tamamlama',
    ),
  ];

  Future<void> _startExam(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> config,
  ) async {
    final ok = await showNoHeartsDialog(context, ref, HeartsService.examCost);
    if (!ok || !context.mounted) return;
    await ref.read(heartsProvider.notifier).use(HeartsService.examCost);
    if (!context.mounted) return;
    context.go('/exam/session', extra: config);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider).value;
    final weakCategories = profile?.weakCategories ?? [];
    final isAmt = profile?.role == 'amt';

    return Column(
      children: [
        HeartsEmptyBanner(),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Sınavlar', style: AppTextStyles.heading2),
                    const SizedBox(height: 12),
                    const PremiumUpsellCard(source: 'exams'),

                    // ── Uçak Bakım Teknisyeni Özel Sınavı ──────────────────────
                    if (isAmt) ...[
                      _AmtExamCard(
                        onTap: () =>
                            _startExam(context, ref, {'mode': 'amt_exam'}),
                      ),
                      const SizedBox(height: 16),
                    ],

                    _DailyExamCard(
                      onTap: () => _startExam(context, ref, {
                        'count': 20,
                        'mode': 'daily',
                      }),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Kategoriye Göre Pratik',
                      style: AppTextStyles.heading3,
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.15,
                      children: _categories
                          .map(
                            (c) => _CategoryCard(
                              category: c.$1,
                              icon: c.$2,
                              label: c.$3,
                              isWeak: weakCategories.contains(c.$1.id),
                              onTap: () => _startExam(context, ref, {
                                'count': 15,
                                'category': c.$1.id,
                                'mode': 'category',
                              }),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: '⚡  Hızlı Pratik (10 Soru)',
                      outlined: true,
                      onPressed: () => _startExam(context, ref, {
                        'count': 10,
                        'mode': 'quick',
                      }),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Sınav başlatmak ', style: AppTextStyles.caption),
                        const Text(
                          '❤️ 10',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.error,
                          ),
                        ),
                        Text(' hak kullanır', style: AppTextStyles.caption),
                      ],
                    ),
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

// ── Uçak Bakım Teknisyeni Özel Sınav Kartı ───────────────────────────────────

class _AmtExamCard extends StatelessWidget {
  final VoidCallback onTap;
  const _AmtExamCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryDeep, AppColors.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDeep.withValues(alpha: 0.35),
              blurRadius: 16,
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
                  // Rozet
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '🔧 Uçak Bakım Teknisyeni',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Yabancı Dil Sınavı',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'SHGM standart sınav formatı',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    children: [
                      _chip(Icons.timer_outlined, '80 dakika'),
                      _chip(Icons.quiz_outlined, '80 soru'),
                      _chip(Icons.category_outlined, '6 bölüm'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🔧', style: TextStyle(fontSize: 24)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 13),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}

// ── Günlük Sınav Kartı ────────────────────────────────────────────────────────

class _DailyExamCard extends StatelessWidget {
  final VoidCallback onTap;
  const _DailyExamCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.30),
              blurRadius: 16,
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
                  const Text(
                    'Bugünün Sınavı',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Günlük Karma Sınav',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _chip(Icons.timer_outlined, '20 dk'),
                      const SizedBox(width: 10),
                      _chip(Icons.quiz_outlined, '20 soru'),
                      const SizedBox(width: 10),
                      _chip(Icons.favorite, '❤️ 10'),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String label) {
    if (label.startsWith('❤️')) {
      return Text(
        label,
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      );
    }
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 14),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final QuestionCategory category;
  final IconData icon;
  final String label;
  final bool isWeak;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.icon,
    required this.label,
    required this.isWeak,
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
          color: isWeak ? AppColors.warningLight : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isWeak ? AppColors.warning : AppColors.divider,
            width: isWeak ? 1.5 : 1,
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
                    color: isWeak ? AppColors.warningBg : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: isWeak ? AppColors.warning : AppColors.primary,
                    size: 20,
                  ),
                ),
                const Spacer(),
                if (isWeak)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.white,
                          size: 10,
                        ),
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
            Text(label, style: AppTextStyles.bodyBold),
          ],
        ),
      ),
    );
  }
}
