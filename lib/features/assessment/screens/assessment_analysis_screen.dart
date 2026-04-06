import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/ai_analysis_result.dart';
import '../../../core/services/ai_analysis_service.dart';
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
    'Reading your 15 answers...',
    'Mapping category performance...',
    'Identifying technical gaps...',
    'Building your personal profile...',
    'Generating recommendations...',
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
        ProficiencyLevel.beginner => 'Beginner',
        ProficiencyLevel.elementary => 'Elementary',
        ProficiencyLevel.intermediate => 'Intermediate',
        ProficiencyLevel.advanced => 'Advanced',
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
        'atc' => 'Air Traffic Controller',
        'cabin_crew' => 'Cabin Crew',
        _ => 'Aviation Student',
      };

  IconData _categoryIcon(QuestionCategory cat) => switch (cat) {
        QuestionCategory.grammar => Icons.spellcheck_outlined,
        QuestionCategory.vocabulary => Icons.menu_book_outlined,
        QuestionCategory.translation => Icons.translate_outlined,
        QuestionCategory.reading => Icons.article_outlined,
        QuestionCategory.fillBlanks => Icons.edit_outlined,
        QuestionCategory.sentenceCompletion => Icons.short_text_outlined,
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
            'AI Analysis in Progress',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Analyzing your responses to build a\npersonalized aviation English profile.',
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
                      'Personalized AI Analysis',
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
                          '${widget.totalCorrect} / ${widget.totalQuestions} correct  •  '
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
                      Text('AI Summary', style: AppTextStyles.bodyBold),
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
            const Text('Skill Breakdown', style: AppTextStyles.heading3),
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
              const Text('Technical Focus Areas', style: AppTextStyles.heading3),
              const SizedBox(height: 6),
              const Text(
                'AI-identified gaps based on your answers and role.',
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: 14),
              ...result.focusAreas.map((area) => _FocusAreaCard(area: area)),
            ],

            // Study Tips
            if (result.studyTips.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text('Your Action Plan', style: AppTextStyles.heading3),
              const SizedBox(height: 14),
              ...result.studyTips.asMap().entries.map((e) => _TipCard(
                    number: e.key + 1,
                    text: e.value,
                  )),
            ],

            // ── Membership Plans ──────────────────────────────────────────
            const SizedBox(height: 32),
            _MembershipSection(),

            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => context.go('/home/exams'),
                child: const Text(
                  'Continue with free access',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
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
              isHigh ? 'HIGH' : 'MED',
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

// ── Membership section ────────────────────────────────────────────────────────

class _MembershipSection extends StatefulWidget {
  @override
  State<_MembershipSection> createState() => _MembershipSectionState();
}

class _MembershipSectionState extends State<_MembershipSection> {
  bool _annual = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              const Text(
                'Unlock Your Full Study Plan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'Practice with 1,895 questions tailored to your analysis.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            children: [
              // Toggle
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _PlanToggle(
                      label: 'Monthly',
                      selected: !_annual,
                      onTap: () => setState(() => _annual = false),
                    ),
                    _PlanToggle(
                      label: 'Annual  🔥 Save 50%',
                      selected: _annual,
                      onTap: () => setState(() => _annual = true),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Price
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _annual
                    ? _PriceDisplay(
                        key: const ValueKey('annual'),
                        price: '\$4.99',
                        period: '/month',
                        note: 'Billed \$59.99/year',
                        badge: 'Best Value',
                      )
                    : _PriceDisplay(
                        key: const ValueKey('monthly'),
                        price: '\$9.99',
                        period: '/month',
                        note: 'Billed monthly, cancel anytime',
                      ),
              ),

              const SizedBox(height: 20),

              // Features
              const _FeatureList(),

              const SizedBox(height: 20),

              PrimaryButton(
                label: 'Start Free 7-Day Trial',
                onPressed: () => context.go('/home/exams'),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'No credit card required • Cancel anytime',
                  style: AppTextStyles.caption,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlanToggle extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PlanToggle({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: selected
                ? [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4, offset: const Offset(0, 1))]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _PriceDisplay extends StatelessWidget {
  final String price;
  final String period;
  final String note;
  final String? badge;

  const _PriceDisplay({
    super.key,
    required this.price,
    required this.period,
    required this.note,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              price,
              style: const TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                height: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 6, left: 4),
              child: Text(
                period,
                style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        if (badge != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              badge!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF15803D),
              ),
            ),
          ),
        const SizedBox(height: 4),
        Text(note, style: AppTextStyles.caption),
      ],
    );
  }
}

class _FeatureList extends StatelessWidget {
  const _FeatureList();

  static const _features = [
    'All 1,895 questions unlocked',
    'Your personalized study path',
    'Detailed analytics & weak area tracking',
    'AI-powered coaching after each exam',
    'Offline access on all devices',
    'Rank system & progress certificates',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _features
          .map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.success, size: 17),
                  const SizedBox(width: 10),
                  Text(f, style: AppTextStyles.body),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
