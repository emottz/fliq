import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/airplane_logo.dart';
import '../../../shared/widgets/primary_button.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  static const _features = [
    (Icons.quiz_outlined, 'Sınırsız Pratik Sınavı', '2.000+ gerçek formatlı soruyla kendini test et'),
    (Icons.school_outlined, 'Kişisel Ders Yolu', 'Seviyene göre AI tarafından oluşturulan rota'),
    (Icons.emoji_events_outlined, 'Rütbe & XP Sistemi', 'Havacılık rütbeleriyle ilerleni takip et'),
    (Icons.bar_chart_outlined, 'Detaylı Analitik', 'Kategoriye göre zayıf noktalarını bul'),
    (Icons.offline_bolt_outlined, 'Çevrimdışı Erişim', 'Her yerde, her zaman çalış'),
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
                  const Text('Tam Potansiyelini Ortaya Çıkar', style: AppTextStyles.heading1, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  const Text(
                    'FLIQ ile İngilizce ustası olan binlerce havacılık profesyoneline katıl',
                    style: AppTextStyles.caption,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  ..._features.map((f) => _FeatureRow(icon: f.$1, title: f.$2, subtitle: f.$3)),
                  const SizedBox(height: 28),
                  _PricingCard(
                    title: 'Aylık',
                    price: '\$9.99',
                    period: '/ay',
                    isHighlighted: false,
                  ),
                  const SizedBox(height: 12),
                  _PricingCard(
                    title: 'Yıllık',
                    price: '\$59.99',
                    period: '/yıl',
                    badge: '%50 Tasarruf',
                    isHighlighted: true,
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: 'Ücretsiz Dene',
                    onPressed: () => context.go('/home/exams'),
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    label: 'Ücretsiz devam et',
                    outlined: true,
                    onPressed: () => context.go('/home/exams'),
                  ),
                  const SizedBox(height: 16),
                  const Text('Kredi kartı gerekmez', style: AppTextStyles.caption),
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
                Text('Tüm özelliklere tam erişim', style: AppTextStyles.caption),
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
