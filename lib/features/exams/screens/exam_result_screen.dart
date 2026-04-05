import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/question_model.dart';
import '../../../shared/widgets/primary_button.dart';

class ExamResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;
  const ExamResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final correct = result['correct'] as int? ?? 0;
    final total = result['total'] as int? ?? 1;
    final xpEarned = result['xpEarned'] as int? ?? 0;
    final percentage = (correct / total * 100).round();

    final rawQuestions = result['questions'] as List? ?? [];
    final rawAnswers = result['answers'] as Map? ?? {};
    final questions = rawQuestions
        .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final answers = rawAnswers.map((k, v) => MapEntry(int.parse(k.toString()), v as int));

    Color scoreColor;
    String scoreEmoji;
    if (percentage >= 80) {
      scoreColor = AppColors.success;
      scoreEmoji = '🏆';
    } else if (percentage >= 60) {
      scoreColor = AppColors.primary;
      scoreEmoji = '✈️';
    } else {
      scoreColor = AppColors.warning;
      scoreEmoji = '📚';
    }

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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Text(scoreEmoji, style: const TextStyle(fontSize: 64)),
                      const SizedBox(height: 12),
                      Text(
                        '$percentage%',
                        style: TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.w800,
                          color: scoreColor,
                        ),
                      ),
                      Text('$correct / $total correct', style: AppTextStyles.body),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.bolt, color: AppColors.xpOrange, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              '+$xpEarned XP Earned',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.xpOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Answer Review', style: AppTextStyles.heading3),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(questions.length, (i) {
                        final q = questions[i];
                        final userAnswer = answers[i];
                        final isCorrect = userAnswer == q.correctIndex;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isCorrect ? AppColors.successLight : AppColors.errorLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isCorrect ? AppColors.success : AppColors.error,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    isCorrect ? Icons.check_circle : Icons.cancel,
                                    color: isCorrect ? AppColors.success : AppColors.error,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Q${i + 1}: ${q.questionText}',
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              if (!isCorrect && userAnswer != null) ...[
                                const SizedBox(height: 6),
                                Text(
                                  'Your answer: ${q.options[userAnswer]}',
                                  style: const TextStyle(fontSize: 12, color: AppColors.error),
                                ),
                              ],
                              const SizedBox(height: 4),
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
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: PrimaryButton(
                  label: 'Continue',
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
