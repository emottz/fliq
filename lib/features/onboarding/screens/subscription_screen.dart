import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/airplane_logo.dart';
import '../../../shared/widgets/primary_button.dart';

// ── Rol bazlı fiyatlandırma modeli ───────────────────────────────────────────

class _RolePricing {
  final String roleKey;
  final String roleLabel;
  final String roleEmoji;
  final double monthly;
  final double annual;       // aylık eşdeğer
  final double annualTotal;
  final List<String> highlights; // 3 kısa madde

  const _RolePricing({
    required this.roleKey,
    required this.roleLabel,
    required this.roleEmoji,
    required this.monthly,
    required this.annual,
    required this.annualTotal,
    required this.highlights,
  });

  String get monthlyStr => '\$${monthly % 1 == 0 ? monthly.toInt() : monthly}';
  String get annualStr  => '\$${annual  % 1 == 0 ? annual.toInt()  : annual}';
  String get annualTotalStr => '\$${annualTotal % 1 == 0 ? annualTotal.toInt() : annualTotal}';
}

const _allPlans = [
  _RolePricing(
    roleKey: 'pilot',
    roleLabel: 'Pilot',
    roleEmoji: '✈️',
    monthly: 50,
    annual: 35,
    annualTotal: 420,
    highlights: [
      '33+ ileri seviye ders',
      'ATC, METAR, SID/STAR, kaza raporu',
      'Pilot Ligi — sadece pilotlarla yarış',
    ],
  ),
  _RolePricing(
    roleKey: 'cabin_crew',
    roleLabel: 'Kabin Görevlisi',
    roleEmoji: '💺',
    monthly: 25,
    annual: 17.5,
    annualTotal: 210,
    highlights: [
      '10 kabin odaklı ders',
      'Acil prosedür, CRM, DG dili',
      'Kabin Ligi — kabin ekibiyle yarış',
    ],
  ),
  _RolePricing(
    roleKey: 'amt',
    roleLabel: 'Uçak Bakım Teknisyeni',
    roleEmoji: '🔧',
    monthly: 25,
    annual: 17.5,
    annualTotal: 210,
    highlights: [
      '10 teknik bakım dersi',
      'AMM, AD, EASA Part-66 dili',
      'AMT Ligi — teknisyenlerle yarış',
    ],
  ),
  _RolePricing(
    roleKey: 'student',
    roleLabel: 'Öğrenci',
    roleEmoji: '🎓',
    monthly: 10,
    annual: 7,
    annualTotal: 84,
    highlights: [
      '14 temel havacılık dersi',
      'Gramer, kelime, temel ATC',
      'Öğrenci Ligi — öğrencilerle yarış',
    ],
  ),
];

// ── Ana ekran ─────────────────────────────────────────────────────────────────

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  Offerings? _offerings;
  Package? _selectedPackage;
  bool _loadingOfferings = true;
  bool _purchasing = false;
  bool _restoring = false;
  String? _errorMessage;
  bool _annual = true;
  String _selectedRoleKey = 'pilot'; // hangi plan seçili

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Kullanıcının kendi rolünü varsayılan seçili yap
    final profile = ref.read(userProfileProvider).valueOrNull;
    if (profile != null && profile.role.isNotEmpty) {
      _selectedRoleKey = profile.role;
    }
  }

  Future<void> _loadOfferings() async {
    final service = ref.read(subscriptionServiceProvider);
    final offerings = await service.getOfferings();
    if (!mounted) return;
    setState(() {
      _offerings = offerings;
      _loadingOfferings = false;
      if (offerings != null) {
        final packages = offerings.current?.availablePackages ?? [];
        if (packages.isNotEmpty) {
          _selectedPackage = packages.firstWhere(
            (p) => p.packageType == PackageType.annual,
            orElse: () => packages.first,
          );
        }
      }
    });
  }

  Future<void> _purchase() async {
    if (_selectedPackage == null) {
      _goNext();
      return;
    }
    setState(() { _purchasing = true; _errorMessage = null; });
    final service = ref.read(subscriptionServiceProvider);
    final (success, error) = await service.purchasePackage(_selectedPackage!);
    if (!mounted) return;
    if (success) {
      await ref.read(isPremiumProvider.notifier).refresh();
      _goNext();
    } else if (error != null) {
      setState(() { _errorMessage = error; _purchasing = false; });
    } else {
      setState(() { _purchasing = false; });
    }
  }

  Future<void> _restore() async {
    setState(() { _restoring = true; _errorMessage = null; });
    final service = ref.read(subscriptionServiceProvider);
    final ok = await service.restorePurchases();
    if (!mounted) return;
    if (ok) {
      await ref.read(isPremiumProvider.notifier).refresh();
      _goNext();
    } else {
      setState(() {
        _restoring = false;
        _errorMessage = 'Geri yüklenecek aktif abonelik bulunamadı.';
      });
    }
  }

  void _goNext() {
    if (Navigator.canPop(context)) {
      context.pop();
    } else {
      context.go('/assessment-intro');
    }
  }

  void _continueFree() => _goNext();

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    final selectedPricing = _allPlans.firstWhere(
      (p) => p.roleKey == _selectedRoleKey,
      orElse: () => _allPlans.first,
    );

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
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, canPop ? 4 : 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Başlık ───────────────────────────────────────────────
                  Center(child: const AirplaneLogo(size: 48)),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'Planını Seç',
                      style: AppTextStyles.heading1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Center(
                    child: Text(
                      'Mesleğine özel içerik, kendi liginde yarış',
                      style: AppTextStyles.caption,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Aylık / Yıllık toggle ────────────────────────────────
                  _PeriodToggle(
                    annual: _annual,
                    onToggle: (v) => setState(() => _annual = v),
                  ),
                  const SizedBox(height: 16),

                  // ── 4 Plan kartı ─────────────────────────────────────────
                  ..._allPlans.map((plan) => _PlanCard(
                    plan: plan,
                    annual: _annual,
                    isSelected: plan.roleKey == _selectedRoleKey,
                    onTap: () => setState(() => _selectedRoleKey = plan.roleKey),
                  )),

                  const SizedBox(height: 8),

                  // ── Seçili planın özellikleri ────────────────────────────
                  _SelectedPlanFeatures(pricing: selectedPricing),
                  const SizedBox(height: 20),

                  // ── Hata mesajı ──────────────────────────────────────────
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
                    const SizedBox(height: 12),
                  ],

                  // ── Satın Al butonu ──────────────────────────────────────
                  _loadingOfferings
                      ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                      : _purchasing
                          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                          : PrimaryButton(
                              label: _selectedPackage != null
                                  ? '${selectedPricing.roleEmoji}  ${selectedPricing.roleLabel} Planını Al'
                                  : '${selectedPricing.roleEmoji}  Devam Et',
                              onPressed: _purchase,
                            ),

                  const SizedBox(height: 10),

                  PrimaryButton(
                    label: 'Ücretsiz Devam Et',
                    outlined: true,
                    onPressed: _continueFree,
                  ),

                  const SizedBox(height: 14),

                  Center(
                    child: _restoring
                        ? const SizedBox(
                            height: 20, width: 20,
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
                  ),
                  const SizedBox(height: 4),
                  const Center(
                    child: Text(
                      'Kredi kartı gerekmez · İstediğin zaman iptal et',
                      style: AppTextStyles.caption,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Aylık / Yıllık geçiş ─────────────────────────────────────────────────────

class _PeriodToggle extends StatelessWidget {
  final bool annual;
  final ValueChanged<bool> onToggle;

  const _PeriodToggle({required this.annual, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _Tab(label: 'Aylık', selected: !annual, onTap: () => onToggle(false)),
          _Tab(
            label: 'Yıllık  🔥 %30 İndirim',
            selected: annual,
            onTap: () => onToggle(true),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Tab({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: selected
                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4, offset: const Offset(0, 1))]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Plan kartı ────────────────────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  final _RolePricing plan;
  final bool annual;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.plan,
    required this.annual,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final price = annual ? plan.annualStr : plan.monthlyStr;
    final period = annual ? '/ay' : '/ay';
    final note = annual ? '${plan.annualTotalStr}/yıl faturalandırılır' : 'Aylık faturalandırılır';

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.06) : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Seçim göstergesi
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.primary : AppColors.textHint,
              size: 20,
            ),
            const SizedBox(width: 12),
            // Emoji + isim
            Text(plan.roleEmoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.roleLabel,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    note,
                    style: const TextStyle(fontSize: 11, color: AppColors.textHint),
                  ),
                ],
              ),
            ),
            // Fiyat
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: price,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        ),
                      ),
                      TextSpan(
                        text: period,
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                if (annual)
                  Container(
                    margin: const EdgeInsets.only(top: 3),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '%30 İndirim',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Seçili planın özellikleri ─────────────────────────────────────────────────

class _SelectedPlanFeatures extends StatelessWidget {
  final _RolePricing pricing;
  const _SelectedPlanFeatures({required this.pricing});

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${pricing.roleEmoji}  ${pricing.roleLabel} Planı İçeriği',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            ...pricing.highlights.map((h) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      h,
                      style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
