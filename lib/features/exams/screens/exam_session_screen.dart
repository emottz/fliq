import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/question_model.dart';
import '../../../shared/providers/app_providers.dart';

class ExamSessionScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> config;
  const ExamSessionScreen({super.key, required this.config});

  @override
  ConsumerState<ExamSessionScreen> createState() => _ExamSessionScreenState();
}

class _ExamSessionScreenState extends ConsumerState<ExamSessionScreen> {
  List<QuestionModel>? _questions;
  int _current = 0;
  final Map<int, int> _answers = {};
  int? _selected;
  bool _answered = false;
  bool _loading = true;
  late int _secondsLeft;
  Timer? _timer;

  int get _totalSeconds => (widget.config['count'] as int? ?? 20) * 60;

  @override
  void initState() {
    super.initState();
    _secondsLeft = _totalSeconds;
    _load();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    final repo = ref.read(questionRepositoryProvider);
    final count = widget.config['count'] as int? ?? 20;
    final catId = widget.config['category'] as String?;
    final category = catId != null ? QuestionCategory.fromId(catId) : null;

    final questions = await repo.buildExamSession(category: category, count: count);
    if (mounted) {
      setState(() { _questions = questions; _loading = false; });
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsLeft <= 1) {
        _timer?.cancel();
        _finish();
      } else {
        setState(() => _secondsLeft--);
      }
    });
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
    _timer?.cancel();
    final questions = _questions!;
    int correct = 0;
    for (int i = 0; i < questions.length; i++) {
      if (_answers[i] == questions[i].correctIndex) correct++;
    }

    // XP calculation
    int xp = 30;
    xp += correct * 2;
    if (correct == questions.length) xp += 25;

    await ref.read(userProfileProvider.notifier).addXp(xp);
    await ref.read(userRepositoryProvider).incrementExamsTaken();

    if (mounted) {
      context.go('/exam/result', extra: {
        'correct': correct,
        'total': questions.length,
        'xpEarned': xp,
        'questions': questions.map((q) => q.toJson()).toList(),
        'answers': Map<String, dynamic>.from(_answers.map((k, v) => MapEntry(k.toString(), v))),
      });
    }
  }

  String get _timeStr {
    final m = _secondsLeft ~/ 60;
    final s = _secondsLeft % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
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
    final isLowTime = _secondsLeft < 30;
    final weakCategories = ref.watch(userProfileProvider).value?.weakCategories ?? [];
    final isWeakQuestion = weakCategories.contains(question.category.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showQuitDialog(),
        ),
        title: Text('${_current + 1} / $total', style: AppTextStyles.body),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isLowTime ? AppColors.errorLight : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.timer_outlined,
                    size: 16, color: isLowTime ? AppColors.error : AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  _timeStr,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: isLowTime ? AppColors.error : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: (_current + 1) / total,
                  minHeight: 4,
                  backgroundColor: AppColors.divider,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  borderRadius: BorderRadius.circular(2),
                ),
                const SizedBox(height: 16),
                if (question.passageText != null)
                  _PassageCard(title: question.passageTitle, text: question.passageText!),
                if (isWeakQuestion) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 14),
                        SizedBox(width: 6),
                        Text(
                          'Bu konuda eksik var — iyi pratik fırsatı!',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF92400E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Text(question.questionText, style: AppTextStyles.body),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: question.options.length,
                    itemBuilder: (_, i) {
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
                                  color: bg != null
                                      ? (i == question.correctIndex ? AppColors.success : AppColors.error)
                                      : (_selected == i ? AppColors.primary : AppColors.surfaceVariant),
                                ),
                                child: Center(
                                  child: Text(
                                    String.fromCharCode(65 + i),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      color: bg != null || _selected == i ? Colors.white : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(child: Text(question.options[i], style: AppTextStyles.body)),
                              if (_answered && i == question.correctIndex)
                                const Icon(Icons.check_circle, color: AppColors.success, size: 20),
                              if (_answered && i == _selected && i != question.correctIndex)
                                const Icon(Icons.cancel, color: AppColors.error, size: 20),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showQuitDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sınavdan Çık?'),
        content: const Text('İlerlemeliğin kaybolacak.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Devam Et')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/home/exams');
            },
            child: const Text('Çık', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _PassageCard extends StatefulWidget {
  final String? title;
  final String text;
  const _PassageCard({this.title, required this.text});

  @override
  State<_PassageCard> createState() => _PassageCardState();
}

class _PassageCardState extends State<_PassageCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.article_outlined, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    widget.title ?? 'Passage',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.primary),
                  ),
                ),
                Icon(_expanded ? Icons.expand_less : Icons.expand_more,
                    size: 18, color: AppColors.textSecondary),
              ],
            ),
            if (_expanded) ...[
              const SizedBox(height: 8),
              Text(widget.text, style: AppTextStyles.caption),
            ],
          ],
        ),
      ),
    );
  }
}
