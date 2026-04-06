import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/question_model.dart';
import '../../../data/models/user_profile_model.dart';
import '../../../shared/widgets/primary_button.dart';

class AssessmentAnalysisScreen extends StatefulWidget {
  /// Keys: QuestionCategory.id → {'correct': int, 'total': int}
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
  late AnimationController _fadeCtrl;
  late AnimationController _progressCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _progressCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _progressCtrl.forward();
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _progressCtrl.dispose();
    super.dispose();
  }

  // ── Derived data ──────────────────────────────────────────────────────────

  List<QuestionCategory> get _weakCategories {
    return QuestionCategory.values.where((cat) {
      final data = widget.categoryResults[cat.id];
      if (data == null || data['total'] == 0) return false;
      final ratio = data['correct']! / data['total']!;
      return ratio < 0.6;
    }).toList();
  }

  List<QuestionCategory> get _strongCategories {
    return QuestionCategory.values.where((cat) {
      final data = widget.categoryResults[cat.id];
      if (data == null || data['total'] == 0) return false;
      final ratio = data['correct']! / data['total']!;
      return ratio >= 0.8;
    }).toList();
  }

  String get _levelLabel {
    switch (widget.level) {
      case ProficiencyLevel.beginner:
        return 'Beginner';
      case ProficiencyLevel.elementary:
        return 'Elementary';
      case ProficiencyLevel.intermediate:
        return 'Intermediate';
      case ProficiencyLevel.advanced:
        return 'Advanced';
    }
  }

  String get _levelEmoji {
    switch (widget.level) {
      case ProficiencyLevel.beginner:
        return '🌱';
      case ProficiencyLevel.elementary:
        return '✈️';
      case ProficiencyLevel.intermediate:
        return '🛫';
      case ProficiencyLevel.advanced:
        return '🏆';
    }
  }

  Color get _levelColor {
    switch (widget.level) {
      case ProficiencyLevel.beginner:
        return const Color(0xFF10B981);
      case ProficiencyLevel.elementary:
        return const Color(0xFF3B82F6);
      case ProficiencyLevel.intermediate:
        return const Color(0xFF8B5CF6);
      case ProficiencyLevel.advanced:
        return const Color(0xFFF59E0B);
    }
  }

  String get _roleLabel {
    switch (widget.role) {
      case 'pilot':
        return 'Pilot';
      case 'atc':
        return 'Air Traffic Controller';
      case 'cabin_crew':
        return 'Cabin Crew';
      default:
        return 'Aviation Student';
    }
  }

  // ── AI-style personalized analysis text ───────────────────────────────────

  String get _analysisHeadline {
    final weak = _weakCategories;
    if (weak.isEmpty) {
      return 'Excellent foundation! Your skills are well-rounded across all areas.';
    }
    if (weak.length == 1) {
      return 'Strong overall — one key area to sharpen before your exam.';
    }
    return 'Clear growth areas identified — a focused plan will accelerate your progress.';
  }

  String _categoryInsight(QuestionCategory cat) {
    switch (cat) {
      case QuestionCategory.grammar:
        return _grammarInsight();
      case QuestionCategory.vocabulary:
        return _vocabInsight();
      case QuestionCategory.translation:
        return _translationInsight();
      case QuestionCategory.reading:
        return _readingInsight();
      case QuestionCategory.fillBlanks:
        return _fillBlanksInsight();
      case QuestionCategory.sentenceCompletion:
        return _sentenceInsight();
    }
  }

  String _grammarInsight() {
    switch (widget.role) {
      case 'pilot':
        return 'Focus on modal verbs (shall, must, should) and conditional structures used in ATC clearances and NOTAMs.';
      case 'atc':
        return 'Tense consistency and passive voice are critical when issuing traffic information and clearances.';
      case 'cabin_crew':
        return 'Review safety announcement grammar — especially imperative and modal structures for passenger instructions.';
      default:
        return 'Strengthen your command of aviation-specific grammar: modals, conditionals, and passive constructions.';
    }
  }

  String _vocabInsight() {
    switch (widget.role) {
      case 'pilot':
        return 'Deepen your ICAO standard phraseology and weather-related terminology (METAR, TAF, SIGMET vocabulary).';
      case 'atc':
        return 'Master phraseology for holding patterns, SID/STAR procedures, and emergency communications.';
      case 'cabin_crew':
        return 'Prioritize safety equipment terminology and passenger management vocabulary per ICAO standards.';
      default:
        return 'Build your core aviation vocabulary: ATC phraseology, aircraft systems, and ICAO terminology.';
    }
  }

  String _translationInsight() {
    switch (widget.role) {
      case 'pilot':
        return 'Practice converting operational reports (PIREP, METAR) between English and your native language context.';
      case 'atc':
        return 'Work on accurately translating controller instructions and readbacks without ambiguity.';
      default:
        return 'Work on understanding aviation texts in context — focus on meaning over word-for-word translation.';
    }
  }

  String _readingInsight() {
    switch (widget.role) {
      case 'pilot':
        return 'Improve reading speed on NOTAMs, AIP supplements, and Operations Manuals under time pressure.';
      case 'atc':
        return 'Practice reading ATC strips, flight plans, and coordination messages for key operational data.';
      default:
        return 'Practice reading aviation documents — NOTAMs, METARs, SOPs — focusing on extracting key information quickly.';
    }
  }

  String _fillBlanksInsight() {
    return 'Work on understanding collocations and fixed expressions in aviation English — many answers follow standard phraseology patterns.';
  }

  String _sentenceInsight() {
    return 'Strengthen your ability to complete aviation sentences by studying common discourse structures and logical flow in ATC/pilot communication.';
  }

  List<_Recommendation> get _recommendations {
    final recs = <_Recommendation>[];
    final weak = _weakCategories;

    if (weak.isEmpty) {
      recs.add(_Recommendation(
        icon: Icons.workspace_premium_outlined,
        title: 'Maintain Your Edge',
        body: 'Take 2–3 practice exams per week to stay sharp across all categories.',
      ));
    } else {
      for (final cat in weak.take(2)) {
        recs.add(_Recommendation(
          icon: _categoryIcon(cat),
          title: 'Prioritize ${cat.displayName}',
          body: _categoryInsight(cat),
        ));
      }
    }

    recs.add(_Recommendation(
      icon: Icons.access_time_outlined,
      title: 'Daily 15-minute sessions',
      body: 'Consistent short practice beats irregular long sessions. Aim for 5 days/week minimum.',
    ));

    if (widget.role == 'pilot' || widget.role == 'atc') {
      recs.add(_Recommendation(
        icon: Icons.headset_mic_outlined,
        title: 'Practice live phraseology',
        body: 'Listen to LiveATC.net and shadow real controller–pilot exchanges to internalize standard patterns.',
      ));
    }

    return recs.take(3).toList();
  }

  IconData _categoryIcon(QuestionCategory cat) {
    switch (cat) {
      case QuestionCategory.grammar:
        return Icons.spellcheck_outlined;
      case QuestionCategory.vocabulary:
        return Icons.menu_book_outlined;
      case QuestionCategory.translation:
        return Icons.translate_outlined;
      case QuestionCategory.reading:
        return Icons.article_outlined;
      case QuestionCategory.fillBlanks:
        return Icons.edit_outlined;
      case QuestionCategory.sentenceCompletion:
        return Icons.short_text_outlined;
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
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
                            Icon(Icons.auto_awesome, color: Color(0xFF7C3AED), size: 14),
                            SizedBox(width: 6),
                            Text(
                              'AI-Powered Analysis',
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

                    const SizedBox(height: 16),
                    const Center(
                      child: Text('Your Results', style: AppTextStyles.heading1, textAlign: TextAlign.center),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        _roleLabel,
                        style: AppTextStyles.caption,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 24),

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
                          Text(_levelEmoji, style: const TextStyle(fontSize: 48)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Your ICAO Level',
                                  style: TextStyle(fontSize: 12, color: Colors.white70),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _levelLabel,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${widget.totalCorrect} / ${widget.totalQuestions} correct',
                                  style: const TextStyle(fontSize: 14, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Analysis summary
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
                              Icon(Icons.psychology_outlined, color: AppColors.primary, size: 18),
                              SizedBox(width: 8),
                              Text('Analysis Summary', style: AppTextStyles.bodyBold),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _analysisHeadline,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Category breakdown
                    const Text('Skill Breakdown', style: AppTextStyles.heading3),
                    const SizedBox(height: 4),
                    const Text('Performance across all 6 ICAO areas.', style: AppTextStyles.caption),
                    const SizedBox(height: 16),
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

                    // Strengths
                    if (_strongCategories.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      const Text('Areas of Strength', style: AppTextStyles.heading3),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _strongCategories.map((cat) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: AppColors.successLight,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.success.withOpacity(0.4)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star, color: AppColors.success, size: 14),
                                const SizedBox(width: 5),
                                Text(
                                  cat.displayName,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.success,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],

                    // Weak areas with insights
                    if (_weakCategories.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      const Text('Focus Areas', style: AppTextStyles.heading3),
                      const SizedBox(height: 12),
                      ..._weakCategories.map((cat) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7ED),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFFED7AA)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(_categoryIcon(cat),
                                      color: const Color(0xFFEA580C), size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    cat.displayName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF9A3412),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _categoryInsight(cat),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF7C2D12),
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],

                    // Recommendations
                    const SizedBox(height: 24),
                    const Text('Your Study Plan', style: AppTextStyles.heading3),
                    const SizedBox(height: 4),
                    const Text(
                      'AI-recommended actions based on your profile and results.',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 16),
                    ..._recommendations.asMap().entries.map((entry) {
                      final i = entry.key;
                      final rec = entry.value;
                      return _RecommendationCard(
                        number: i + 1,
                        icon: rec.icon,
                        title: rec.title,
                        body: rec.body,
                      );
                    }),

                    const SizedBox(height: 32),

                    // CTA
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Ready to follow your personalized plan?',
                            style: AppTextStyles.bodyBold,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Unlock full access to all lessons, exams, and AI coaching.',
                            style: AppTextStyles.caption,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          PrimaryButton(
                            label: 'See My Study Plan',
                            onPressed: () => context.go('/subscription'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: () => context.go('/home/exams'),
                        child: const Text(
                          'Skip for now',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Supporting widgets ─────────────────────────────────────────────────────

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

  Color get _barColor {
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
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _barColor,
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
                      valueColor: AlwaysStoppedAnimation<Color>(_barColor),
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

class _RecommendationCard extends StatelessWidget {
  final int number;
  final IconData icon;
  final String title;
  final String body;

  const _RecommendationCard({
    required this.number,
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyBold),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
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

class _Recommendation {
  final IconData icon;
  final String title;
  final String body;
  const _Recommendation({required this.icon, required this.title, required this.body});
}
