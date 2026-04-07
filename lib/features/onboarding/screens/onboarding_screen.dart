import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/user_profile_model.dart';
import '../../../core/services/firestore_service.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/primary_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  int _step = 0;
  bool _saving = false;
  late AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;

  // Q1
  String _licenseLevel = '';
  // Q2
  String _nativeLanguage = '';
  // Q3
  String _englishLevel = '';
  // Q4
  String _goal = '';
  // Q5
  String _dailyTime = '';
  // Q6 — sınav tarihi
  String _examTimeline = '';

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut));
    _slideCtrl.forward();
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    super.dispose();
  }

  bool _canProceed() => switch (_step) {
        0 => _licenseLevel.isNotEmpty && _nativeLanguage.isNotEmpty,
        1 => _englishLevel.isNotEmpty && _goal.isNotEmpty,
        2 => _dailyTime.isNotEmpty && _examTimeline.isNotEmpty,
        _ => false,
      };

  Future<void> _next() async {
    if (_step < 2) {
      _slideCtrl.reset();
      setState(() => _step++);
      _slideCtrl.forward();
    } else {
      await _save();
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final profile = UserProfileModel(
      role: 'pilot',
      licenseLevel: _licenseLevel,
      nativeLanguage: _nativeLanguage,
      englishLevel: _englishLevel,
      goal: _goal,
      dailyTime: _dailyTime,
      examTimeline: _examTimeline,
      level: ProficiencyLevel.beginner,
      totalXp: 0,
      streakDays: 0,
      categoryProgress: {},
    );
    await ref.read(userProfileProvider.notifier).saveProfile(profile);
    FirestoreService.saveOnboarding(profile); // fire-and-forget
    if (mounted) context.go('/assessment-intro');
  }

  static const _steps = [
    (emoji: '🧑‍✈️', title: 'Kim olduğun'),
    (emoji: '📚', title: 'Dil durumun'),
    (emoji: '🎯', title: 'Çalışma planın'),
  ];

  @override
  Widget build(BuildContext context) {
    final step = _steps[_step];
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──────────────────────────────────────
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.flight,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'FLIQ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: 2,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_step + 1} / 3 adım',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── Progress bar ─────────────────────────────────
                  Row(
                    children: List.generate(3, (i) {
                      return Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                          height: 4,
                          decoration: BoxDecoration(
                            color: i <= _step
                                ? AppColors.primary
                                : AppColors.divider,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 28),

                  // ── Step title ────────────────────────────────────
                  Text(
                    '${step.emoji}  ${step.title}',
                    style: AppTextStyles.heading2,
                  ),

                  const SizedBox(height: 20),

                  // ── Questions ────────────────────────────────────
                  Expanded(
                    child: SlideTransition(
                      position: _slideAnim,
                      child: SingleChildScrollView(
                        child: _buildStep(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Continue button ──────────────────────────────
                  PrimaryButton(
                    label: _step < 2 ? 'Devam Et →' : 'Başlayalım 🚀',
                    isLoading: _saving,
                    onPressed: _canProceed() ? _next : null,
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      // ── Ekran 1: Kim olduğun ─────────────────────────────────
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Question(
              label: 'Uçuş eğitiminde hangi aşamadasın?',
              hint: 'İçerik zorluğunu belirler',
              options: const [
                ('not_started', '🌱  Henüz başlamadım'),
                ('theory', '📖  Teorik eğitimdeyim'),
                ('flight_training', '✈️  Uçuş eğitimindeyim'),
                ('ppl_holder', '🏅  PPL aldım'),
              ],
              selected: _licenseLevel,
              onSelect: (v) => setState(() => _licenseLevel = v),
            ),
            const SizedBox(height: 24),
            _Question(
              label: 'Ana dilin nedir?',
              hint: 'Türkçe konuşanlara özel hata kalıpları var',
              options: const [
                ('turkish', '🇹🇷  Türkçe'),
                ('other', '🌐  Diğer'),
              ],
              selected: _nativeLanguage,
              onSelect: (v) => setState(() => _nativeLanguage = v),
            ),
            const SizedBox(height: 8),
          ],
        );

      // ── Ekran 2: Dil durumun ────────────────────────────────
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Question(
              label: 'İngilizce seviyeni nasıl değerlendirirsin?',
              hint: '3 seçenek yeterli, fazlası kafa karıştırır',
              options: const [
                ('weak', '🔴  Zayıf'),
                ('medium', '🟡  Orta'),
                ('good', '🟢  İyi'),
              ],
              selected: _englishLevel,
              onSelect: (v) => setState(() => _englishLevel = v),
            ),
            const SizedBox(height: 24),
            _Question(
              label: 'Hedefin ne?',
              hint: 'ICAO hedefliyorsan test formatına uygun sorular öne çıkar',
              options: const [
                ('icao', '🎖️  ICAO sınavına hazırlanmak'),
                ('general', '✈️  Genel aviation İngilizcesi'),
                ('both', '🔥  Her ikisi'),
              ],
              selected: _goal,
              onSelect: (v) => setState(() => _goal = v),
            ),
            const SizedBox(height: 8),
          ],
        );

      // ── Ekran 3: Çalışma planın ─────────────────────────────
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Question(
              label: 'Günlük ne kadar vakit ayırabilirsin?',
              hint: 'Session uzunluğu ve bildirim sıklığı buna göre ayarlanır',
              options: const [
                ('5_10', '⚡  5 – 10 dakika'),
                ('15_20', '🔥  15 – 20 dakika'),
                ('30_plus', '🏆  30+ dakika'),
              ],
              selected: _dailyTime,
              onSelect: (v) => setState(() => _dailyTime = v),
            ),
            const SizedBox(height: 24),
            _Question(
              label: 'ICAO sınavın ne zaman?',
              hint: 'Önceliklendirme ve yoğunluk buna göre şekillenir',
              options: const [
                ('not_planned', '📅  Planlamadım henüz'),
                ('6_months_plus', '🗓️  6 aydan fazla var'),
                ('6_months', '⏳  6 ay içinde'),
                ('1_month', '🚨  1 ay içinde'),
              ],
              selected: _examTimeline,
              onSelect: (v) => setState(() => _examTimeline = v),
            ),
            const SizedBox(height: 8),
          ],
        );

      default:
        return const SizedBox();
    }
  }
}

// ── Question widget ───────────────────────────────────────────────────────────

class _Question extends StatelessWidget {
  final String label;
  final String? hint;
  final List<(String, String)> options;
  final String selected;
  final ValueChanged<String> onSelect;

  const _Question({
    required this.label,
    this.hint,
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodyBold),
        if (hint != null) ...[
          const SizedBox(height: 3),
          Text(
            hint!,
            style: const TextStyle(fontSize: 12, color: AppColors.textHint),
          ),
        ],
        const SizedBox(height: 12),
        Column(
          children: options.map((o) {
            final isSelected = o.$1 == selected;
            return GestureDetector(
              onTap: () => onSelect(o.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.divider,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        o.$2,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle_rounded,
                          color: Colors.white, size: 18),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
