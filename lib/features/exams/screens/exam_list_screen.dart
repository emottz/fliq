import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/question_model.dart';
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
              _DailyExamCard(onTap: () => context.go('/exam/session', extra: {'count': 20, 'mode': 'daily'})),
              const SizedBox(height: 24),
              const Text('Kategoriye Göre Pratik', style: AppTextStyles.heading3),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: _categories.map((c) => _CategoryCard(
                  category: c.$1,
                  icon: c.$2,
                  label: c.$3,
                  onTap: () => context.go('/exam/session', extra: {
                    'count': 15,
                    'category': c.$1.id,
                    'mode': 'category',
                  }),
                )).toList(),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: '⚡  Hızlı Pratik (10 Soru)',
                outlined: true,
                onPressed: () => context.go('/exam/session', extra: {'count': 10, 'mode': 'quick'}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
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
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            Text(label, style: AppTextStyles.bodyBold),
          ],
        ),
      ),
    );
  }
}
