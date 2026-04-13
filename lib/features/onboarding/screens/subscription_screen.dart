import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/iap_constants.dart';
import '../../../core/services/iap_service.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/primary_button.dart';

// ── Plan modeli ───────────────────────────────────────────────────────────────

class _Plan {
  final String roleKey;
  final String label;
  final String emoji;
  final Color accent;
  final Color accentLight;
  final int monthlyPrice;   // ₺/ay
  final String tagline;
  final List<_Feature> features;

  const _Plan({
    required this.roleKey,
    required this.label,
    required this.emoji,
    required this.accent,
    required this.accentLight,
    required this.monthlyPrice,
    required this.tagline,
    required this.features,
  });

  int get fourMonthPrice => (monthlyPrice * 0.7).round(); // %30 indirim
  int get fourMonthTotal => fourMonthPrice * 4;
  int get fourMonthSaving => monthlyPrice * 4 - fourMonthTotal;
}

class _Feature {
  final IconData icon;
  final String text;
  final bool highlight; // sarı rozet
  const _Feature(this.icon, this.text, {this.highlight = false});
}

const _kDiscount = 0.30; // %30

final _plans = [
  _Plan(
    roleKey: 'pilot',
    label: 'Pilot',
    emoji: '✈️',
    accent: AppColors.primary,
    accentLight: Color(0xFFEFF6FF),
    monthlyPrice: 2000,
    tagline: 'ICAO sınavına hazır en kapsamlı içerik',
    features: [
      _Feature(Icons.school_rounded,        '60+ ders: ATC iletişimi, METAR/TAF, SID/STAR, PIREP', highlight: true),
      _Feature(Icons.record_voice_over,     'Gerçek ATC ses senaryoları ile dinleme pratiği'),
      _Feature(Icons.description_outlined,  'Kaza raporu, IFR clearance, ops manual terminolojisi'),
      _Feature(Icons.emoji_events_rounded,  'Pilot Ligi — sadece pilotlarla haftalık yarış'),
      _Feature(Icons.bar_chart_rounded,     'Zayıf kategori analizi + kişisel çalışma planı'),
      _Feature(Icons.quiz_rounded,          'Sınırsız ICAO Level 4-6 odaklı sınav'),
      _Feature(Icons.auto_awesome,          'Her sınavdan sonra AI koçluk yorumu'),
    ],
  ),
  _Plan(
    roleKey: 'cabin_crew',
    label: 'Kabin Görevlisi',
    emoji: '💺',
    accent: Color(0xFF7C3AED),
    accentLight: Color(0xFFF5F3FF),
    monthlyPrice: 1500,
    tagline: 'Kabin ekibine özel dil ve prosedür eğitimi',
    features: [
      _Feature(Icons.school_rounded,        '18 kabin dersi + tüm temel havacılık dersleri', highlight: true),
      _Feature(Icons.local_hospital_outlined,'Tahliye, tıbbi acil ve CRM prosedür dili'),
      _Feature(Icons.warning_amber_rounded, 'Dangerous Goods, MAYDAY, PAN-PAN komut pratiği'),
      _Feature(Icons.people_rounded,        'Yolcu iletişimi ve hizmet senaryoları'),
      _Feature(Icons.emoji_events_rounded,  'Kabin Ligi — kabin ekibiyle haftalık yarış'),
      _Feature(Icons.bar_chart_rounded,     'Kişisel analiz + öncelikli zayıf alan takibi'),
      _Feature(Icons.quiz_rounded,          'Sınırsız kategori sınavı'),
    ],
  ),
  _Plan(
    roleKey: 'amt',
    label: 'Uçak Bakım Teknikeri',
    emoji: '🔧',
    accent: Color(0xFFD97706),
    accentLight: Color(0xFFFFFBEB),
    monthlyPrice: 1500,
    tagline: 'EASA Part-145 odaklı teknik İngilizce',
    features: [
      _Feature(Icons.school_rounded,        '18 teknik bakım dersi + temel havacılık dersleri', highlight: true),
      _Feature(Icons.build_outlined,        'AMM, NDT, EASA Part-145 terminolojisi'),
      _Feature(Icons.security_outlined,     'SMS (Safety Management System) dili'),
      _Feature(Icons.edit_note_rounded,     'Teknik günlük ve squawk yazma pratiği'),
      _Feature(Icons.emoji_events_rounded,  'AMT Ligi — teknisyenlerle haftalık yarış'),
      _Feature(Icons.bar_chart_rounded,     'Teknik terim analizi ve hafıza önerileri'),
      _Feature(Icons.quiz_rounded,          'Sınırsız teknik terminoloji sınavı'),
    ],
  ),
  _Plan(
    roleKey: 'student',
    label: 'Öğrenci',
    emoji: '🎓',
    accent: Color(0xFF059669),
    accentLight: Color(0xFFECFDF5),
    monthlyPrice: 500,
    tagline: 'Sıfırdan ICAO giriş seviyesine',
    features: [
      _Feature(Icons.school_rounded,        '35+ temel ve orta seviye havacılık dersi', highlight: true),
      _Feature(Icons.spellcheck_rounded,    'Gramer, kelime bilgisi ve cümle yapıları'),
      _Feature(Icons.headset_mic_rounded,   'ATC iletişim temelleri ve phraseology'),
      _Feature(Icons.cloud_outlined,        'METAR/TAF okuma ve hava durumu dili'),
      _Feature(Icons.flight_takeoff_rounded,'Uçuş fazları ve çevre terminolojisi'),
      _Feature(Icons.emoji_events_rounded,  'Öğrenci Ligi — diğer öğrencilerle yarış'),
      _Feature(Icons.trending_up_rounded,   'A2\'den C1\'e seviye ilerleme sistemi'),
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
  bool _purchasing = false;
  String? _errorMessage;
  bool _fourMonth = false;
  String _selectedRoleKey = 'pilot';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final profile = ref.read(userProfileProvider).valueOrNull;
    if (profile != null && profile.role.isNotEmpty) {
      _selectedRoleKey = profile.role;
    }
  }

  _Plan get _selected =>
      _plans.firstWhere((p) => p.roleKey == _selectedRoleKey, orElse: () => _plans.first);

  // ── Satın alma ────────────────────────────────────────────────────────────

  Future<void> _purchase() async {
    setState(() { _purchasing = true; _errorMessage = null; });
    try {
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        await _purchaseMobile();
      } else {
        await _purchaseWeb();
      }
    } finally {
      if (mounted) setState(() => _purchasing = false);
    }
  }

  Future<void> _purchaseMobile() async {
    final svc = IapService.instance;
    final available = await svc.isAvailable();
    if (!available) {
      setState(() => _errorMessage = 'Google Play Store erişilemiyor. İnternet bağlantını kontrol et.');
      return;
    }
    final productId = IapConstants.productId(roleKey: _selectedRoleKey, annual: _fourMonth);
    final product = await svc.getProduct(productId);
    if (product == null) {
      setState(() => _errorMessage = 'Bu plan şu an mevcut değil (ID: $productId).');
      return;
    }
    await svc.buy(product);
  }

  Future<void> _purchaseWeb() async {
    try {
      final service = ref.read(subscriptionServiceProvider);
      final url = await service.createCheckout(planKey: _selectedRoleKey, annual: _fourMonth);
      if (!mounted) return;
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        setState(() => _errorMessage = 'Ödeme sayfası açılamadı. Lütfen tekrar deneyin.');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = e.toString().replaceAll('Exception: ', ''));
    }
  }

  void _goBack() {
    if (Navigator.canPop(context)) {
      context.pop();
    } else {
      context.go('/home/exams');
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final plan = _selected;
    final canPop = Navigator.canPop(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: CustomScrollView(
        slivers: [
          // ── Hero app bar ───────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: canPop
                ? IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    onPressed: _goBack,
                  )
                : null,
            flexibleSpace: FlexibleSpaceBar(
              background: _HeroHeader(),
            ),
          ),

          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      // ── Periyot toggle ──────────────────────────────────────
                      _PeriodToggle(
                        fourMonth: _fourMonth,
                        onToggle: (v) => setState(() => _fourMonth = v),
                      ),
                      const SizedBox(height: 20),

                      // ── Plan kartları ───────────────────────────────────────
                      ..._plans.map((p) => _PlanCard(
                        plan: p,
                        isSelected: p.roleKey == _selectedRoleKey,
                        fourMonth: _fourMonth,
                        onTap: () => setState(() => _selectedRoleKey = p.roleKey),
                      )),

                      const SizedBox(height: 8),

                      // ── Hata ────────────────────────────────────────────────
                      if (_errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.errorLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: AppColors.error, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(color: AppColors.error, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // ── CTA butonu ──────────────────────────────────────────
                      _purchasing
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                child: CircularProgressIndicator(color: AppColors.primary),
                              ),
                            )
                          : _BuyButton(plan: plan, fourMonth: _fourMonth, onPressed: _purchase),

                      const SizedBox(height: 12),

                      // Ücretsiz devam
                      Center(
                        child: TextButton(
                          onPressed: _goBack,
                          child: const Text(
                            'Ücretsiz devam et',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      // Güven metni
                      Center(
                        child: Text(
                          kIsWeb
                              ? 'Güvenli ödeme · iyzico · İstediğin zaman iptal et'
                              : 'Google Play üzerinden güvenli ödeme · İstediğin zaman iptal et',
                          style: const TextStyle(fontSize: 11, color: AppColors.textHint),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
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

// ── Hero header ───────────────────────────────────────────────────────────────

class _HeroHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDeep, AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '👑  Avialish Premium',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Mesleğine özel içerik · Sınırsız pratik · Lig sistemi',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 14),
              // Trust chips
              Wrap(
                spacing: 8,
                children: const [
                  _TrustChip('🔒 Güvenli ödeme'),
                  _TrustChip('↩️ İstediğin zaman iptal'),
                  _TrustChip('⚡ Anında erişim'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrustChip extends StatelessWidget {
  final String label;
  const _TrustChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
      ),
    );
  }
}

// ── Periyot toggle ────────────────────────────────────────────────────────────

class _PeriodToggle extends StatelessWidget {
  final bool fourMonth;
  final ValueChanged<bool> onToggle;
  const _PeriodToggle({required this.fourMonth, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.divider),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              _ToggleTab(
                label: 'Aylık',
                sublabel: 'Normal fiyat',
                selected: !fourMonth,
                onTap: () => onToggle(false),
              ),
              _ToggleTab(
                label: '4 Aylık',
                sublabel: '%30 daha ucuz',
                selected: fourMonth,
                onTap: () => onToggle(true),
                badge: '%30',
              ),
            ],
          ),
        ),
        // Badge
        if (fourMonth)
          Positioned(
            top: -10,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                '🔥 En Popüler',
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
              ),
            ),
          ),
      ],
    );
  }
}

class _ToggleTab extends StatelessWidget {
  final String label;
  final String sublabel;
  final bool selected;
  final VoidCallback onTap;
  final String? badge;

  const _ToggleTab({
    required this.label,
    required this.sublabel,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: selected
                ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))]
                : null,
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: selected ? Colors.white : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                sublabel,
                style: TextStyle(
                  fontSize: 11,
                  color: selected ? Colors.white70 : AppColors.textHint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Plan kartı ────────────────────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  final _Plan plan;
  final bool isSelected;
  final bool fourMonth;
  final VoidCallback onTap;

  const _PlanCard({
    required this.plan,
    required this.isSelected,
    required this.fourMonth,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final price = fourMonth ? plan.fourMonthPrice : plan.monthlyPrice;
    final priceStr = '₺${_fmt(price)}';
    final billNote = fourMonth
        ? '₺${_fmt(plan.fourMonthTotal)} · 4 ayda bir ödenir'
        : 'Her ay yenilenir';
    final saving = fourMonth ? '₺${_fmt(plan.fourMonthSaving)} tasarruf' : '';

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isSelected ? plan.accentLight : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? plan.accent : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: plan.accent.withValues(alpha: 0.12), blurRadius: 16, offset: const Offset(0, 4))]
              : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            // ── Kart başlığı ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  // Seçim indikatörü
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? plan.accent : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? plan.accent : AppColors.divider,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  // Emoji
                  Text(plan.emoji, style: const TextStyle(fontSize: 26)),
                  const SizedBox(width: 10),
                  // İsim + tagline
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.label,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: isSelected ? plan.accent : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          plan.tagline,
                          style: TextStyle(
                            fontSize: 11,
                            color: isSelected
                                ? plan.accent.withValues(alpha: 0.7)
                                : AppColors.textHint,
                          ),
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
                              text: priceStr,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: isSelected ? plan.accent : AppColors.textPrimary,
                              ),
                            ),
                            TextSpan(
                              text: '/ay',
                              style: TextStyle(
                                fontSize: 11,
                                color: isSelected
                                    ? plan.accent.withValues(alpha: 0.7)
                                    : AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (fourMonth)
                        Container(
                          margin: const EdgeInsets.only(top: 3),
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            saving,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF15803D),
                            ),
                          ),
                        ),
                      Text(
                        billNote,
                        style: const TextStyle(fontSize: 10, color: AppColors.textHint),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Özellikler (sadece seçiliyken) ───────────────────────────
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 250),
              crossFadeState: isSelected
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: _FeatureList(plan: plan),
              secondChild: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  static String _fmt(int n) {
    if (n >= 1000) {
      final s = n.toString();
      final List<String> parts = [];
      int start = s.length % 3;
      if (start > 0) parts.add(s.substring(0, start));
      for (int i = start; i < s.length; i += 3) {
        parts.add(s.substring(i, i + 3));
      }
      return parts.join('.');
    }
    return n.toString();
  }
}

// ── Özellik listesi ───────────────────────────────────────────────────────────

class _FeatureList extends StatelessWidget {
  final _Plan plan;
  const _FeatureList({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: plan.accent.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: plan.features.map((f) => _FeatureRow(feature: f, accent: plan.accent)).toList(),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final _Feature feature;
  final Color accent;
  const _FeatureRow({required this.feature, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(feature.icon, size: 15, color: accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      feature.text,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                  ),
                  if (feature.highlight) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '⭐ Öne çıkan',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFD97706),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Satın al butonu ───────────────────────────────────────────────────────────

class _BuyButton extends StatelessWidget {
  final _Plan plan;
  final bool fourMonth;
  final VoidCallback onPressed;

  const _BuyButton({required this.plan, required this.fourMonth, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final price = fourMonth ? plan.fourMonthPrice : plan.monthlyPrice;
    final priceStr = '₺${_PlanCard._fmt(price)}/ay';

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              plan.accent,
              Color.lerp(plan.accent, Colors.black, 0.15)!,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: plan.accent.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(plan.emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text(
                  '${plan.label} Planını Al',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              fourMonth
                  ? '$priceStr · ${_PlanCard._fmt(plan.fourMonthTotal)} ₺ 4 ayda bir'
                  : '$priceStr · Her ay yenilenir',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
