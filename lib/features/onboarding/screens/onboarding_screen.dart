import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/user_profile_model.dart';
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

  // Step 1 — Kim olduğun
  String _licenseLevel = '';
  String _flightHours = '';
  String _nativeLanguage = '';

  // Step 2 — Nerede olduğun
  String _englishLevel = '';
  String _icaoLevel = '';
  String _examTimeline = '';

  // Step 3 — Ne istediğin
  String _hardestArea = '';
  String _flyingEnvironment = '';
  String _aircraftType = '';
  String _dailyTime = '';

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
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
        0 => _licenseLevel.isNotEmpty &&
            _flightHours.isNotEmpty &&
            _nativeLanguage.isNotEmpty,
        1 => _englishLevel.isNotEmpty &&
            _icaoLevel.isNotEmpty &&
            _examTimeline.isNotEmpty,
        2 => _hardestArea.isNotEmpty &&
            _flyingEnvironment.isNotEmpty &&
            _aircraftType.isNotEmpty &&
            _dailyTime.isNotEmpty,
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
      flightHours: _flightHours,
      nativeLanguage: _nativeLanguage,
      englishLevel: _englishLevel,
      icaoLevel: _icaoLevel,
      examTimeline: _examTimeline,
      hardestArea: _hardestArea,
      flyingEnvironment: _flyingEnvironment,
      aircraftType: _aircraftType,
      dailyTime: _dailyTime,
      level: ProficiencyLevel.beginner,
      totalXp: 0,
      streakDays: 0,
      categoryProgress: {},
    );
    await ref.read(userProfileProvider.notifier).saveProfile(profile);
    if (mounted) context.go('/assessment-intro');
  }

  static const _steps = [
    (emoji: '🧑‍✈️', title: 'Kim olduğun', sub: 'Temel kimlik bilgilerin'),
    (emoji: '🌍', title: 'Nerede olduğun', sub: 'Mevcut dil durumun'),
    (emoji: '🎯', title: 'Ne istediğin', sub: 'Hedef ve motivasyon'),
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
                      // Logo mark
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

                  const SizedBox(height: 24),

                  // ── Step title ────────────────────────────────────
                  Text(
                    '${step.emoji}  ${step.title}',
                    style: AppTextStyles.heading2,
                  ),
                  const SizedBox(height: 4),
                  Text(step.sub, style: AppTextStyles.caption),

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
      case 0:
        return _StepContent(
          questions: [
            _QuestionData(
              label: 'Mevcut Lisans Seviyeni',
              hint: 'ICAO gereksinimleri lisansa göre değişir',
              options: const [
                ('ppl_student', 'PPL Öğrencisi'),
                ('cpl_student', 'CPL Öğrencisi'),
                ('ppl_holder', 'PPL Sahibi (CPL hazırlığı)'),
              ],
              selected: _licenseLevel,
              onSelect: (v) => setState(() => _licenseLevel = v),
            ),
            _QuestionData(
              label: 'Toplam Uçuş Saati',
              hint: 'Terim aşinalığı ve kelime zorluğu buna göre ayarlanır',
              options: const [
                ('0_50', '0 – 50 saat'),
                ('50_200', '50 – 200 saat'),
                ('200_plus', '200+ saat'),
              ],
              selected: _flightHours,
              onSelect: (v) => setState(() => _flightHours = v),
            ),
            _QuestionData(
              label: 'Ana Dilin',
              hint: 'Hata kalıpları ana dile göre değişir',
              options: const [
                ('turkish', '🇹🇷  Türkçe'),
                ('arabic', '🇸🇦  Arapça'),
                ('other', '🌐  Diğer'),
              ],
              selected: _nativeLanguage,
              onSelect: (v) => setState(() => _nativeLanguage = v),
            ),
          ],
        );
      case 1:
        return _StepContent(
          questions: [
            _QuestionData(
              label: 'Genel İngilizce Seviyeni',
              hint: 'ICAO skoru genel seviyeden bağımsız değil',
              options: const [
                ('a2', 'A2  Temel'),
                ('b1', 'B1  Orta öncesi'),
                ('b2', 'B2  Orta'),
                ('c1', 'C1  İleri'),
              ],
              selected: _englishLevel,
              onSelect: (v) => setState(() => _englishLevel = v),
            ),
            _QuestionData(
              label: 'ICAO Dil Seviyesi',
              hint: 'Daha önce resmi ICAO testi yaptırdın mı?',
              options: const [
                ('none', 'Test olmadım'),
                ('level_3', 'Level 3'),
                ('level_4', 'Level 4'),
                ('level_5', 'Level 5+'),
              ],
              selected: _icaoLevel,
              onSelect: (v) => setState(() => _icaoLevel = v),
            ),
            _QuestionData(
              label: 'Test Tarihin Var mı?',
              hint: 'İçerik yoğunluğu ve önceliklendirme buna göre şekillenir',
              options: const [
                ('not_planned', 'Planlamadım'),
                ('6_months_plus', '6 ay+ var'),
                ('6_months', '6 ay içinde'),
                ('1_month', '1 ay içinde'),
              ],
              selected: _examTimeline,
              onSelect: (v) => setState(() => _examTimeline = v),
            ),
          ],
        );
      case 2:
        return _StepContent(
          questions: [
            _QuestionData(
              label: 'En Zor Bulduğun Alan',
              hint: 'İlk ders planı buna göre şekillenir',
              options: const [
                ('phraseology', '📻  Phraseology'),
                ('vocabulary', '📚  Kelime dağarcığı'),
                ('listening', '🎧  Dinleme / Anlama'),
                ('pronunciation', '🗣️  Telaffuz'),
              ],
              selected: _hardestArea,
              onSelect: (v) => setState(() => _hardestArea = v),
            ),
            _QuestionData(
              label: 'Uçuş / Simülatör Ortamın',
              hint: 'Yurt içi ağırlıklıysa non-standard phraseology maruziyetin yüksek',
              options: const [
                ('domestic', '🏠  Yurt İçi'),
                ('international', '🌍  Uluslararası'),
                ('both', '↔️  Her İkisi'),
              ],
              selected: _flyingEnvironment,
              onSelect: (v) => setState(() => _flyingEnvironment = v),
            ),
            _QuestionData(
              label: 'Uçak Tipi / Kategorisi',
              hint: 'Kelime setleri uçak tipine göre farklılaşır',
              options: const [
                ('sep', '🛩️  SEP (Single-engine)'),
                ('multi', '✈️  Multi-engine'),
                ('jet', '🚀  Jet (Type rating)'),
              ],
              selected: _aircraftType,
              onSelect: (v) => setState(() => _aircraftType = v),
            ),
            _QuestionData(
              label: 'Günlük Ayırabildiğin Süre',
              hint: 'Session uzunluğu ve tekrar aralıkları buna göre optimize edilir',
              options: const [
                ('5_10', '⚡ 5 – 10 dk'),
                ('15_20', '🔥 15 – 20 dk'),
                ('30_plus', '🏆 30+ dk'),
              ],
              selected: _dailyTime,
              onSelect: (v) => setState(() => _dailyTime = v),
            ),
          ],
        );
      default:
        return const SizedBox();
    }
  }
}

// ── Step content ──────────────────────────────────────────────────────────────

class _QuestionData {
  final String label;
  final String? hint;
  final List<(String, String)> options;
  final String selected;
  final ValueChanged<String> onSelect;

  const _QuestionData({
    required this.label,
    this.hint,
    required this.options,
    required this.selected,
    required this.onSelect,
  });
}

class _StepContent extends StatelessWidget {
  final List<_QuestionData> questions;
  const _StepContent({required this.questions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < questions.length; i++) ...[
          if (i > 0) const SizedBox(height: 22),
          _QuestionWidget(data: questions[i]),
        ],
        const SizedBox(height: 8),
      ],
    );
  }
}

class _QuestionWidget extends StatelessWidget {
  final _QuestionData data;
  const _QuestionWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(data.label, style: AppTextStyles.bodyBold),
        if (data.hint != null) ...[
          const SizedBox(height: 3),
          Text(
            data.hint!,
            style: const TextStyle(fontSize: 12, color: AppColors.textHint),
          ),
        ],
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: data.options.map((o) {
            final isSelected = o.$1 == data.selected;
            return GestureDetector(
              onTap: () => data.onSelect(o.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isSelected ? AppColors.primary : AppColors.divider,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Text(
                  o.$2,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
