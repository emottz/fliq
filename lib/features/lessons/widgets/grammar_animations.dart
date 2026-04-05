import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/lesson_content_model.dart';

/// Dispatches to the correct animation widget based on type.
class GrammarAnimationWidget extends StatelessWidget {
  final GrammarAnimationType type;
  const GrammarAnimationWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      GrammarAnimationType.passiveVoice => const _PassiveVoiceAnimation(),
      GrammarAnimationType.modalVerbs => const _ModalVerbAnimation(),
      GrammarAnimationType.conditionals => const _ConditionalAnimation(),
      GrammarAnimationType.reportedSpeech => const _ReportedSpeechAnimation(),
      _ => const SizedBox.shrink(),
    };
  }
}

// ─────────────────────────────────────────────────────────────
// PASSIVE VOICE ANIMATION
// Shows: S + V + O  →  O + be + V3
// ─────────────────────────────────────────────────────────────
class _PassiveVoiceAnimation extends StatefulWidget {
  const _PassiveVoiceAnimation();

  @override
  State<_PassiveVoiceAnimation> createState() => _PassiveVoiceAnimationState();
}

class _PassiveVoiceAnimationState extends State<_PassiveVoiceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade1; // active sentence fades out
  late Animation<double> _fade2; // passive sentence fades in
  late Animation<double> _arrow; // arrow scales in
  bool _playing = false;

  static const _active = ['The engineer', 'replaced', 'the fuel filter.'];
  static const _activeParts = ['subject', 'verb', 'object'];
  static const _passive = ['The fuel filter', 'was replaced', 'by the engineer.'];
  static const _passiveParts = ['object→subject', 'be + V3', 'by + agent'];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400));
    _fade1 = Tween<double>(begin: 1, end: 0.0).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.1, 0.45, curve: Curves.easeOut)),
    );
    _arrow = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.4, 0.6, curve: Curves.elasticOut)),
    );
    _fade2 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.55, 0.9, curve: Curves.easeIn)),
    );
    _ctrl.addStatusListener((s) {
      if (s == AnimationStatus.completed) setState(() => _playing = false);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _play() {
    _ctrl.reset();
    _ctrl.forward();
    setState(() => _playing = true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) {
          return Column(
            children: [
              // ACTIVE row
              Opacity(
                opacity: _fade1.value,
                child: _SentenceRow(
                  parts: _active,
                  labels: _activeParts,
                  colors: const [Color(0xFF7C3AED), AppColors.primary, Color(0xFF059669)],
                  tag: 'ACTIVE',
                  tagColor: const Color(0xFF7C3AED),
                ),
              ),
              // Arrow
              Transform.scale(
                scale: _arrow.value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_downward, color: AppColors.primary, size: 28),
                      const SizedBox(width: 6),
                      Text(
                        'Passive transformation',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // PASSIVE row
              Opacity(
                opacity: _fade2.value,
                child: _SentenceRow(
                  parts: _passive,
                  labels: _passiveParts,
                  colors: const [Color(0xFF059669), AppColors.primary, Color(0xFF7C3AED)],
                  tag: 'PASSIVE',
                  tagColor: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _playing ? null : _play,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: _playing ? AppColors.divider : AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_playing ? Icons.hourglass_top : Icons.play_arrow,
                          color: Colors.white, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        _playing ? 'Animating…' : 'Play Animation',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SentenceRow extends StatelessWidget {
  final List<String> parts;
  final List<String> labels;
  final List<Color> colors;
  final String tag;
  final Color tagColor;

  const _SentenceRow({
    required this.parts,
    required this.labels,
    required this.colors,
    required this.tag,
    required this.tagColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: tagColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(tag,
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(parts.length, (i) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: colors[i].withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colors[i].withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    parts[i],
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: colors[i]),
                  ),
                ),
                const SizedBox(height: 3),
                Text(labels[i],
                    style: const TextStyle(fontSize: 9, color: AppColors.textSecondary, letterSpacing: 0.5)),
              ],
            );
          }),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// MODAL VERB ANIMATION — spectrum from weak to strong
// ─────────────────────────────────────────────────────────────
class _ModalVerbAnimation extends StatefulWidget {
  const _ModalVerbAnimation();

  @override
  State<_ModalVerbAnimation> createState() => _ModalVerbAnimationState();
}

class _ModalVerbAnimationState extends State<_ModalVerbAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  int _activeIndex = 0;

  static const _modals = [
    _ModalData('can', 'Ability / Possibility', Color(0xFF0EA5E9),
        'Aircraft can fly at altitudes above 40,000 ft.'),
    _ModalData('may', 'Permission / Possibility', Color(0xFF8B5CF6),
        'The aircraft may depart after all checks are complete.'),
    _ModalData('should', 'Recommendation / Advice', Color(0xFFF59E0B),
        'Pilots should complete the pre-flight checklist carefully.'),
    _ModalData('must', 'Obligation / Necessity', Color(0xFFEF4444),
        'All maintenance records must be kept for two years.'),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _ctrl.value = 1.0;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _select(int i) async {
    await _ctrl.reverse();
    setState(() => _activeIndex = i);
    _ctrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    final modal = _modals[_activeIndex];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tap a modal verb to see its usage',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          // Spectrum bar
          Row(
            children: [
              const Text('weak', style: TextStyle(fontSize: 10, color: AppColors.textHint)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: List.generate(_modals.length, (i) {
                      final m = _modals[i];
                      final isActive = i == _activeIndex;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => _select(i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: EdgeInsets.symmetric(horizontal: i == 0 || i == _modals.length - 1 ? 0 : 3),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isActive ? m.color : m.color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: m.color.withValues(alpha: isActive ? 1.0 : 0.3),
                                width: isActive ? 2 : 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                m.verb,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  color: isActive ? Colors.white : m.color,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const Text('strong', style: TextStyle(fontSize: 10, color: AppColors.textHint)),
            ],
          ),
          const SizedBox(height: 16),
          // Detail card
          FadeTransition(
            opacity: _ctrl,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: modal.color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: modal.color.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        modal.verb.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: modal.color,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: modal.color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          modal.meaning,
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '"${modal.example}"',
                    style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModalData {
  final String verb;
  final String meaning;
  final Color color;
  final String example;
  const _ModalData(this.verb, this.meaning, this.color, this.example);
}

// ─────────────────────────────────────────────────────────────
// CONDITIONAL ANIMATION — shows IF / THEN flow
// ─────────────────────────────────────────────────────────────
class _ConditionalAnimation extends StatefulWidget {
  const _ConditionalAnimation();

  @override
  State<_ConditionalAnimation> createState() => _ConditionalAnimationState();
}

class _ConditionalAnimationState extends State<_ConditionalAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  int _activeType = 0;

  static const _types = [
    _CondType(
      label: 'Type 1',
      subtitle: 'Real / Possible',
      color: Color(0xFF059669),
      ifClause: 'If + Present Simple',
      ifExample: 'If the oil pressure drops',
      thenClause: 'will / must + base verb',
      thenExample: 'the pilot will declare an emergency.',
    ),
    _CondType(
      label: 'Type 2',
      subtitle: 'Hypothetical',
      color: AppColors.primary,
      ifClause: 'If + Past Simple',
      ifExample: 'If the engine failed',
      thenClause: 'would / could + base verb',
      thenExample: 'the crew would follow the ECAM.',
    ),
    _CondType(
      label: 'Type 3',
      subtitle: 'Impossible (past)',
      color: Color(0xFFEF4444),
      ifClause: 'If + Past Perfect',
      ifExample: 'If maintenance had been done',
      thenClause: 'would have + past participle',
      thenExample: 'the fault would not have occurred.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _ctrl.value = 1.0;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _select(int i) async {
    await _ctrl.reverse();
    setState(() => _activeType = i);
    _ctrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    final t = _types[_activeType];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          // Tab selector
          Row(
            children: List.generate(_types.length, (i) {
              final type = _types[i];
              final active = i == _activeType;
              return Expanded(
                child: GestureDetector(
                  onTap: () => _select(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(right: i < _types.length - 1 ? 8 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? type.color : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: active ? type.color : AppColors.divider,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          type.label,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: active ? Colors.white : AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          type.subtitle,
                          style: TextStyle(
                            fontSize: 9,
                            color: active ? Colors.white70 : AppColors.textHint,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          FadeTransition(
            opacity: _ctrl,
            child: Column(
              children: [
                // IF block
                _ConditionalBlock(
                  prefix: 'IF',
                  structure: t.ifClause,
                  example: t.ifExample,
                  color: t.color,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Icon(Icons.arrow_downward, color: t.color, size: 24),
                ),
                // THEN block
                _ConditionalBlock(
                  prefix: 'THEN',
                  structure: t.thenClause,
                  example: t.thenExample,
                  color: t.color.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConditionalBlock extends StatelessWidget {
  final String prefix;
  final String structure;
  final String example;
  final Color color;

  const _ConditionalBlock({
    required this.prefix,
    required this.structure,
    required this.example,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              prefix,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(structure,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
                const SizedBox(height: 4),
                Text(
                  '"$example"',
                  style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CondType {
  final String label;
  final String subtitle;
  final Color color;
  final String ifClause;
  final String ifExample;
  final String thenClause;
  final String thenExample;
  const _CondType({
    required this.label,
    required this.subtitle,
    required this.color,
    required this.ifClause,
    required this.ifExample,
    required this.thenClause,
    required this.thenExample,
  });
}

// ─────────────────────────────────────────────────────────────
// REPORTED SPEECH ANIMATION — tense backshift
// ─────────────────────────────────────────────────────────────
class _ReportedSpeechAnimation extends StatefulWidget {
  const _ReportedSpeechAnimation();

  @override
  State<_ReportedSpeechAnimation> createState() => _ReportedSpeechAnimationState();
}

class _ReportedSpeechAnimationState extends State<_ReportedSpeechAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _slide;
  int _step = 0; // 0=direct, 1=transform, 2=reported

  static const _pairs = [
    _ShiftPair('is', 'was', 'present → past'),
    _ShiftPair('will', 'would', 'will → would'),
    _ShiftPair('can', 'could', 'can → could'),
    _ShiftPair('must', 'had to', 'must → had to'),
    _ShiftPair('has found', 'had found', 'present perfect → past perfect'),
  ];

  int _pairIndex = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _slide = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _next() {
    setState(() => _pairIndex = (_pairIndex + 1) % _pairs.length);
    _ctrl.reset();
    _ctrl.forward();
    setState(() => _step = 1);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _step = 2);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pair = _pairs[_pairIndex];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const Text('Tense Backshift', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 4),
          const Text('Tap "Next" to see how tenses shift in reported speech',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _TenseBox(
                  label: 'Direct Speech',
                  verb: pair.direct,
                  color: const Color(0xFF7C3AED),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: AnimatedBuilder(
                  animation: _slide,
                  builder: (_, __) => Transform.scale(
                    scale: 0.6 + _slide.value * 0.4,
                    child: const Icon(Icons.arrow_forward, color: AppColors.primary, size: 28),
                  ),
                ),
              ),
              Expanded(
                child: _TenseBox(
                  label: 'Reported Speech',
                  verb: pair.reported,
                  color: AppColors.primary,
                  highlighted: _step >= 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              pair.rule,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _next,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.skip_next, color: Colors.white, size: 18),
                  SizedBox(width: 6),
                  Text('Next Tense', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TenseBox extends StatelessWidget {
  final String label;
  final String verb;
  final Color color;
  final bool highlighted;

  const _TenseBox({
    required this.label,
    required this.verb,
    required this.color,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: highlighted ? color.withValues(alpha: 0.12) : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlighted ? color : AppColors.divider,
          width: highlighted ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Text(
            verb,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShiftPair {
  final String direct;
  final String reported;
  final String rule;
  const _ShiftPair(this.direct, this.reported, this.rule);
}
