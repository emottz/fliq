import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/lesson_content_model.dart';
import '../../../data/models/question_model.dart';
import '../../../shared/providers/app_providers.dart';
import 'grammar_animations.dart';

const _kPassThreshold = 0.60; // 60% to pass

/// Full-card widget per section — used in PageView.
class LessonCardWidget extends StatelessWidget {
  final LessonSection section;
  final int sectionIndex;
  final String lessonEmoji;
  final String lessonCategoryId;
  /// Called only for practice sections when the user completes the quiz.
  final void Function(bool passed)? onPracticeResult;

  const LessonCardWidget({
    super.key,
    required this.section,
    required this.sectionIndex,
    required this.lessonEmoji,
    required this.lessonCategoryId,
    this.onPracticeResult,
  });

  @override
  Widget build(BuildContext context) {
    return switch (section.type) {
      LessonSectionType.intro => _IntroCard(section: section, emoji: lessonEmoji),
      LessonSectionType.rule => _RuleCard(section: section),
      LessonSectionType.examples => _ExamplesCard(section: section),
      LessonSectionType.animation => _AnimationCard(section: section),
      LessonSectionType.practice => _PracticeCard(
          section: section,
          categoryId: lessonCategoryId,
          onResult: onPracticeResult,
        ),
      LessonSectionType.tip => _TipCard(section: section),
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// INTRO CARD — gradient, large emoji, headline
// ─────────────────────────────────────────────────────────────────────────────

class _IntroCard extends StatefulWidget {
  final LessonSection section;
  final String emoji;
  const _IntroCard({required this.section, required this.emoji});

  @override
  State<_IntroCard> createState() => _IntroCardState();
}

class _IntroCardState extends State<_IntroCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E3A8A), AppColors.primary, Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Emoji in circle
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                ),
                child: Center(
                  child: Text(widget.emoji, style: const TextStyle(fontSize: 52)),
                ),
              ),
              const SizedBox(height: 24),
              if (widget.section.title != null) ...[
                Text(
                  widget.section.title!,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
              ],
              if (widget.section.body != null)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    widget.section.body!,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RULE CARD — visual formula chips + body
// ─────────────────────────────────────────────────────────────────────────────

class _RuleCard extends StatefulWidget {
  final LessonSection section;
  const _RuleCard({required this.section});

  @override
  State<_RuleCard> createState() => _RuleCardState();
}

class _RuleCardState extends State<_RuleCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  /// Parse title like "Subject + Modal + Verb" into chips
  List<String> get _formulaParts {
    final t = widget.section.title ?? '';
    if (t.contains('+') || t.contains('→')) {
      return t.split(RegExp(r'[+→]')).map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final parts = _formulaParts;

    return FadeTransition(
      opacity: _fade,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rule header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFBFDBFE), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'RULE',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1),
                        ),
                      ),
                      if (widget.section.title != null && parts.isEmpty) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.section.title!,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                        ),
                      ],
                    ],
                  ),

                  // Formula chips
                  if (parts.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 6,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: parts.asMap().entries.expand((entry) {
                        final i = entry.key;
                        final p = entry.value;
                        return [
                          _FormulaChip(text: p, index: i),
                          if (i < parts.length - 1)
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              child: Icon(Icons.add_rounded, color: AppColors.primary, size: 18),
                            ),
                        ];
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),

            if (widget.section.body != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: _RichBody(text: widget.section.body!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FormulaChip extends StatelessWidget {
  final String text;
  final int index;
  const _FormulaChip({required this.text, required this.index});

  static const _colors = [
    Color(0xFF2563EB),
    Color(0xFF7C3AED),
    Color(0xFF059669),
    Color(0xFFD97706),
    Color(0xFFDC2626),
  ];

  @override
  Widget build(BuildContext context) {
    final color = _colors[index % _colors.length];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EXAMPLES CARD — flip-style reveal cards
// ─────────────────────────────────────────────────────────────────────────────

class _ExamplesCard extends StatelessWidget {
  final LessonSection section;
  const _ExamplesCard({required this.section});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.title != null) ...[
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE9FE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'EXAMPLES',
                    style: TextStyle(color: Color(0xFF7C3AED), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(section.title!, style: AppTextStyles.heading3),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          if (section.examples != null)
            ...section.examples!.map((e) => _FlipExampleCard(example: e)),
        ],
      ),
    );
  }
}

class _FlipExampleCard extends StatefulWidget {
  final ExampleSentence example;
  const _FlipExampleCard({required this.example});

  @override
  State<_FlipExampleCard> createState() => _FlipExampleCardState();
}

class _FlipExampleCardState extends State<_FlipExampleCard>
    with SingleTickerProviderStateMixin {
  bool _flipped = false;
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    if (widget.example.translation == null) return;
    setState(() => _flipped = !_flipped);
    if (_flipped) {
      _ctrl.forward();
    } else {
      _ctrl.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.example;
    final hasTranslation = e.translation != null;

    return GestureDetector(
      onTap: _toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _flipped ? const Color(0xFFF0FDF4) : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _flipped ? AppColors.success.withOpacity(0.5) : AppColors.divider,
            width: _flipped ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Highlighted sentence
            _HighlightedSentence(sentence: e.sentence, highlight: e.highlight),

            if (hasTranslation) ...[
              const SizedBox(height: 12),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _flipped
                    ? Column(
                        key: const ValueKey('tr'),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(height: 1),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.translate, color: AppColors.success, size: 14),
                              const SizedBox(width: 5),
                              Text(
                                e.translation!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF166534),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        key: const ValueKey('hint'),
                        children: [
                          const Icon(Icons.touch_app_outlined, size: 13, color: AppColors.textHint),
                          const SizedBox(width: 4),
                          Text(
                            'Türkçe çeviriyi görmek için dokun',
                            style: const TextStyle(fontSize: 11, color: AppColors.textHint),
                          ),
                        ],
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TIP CARD — amber gradient, large icon
// ─────────────────────────────────────────────────────────────────────────────

class _TipCard extends StatefulWidget {
  final LessonSection section;
  const _TipCard({required this.section});

  @override
  State<_TipCard> createState() => _TipCardState();
}

class _TipCardState extends State<_TipCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _slide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFFBEB), Color(0xFFFEF3C7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFFDE68A), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFFDE68A),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.tips_and_updates_rounded, color: Color(0xFFD97706), size: 36),
            ),
            const SizedBox(height: 18),
            if (widget.section.title != null) ...[
              Text(
                widget.section.title!,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF92400E),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
            ],
            if (widget.section.body != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  widget.section.body!,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF78350F),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ANIMATION CARD
// ─────────────────────────────────────────────────────────────────────────────

class _AnimationCard extends StatelessWidget {
  final LessonSection section;
  const _AnimationCard({required this.section});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.title != null) ...[
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'VISUAL',
                    style: TextStyle(color: Color(0xFF059669), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(section.title!, style: AppTextStyles.heading3)),
              ],
            ),
            const SizedBox(height: 16),
          ],
          if (section.animationType != null)
            GrammarAnimationWidget(type: section.animationType!),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PRACTICE CARD — interactive quiz
// ─────────────────────────────────────────────────────────────────────────────

class _PracticeCard extends ConsumerStatefulWidget {
  final LessonSection section;
  final String categoryId;
  final void Function(bool passed)? onResult;
  const _PracticeCard({required this.section, required this.categoryId, this.onResult});

  @override
  ConsumerState<_PracticeCard> createState() => _PracticeCardState();
}

class _PracticeCardState extends ConsumerState<_PracticeCard> {
  final Map<int, int> _answers = {};
  int _current = 0;
  bool _answered = false;
  bool _allDone = false;
  int _score = 0;
  bool _loadingFromBank = false;

  List<QuestionModel> _questions = [];

  @override
  void initState() {
    super.initState();
    _initQuestions();
  }

  Future<void> _initQuestions() async {
    // Önce hardcoded soruları yükle (anında gösterim)
    final hardcoded = widget.section.practiceQuestions ?? [];

    // Bank'tan yüklemeyi dene
    setState(() { _loadingFromBank = true; });
    try {
      final repo = ref.read(questionRepositoryProvider);
      final category = QuestionCategory.fromId(widget.categoryId);
      var pool = await repo.getByCategory(category);
      // Pasaj içeren soruları filtrele — practice card onları gösteremiyor
      pool = pool.where((q) => q.passageText == null).toList();
      if (pool.isNotEmpty) {
        pool.shuffle();
        final count = widget.section.practiceCount;
        _questions = pool.take(count).map((q) => q.withShuffledOptions()).toList();
      } else {
        _questions = List.of(hardcoded)..shuffle();
      }
    } catch (_) {
      _questions = List.of(hardcoded)..shuffle();
    } finally {
      if (mounted) setState(() { _loadingFromBank = false; });
    }
  }

  void _select(int i) {
    if (_answered) return;
    setState(() {
      _answers[_current] = i;
      _answered = true;
      if (i == _questions[_current].correctIndex) _score++;
    });
  }

  void _next() {
    if (_current < _questions.length - 1) {
      setState(() { _current++; _answered = false; });
    } else {
      final passed = _questions.isNotEmpty && _score / _questions.length >= _kPassThreshold;
      setState(() => _allDone = true);
      widget.onResult?.call(passed);
    }
  }

  void _restart() {
    final wasPass = _questions.isNotEmpty && _score / _questions.length >= _kPassThreshold;
    if (!wasPass) widget.onResult?.call(false);
    setState(() { _answers.clear(); _current = 0; _answered = false; _allDone = false; _score = 0; });
    _initQuestions(); // yeni rastgele sorular çek
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingFromBank) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_questions.isEmpty) return const SizedBox();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.quiz_outlined, color: Colors.white, size: 13),
                    SizedBox(width: 4),
                    Text('PRATİK', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
                  ],
                ),
              ),
              if (!_allDone) ...[
                const Spacer(),
                Text('${_current + 1} / ${_questions.length}', style: AppTextStyles.caption),
              ],
            ],
          ),
          const SizedBox(height: 14),

          if (_allDone)
            _ScoreCard(score: _score, total: _questions.length, onRetry: _restart)
          else ...[
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
                      _current < _questions.length - 1 ? 'İleri →' : 'Sonuçları Gör',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final QuestionModel question;
  final int? selectedIndex;
  final bool answered;
  final ValueChanged<int> onSelect;

  const _QuestionCard({required this.question, required this.selectedIndex, required this.answered, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.divider),
          ),
          child: Text(question.questionText, style: AppTextStyles.body),
        ),
        const SizedBox(height: 10),
        ...List.generate(question.options.length, (i) {
          Color? bg;
          Color border = AppColors.divider;
          final selected = selectedIndex == i;
          if (answered) {
            if (i == question.correctIndex) { bg = AppColors.successLight; border = AppColors.success; }
            else if (selected) { bg = AppColors.errorLight; border = AppColors.error; }
          } else if (selected) { border = AppColors.primary; }

          return GestureDetector(
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              decoration: BoxDecoration(
                color: bg ?? AppColors.surface,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: border, width: selected || bg != null ? 2 : 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: bg != null ? (i == question.correctIndex ? AppColors.success : AppColors.error)
                          : (selected ? AppColors.primary : AppColors.surfaceVariant),
                    ),
                    child: Center(
                      child: Text(
                        String.fromCharCode(65 + i),
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13,
                            color: bg != null || selected ? Colors.white : AppColors.textSecondary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(question.options[i], style: AppTextStyles.body)),
                  if (answered && i == question.correctIndex)
                    const Icon(Icons.check_circle, color: AppColors.success, size: 18),
                  if (answered && selected && i != question.correctIndex)
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
    final pct = total > 0 ? score / total : 0.0;
    final passed = pct >= _kPassThreshold;
    final pctInt = (pct * 100).round();

    if (passed) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.success.withOpacity(0.4), width: 1.5),
        ),
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.success,
                boxShadow: [BoxShadow(color: AppColors.success.withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 4))],
              ),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 36),
            ),
            const SizedBox(height: 14),
            const Text('Pratik Tamamlandı!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF166534))),
            const SizedBox(height: 6),
            Text(
              '$score / $total doğru — %$pctInt',
              style: const TextStyle(fontSize: 15, color: Color(0xFF15803D)),
            ),
            const SizedBox(height: 10),
            const Text(
              'Bu dersi artık tamamlayabilirsiniz.',
              style: TextStyle(fontSize: 13, color: Color(0xFF166534)),
            ),
          ],
        ),
      );
    }

    // Failed
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.error.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.error,
              boxShadow: [BoxShadow(color: AppColors.error.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 4))],
            ),
            child: const Icon(Icons.close_rounded, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 14),
          const Text('Olmadı!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF9B1C1C))),
          const SizedBox(height: 6),
          Text(
            '$score / $total doğru — %$pctInt',
            style: const TextStyle(fontSize: 15, color: Color(0xFFB91C1C)),
          ),
          const SizedBox(height: 6),
          const Text(
            'Geçmek için %60 veya üzeri almanız gerekiyor.\nDersi tekrar gözden geçirip tekrar deneyin.',
            style: TextStyle(fontSize: 13, color: Color(0xFF991B1B), height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.replay_rounded, size: 18),
              label: const Text('Tekrar Dene', style: TextStyle(fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

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
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Text(
                highlight!,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary, height: 1.4),
              ),
            ),
          ),
          if (parts.length > 1) TextSpan(text: parts.sublist(1).join(highlight!)),
        ],
      ),
    );
  }
}

class _RichBody extends StatelessWidget {
  final String text;
  const _RichBody({required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: text.split('\n').map((line) {
        if (line.trim().isEmpty) return const SizedBox(height: 4);
        return Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: _buildLine(line),
        );
      }).toList(),
    );
  }

  Widget _buildLine(String line) {
    if (line.trimLeft().startsWith('•')) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 7, right: 6),
            child: CircleAvatar(radius: 3, backgroundColor: AppColors.primary),
          ),
          Expanded(child: _buildLine(line.trimLeft().substring(1).trim())),
        ],
      );
    }
    final spans = <InlineSpan>[];
    final pattern = RegExp(r'\*\*(.+?)\*\*|\*(.+?)\*|`(.+?)`');
    int last = 0;
    for (final m in pattern.allMatches(line)) {
      if (m.start > last) spans.add(TextSpan(text: line.substring(last, m.start)));
      if (m.group(1) != null) {
        spans.add(TextSpan(text: m.group(1), style: const TextStyle(fontWeight: FontWeight.w700)));
      } else if (m.group(2) != null) {
        spans.add(TextSpan(text: m.group(2), style: const TextStyle(fontStyle: FontStyle.italic)));
      } else if (m.group(3) != null) {
        spans.add(WidgetSpan(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(4), border: Border.all(color: AppColors.divider)),
            child: Text(m.group(3)!, style: const TextStyle(fontSize: 13, fontFamily: 'monospace')),
          ),
        ));
      }
      last = m.end;
    }
    if (last < line.length) spans.add(TextSpan(text: line.substring(last)));
    return RichText(text: TextSpan(style: AppTextStyles.body, children: spans));
  }
}
