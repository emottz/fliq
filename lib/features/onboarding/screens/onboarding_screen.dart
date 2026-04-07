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

  // Adım 1 — Kim olduğun
  String _licenseLevel = '';
  String _flyingEnvironment = '';
  String _flightHours = '';

  // Adım 2 — Dil & hedef
  String _nativeLanguage = '';
  String _englishLevel = '';
  String _hardestArea = '';

  // Adım 3 — Plan & deneyim
  String _goal = '';
  String _dailyTime = '';
  String _examTimeline = '';
  String _prevIcaoAttempt = '';

  static const _totalSteps = 3;

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
        0 => _licenseLevel.isNotEmpty && _flyingEnvironment.isNotEmpty && _flightHours.isNotEmpty,
        1 => _nativeLanguage.isNotEmpty && _englishLevel.isNotEmpty && _hardestArea.isNotEmpty,
        2 => _goal.isNotEmpty && _dailyTime.isNotEmpty && _examTimeline.isNotEmpty && _prevIcaoAttempt.isNotEmpty,
        _ => false,
      };

  Future<void> _next() async {
    if (_step < _totalSteps - 1) {
      _slideCtrl.reset();
      setState(() => _step++);
      _slideCtrl.forward();
    } else {
      await _save();
    }
  }

  void _back() {
    if (_step > 0) {
      _slideCtrl.reset();
      setState(() => _step--);
      _slideCtrl.forward();
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final profile = UserProfileModel(
      role: 'pilot',
      licenseLevel: _licenseLevel,
      flyingEnvironment: _flyingEnvironment,
      flightHours: _flightHours,
      nativeLanguage: _nativeLanguage,
      englishLevel: _englishLevel,
      hardestArea: _hardestArea,
      goal: _goal,
      dailyTime: _dailyTime,
      examTimeline: _examTimeline,
      prevIcaoAttempt: _prevIcaoAttempt,
      level: ProficiencyLevel.beginner,
      totalXp: 0,
      streakDays: 0,
      categoryProgress: {},
    );
    await ref.read(userProfileProvider.notifier).saveProfile(profile);
    FirestoreService.saveOnboarding(profile);
    if (mounted) context.go('/assessment-intro');
  }

  static const _steps = [
    (emoji: '🧑‍✈️', title: 'Uçuş profilin'),
    (emoji: '📚', title: 'Dil durumun'),
    (emoji: '🎯', title: 'Plan & deneyim'),
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
                      if (_step > 0)
                        GestureDetector(
                          onTap: _back,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.arrow_back_ios_new_rounded,
                                color: AppColors.textSecondary, size: 16),
                          ),
                        )
                      else
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.flight, color: Colors.white, size: 20),
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
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_step + 1} / $_totalSteps adım',
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
                    children: List.generate(_totalSteps, (i) {
                      return Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: EdgeInsets.only(right: i < _totalSteps - 1 ? 6 : 0),
                          height: 4,
                          decoration: BoxDecoration(
                            color: i <= _step ? AppColors.primary : AppColors.divider,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 28),

                  Text('${step.emoji}  ${step.title}', style: AppTextStyles.heading2),

                  const SizedBox(height: 20),

                  Expanded(
                    child: SlideTransition(
                      position: _slideAnim,
                      child: SingleChildScrollView(child: _buildStep()),
                    ),
                  ),

                  const SizedBox(height: 12),

                  PrimaryButton(
                    label: _step < _totalSteps - 1 ? 'Devam Et →' : 'Başlayalım 🚀',
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
      // ── Adım 1: Uçuş profilin ────────────────────────────────
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Question(
              label: 'Uçuş eğitiminde hangi aşamadasın?',
              hint: 'İçerik zorluğunu ve konuları belirler',
              options: const [
                ('not_started', '🌱  Henüz başlamadım'),
                ('theory', '📖  Teorik eğitimdeyim'),
                ('flight_training', '✈️  Uçuş eğitimindeyim'),
                ('ppl_holder', '🏅  PPL / Lisans sahibiyim'),
              ],
              selected: _licenseLevel,
              onSelect: (v) => setState(() => _licenseLevel = v),
            ),
            const SizedBox(height: 24),
            _Question(
              label: 'Hangi uçuş ortamında çalışıyorsun?',
              hint: 'ATC iletişimi ve senaryo içerikleri buna göre şekillenir',
              options: const [
                ('vfr_private', '🛩️  VFR / Özel uçuş'),
                ('ifr_commercial', '🛫  IFR / Ticari uçuş'),
                ('atc', '🗼  Hava Trafik Kontrolü'),
                ('cabin', '💺  Kabin ekibi'),
                ('student', '🎓  Öğrenci / Henüz uçmadım'),
              ],
              selected: _flyingEnvironment,
              onSelect: (v) => setState(() => _flyingEnvironment = v),
            ),
            const SizedBox(height: 24),
            _Question(
              label: 'Toplam uçuş saatin ne kadar?',
              hint: 'Soru senaryolarının karmaşıklığını ayarlar',
              options: const [
                ('0_50', '🔰  0 – 50 saat'),
                ('50_200', '📈  50 – 200 saat'),
                ('200_500', '🚀  200 – 500 saat'),
                ('500_plus', '🏆  500+ saat'),
              ],
              selected: _flightHours,
              onSelect: (v) => setState(() => _flightHours = v),
            ),
            const SizedBox(height: 8),
          ],
        );

      // ── Adım 2: Dil durumun ──────────────────────────────────
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Question(
              label: 'Ana dilin nedir?',
              hint: 'Türkçe konuşanlar için özel hata kalıpları analizi',
              options: const [
                ('turkish', '🇹🇷  Türkçe'),
                ('other', '🌐  Diğer'),
              ],
              selected: _nativeLanguage,
              onSelect: (v) => setState(() => _nativeLanguage = v),
            ),
            const SizedBox(height: 24),
            _Question(
              label: 'İngilizce seviyeni nasıl değerlendirirsin?',
              hint: 'Öğrenme yolunun başlangıç noktası',
              options: const [
                ('weak', '🔴  Zayıf — temel günlük İngilizce bile zor'),
                ('medium', '🟡  Orta — anlıyorum ama aviation İngilizcesi eksik'),
                ('good', '🟢  İyi — genel İngilizce iyi, uzmanlık gerektiriyor'),
              ],
              selected: _englishLevel,
              onSelect: (v) => setState(() => _englishLevel = v),
            ),
            const SizedBox(height: 24),
            _Question(
              label: 'Seni en çok hangi alan zorluyor?',
              hint: 'İlk haftalar bu alana yoğunlaşırsın',
              options: const [
                ('grammar', '📝  Gramer yapıları'),
                ('vocabulary', '📖  Havacılık kelime bilgisi'),
                ('atc_comm', '🎙️  ATC iletişimi & phraseology'),
                ('reading', '📄  METAR / NOTAM okuma'),
                ('all', '🔥  Hepsi eşit derecede zor'),
              ],
              selected: _hardestArea,
              onSelect: (v) => setState(() => _hardestArea = v),
            ),
            const SizedBox(height: 8),
          ],
        );

      // ── Adım 3: Plan & deneyim ──────────────────────────────
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const SizedBox(height: 24),
            _Question(
              label: 'Daha önce ICAO / havacılık İngilizcesi sınavına girdin mi?',
              hint: 'Geçmiş deneyim öğrenme stratejisini etkiler',
              options: const [
                ('never', '🆕  Hayır, ilk kez hazırlanıyorum'),
                ('failed', '❌  Girdim ama geçemedim / istediğim seviyeyi alamadım'),
                ('passed_want_higher', '✅  Geçtim, daha yüksek seviye istiyorum'),
              ],
              selected: _prevIcaoAttempt,
              onSelect: (v) => setState(() => _prevIcaoAttempt = v),
            ),
            const SizedBox(height: 24),
            _Question(
              label: 'Günlük ne kadar vakit ayırabilirsin?',
              hint: 'Seans uzunluğu ve bildirim sıklığı buna göre ayarlanır',
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
              hint: 'Önceliklendirme ve çalışma yoğunluğu buna göre şekillenir',
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
          Text(hint!, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
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
                      ? [BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )]
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
                      const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
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
