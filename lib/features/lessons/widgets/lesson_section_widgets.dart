import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/lesson_content_model.dart';
import '../../../data/models/question_model.dart';
import 'grammar_animations.dart';

/// Renders a single LessonSection based on its type.
class LessonSectionWidget extends StatelessWidget {
  final LessonSection section;
  final int sectionIndex;

  const LessonSectionWidget({
    super.key,
    required this.section,
    required this.sectionIndex,
  });

  @override
  Widget build(BuildContext context) {
    return switch (section.type) {
      LessonSectionType.intro => _IntroSection(section: section),
      LessonSectionType.rule => _RuleSection(section: section),
      LessonSectionType.examples => _ExamplesSection(section: section),
      LessonSectionType.animation => _AnimationSection(section: section),
      LessonSectionType.practice => _PracticeSection(section: section),
      LessonSectionType.tip => _TipSection(section: section),
    };
  }
}

// ─────────────────────────────────────────────────────────────
// INTRO SECTION
// ─────────────────────────────────────────────────────────────
class _IntroSection extends StatelessWidget {
  final LessonSection section;
  const _IntroSection({required this.section});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.title != null)
          Text(section.title!, style: AppTextStyles.heading3),
        if (section.title != null) const SizedBox(height: 10),
        if (section.body != null)
          _RichBody(text: section.body!),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// RULE SECTION — blue highlighted box
// ─────────────────────────────────────────────────────────────
class _RuleSection extends StatelessWidget {
  final LessonSection section;
  const _RuleSection({required this.section});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
        border: const Border(left: BorderSide(color: AppColors.primary, width: 4)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.title != null) ...[
            Text(section.title!,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.primary,
                )),
            const SizedBox(height: 10),
          ],
          if (section.body != null) _RichBody(text: section.body!),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// EXAMPLES SECTION
// ─────────────────────────────────────────────────────────────
class _ExamplesSection extends StatelessWidget {
  final LessonSection section;
  const _ExamplesSection({required this.section});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.title != null) ...[
          Text(section.title!, style: AppTextStyles.heading3),
          const SizedBox(height: 12),
        ],
        if (section.examples != null)
          ...section.examples!.map((e) => _ExampleCard(example: e)),
      ],
    );
  }
}

class _ExampleCard extends StatefulWidget {
  final ExampleSentence example;
  const _ExampleCard({required this.example});

  @override
  State<_ExampleCard> createState() => _ExampleCardState();
}

class _ExampleCardState extends State<_ExampleCard> {
  bool _showTranslation = false;

  @override
  Widget build(BuildContext context) {
    final e = widget.example;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HighlightedSentence(sentence: e.sentence, highlight: e.highlight),
          if (e.translation != null) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => setState(() => _showTranslation = !_showTranslation),
              child: Row(
                children: [
                  Icon(
                    _showTranslation ? Icons.visibility_off_outlined : Icons.translate,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _showTranslation ? 'Çeviriyi gizle' : 'Türkçe çeviriyi göster',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            if (_showTranslation) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                ),
                child: Text(
                  e.translation!,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF166534), height: 1.4),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _HighlightedSentence extends StatelessWidget {
  final String sentence;
  final String? highlight;

  const _HighlightedSentence({required this.sentence, this.highlight});

  @override
  Widget build(BuildContext context) {
    if (highlight == null || !sentence.contains(highlight!)) {
      return Text(sentence, style: AppTextStyles.body);
    }

    final parts = sentence.split(highlight!);
    return RichText(
      text: TextSpan(
        style: AppTextStyles.body,
        children: [
          TextSpan(text: parts.first),
          WidgetSpan(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Text(
                highlight!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (parts.length > 1) TextSpan(text: parts.sublist(1).join(highlight!)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ANIMATION SECTION
// ─────────────────────────────────────────────────────────────
class _AnimationSection extends StatelessWidget {
  final LessonSection section;
  const _AnimationSection({required this.section});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.title != null) ...[
          Text(section.title!, style: AppTextStyles.heading3),
          const SizedBox(height: 12),
        ],
        if (section.animationType != null)
          GrammarAnimationWidget(type: section.animationType!),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TIP SECTION — amber highlighted box
// ─────────────────────────────────────────────────────────────
class _TipSection extends StatelessWidget {
  final LessonSection section;
  const _TipSection({required this.section});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(14),
        border: const Border(left: BorderSide(color: AppColors.warning, width: 4)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.title != null) ...[
            Text(section.title!,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.warning,
                )),
            const SizedBox(height: 10),
          ],
          if (section.body != null) _RichBody(text: section.body!),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PRACTICE SECTION — embedded mini-quiz (no timer, immediate feedback)
// ─────────────────────────────────────────────────────────────
class _PracticeSection extends StatefulWidget {
  final LessonSection section;
  const _PracticeSection({required this.section});

  @override
  State<_PracticeSection> createState() => _PracticeSectionState();
}

class _PracticeSectionState extends State<_PracticeSection> {
  final Map<int, int> _answers = {};
  int _current = 0;
  bool _answered = false;
  bool _allDone = false;
  int _score = 0;

  List<QuestionModel> get _questions => widget.section.practiceQuestions ?? [];

  void _select(int optionIndex) {
    if (_answered) return;
    final q = _questions[_current];
    final isCorrect = optionIndex == q.correctIndex;
    setState(() {
      _answers[_current] = optionIndex;
      _answered = true;
      if (isCorrect) _score++;
    });
  }

  void _next() {
    if (_current < _questions.length - 1) {
      setState(() {
        _current++;
        _answered = false;
      });
    } else {
      setState(() => _allDone = true);
    }
  }

  void _restart() {
    setState(() {
      _answers.clear();
      _current = 0;
      _answered = false;
      _allDone = false;
      _score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.quiz_outlined, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text('Pratik', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (!_allDone)
              Text(
                '${_current + 1} / ${_questions.length}',
                style: AppTextStyles.caption,
              ),
          ],
        ),
        const SizedBox(height: 12),

        // passage text (if any)
        if (widget.section.body != null) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(widget.section.body!, style: AppTextStyles.caption),
          ),
          const SizedBox(height: 12),
        ],

        if (_allDone)
          _ScoreCard(score: _score, total: _questions.length, onRetry: _restart)
        else ...[
          _QuestionCard(
            question: _questions[_current],
            selectedIndex: _answers[_current],
            answered: _answered,
            onSelect: _select,
          ),
          if (_answered)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    _current < _questions.length - 1 ? 'Sonraki Soru →' : 'Pratiği Bitir',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final QuestionModel question;
  final int? selectedIndex;
  final bool answered;
  final ValueChanged<int> onSelect;

  const _QuestionCard({
    required this.question,
    required this.selectedIndex,
    required this.answered,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: Text(question.questionText, style: AppTextStyles.body),
        ),
        const SizedBox(height: 10),
        ...List.generate(question.options.length, (i) {
          Color? bg;
          Color borderColor = AppColors.divider;
          bool isSelected = selectedIndex == i;

          if (answered) {
            if (i == question.correctIndex) {
              bg = AppColors.successLight;
              borderColor = AppColors.success;
            } else if (isSelected) {
              bg = AppColors.errorLight;
              borderColor = AppColors.error;
            }
          } else if (isSelected) {
            borderColor = AppColors.primary;
          }

          return GestureDetector(
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: bg ?? AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderColor, width: isSelected || bg != null ? 2 : 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: bg != null
                          ? (i == question.correctIndex ? AppColors.success : AppColors.error)
                          : (isSelected ? AppColors.primary : AppColors.surfaceVariant),
                    ),
                    child: Center(
                      child: Text(
                        String.fromCharCode(65 + i),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: bg != null || isSelected ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(question.options[i], style: AppTextStyles.label)),
                  if (answered && i == question.correctIndex)
                    const Icon(Icons.check_circle, color: AppColors.success, size: 18),
                  if (answered && isSelected && i != question.correctIndex)
                    const Icon(Icons.cancel, color: AppColors.error, size: 18),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onRetry;

  const _ScoreCard({required this.score, required this.total, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final pct = (score / total * 100).round();
    final color = pct >= 75 ? AppColors.success : pct >= 50 ? AppColors.primary : AppColors.warning;
    final emoji = pct >= 75 ? '🎉' : pct >= 50 ? '👍' : '📚';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 36)),
          const SizedBox(height: 8),
          Text(
            '$score / $total',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: color),
          ),
          const SizedBox(height: 4),
          Text('%$pct doğru', style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.replay, size: 16),
            label: const Text('Tekrar Dene'),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// RICH BODY — renders **bold**, *italic*, and \n as paragraphs
// ─────────────────────────────────────────────────────────────
class _RichBody extends StatelessWidget {
  final String text;
  const _RichBody({required this.text});

  @override
  Widget build(BuildContext context) {
    final paragraphs = text.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragraphs.map((para) {
        if (para.trim().isEmpty) return const SizedBox(height: 6);
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: _buildRichText(para),
        );
      }).toList(),
    );
  }

  Widget _buildRichText(String line) {
    // Parse bullet points
    if (line.trimLeft().startsWith('•')) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6, right: 6),
            child: CircleAvatar(radius: 3, backgroundColor: AppColors.primary),
          ),
          Expanded(child: _buildRichText(line.trimLeft().substring(1).trim())),
        ],
      );
    }

    // Parse **bold** and *italic* inline
    final spans = <InlineSpan>[];
    final pattern = RegExp(r'\*\*(.+?)\*\*|\*(.+?)\*|`(.+?)`');
    int last = 0;

    for (final match in pattern.allMatches(line)) {
      if (match.start > last) {
        spans.add(TextSpan(text: line.substring(last, match.start)));
      }
      if (match.group(1) != null) {
        spans.add(TextSpan(
          text: match.group(1),
          style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ));
      } else if (match.group(2) != null) {
        spans.add(TextSpan(
          text: match.group(2),
          style: const TextStyle(fontStyle: FontStyle.italic),
        ));
      } else if (match.group(3) != null) {
        spans.add(WidgetSpan(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.divider),
            ),
            child: Text(
              match.group(3)!,
              style: const TextStyle(fontSize: 13, fontFamily: 'monospace', color: AppColors.textPrimary),
            ),
          ),
        ));
      }
      last = match.end;
    }

    if (last < line.length) {
      spans.add(TextSpan(text: line.substring(last)));
    }

    return RichText(
      text: TextSpan(
        style: AppTextStyles.body,
        children: spans,
      ),
    );
  }
}
