import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/airplane_logo.dart';
import '../../../shared/widgets/primary_button.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  static const _features = [
    (Icons.quiz_outlined, 'Unlimited Practice Exams', 'Test yourself with 2,000+ real-style questions'),
    (Icons.school_outlined, 'Personalized Lesson Path', 'AI-curated route based on your level'),
    (Icons.emoji_events_outlined, 'Rank & XP System', 'Track progress with aviation ranks'),
    (Icons.bar_chart_outlined, 'Detailed Analytics', 'Identify your weak spots by category'),
    (Icons.offline_bolt_outlined, 'Offline Access', 'Study anywhere, anytime'),
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
                children: [
                  const AirplaneLogo(size: 56),
                  const SizedBox(height: 28),
                  const Text('Unlock Your Full Potential', style: AppTextStyles.heading1, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  const Text(
                    'Join thousands of aviation professionals who mastered English with FLIQ',
                    style: AppTextStyles.caption,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  ..._features.map((f) => _FeatureRow(icon: f.$1, title: f.$2, subtitle: f.$3)),
                  const SizedBox(height: 28),
                  _PricingCard(
                    title: 'Monthly',
                    price: '\$9.99',
                    period: '/month',
                    isHighlighted: false,
                  ),
                  const SizedBox(height: 12),
                  _PricingCard(
                    title: 'Annual',
                    price: '\$59.99',
                    period: '/year',
                    badge: 'Save 50%',
                    isHighlighted: true,
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: 'Start Free Trial',
                    onPressed: () => context.go('/assessment'),
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    label: 'Continue without account',
                    outlined: true,
                    onPressed: () => context.go('/assessment'),
                  ),
                  const SizedBox(height: 16),
                  const Text('No credit card required', style: AppTextStyles.caption),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _FeatureRow({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyBold),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: AppColors.success, size: 20),
        ],
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final String? badge;
  final bool isHighlighted;

  const _PricingCard({
    required this.title,
    required this.price,
    required this.period,
    this.badge,
    required this.isHighlighted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isHighlighted ? AppColors.surfaceVariant : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlighted ? AppColors.primary : AppColors.divider,
          width: isHighlighted ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: AppTextStyles.bodyBold),
                    if (badge != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          badge!,
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text('Full access to all features', style: AppTextStyles.caption),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: price,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                TextSpan(
                  text: period,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
