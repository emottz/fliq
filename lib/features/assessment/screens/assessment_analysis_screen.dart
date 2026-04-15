import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/ai_analysis_result.dart';
import '../../../core/services/ai_analysis_service.dart';
import '../../../data/lessons/lesson_content_data.dart';
import '../../../data/models/question_model.dart';
import '../../../data/models/user_profile_model.dart';
import '../../../shared/widgets/primary_button.dart';

class AssessmentAnalysisScreen extends StatefulWidget {
  final Map<String, Map<String, int>> categoryResults;
  final ProficiencyLevel level;
  final int totalCorrect;
  final int totalQuestions;
  final String role;

  const AssessmentAnalysisScreen({
    super.key,
    required this.categoryResults,
    required this.level,
    required this.totalCorrect,
    required this.totalQuestions,
    required this.role,
  });

  @override
  State<AssessmentAnalysisScreen> createState() => _AssessmentAnalysisScreenState();
}

class _AssessmentAnalysisScreenState extends State<AssessmentAnalysisScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressCtrl;
  late AnimationController _fadeCtrl;
  late AnimationController _pulseCtrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _pulseAnim;

  AiAnalysisResult? _result;
  int _loadingStep = 0;
  bool _done = false;

  static const _loadingSteps = [
    '25 cevabın okunuyor...',
    'Kategori performansı haritalanıyor...',
    'Teknik eksiklikler tespit ediliyor...',
    'Kişisel profil oluşturuluyor...',
    'Öneriler hazırlanıyor...',
  ];

  @override
  void initState() {
    super.initState();

    _progressCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);

    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _runAnalysis();
  }

  Future<void> _runAnalysis() async {
    // Animate loading steps while the API call runs in parallel
    final apiCall = AiAnalysisService().analyze(
      role: widget.role,
      level: widget.level.name,
      totalCorrect: widget.totalCorrect,
      totalQuestions: widget.totalQuestions,
      categoryResults: widget.categoryResults,
    );

    for (int i = 0; i < _loadingSteps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 650));
      if (mounted) setState(() => _loadingStep = i);
    }

    // Wait for API result (already running in background)
    final result = await apiCall;

    if (mounted) {
      setState(() {
        _result = result;
        _done = true;
      });
      _pulseCtrl.stop();
      _fadeCtrl.forward();
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) _progressCtrl.forward();
      });
    }
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    _fadeCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String get _levelLabel => switch (widget.level) {
        ProficiencyLevel.beginner => 'Başlangıç',
        ProficiencyLevel.elementary => 'Temel',
        ProficiencyLevel.intermediate => 'Orta',
        ProficiencyLevel.advanced => 'İleri',
      };

  String get _levelEmoji => switch (widget.level) {
        ProficiencyLevel.beginner => '🌱',
        ProficiencyLevel.elementary => '✈️',
        ProficiencyLevel.intermediate => '🛫',
        ProficiencyLevel.advanced => '🏆',
      };

  Color get _levelColor => switch (widget.level) {
        ProficiencyLevel.beginner => const Color(0xFF10B981),
        ProficiencyLevel.elementary => const Color(0xFF3B82F6),
        ProficiencyLevel.intermediate => const Color(0xFF8B5CF6),
        ProficiencyLevel.advanced => const Color(0xFFF59E0B),
      };

  String get _roleLabel => switch (widget.role) {
        'pilot' => 'Pilot',
        'atc' => 'Hava Trafik Kontrolörü',
        'cabin_crew' => 'Kabin Ekibi',
        'amt' => 'Uçak Bakım Teknisyeni',
        _ => 'Havacılık Öğrencisi',
      };

  // ── Lesson recommendation map ─────────────────────────────────────────────
  // Each entry: (lessonId, minLevelIndex)  0=beginner 1=elementary 2=intermediate 3=advanced
  static const _lessonsByCategory = {
    'grammar': [
      ('grammar_1', 0), ('grammar_2', 0), ('grammar_5', 0),
      ('grammar_3', 1), ('grammar_4', 2), ('grammar_6', 2), ('grammar_7', 3),
    ],
    'vocabulary': [
      ('vocab_1', 0), ('vocab_3', 0), ('vocab_4', 0),
      ('vocab_2', 1), ('vocab_5', 1),
      ('vocab_6', 2), ('vocab_7', 3),
    ],
    'translation': [
      ('translation_1', 1), ('translation_2', 1),
      ('translation_3', 2), ('translation_4', 3),
    ],
    'reading': [
      ('reading_3', 1),
      ('reading_1', 2), ('reading_4', 2),
      ('reading_2', 3), ('reading_5', 3), ('reading_6', 3),
    ],
    'fill_blanks': [
      ('fill_1', 0), ('fill_2', 0),
      ('fill_3', 1), ('fill_4', 2), ('fill_5', 3),
    ],
    'sentence_completion': [
      ('completion_1', 2), ('completion_3', 3), ('completion_2', 3),
    ],
  };

  Widget _buildRecommendedLessons() {
    final userLevelIdx = widget.level.index;
    final recs = <({String id, String catLabel, double score})>[];

    for (final cat in QuestionCategory.values) {
      final data = widget.categoryResults[cat.id];
      final correct = data?['correct'] ?? 0;
      final total = data?['total'] ?? 0;
      if (total == 0) continue;
      final ratio = correct / total;
      if (ratio >= 0.6) continue; // no recommendation needed

      final allLessons = _lessonsByCategory[cat.id] ?? [];
      // pick up to 2 lessons at or below user level, highest level first
      final suitable = allLessons
          .where((l) => l.$2 <= userLevelIdx)
          .toList()
          .reversed
          .take(2)
          .toList();

      for (final l in suitable) {
        recs.add((id: l.$1, catLabel: cat.displayName, score: ratio));
      }
    }

    if (recs.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Row(
          children: const [
            Icon(Icons.school_outlined, color: AppColors.primary, size: 16),
            SizedBox(width: 8),
            Text('Senin İçin Hazırlanan Dersler', style: AppTextStyles.heading3),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Eksik kaldığın konular baz alınarak bu dersler eklendi.',
          style: AppTextStyles.caption,
        ),
        const SizedBox(height: 12),
        ...recs.take(5).map((r) {
          final lesson = LessonContentData.findById(r.id);
          if (lesson == null) return const SizedBox.shrink();
          return _RecommendedLessonCard(
            emoji: lesson.emoji,
            title: lesson.title,
            categoryLabel: r.catLabel,
            score: r.score,
          );
        }),
      ],
    );
  }

  IconData _categoryIcon(QuestionCategory cat) => switch (cat) {
        QuestionCategory.grammar => Icons.spellcheck_outlined,
        QuestionCategory.vocabulary => Icons.menu_book_outlined,
        QuestionCategory.translation => Icons.translate_outlined,
        QuestionCategory.reading => Icons.article_outlined,
        QuestionCategory.fillBlanks => Icons.edit_outlined,
        QuestionCategory.sentenceCompletion => Icons.short_text_outlined,
        QuestionCategory.aviationTerms => Icons.flight_outlined,
      };

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: _done ? _buildResults() : _buildLoading(),
          ),
        ),
      ),
    );
  }

  // ── Loading state ─────────────────────────────────────────────────────────

  Widget _buildLoading() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _pulseAnim,
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7C3AED).withOpacity(0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 40),
            ),
          ),
          const SizedBox(height: 36),
          const Text(
            'AI Analizi Devam Ediyor',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Kişisel havacılık İngilizcesi profilin\noluşturuluyor.',
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          // Step list
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(_loadingSteps.length, (i) {
              final isDone = i < _loadingStep;
              final isActive = i == _loadingStep;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: isDone
                          ? const Icon(Icons.check_circle, color: AppColors.success, size: 22)
                          : isActive
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: AppColors.primary,
                                  ),
                                )
                              : Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.divider, width: 2),
                                  ),
                                ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      _loadingSteps[i],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isDone
                            ? AppColors.textSecondary
                            : isActive
                                ? AppColors.textPrimary
                                : AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ── Results state ─────────────────────────────────────────────────────────

  Widget _buildResults() {
    final result = _result!;
    return FadeTransition(
      opacity: _fadeAnim,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI badge
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, color: Color(0xFF7C3AED), size: 13),
                    SizedBox(width: 6),
                    Text(
                      'Kişiselleştirilmiş AI Analizi',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7C3AED),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Level card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_levelColor, _levelColor.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(_levelEmoji, style: const TextStyle(fontSize: 44)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _roleLabel,
                          style: const TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _levelLabel,
                          style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.totalCorrect} / ${widget.totalQuestions} doğru  •  '
                          '${(widget.totalCorrect / widget.totalQuestions * 100).round()}%',
                          style: const TextStyle(fontSize: 13, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // AI Summary
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.psychology_outlined, color: AppColors.primary, size: 17),
                      SizedBox(width: 8),
                      Text('AI Özeti', style: AppTextStyles.bodyBold),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    result.summary,
                    style: const TextStyle(
                      fontSize: 14, color: AppColors.textPrimary, height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Category breakdown
            const Text('Beceri Dağılımı', style: AppTextStyles.heading3),
            const SizedBox(height: 14),
            ...QuestionCategory.values.map((cat) {
              final data = widget.categoryResults[cat.id];
              final correct = data?['correct'] ?? 0;
              final total = data?['total'] ?? 0;
              final ratio = total > 0 ? correct / total : 0.0;
              return _CategoryBar(
                icon: _categoryIcon(cat),
                label: cat.displayName,
                correct: correct,
                total: total,
                ratio: ratio,
                progressAnim: _progressCtrl,
              );
            }),

            // Focus Areas
            if (result.focusAreas.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text('Teknik Odak Alanları', style: AppTextStyles.heading3),
              const SizedBox(height: 6),
              const Text(
                'AI, cevaplarına ve rolüne göre eksikleri belirledi.',
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: 14),
              ...result.focusAreas.map((area) => _FocusAreaCard(area: area)),
            ],

            // Recommended Lessons
            _buildRecommendedLessons(),

            // Study Tips
            if (result.studyTips.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text('Çalışma Planın', style: AppTextStyles.heading3),
              const SizedBox(height: 14),
              ...result.studyTips.asMap().entries.map((e) => _TipCard(
                    number: e.key + 1,
                    text: e.value,
                  )),
            ],

            const SizedBox(height: 32),
            PrimaryButton(
              label: 'Hemen Başla  →',
              onPressed: () => context.go('/home/exams'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ── Recommended lesson card ───────────────────────────────────────────────────

class _RecommendedLessonCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String categoryLabel;
  final double score;

  const _RecommendedLessonCard({
    required this.emoji,
    required this.title,
    required this.categoryLabel,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (score * 100).round();
    final isLow = score < 0.4;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyBold),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: isLow ? const Color(0xFFFFF7ED) : const Color(0xFFFEF9C3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '$categoryLabel • %$pct',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isLow ? const Color(0xFFEA580C) : const Color(0xFF92400E),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Flexible(
                      child: Text(
                        'Bu konuda eksik kaldın',
                        style: TextStyle(fontSize: 11, color: AppColors.textHint),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: AppColors.textHint),
        ],
      ),
    );
  }
}

// ── Category bar ──────────────────────────────────────────────────────────────

class _CategoryBar extends StatelessWidget {
  final IconData icon;
  final String label;
  final int correct;
  final int total;
  final double ratio;
  final AnimationController progressAnim;

  const _CategoryBar({
    required this.icon,
    required this.label,
    required this.correct,
    required this.total,
    required this.ratio,
    required this.progressAnim,
  });

  Color get _color {
    if (ratio >= 0.8) return AppColors.success;
    if (ratio >= 0.5) return AppColors.primary;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label, style: AppTextStyles.body),
                    Text(
                      total > 0 ? '$correct/$total' : '—',
                      style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600, color: _color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: AnimatedBuilder(
                    animation: progressAnim,
                    builder: (_, __) => LinearProgressIndicator(
                      value: ratio * progressAnim.value,
                      minHeight: 8,
                      backgroundColor: AppColors.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(_color),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Focus area card ───────────────────────────────────────────────────────────

class _FocusAreaCard extends StatelessWidget {
  final AiFocusArea area;
  const _FocusAreaCard({required this.area});

  @override
  Widget build(BuildContext context) {
    final isHigh = area.isHigh;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHigh ? const Color(0xFFFFF7ED) : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isHigh ? const Color(0xFFFED7AA) : AppColors.divider,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isHigh ? const Color(0xFFEA580C) : AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isHigh ? 'YÜKSEK' : 'ORTA',
              style: const TextStyle(
                color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  area.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isHigh ? const Color(0xFF9A3412) : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  area.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: isHigh ? const Color(0xFF7C2D12) : AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tip card ──────────────────────────────────────────────────────────────────

class _TipCard extends StatelessWidget {
  final int number;
  final String text;
  const _TipCard({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13, color: AppColors.textPrimary, height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


