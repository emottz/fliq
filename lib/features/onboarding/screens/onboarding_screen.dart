import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/user_profile_model.dart';
import '../../../core/services/firestore_service.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/primary_button.dart';

// ── Soru tanımları ────────────────────────────────────────────────────────────

class _Q {
  final String key;
  final String emoji;
  final String question;
  final String? hint;
  final List<(String, String)> options;
  const _Q({
    required this.key,
    required this.emoji,
    required this.question,
    this.hint,
    required this.options,
  });
}

const _questions = [
  _Q(
    key: 'role',
    emoji: '👤',
    question: 'Rolün nedir?',
    hint: 'İçerik ve sorular rolüne göre özelleştirilir',
    options: [
      ('pilot', '🧑‍✈️  Pilot'),
      ('cabin_crew', '💺  Kabin Ekibi'),
      ('amt', '🔧  Aircraft Maintenance Technician'),
      ('student', '🎓  Öğrenci'),
    ],
  ),
  _Q(
    key: 'licenseLevel',
    emoji: '🧑‍✈️',
    question: 'Uçuş eğitiminde hangi aşamadasın?',
    hint: 'İçerik zorluğunu ve konuları belirler',
    options: [
      ('not_started', '🌱  Henüz başlamadım'),
      ('theory', '📖  Teorik eğitimdeyim'),
      ('flight_training', '✈️  Uçuş eğitimindeyim'),
      ('ppl_holder', '🏅  PPL / Lisans sahibiyim'),
    ],
  ),
  _Q(
    key: 'flyingEnvironment',
    emoji: '🗺️',
    question: 'Hangi uçuş ortamında çalışıyorsun?',
    hint: 'ATC iletişimi ve senaryo içerikleri buna göre şekillenir',
    options: [
      ('vfr_private', '🛩️  VFR / Özel uçuş'),
      ('ifr_commercial', '🛫  IFR / Ticari uçuş'),
      ('atc', '🗼  Hava Trafik Kontrolü'),
      ('cabin', '💺  Kabin ekibi'),
      ('student', '🎓  Öğrenci / Henüz uçmadım'),
    ],
  ),
  _Q(
    key: 'flightHours',
    emoji: '⏱️',
    question: 'Toplam uçuş saatin ne kadar?',
    hint: 'Soru senaryolarının karmaşıklığını ayarlar',
    options: [
      ('0_50', '🔰  0 – 50 saat'),
      ('50_200', '📈  50 – 200 saat'),
      ('200_500', '🚀  200 – 500 saat'),
      ('500_plus', '🏆  500+ saat'),
    ],
  ),
  _Q(
    key: 'nativeLanguage',
    emoji: '🌐',
    question: 'Ana dilin nedir?',
    hint: 'Türkçe konuşanlar için özel hata kalıpları analizi',
    options: [
      ('turkish', '🇹🇷  Türkçe'),
      ('other', '🌍  Diğer'),
    ],
  ),
  _Q(
    key: 'englishLevel',
    emoji: '📊',
    question: 'İngilizce seviyeni nasıl değerlendirirsin?',
    hint: 'Öğrenme yolunun başlangıç noktası',
    options: [
      ('weak', '🔴  Zayıf — temel günlük İngilizce bile zor'),
      ('medium', '🟡  Orta — anlıyorum ama aviation İngilizcesi eksik'),
      ('good', '🟢  İyi — genel İngilizce iyi, uzmanlık gerektiriyor'),
    ],
  ),
  _Q(
    key: 'hardestArea',
    emoji: '🎯',
    question: 'Seni en çok hangi alan zorluyor?',
    hint: 'İlk haftalar bu alana öncelik verilir',
    options: [
      ('grammar', '📝  Gramer yapıları'),
      ('vocabulary', '📖  Havacılık kelime bilgisi'),
      ('atc_comm', '🎙️  ATC iletişimi & phraseology'),
      ('reading', '📄  METAR / NOTAM okuma'),
      ('all', '🔥  Hepsi eşit derecede zor'),
    ],
  ),
  _Q(
    key: 'goal',
    emoji: '🏁',
    question: 'Hedefin ne?',
    hint: 'ICAO hedefliyorsan test formatına uygun sorular öne çıkar',
    options: [
      ('icao', '🎖️  ICAO sınavına hazırlanmak'),
      ('general', '✈️  Genel aviation İngilizcesi'),
      ('both', '🔥  Her ikisi'),
    ],
  ),
  _Q(
    key: 'prevIcaoAttempt',
    emoji: '📋',
    question: 'Daha önce ICAO / havacılık İngilizcesi sınavına girdin mi?',
    hint: 'Geçmiş deneyim öğrenme stratejisini etkiler',
    options: [
      ('never', '🆕  Hayır, ilk kez hazırlanıyorum'),
      ('failed', '❌  Girdim ama istediğim seviyeyi alamadım'),
      ('passed_want_higher', '✅  Geçtim, daha yüksek seviye istiyorum'),
    ],
  ),
  _Q(
    key: 'dailyTime',
    emoji: '⏰',
    question: 'Günlük ne kadar vakit ayırabilirsin?',
    hint: 'Seans uzunluğu ve bildirim sıklığı buna göre ayarlanır',
    options: [
      ('5_10', '⚡  5 – 10 dakika'),
      ('15_20', '🔥  15 – 20 dakika'),
      ('30_plus', '🏆  30+ dakika'),
    ],
  ),
  _Q(
    key: 'examTimeline',
    emoji: '📅',
    question: 'ICAO sınavın ne zaman?',
    hint: 'Önceliklendirme ve çalışma yoğunluğu buna göre şekillenir',
    options: [
      ('not_planned', '🗓️  Planlamadım henüz'),
      ('6_months_plus', '📆  6 aydan fazla var'),
      ('6_months', '⏳  6 ay içinde'),
      ('1_month', '🚨  1 ay içinde'),
    ],
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  int _step = 0;
  bool _saving = false;
  final Map<String, String> _answers = {};

  late AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;
  bool _goingForward = true;

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    _slideCtrl.forward();
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    super.dispose();
  }

  void _animateTo(int next) {
    _goingForward = next > _step;
    _slideCtrl.reset();
    _slideAnim = Tween<Offset>(
      begin: Offset(_goingForward ? 1.0 : -1.0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    setState(() => _step = next);
    _slideCtrl.forward();
  }

  String get _currentKey => _questions[_step].key;
  bool get _answered => _answers.containsKey(_currentKey);

  Future<void> _next() async {
    if (!_answered) return;
    if (_step < _questions.length - 1) {
      _animateTo(_step + 1);
    } else {
      await _save();
    }
  }

  void _back() {
    if (_step > 0) _animateTo(_step - 1);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final profile = UserProfileModel(
      role: _answers['role'] ?? 'pilot',
      licenseLevel: _answers['licenseLevel'] ?? '',
      flyingEnvironment: _answers['flyingEnvironment'] ?? '',
      flightHours: _answers['flightHours'] ?? '',
      nativeLanguage: _answers['nativeLanguage'] ?? '',
      englishLevel: _answers['englishLevel'] ?? '',
      hardestArea: _answers['hardestArea'] ?? '',
      goal: _answers['goal'] ?? '',
      prevIcaoAttempt: _answers['prevIcaoAttempt'] ?? '',
      dailyTime: _answers['dailyTime'] ?? '',
      examTimeline: _answers['examTimeline'] ?? '',
      level: ProficiencyLevel.beginner,
      totalXp: 0,
      streakDays: 0,
      categoryProgress: {},
    );
    await ref.read(userProfileProvider.notifier).saveProfile(profile);
    FirestoreService.saveOnboarding(profile);
    if (mounted) context.go('/assessment-intro');
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_step];
    final total = _questions.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                // ── Top bar ──────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      // Geri butonu
                      GestureDetector(
                        onTap: _step > 0 ? _back : null,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: _step > 0 ? 1.0 : 0.0,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: AppColors.textSecondary,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Progress bar
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${_step + 1} / $total',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: TweenAnimationBuilder<double>(
                                tween: Tween(begin: _step / total, end: (_step + 1) / total),
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                                builder: (_, v, __) => LinearProgressIndicator(
                                  value: v,
                                  minHeight: 5,
                                  backgroundColor: AppColors.divider,
                                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ── Soru & seçenekler (animasyonlu) ──────────
                Expanded(
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Emoji
                          Text(q.emoji, style: const TextStyle(fontSize: 44)),
                          const SizedBox(height: 16),
                          // Soru
                          Text(
                            q.question,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                          ),
                          if (q.hint != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              q.hint!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                          const SizedBox(height: 28),
                          // Seçenekler
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: q.options.map((o) {
                                  final isSelected = _answers[_currentKey] == o.$1;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() => _answers[_currentKey] = o.$1);
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 160),
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 16),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.surface,
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.divider,
                                          width: isSelected ? 2 : 1,
                                        ),
                                        boxShadow: isSelected
                                            ? [BoxShadow(
                                                color: AppColors.primary.withValues(alpha: 0.22),
                                                blurRadius: 10,
                                                offset: const Offset(0, 3),
                                              )]
                                            : null,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              o.$2,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: isSelected
                                                    ? Colors.white
                                                    : AppColors.textPrimary,
                                              ),
                                            ),
                                          ),
                                          if (isSelected)
                                            const Icon(
                                              Icons.check_circle_rounded,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Devam butonu ──────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                  child: PrimaryButton(
                    label: _step < _questions.length - 1
                        ? 'Devam Et →'
                        : 'Başlayalım 🚀',
                    isLoading: _saving,
                    onPressed: _answered ? _next : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
