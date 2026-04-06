import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/ai_analysis_result.dart';
import '../../../core/services/ai_analysis_service.dart';
import '../../../data/models/question_model.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/primary_button.dart';

class ExamResultScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> result;
  const ExamResultScreen({super.key, required this.result});

  @override
  ConsumerState<ExamResultScreen> createState() => _ExamResultScreenState();
}

class _ExamResultScreenState extends ConsumerState<ExamResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressCtrl;
  AiAnalysisResult? _aiResult;
  bool _aiLoading = true;

  late int correct;
  late int total;
  late int xpEarned;
  late int percentage;
  late List<QuestionModel> questions;
  late Map<int, int> answers;
  late Map<String, Map<String, int>> categoryResults;

  @override
  void initState() {
    super.initState();
    _progressCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    correct = widget.result['correct'] as int? ?? 0;
    total = widget.result['total'] as int? ?? 1;
    xpEarned = widget.result['xpEarned'] as int? ?? 0;
    percentage = (correct / total * 100).round();

    final rawQ = widget.result['questions'] as List? ?? [];
    final rawA = widget.result['answers'] as Map? ?? {};
    questions = rawQ
        .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
        .toList();
    answers = rawA.map((k, v) => MapEntry(int.parse(k.toString()), v as int));

    // Build per-category breakdown
    categoryResults = {};
    for (final cat in QuestionCategory.values) {
      categoryResults[cat.id] = {'correct': 0, 'total': 0};
    }
    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      final d = categoryResults[q.category.id]!;
      d['total'] = d['total']! + 1;
      if (answers[i] == q.correctIndex) d['correct'] = d['correct']! + 1;
    }

    _runAI();
  }

  Future<void> _runAI() async {
    final profile = await ref.read(userRepositoryProvider).getProfile();
    final role = profile?.role ?? 'student';
    final level = profile?.level.name ?? 'elementary';

    final result = await AiAnalysisService().analyze(
      role: role,
      level: level,
      totalCorrect: correct,
      totalQuestions: total,
      categoryResults: categoryResults,
    );

    if (mounted) {
      setState(() {
        _aiResult = result;
        _aiLoading = false;
      });
      _progressCtrl.forward();
    }
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    super.dispose();
  }

  Color get _scoreColor {
    if (percentage >= 80) return AppColors.success;
    if (percentage >= 60) return AppColors.primary;
    return AppColors.warning;
  }

  String get _scoreEmoji {
    if (percentage >= 80) return '🏆';
    if (percentage >= 60) return '✈️';
    return '📚';
  }

  IconData _categoryIcon(QuestionCategory cat) => switch (cat) {
        QuestionCategory.grammar => Icons.spellcheck_outlined,
        QuestionCategory.vocabulary => Icons.menu_book_outlined,
        QuestionCategory.translation => Icons.translate_outlined,
        QuestionCategory.reading => Icons.article_outlined,
        QuestionCategory.fillBlanks => Icons.edit_outlined,
        QuestionCategory.sentenceCompletion => Icons.short_text_outlined,
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Exam Results', style: AppTextStyles.heading3),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Score header ──────────────────────────────────
                      Center(
                        child: Column(
                          children: [
                            Text(_scoreEmoji,
                                style: const TextStyle(fontSize: 60)),
                            const SizedBox(height: 8),
                            Text(
                              '$percentage%',
                              style: TextStyle(
                                fontSize: 52,
                                fontWeight: FontWeight.w800,
                                color: _scoreColor,
                              ),
                            ),
                            Text('$correct / $total correct',
                                style: AppTextStyles.body),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.bolt,
                                      color: AppColors.xpOrange, size: 22),
                                  const SizedBox(width: 6),
                                  Text(
                                    '+$xpEarned XP Earned',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.xpOrange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Category breakdown ────────────────────────────
                      const Text('Skill Breakdown', style: AppTextStyles.heading3),
                      const SizedBox(height: 12),
                      ...QuestionCategory.values.where((cat) {
                        final t = categoryResults[cat.id]?['total'] ?? 0;
                        return t > 0;
                      }).map((cat) {
                        final d = categoryResults[cat.id]!;
                        final c = d['correct']!;
                        final t = d['total']!;
                        final ratio = c / t;
                        final color = ratio >= 0.8
                            ? AppColors.success
                            : ratio >= 0.5
                                ? AppColors.primary
                                : AppColors.error;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: Icon(_categoryIcon(cat),
                                    color: AppColors.primary, size: 16),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(cat.displayName,
                                            style: AppTextStyles.body),
                                        Text(
                                          '$c/$t',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: color,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: AnimatedBuilder(
                                        animation: _progressCtrl,
                                        builder: (_, __) =>
                                            LinearProgressIndicator(
                                          value: ratio * _progressCtrl.value,
                                          minHeight: 7,
                                          backgroundColor:
                                              AppColors.surfaceVariant,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  color),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 24),

                      // ── AI Analysis ───────────────────────────────────
                      Row(
                        children: [
                          const Icon(Icons.auto_awesome,
                              color: Color(0xFF7C3AED), size: 16),
                          const SizedBox(width: 8),
                          const Text('AI Analysis', style: AppTextStyles.heading3),
                          const Spacer(),
                          if (_aiLoading)
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF7C3AED),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      if (_aiLoading)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F3FF),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: const Color(0xFFDDD6FE)),
                          ),
                          child: const Row(
                            children: [
                              SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF7C3AED),
                                ),
                              ),
                              SizedBox(width: 14),
                              Text(
                                'Analyzing your answers...',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF7C3AED),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      else ...[
                        // Summary
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: Text(
                            _aiResult!.summary,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                              height: 1.6,
                            ),
                          ),
                        ),

                        // Focus areas
                        if (_aiResult!.focusAreas.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Text('Technical Focus Areas',
                              style: AppTextStyles.bodyBold),
                          const SizedBox(height: 10),
                          ..._aiResult!.focusAreas.map((area) {
                            final isHigh = area.isHigh;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isHigh
                                    ? const Color(0xFFFFF7ED)
                                    : AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isHigh
                                      ? const Color(0xFFFED7AA)
                                      : AppColors.divider,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isHigh
                                          ? const Color(0xFFEA580C)
                                          : AppColors.primary,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      isHigh ? 'HIGH' : 'MED',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          area.title,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: isHigh
                                                ? const Color(0xFF9A3412)
                                                : AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          area.description,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isHigh
                                                ? const Color(0xFF7C2D12)
                                                : AppColors.textSecondary,
                                            height: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],

                        // Study tips
                        if (_aiResult!.studyTips.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Text('Action Plan', style: AppTextStyles.bodyBold),
                          const SizedBox(height: 10),
                          ..._aiResult!.studyTips.asMap().entries.map((e) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(13),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(11),
                                border: Border.all(color: AppColors.divider),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${e.key + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      e.value,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textPrimary,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ],

                      const SizedBox(height: 24),

                      // ── Answer Review ────────────────────────────────
                      const Text('Answer Review', style: AppTextStyles.heading3),
                      const SizedBox(height: 12),
                      ...List.generate(questions.length, (i) {
                        final q = questions[i];
                        final userAnswer = answers[i];
                        final isCorrect = userAnswer == q.correctIndex;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(13),
                          decoration: BoxDecoration(
                            color: isCorrect
                                ? AppColors.successLight
                                : AppColors.errorLight,
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(
                              color: isCorrect
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    isCorrect
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: isCorrect
                                        ? AppColors.success
                                        : AppColors.error,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 7),
                                  Expanded(
                                    child: Text(
                                      'Q${i + 1}: ${q.questionText}',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              if (!isCorrect && userAnswer != null) ...[
                                const SizedBox(height: 5),
                                Text(
                                  'Your answer: ${q.options[userAnswer]}',
                                  style: const TextStyle(
                                      fontSize: 12, color: AppColors.error),
                                ),
                              ],
                              const SizedBox(height: 3),
                              Text(
                                'Correct: ${q.options[q.correctIndex]}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              // ── Bottom CTA ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: PrimaryButton(
                  label: 'Back to Home',
                  onPressed: () => context.go('/home/exams'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
