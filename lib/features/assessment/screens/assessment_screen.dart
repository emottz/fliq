import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/question_model.dart';
import '../../../data/models/user_profile_model.dart';
import '../../../shared/providers/app_providers.dart';

class AssessmentScreen extends ConsumerStatefulWidget {
  const AssessmentScreen({super.key});

  @override
  ConsumerState<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends ConsumerState<AssessmentScreen> {
  List<QuestionModel>? _questions;
  int _current = 0;
  final Map<int, int> _answers = {};
  int? _selected;
  bool _loading = true;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(questionRepositoryProvider);
    final questions = await repo.getAssessmentQuestions();
    if (mounted) setState(() { _questions = questions; _loading = false; });
  }

  void _select(int index) {
    if (_answered) return;
    setState(() { _selected = index; _answered = true; });
    _answers[_current] = index;

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      if (_current < (_questions?.length ?? 1) - 1) {
        setState(() { _current++; _selected = null; _answered = false; });
      } else {
        _finish();
      }
    });
  }

  Future<void> _finish() async {
    final questions = _questions!;
    int correct = 0;

    // Per-category tracking
    final Map<String, Map<String, int>> categoryResults = {};
    for (final cat in QuestionCategory.values) {
      categoryResults[cat.id] = {'correct': 0, 'total': 0};
    }

    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      final catData = categoryResults[q.category.id]!;
      catData['total'] = catData['total']! + 1;
      if (_answers[i] == q.correctIndex) {
        correct++;
        catData['correct'] = catData['correct']! + 1;
      }
    }

    ProficiencyLevel level;
    if (correct <= 5) {
      level = ProficiencyLevel.beginner;
    } else if (correct <= 9) {
      level = ProficiencyLevel.elementary;
    } else if (correct <= 12) {
      level = ProficiencyLevel.intermediate;
    } else {
      level = ProficiencyLevel.advanced;
    }

    final weakCategories = categoryResults.entries
        .where((e) {
          final total = e.value['total'] ?? 0;
          final correct = e.value['correct'] ?? 0;
          return total > 0 && correct / total < 0.6;
        })
        .map((e) => e.key)
        .toList();

    final profile = await ref.read(userRepositoryProvider).getProfile();
    if (profile != null) {
      await ref.read(userProfileProvider.notifier).saveLevel(
        profile.copyWith(level: level, weakCategories: weakCategories),
      );
    }

    if (mounted) {
      context.go('/assessment-analysis', extra: {
        'categoryResults': categoryResults,
        'level': level.name,
        'totalCorrect': correct,
        'totalQuestions': questions.length,
        'role': profile?.role ?? 'student',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _questions == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    final question = _questions![_current];
    final total = _questions!.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Seviye Tespiti', style: AppTextStyles.heading3),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: (_current + 1) / total,
                  minHeight: 6,
                  backgroundColor: AppColors.surfaceVariant,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  borderRadius: BorderRadius.circular(3),
                ),
                const SizedBox(height: 8),
                Text('${_current + 1} / $total', style: AppTextStyles.caption),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Text(question.questionText, style: AppTextStyles.body),
                ),
                const SizedBox(height: 20),
                ...List.generate(question.options.length, (i) {
                  Color? bg;
                  Color? border;
                  if (_answered) {
                    if (i == question.correctIndex) {
                      bg = AppColors.successLight;
                      border = AppColors.success;
                    } else if (i == _selected && i != question.correctIndex) {
                      bg = AppColors.errorLight;
                      border = AppColors.error;
                    }
                  }

                  return GestureDetector(
                    onTap: () => _select(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      decoration: BoxDecoration(
                        color: bg ?? AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: border ?? (_selected == i ? AppColors.primary : AppColors.divider),
                          width: _selected == i || border != null ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _selected == i ? AppColors.primary : AppColors.surfaceVariant,
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + i),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: _selected == i ? Colors.white : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(question.options[i], style: AppTextStyles.body)),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

