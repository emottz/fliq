import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/airplane_logo.dart';
import '../../../shared/widgets/primary_button.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

// Rol bazlı fiyatlandırma
class _RolePricing {
  final String roleLabel;
  final double monthly;
  final double annual; // aylık eşdeğer
  final double annualTotal;
  final List<(IconData, String, String)> features;

  const _RolePricing({
    required this.roleLabel,
    required this.monthly,
    required this.annual,
    required this.annualTotal,
    required this.features,
  });
}

const _pilotPricing = _RolePricing(
  roleLabel: 'Pilot',
  monthly: 50,
  annual: 35,
  annualTotal: 420,
  features: [
    (Icons.quiz_outlined, 'Sınırsız Pratik Sınavı', '2.000+ ICAO ve EASA formatlı soru'),
    (Icons.school_outlined, '33 İleri Seviye Ders', 'ATC iletişimi, METAR, SID/STAR, kaza raporları ve daha fazlası'),
    (Icons.emoji_events_outlined, 'Pilot Ligi', 'Sadece pilotlarla rekabet et, rütbe kazan'),
    (Icons.bar_chart_outlined, 'Detaylı Analitik', 'Kategoriye göre zayıf noktalarını bul'),
    (Icons.offline_bolt_outlined, 'Çevrimdışı Erişim', 'Her yerde, her zaman çalış'),
  ],
);

const _cabinPricing = _RolePricing(
  roleLabel: 'Kabin Görevlisi',
  monthly: 25,
  annual: 17.5,
  annualTotal: 210,
  features: [
    (Icons.quiz_outlined, 'Sınırsız Pratik Sınavı', 'Kabin prosedürü ve emniyet sorularıyla hazırlan'),
    (Icons.school_outlined, 'Kabin İçin Özel Dersler', 'Yolcu iletişimi, acil durum, CRM, tehlikeli madde'),
    (Icons.emoji_events_outlined, 'Kabin Ligi', 'Kabin görevlileriyle kendi liginde yarış'),
    (Icons.bar_chart_outlined, 'Detaylı Analitik', 'Kategoriye göre zayıf noktalarını bul'),
    (Icons.offline_bolt_outlined, 'Çevrimdışı Erişim', 'Her yerde, her zaman çalış'),
  ],
);

const _amtPricing = _RolePricing(
  roleLabel: 'Uçak Bakım Teknisyeni',
  monthly: 25,
  annual: 17.5,
  annualTotal: 210,
  features: [
    (Icons.quiz_outlined, 'Sınırsız Pratik Sınavı', 'AMM, EASA Part-66 ve SHGM odaklı sorular'),
    (Icons.school_outlined, 'Teknik Bakım Dersleri', 'AMM dili, AD okuma, arıza raporlaması, teknik kısaltmalar'),
    (Icons.emoji_events_outlined, 'Teknisyen Ligi', 'AMT\'lerle kendi liginde yarış'),
    (Icons.bar_chart_outlined, 'Detaylı Analitik', 'Kategoriye göre zayıf noktalarını bul'),
    (Icons.offline_bolt_outlined, 'Çevrimdışı Erişim', 'Her yerde, her zaman çalış'),
  ],
);

const _studentPricing = _RolePricing(
  roleLabel: 'Öğrenci',
  monthly: 10,
  annual: 7,
  annualTotal: 84,
  features: [
    (Icons.quiz_outlined, 'Sınırsız Pratik Sınavı', 'Temel havacılık İngilizcesi sorularıyla başla'),
    (Icons.school_outlined, 'Temel Dersler', 'Gramer, kelime bilgisi ve temel ATC iletişimi'),
    (Icons.emoji_events_outlined, 'Öğrenci Ligi', 'Öğrencilerle kendi liginde yarış'),
    (Icons.bar_chart_outlined, 'Detaylı Analitik', 'Kategoriye göre zayıf noktalarını bul'),
    (Icons.offline_bolt_outlined, 'Çevrimdışı Erişim', 'Her yerde, her zaman çalış'),
  ],
);

_RolePricing _getPricingForRole(String role) {
  switch (role) {
    case 'pilot':
      return _pilotPricing;
    case 'cabin_crew':
      return _cabinPricing;
    case 'amt':
      return _amtPricing;
    default:
      return _studentPricing;
  }
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {

  Offerings? _offerings;
  Package? _selectedPackage;
  bool _loadingOfferings = true;
  bool _purchasing = false;
  bool _restoring = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    final service = ref.read(subscriptionServiceProvider);
    final offerings = await service.getOfferings();
    if (!mounted) return;
    setState(() {
      _offerings = offerings;
      _loadingOfferings = false;
      // Varsayılan seçim: yıllık paket (varsa)
      if (offerings != null) {
        final packages = offerings.current?.availablePackages ?? [];
        _selectedPackage = packages.firstWhere(
          (p) => p.packageType == PackageType.annual,
          orElse: () => packages.isNotEmpty ? packages.first : _selectedPackage!,
        );
        if (_selectedPackage == null && packages.isNotEmpty) {
          _selectedPackage = packages.first;
        }
      }
    });
  }

  Future<void> _purchase(Package package) async {
    setState(() { _purchasing = true; _errorMessage = null; });
    final service = ref.read(subscriptionServiceProvider);
    final (success, error) = await service.purchasePackage(package);
    if (!mounted) return;
    if (success) {
      await ref.read(isPremiumProvider.notifier).refresh();
      _goHome();
    } else if (error != null) {
      setState(() { _errorMessage = error; _purchasing = false; });
    } else {
      setState(() { _purchasing = false; }); // kullanıcı iptal etti
    }
  }

  Future<void> _restore() async {
    setState(() { _restoring = true; _errorMessage = null; });
    final service = ref.read(subscriptionServiceProvider);
    final ok = await service.restorePurchases();
    if (!mounted) return;
    if (ok) {
      await ref.read(isPremiumProvider.notifier).refresh();
      _goHome();
    } else {
      setState(() {
        _restoring = false;
        _errorMessage = 'Geri yüklenecek aktif abonelik bulunamadı.';
      });
    }
  }

  void _goHome() {
    if (Navigator.canPop(context)) {
      context.pop();
    } else {
      context.go('/home/exams');
    }
  }

  void _continueFree() => _goHome();

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    final profileAsync = ref.watch(userProfileProvider);
    final role = profileAsync.valueOrNull?.role ?? 'student';
    final pricing = _getPricingForRole(role);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: canPop
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
                onPressed: _continueFree,
              ),
            )
          : null,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, canPop ? 8 : 24, 24, 24),
              child: Column(
                children: [
                  const AirplaneLogo(size: 56),
                  const SizedBox(height: 24),
                  Text(
                    '${pricing.roleLabel} Planı',
                    style: AppTextStyles.heading1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'FLIQ ile İngilizce ustası olan binlerce havacılık profesyoneline katıl',
                    style: AppTextStyles.caption,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ...pricing.features.map((f) => _FeatureRow(icon: f.$1, title: f.$2, subtitle: f.$3)),
                  const SizedBox(height: 24),

                  // Paketler
                  if (_loadingOfferings)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: CircularProgressIndicator(color: AppColors.primary),
                    )
                  else if (_offerings != null &&
                      (_offerings!.current?.availablePackages.isNotEmpty ?? false))
                    ..._buildPackageCards(_offerings!.current!.availablePackages)
                  else
                    ..._buildFallbackCards(pricing),

                  const SizedBox(height: 20),

                  // Hata mesajı
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Color(0xFFDC2626), fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Satın Al butonu
                  _purchasing
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: CircularProgressIndicator(color: AppColors.primary),
                        )
                      : PrimaryButton(
                          label: _selectedPackage != null ? 'Premium\'a Geç' : 'Devam Et',
                          onPressed: _selectedPackage != null
                              ? () => _purchase(_selectedPackage!)
                              : null,
                        ),

                  const SizedBox(height: 12),

                  PrimaryButton(
                    label: 'Ücretsiz Devam Et',
                    outlined: true,
                    onPressed: _continueFree,
                  ),

                  const SizedBox(height: 16),

                  // Geri yükle bağlantısı
                  _restoring
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                        )
                      : TextButton(
                          onPressed: _restore,
                          child: const Text(
                            'Satın Alımları Geri Yükle',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),

                  const SizedBox(height: 4),
                  const Text('Kredi kartı gerekmez · İstediğin zaman iptal et', style: AppTextStyles.caption),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPackageCards(List<Package> packages) {
    return packages.map((pkg) {
      final isAnnual = pkg.packageType == PackageType.annual;
      final isSelected = _selectedPackage?.identifier == pkg.identifier;
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(
          onTap: () => setState(() => _selectedPackage = pkg),
          child: _PricingCard(
            title: isAnnual ? 'Yıllık' : 'Aylık',
            price: pkg.storeProduct.priceString,
            period: isAnnual ? '/yıl' : '/ay',
            badge: isAnnual ? '%50 Tasarruf' : null,
            isHighlighted: isAnnual,
            isSelected: isSelected,
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildFallbackCards(_RolePricing pricing) {
    final monthlyStr = '\$${pricing.monthly % 1 == 0 ? pricing.monthly.toInt() : pricing.monthly}';
    final annualStr = '\$${pricing.annual % 1 == 0 ? pricing.annual.toInt() : pricing.annual}';
    final annualTotalStr = '\$${pricing.annualTotal % 1 == 0 ? pricing.annualTotal.toInt() : pricing.annualTotal}';

    return [
      GestureDetector(
        onTap: () => setState(() => _selectedPackage = null),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _PricingCard(
            title: 'Aylık',
            price: monthlyStr,
            period: '/ay',
            isHighlighted: false,
            isSelected: false,
          ),
        ),
      ),
      GestureDetector(
        onTap: () => setState(() => _selectedPackage = null),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _PricingCard(
            title: 'Yıllık',
            price: annualStr,
            period: '/ay',
            badge: '%30 Tasarruf',
            subtitle: '$annualTotalStr/yıl olarak faturalandırılır',
            isHighlighted: true,
            isSelected: true,
          ),
        ),
      ),
    ];
  }
}

// ── Yardımcı Widgetlar ────────────────────────────────────────────────────────

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _FeatureRow({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 21),
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
  final String? subtitle;
  final bool isHighlighted;
  final bool isSelected;

  const _PricingCard({
    required this.title,
    required this.price,
    required this.period,
    this.badge,
    this.subtitle,
    required this.isHighlighted,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isHighlighted ? AppColors.surfaceVariant : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? AppColors.primary
              : isHighlighted
                  ? AppColors.primary.withValues(alpha: 0.4)
                  : AppColors.divider,
          width: isSelected ? 2 : 1,
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
                Text(
                  subtitle ?? 'Tüm özelliklere tam erişim',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          Row(
            children: [
              if (isSelected)
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(Icons.radio_button_checked, color: AppColors.primary, size: 18),
                )
              else
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(Icons.radio_button_unchecked, color: AppColors.textHint, size: 18),
                ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: price,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    TextSpan(
                      text: period,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
