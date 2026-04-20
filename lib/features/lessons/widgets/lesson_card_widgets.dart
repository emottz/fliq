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
      LessonSectionType.dialogue => _DialogueCard(section: section),
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
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fade = CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.4, curve: Curves.easeOut));
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
                        final start = (0.15 + i * 0.12).clamp(0.0, 0.65);
                        final end = (start + 0.35).clamp(0.0, 1.0);
                        final chipAnim = CurvedAnimation(
                          parent: _ctrl,
                          curve: Interval(start, end, curve: Curves.elasticOut),
                        );
                        return [
                          _FormulaChip(text: p, index: i, entryAnim: chipAnim),
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
  final Animation<double>? entryAnim;
  const _FormulaChip({required this.text, required this.index, this.entryAnim});

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
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color),
      ),
    );
    if (entryAnim == null) return chip;
    return ScaleTransition(
      scale: entryAnim!,
      child: FadeTransition(opacity: entryAnim!, child: chip),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EXAMPLES CARD — flip-style reveal cards
// ─────────────────────────────────────────────────────────────────────────────

class _ExamplesCard extends StatefulWidget {
  final LessonSection section;
  const _ExamplesCard({required this.section});

  @override
  State<_ExamplesCard> createState() => _ExamplesCardState();
}

class _ExamplesCardState extends State<_ExamplesCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    final count = (widget.section.examples?.length ?? 1).clamp(1, 10);
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400 + (count - 1) * 120),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = widget.section.examples ?? [];
    final count = examples.length.clamp(1, 10);
    final totalMs = 400 + (count - 1) * 120;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.section.title != null) ...[
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
                Expanded(child: Text(widget.section.title!, style: AppTextStyles.heading3)),
              ],
            ),
            const SizedBox(height: 16),
          ],
          ...examples.asMap().entries.map((entry) {
            final i = entry.key;
            final startT = (i * 120) / totalMs;
            final endT = ((i * 120) + 400) / totalMs;
            final anim = CurvedAnimation(
              parent: _ctrl,
              curve: Interval(startT.clamp(0.0, 0.9), endT.clamp(0.1, 1.0), curve: Curves.easeOut),
            );
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(anim),
              child: FadeTransition(opacity: anim, child: _FlipExampleCard(example: entry.value)),
            );
          }),
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
  bool _animating = false;
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 380));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (widget.example.translation == null || _animating) return;
    _animating = true;
    // Phase 1: squish to flat (0 → 0.5)
    await _ctrl.animateTo(0.5, curve: Curves.easeIn);
    if (mounted) setState(() => _flipped = !_flipped);
    // Phase 2: expand back (0.5 → 1.0)
    await _ctrl.animateTo(1.0, curve: Curves.elasticOut);
    _ctrl.reset();
    _animating = false;
  }

  double get _scaleY {
    final v = _ctrl.value;
    if (v <= 0.5) return 1.0 - v * 2.0;
    return (v - 0.5) * 2.0;
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.example;
    final hasTranslation = e.translation != null;

    return GestureDetector(
      onTap: _toggle,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..setEntry(1, 1, _scaleY.clamp(0.001, 1.0)),
          child: Container(
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
                _HighlightedSentence(sentence: e.sentence, highlight: e.highlight),
                if (hasTranslation) ...[
                  const SizedBox(height: 12),
                  if (_flipped) ...[
                    const Divider(height: 1),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.translate, color: AppColors.success, size: 14),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            e.translation!,
                            style: const TextStyle(
                              fontSize: 14, color: Color(0xFF166634), fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Row(
                      children: const [
                        Icon(Icons.touch_app_outlined, size: 13, color: AppColors.textHint),
                        SizedBox(width: 4),
                        Text('Türkçe çeviriyi görmek için dokun',
                            style: TextStyle(fontSize: 11, color: AppColors.textHint)),
                      ],
                    ),
                  ],
                ],
              ],
            ),
          ),
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
            GrammarAnimationWidget(type: section.animationType!, section: section),
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
        final selected = pool.take(count).toList();
        final withFifth = await repo.addFifthOptions(selected);
        _questions = withFifth.map((q) => q.withShuffledOptions()).toList();
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

class _QuestionCard extends StatefulWidget {
  final QuestionModel question;
  final int? selectedIndex;
  final bool answered;
  final ValueChanged<int> onSelect;

  const _QuestionCard({required this.question, required this.selectedIndex, required this.answered, required this.onSelect});

  @override
  State<_QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<_QuestionCard> with TickerProviderStateMixin {
  late List<AnimationController> _ctrls;

  // Shake: offset sequence for wrong answer
  Animation<Offset> _shakeAnim(AnimationController c) => TweenSequence<Offset>([
    TweenSequenceItem(tween: Tween(begin: Offset.zero, end: const Offset(-0.04, 0)), weight: 1),
    TweenSequenceItem(tween: Tween(begin: const Offset(-0.04, 0), end: const Offset(0.04, 0)), weight: 2),
    TweenSequenceItem(tween: Tween(begin: const Offset(0.04, 0), end: const Offset(-0.03, 0)), weight: 2),
    TweenSequenceItem(tween: Tween(begin: const Offset(-0.03, 0), end: Offset.zero), weight: 1),
  ]).animate(CurvedAnimation(parent: c, curve: Curves.easeInOut));

  // Bounce: scale sequence for correct answer
  Animation<double> _bounceAnim(AnimationController c) => TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.10), weight: 1),
    TweenSequenceItem(tween: Tween(begin: 1.10, end: 0.96), weight: 1),
    TweenSequenceItem(tween: Tween(begin: 0.96, end: 1.0), weight: 1),
  ]).animate(CurvedAnimation(parent: c, curve: Curves.easeInOut));

  @override
  void initState() {
    super.initState();
    _ctrls = List.generate(
      widget.question.options.length,
      (_) => AnimationController(vsync: this, duration: const Duration(milliseconds: 400)),
    );
  }

  @override
  void didUpdateWidget(_QuestionCard old) {
    super.didUpdateWidget(old);
    if (!old.answered && widget.answered && widget.selectedIndex != null) {
      final sel = widget.selectedIndex!;
      final correct = widget.question.correctIndex;
      if (sel == correct) {
        _ctrls[correct].forward(from: 0);
      } else {
        _ctrls[sel].forward(from: 0);
        Future.delayed(const Duration(milliseconds: 220), () {
          if (mounted && correct < _ctrls.length) _ctrls[correct].forward(from: 0);
        });
      }
    }
  }

  @override
  void dispose() {
    for (final c in _ctrls) c.dispose();
    super.dispose();
  }

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
          child: Text(widget.question.questionText, style: AppTextStyles.body),
        ),
        const SizedBox(height: 10),
        ...List.generate(widget.question.options.length, (i) {
          Color? bg;
          Color border = AppColors.divider;
          final selected = widget.selectedIndex == i;
          final isCorrect = i == widget.question.correctIndex;
          final isWrongSelected = widget.answered && selected && !isCorrect;
          if (widget.answered) {
            if (isCorrect) { bg = AppColors.successLight; border = AppColors.success; }
            else if (selected) { bg = AppColors.errorLight; border = AppColors.error; }
          } else if (selected) { border = AppColors.primary; }

          final ctrl = _ctrls[i];
          final shake = _shakeAnim(ctrl);
          final bounce = _bounceAnim(ctrl);

          return AnimatedBuilder(
            animation: ctrl,
            builder: (_, child) {
              Widget option = child!;
              if (isWrongSelected) option = SlideTransition(position: shake, child: option);
              if (widget.answered && isCorrect) option = ScaleTransition(scale: bounce, child: option);
              return option;
            },
            child: GestureDetector(
              onTap: () => widget.onSelect(i),
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
                        color: bg != null ? (isCorrect ? AppColors.success : AppColors.error)
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
                    Expanded(child: Text(widget.question.options[i], style: AppTextStyles.body)),
                    if (widget.answered && isCorrect)
                      const Icon(Icons.check_circle, color: AppColors.success, size: 18),
                    if (widget.answered && selected && !isCorrect)
                      const Icon(Icons.cancel, color: AppColors.error, size: 18),
                  ],
                ),
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

// ─────────────────────────────────────────────────────────────────────────────
// DIALOGUE CARD — animated chat bubbles between ATC/Pilot, Cabin/Passenger etc.
// ─────────────────────────────────────────────────────────────────────────────

class _DialogueCard extends StatefulWidget {
  final LessonSection section;
  const _DialogueCard({required this.section});

  @override
  State<_DialogueCard> createState() => _DialogueCardState();
}

class _DialogueCardState extends State<_DialogueCard> with TickerProviderStateMixin {
  late List<AnimationController> _ctrs;
  late List<Animation<double>> _fades;
  late List<Animation<Offset>> _slides;
  bool _showTranslations = false;

  static Color _speakerColor(DialogueSpeaker s) => switch (s) {
    DialogueSpeaker.atc       => const Color(0xFF1D4ED8),
    DialogueSpeaker.pilot     => const Color(0xFFD97706),
    DialogueSpeaker.captain   => const Color(0xFF0F3460),
    DialogueSpeaker.cabin     => const Color(0xFF7C3AED),
    DialogueSpeaker.passenger => const Color(0xFF6B7280),
    DialogueSpeaker.amt       => const Color(0xFFB45309),
    DialogueSpeaker.engineer  => const Color(0xFF059669),
  };

  static String _speakerLabel(DialogueSpeaker s) => switch (s) {
    DialogueSpeaker.atc       => 'ATC',
    DialogueSpeaker.pilot     => 'PILOT',
    DialogueSpeaker.captain   => 'CAPTAIN',
    DialogueSpeaker.cabin     => 'CABIN',
    DialogueSpeaker.passenger => 'PAX',
    DialogueSpeaker.amt       => 'AMT',
    DialogueSpeaker.engineer  => 'ENG',
  };

  static String _speakerEmoji(DialogueSpeaker s) => switch (s) {
    DialogueSpeaker.atc       => '🗼',
    DialogueSpeaker.pilot     => '✈️',
    DialogueSpeaker.captain   => '👨‍✈️',
    DialogueSpeaker.cabin     => '💺',
    DialogueSpeaker.passenger => '🧑',
    DialogueSpeaker.amt       => '🔧',
    DialogueSpeaker.engineer  => '📋',
  };

  // "right-side" speakers (bubble on right)
  static bool _isRight(DialogueSpeaker s) =>
      s == DialogueSpeaker.pilot || s == DialogueSpeaker.captain ||
      s == DialogueSpeaker.cabin || s == DialogueSpeaker.amt;

  @override
  void initState() {
    super.initState();
    final lines = widget.section.dialogueLines ?? [];
    _ctrs = List.generate(lines.length, (i) =>
        AnimationController(vsync: this, duration: const Duration(milliseconds: 380)));
    _fades = _ctrs.map((c) => CurvedAnimation(parent: c, curve: Curves.easeOut)).toList();
    _slides = _ctrs.asMap().entries.map((e) {
      final right = _isRight(lines[e.key].speaker);
      return Tween<Offset>(
        begin: Offset(right ? 0.2 : -0.2, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: e.value, curve: Curves.easeOut));
    }).toList();

    // Staggered entry: each bubble 140ms after the previous
    for (int i = 0; i < _ctrs.length; i++) {
      Future.delayed(Duration(milliseconds: 120 + i * 160), () {
        if (mounted) _ctrs[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (final c in _ctrs) { c.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lines = widget.section.dialogueLines ?? [];
    final hasTranslations = lines.any((l) => l.translation != null);

    return Container(
      color: const Color(0xFFF0F4FF),
      child: Column(
        children: [
          // ── Header ─────────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E3A5F), Color(0xFF2563EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('📡', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.section.title ?? 'Radyo İletişimi',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                    ),
                    if (hasTranslations)
                      GestureDetector(
                        onTap: () => setState(() => _showTranslations = !_showTranslations),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: _showTranslations
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            _showTranslations ? '🇬🇧 İngilizce' : '🇹🇷 Çeviri',
                            style: TextStyle(
                              color: _showTranslations ? const Color(0xFF1E3A5F) : Colors.white,
                              fontSize: 11, fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                if (widget.section.body != null) ...[
                  const SizedBox(height: 6),
                  Text(widget.section.body!, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ],
            ),
          ),

          // ── Chat bubbles ───────────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
              itemCount: lines.length,
              itemBuilder: (_, i) {
                final line = lines[i];
                final right = _isRight(line.speaker);
                final color = _speakerColor(line.speaker);
                final displayText = _showTranslations && line.translation != null
                    ? line.translation!
                    : line.text;

                return FadeTransition(
                  opacity: _fades[i],
                  child: SlideTransition(
                    position: _slides[i],
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: right ? MainAxisAlignment.end : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (!right) _buildAvatar(line.speaker, color),
                          if (!right) const SizedBox(width: 8),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: right ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: right ? 0 : 4,
                                    right: right ? 4 : 0,
                                    bottom: 3,
                                  ),
                                  child: Text(
                                    '${_speakerEmoji(line.speaker)} ${_speakerLabel(line.speaker)}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: color,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.68),
                                  decoration: BoxDecoration(
                                    color: right ? color : Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(16),
                                      topRight: const Radius.circular(16),
                                      bottomLeft: Radius.circular(right ? 16 : 4),
                                      bottomRight: Radius.circular(right ? 4 : 16),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: color.withValues(alpha: right ? 0.3 : 0.08),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                    border: right ? null : Border.all(color: color.withValues(alpha: 0.2)),
                                  ),
                                  child: Text(
                                    displayText,
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      color: right ? Colors.white : const Color(0xFF1E293B),
                                      height: 1.45,
                                      fontWeight: line.highlight ? FontWeight.w700 : FontWeight.w400,
                                    ),
                                  ),
                                ),
                                if (line.highlight)
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 4,
                                      left: right ? 0 : 4,
                                      right: right ? 4 : 0,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: color.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: color.withValues(alpha: 0.3)),
                                      ),
                                      child: Text(
                                        '⭐ Önemli ifade',
                                        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (right) const SizedBox(width: 8),
                          if (right) _buildAvatar(line.speaker, color),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(DialogueSpeaker speaker, Color color) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1.5),
      ),
      child: Center(
        child: Text(_speakerEmoji(speaker), style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
