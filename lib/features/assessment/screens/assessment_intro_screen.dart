import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/primary_button.dart';

class AssessmentIntroScreen extends StatelessWidget {
  const AssessmentIntroScreen({super.key});

  static const _categories = [
    (Icons.spellcheck_outlined, 'Grammar', '3 questions'),
    (Icons.menu_book_outlined, 'Vocabulary', '2 questions'),
    (Icons.translate_outlined, 'Translation', '2 questions'),
    (Icons.article_outlined, 'Reading', '3 questions'),
    (Icons.edit_outlined, 'Fill in Blanks', '2 questions'),
    (Icons.short_text_outlined, 'Sentence Completion', '3 questions'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, Color(0xFF1D4ED8)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.flight_takeoff, color: Colors.white, size: 28),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Level Assessment',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'We\'ll analyze your aviation English skills and build a personalized study plan just for you.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.85),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Stats row
                  Row(
                    children: [
                      _StatChip(
                        icon: Icons.quiz_outlined,
                        value: '15',
                        label: 'Questions',
                      ),
                      const SizedBox(width: 12),
                      _StatChip(
                        icon: Icons.timer_outlined,
                        value: '10–15',
                        label: 'Minutes',
                      ),
                      const SizedBox(width: 12),
                      _StatChip(
                        icon: Icons.auto_awesome_outlined,
                        value: 'Free',
                        label: 'AI Analysis',
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Categories
                  const Text('What we test', style: AppTextStyles.heading3),
                  const SizedBox(height: 4),
                  const Text(
                    'Covering all key areas of ICAO aviation English.',
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(_categories.length, (i) {
                    final c = _categories[i];
                    return _CategoryRow(icon: c.$1, title: c.$2, count: c.$3);
                  }),

                  const SizedBox(height: 28),

                  // What happens next
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.auto_awesome, color: AppColors.primary, size: 18),
                            SizedBox(width: 8),
                            Text('After the test, you\'ll get:', style: AppTextStyles.bodyBold),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _BulletItem('Your exact ICAO proficiency level'),
                        _BulletItem('Category-by-category skill breakdown'),
                        _BulletItem('AI-generated weak area analysis'),
                        _BulletItem('A personalized study roadmap'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Tips
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.tips_and_updates_outlined, color: Color(0xFFD97706), size: 18),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Answer honestly — there are no penalties. The more accurate your results, the better your study plan.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF92400E),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  PrimaryButton(
                    label: 'Start Assessment',
                    onPressed: () => context.go('/assessment'),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Results are saved automatically',
                      style: AppTextStyles.caption,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatChip({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String count;
  const _CategoryRow({required this.icon, required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: AppTextStyles.body),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(count, style: AppTextStyles.caption),
          ),
        ],
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  const _BulletItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Icon(Icons.check_circle, color: AppColors.success, size: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: AppTextStyles.body),
          ),
        ],
      ),
    );
  }
}
