import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/lesson_content_model.dart';

/// Dispatches to the correct animation widget based on type.
class GrammarAnimationWidget extends StatelessWidget {
  final GrammarAnimationType type;
  final LessonSection? section;
  const GrammarAnimationWidget({super.key, required this.type, this.section});

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      GrammarAnimationType.passiveVoice    => const _PassiveVoiceAnimation(),
      GrammarAnimationType.modalVerbs      => const _ModalVerbAnimation(),
      GrammarAnimationType.conditionals    => const _ConditionalAnimation(),
      GrammarAnimationType.reportedSpeech  => const _ReportedSpeechAnimation(),
      GrammarAnimationType.tensesTimeline  => const _TensesTimelineAnimation(),
      GrammarAnimationType.sentenceStructure => _SentenceStructureAnimation(section: section),
      GrammarAnimationType.wordBuilder     => _WordBuilderAnimation(section: section),
      GrammarAnimationType.compareContrast => _CompareContrastAnimation(section: section),
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
                        'Edilgen dönüşüm',
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
                        _playing ? 'Oynatılıyor…' : 'Animasyonu Oynat',
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
          const Text('Kullanımını görmek için modal fiile dokun',
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
          // Detail card — slide + fade
          SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, -0.12), end: Offset.zero)
                .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut)),
            child: FadeTransition(
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
      label: 'Tip 1',
      subtitle: 'Gerçek / Mümkün',
      color: Color(0xFF059669),
      ifClause: 'If + Present Simple',
      ifExample: 'If the oil pressure drops',
      thenClause: 'will / must + base verb',
      thenExample: 'the pilot will declare an emergency.',
    ),
    _CondType(
      label: 'Tip 2',
      subtitle: 'Varsayımsal',
      color: AppColors.primary,
      ifClause: 'If + Past Simple',
      ifExample: 'If the engine failed',
      thenClause: 'would / could + base verb',
      thenExample: 'the crew would follow the ECAM.',
    ),
    _CondType(
      label: 'Tip 3',
      subtitle: 'İmkânsız (geçmiş)',
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
          Column(
            children: [
              // IF block — animates slightly before THEN
              SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
                    .animate(CurvedAnimation(parent: _ctrl,
                        curve: const Interval(0.0, 0.7, curve: Curves.easeOut))),
                child: FadeTransition(
                  opacity: CurvedAnimation(parent: _ctrl,
                      curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
                  child: _ConditionalBlock(
                    prefix: 'IF',
                    structure: t.ifClause,
                    example: t.ifExample,
                    color: t.color,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: FadeTransition(
                  opacity: CurvedAnimation(parent: _ctrl,
                      curve: const Interval(0.3, 0.8, curve: Curves.easeOut)),
                  child: Icon(Icons.arrow_downward, color: t.color, size: 24),
                ),
              ),
              // THEN block — delayed
              SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
                    .animate(CurvedAnimation(parent: _ctrl,
                        curve: const Interval(0.3, 1.0, curve: Curves.easeOut))),
                child: FadeTransition(
                  opacity: CurvedAnimation(parent: _ctrl,
                      curve: const Interval(0.3, 0.9, curve: Curves.easeOut)),
                  child: _ConditionalBlock(
                    prefix: 'THEN',
                    structure: t.thenClause,
                    example: t.thenExample,
                    color: t.color.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
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
          const Text('Zaman Geriye Kayması', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 4),
          const Text('Dolaylı anlatımda zamanların nasıl kaydığını görmek için "İleri"ye dokun',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _TenseBox(
                  label: 'Doğrudan Konuşma',
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
                  label: 'Dolaylı Anlatım',
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
                  Text('İleri', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
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
        boxShadow: highlighted
            ? [BoxShadow(color: color.withOpacity(0.30), blurRadius: 10, spreadRadius: 1)]
            : null,
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

// ─────────────────────────────────────────────────────────────
// TENSES TIMELINE ANIMATION
// Interactive timeline: Past ← Present → Future
// Tap each zone to see aviation examples
// ─────────────────────────────────────────────────────────────

class _TensesTimelineAnimation extends StatefulWidget {
  const _TensesTimelineAnimation();

  @override
  State<_TensesTimelineAnimation> createState() => _TensesTimelineAnimationState();
}

class _TensesTimelineAnimationState extends State<_TensesTimelineAnimation>
    with TickerProviderStateMixin {
  int _selected = 1; // 0=past, 1=present, 2=future
  late AnimationController _slideCtrl;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulse;

  static const _tenses = [
    _TenseZone(
      label: 'PAST',
      emoji: '⏮',
      color: Color(0xFF7C3AED),
      title: 'Geçmiş Zaman',
      subtitle: 'Past Simple / Past Perfect',
      examples: [
        ('The aircraft landed safely.', 'Uçak güvenli indi.'),
        ('The crew had completed the checklist.', 'Ekip kontrol listesini tamamlamıştı.'),
        ('ATC cleared the flight for takeoff.', 'ATC kalkış için izin verdi.'),
      ],
    ),
    _TenseZone(
      label: 'NOW',
      emoji: '▶',
      color: Color(0xFF2563EB),
      title: 'Şimdiki Zaman',
      subtitle: 'Present Simple / Present Continuous',
      examples: [
        ('The aircraft is climbing to FL350.', 'Uçak FL350\'ye tırmanıyor.'),
        ('Pilots use standard phraseology.', 'Pilotlar standart iletişim kalıpları kullanır.'),
        ('We are holding at waypoint GOLAX.', 'GOLAX noktasında bekliyoruz.'),
      ],
    ),
    _TenseZone(
      label: 'FUTURE',
      emoji: '⏭',
      color: Color(0xFF059669),
      title: 'Gelecek Zaman',
      subtitle: 'Will / Going to / Present Continuous',
      examples: [
        ('The flight will depart at 14:30.', 'Uçuş saat 14:30\'da kalkacak.'),
        ('We are going to divert to Istanbul.', 'İstanbul\'a sapacağız.'),
        ('Maintenance will inspect the engine.', 'Bakım ekibi motoru inceleyecek.'),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 320));
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _pulse = Tween<double>(begin: 1.0, end: 1.06)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _slideCtrl.forward();
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _select(int i) {
    if (_selected == i) return;
    _slideCtrl.forward(from: 0);
    setState(() => _selected = i);
  }

  @override
  Widget build(BuildContext context) {
    final zone = _tenses[_selected];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Timeline bar ──────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 3))],
              ),
              child: Row(
                children: [
                  // Arrow left
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(Icons.arrow_back_rounded, size: 16, color: AppColors.textHint),
                  ),
                  // Timeline dots
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Line
                        Container(height: 2, color: AppColors.divider),
                        // Zones
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(3, (i) {
                            final z = _tenses[i];
                            final sel = _selected == i;
                            return GestureDetector(
                              onTap: () => _select(i),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: sel ? z.color : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: sel ? z.color : AppColors.divider, width: 1.5),
                                  boxShadow: sel ? [BoxShadow(color: z.color.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))] : null,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(z.emoji, style: const TextStyle(fontSize: 14)),
                                    const SizedBox(height: 2),
                                    Text(z.label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: sel ? Colors.white : AppColors.textSecondary)),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  // Arrow right
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.textHint),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Selected zone card ────────────────────────────────────────────
            AnimatedBuilder(
              animation: _slideCtrl,
              builder: (_, child) => FadeTransition(
                opacity: _slideCtrl,
                child: SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
                      .animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut)),
                  child: child,
                ),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: zone.color.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: zone.color.withValues(alpha: 0.25), width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: zone.color, borderRadius: BorderRadius.circular(12)),
                          child: Text(zone.emoji, style: const TextStyle(fontSize: 20)),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(zone.title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: zone.color)),
                            Text(zone.subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ...zone.examples.map((ex) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: zone.color.withValues(alpha: 0.15)),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ex.$1, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: zone.color)),
                            const SizedBox(height: 4),
                            Text(ex.$2, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Hint ─────────────────────────────────────────────────────────
            ScaleTransition(
              scale: _pulse,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: zone.color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: zone.color.withValues(alpha: 0.25)),
                ),
                child: Text(
                  '← Zaman dilimleri arasında geç →',
                  style: TextStyle(fontSize: 11, color: zone.color, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TenseZone {
  final String label;
  final String emoji;
  final Color color;
  final String title;
  final String subtitle;
  final List<(String, String)> examples;

  const _TenseZone({
    required this.label,
    required this.emoji,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.examples,
  });
}

// ─────────────────────────────────────────────────────────────
// SENTENCE STRUCTURE ANIMATION
// Color-coded grammar breakdown: Subject/Verb/Object/Adverbial
// ─────────────────────────────────────────────────────────────

class _SentenceStructureAnimation extends StatefulWidget {
  final LessonSection? section;
  const _SentenceStructureAnimation({this.section});
  @override
  State<_SentenceStructureAnimation> createState() => _SentenceStructureAnimationState();
}

class _SentenceStructureAnimationState extends State<_SentenceStructureAnimation>
    with TickerProviderStateMixin {
  int _sentenceIdx = 0;
  late AnimationController _ctrl;
  late List<AnimationController> _tokenCtrs;

  static const _roleColors = {
    'subject':     Color(0xFF2563EB),
    'verb':        Color(0xFF16A34A),
    'object':      Color(0xFFD97706),
    'adverbial':   Color(0xFF7C3AED),
    'complement':  Color(0xFFDC2626),
  };
  static const _roleIcons = {
    'subject':    '👤',
    'verb':       '⚡',
    'object':     '📦',
    'adverbial':  '📍',
    'complement': '🔗',
  };

  // Default sentences if no data provided
  static const _defaultSentences = [
    [
      SentenceToken('The captain', 'subject', 'Özne'),
      SentenceToken('declared', 'verb', 'Fiil'),
      SentenceToken('an emergency', 'object', 'Nesne'),
      SentenceToken('at FL220', 'adverbial', 'Zarflık'),
    ],
    [
      SentenceToken('ATC', 'subject', 'Özne'),
      SentenceToken('cleared', 'verb', 'Fiil'),
      SentenceToken('the aircraft', 'object', 'Nesne'),
      SentenceToken('for landing', 'adverbial', 'Zarflık'),
    ],
    [
      SentenceToken('The fuel filter', 'subject', 'Özne'),
      SentenceToken('was replaced', 'verb', 'Fiil (Edilgen)'),
      SentenceToken('by the engineer', 'adverbial', 'Zarflık'),
    ],
    [
      SentenceToken('Visibility', 'subject', 'Özne'),
      SentenceToken('dropped', 'verb', 'Fiil'),
      SentenceToken('below 500 metres', 'complement', 'Tümleç'),
      SentenceToken('rapidly', 'adverbial', 'Zarflık'),
    ],
  ];

  List<List<SentenceToken>> get _sentences =>
      widget.section?.sentenceTokens ?? _defaultSentences;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _buildTokenControllers();
    _startEntry();
  }

  void _buildTokenControllers() {
    final tokens = _sentences[_sentenceIdx];
    _tokenCtrs = List.generate(tokens.length, (i) =>
        AnimationController(vsync: this, duration: const Duration(milliseconds: 340)));
  }

  void _startEntry() {
    for (int i = 0; i < _tokenCtrs.length; i++) {
      Future.delayed(Duration(milliseconds: 150 + i * 180), () {
        if (mounted) _tokenCtrs[i].forward();
      });
    }
  }

  void _nextSentence() {
    for (final c in _tokenCtrs) { c.dispose(); }
    setState(() => _sentenceIdx = (_sentenceIdx + 1) % _sentences.length);
    _buildTokenControllers();
    _startEntry();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    for (final c in _tokenCtrs) { c.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = _sentences[_sentenceIdx];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Legend
            Wrap(
              spacing: 8, runSpacing: 6,
              alignment: WrapAlignment.center,
              children: _roleColors.entries.map((e) {
                final icon = _roleIcons[e.key] ?? '';
                final labels = {'subject':'Özne','verb':'Fiil','object':'Nesne','adverbial':'Zarflık','complement':'Tümleç'};
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: e.value.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: e.value.withValues(alpha: 0.35)),
                  ),
                  child: Text('$icon ${labels[e.key]}',
                      style: TextStyle(fontSize: 11, color: e.value, fontWeight: FontWeight.w700)),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Sentence card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 4))],
              ),
              child: Wrap(
                spacing: 8, runSpacing: 10,
                alignment: WrapAlignment.center,
                children: List.generate(tokens.length, (i) {
                  final token = tokens[i];
                  final color = _roleColors[token.role] ?? AppColors.primary;
                  final fade = CurvedAnimation(parent: _tokenCtrs[i], curve: Curves.easeOut);
                  final slide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
                      .animate(CurvedAnimation(parent: _tokenCtrs[i], curve: Curves.elasticOut));
                  return FadeTransition(
                    opacity: fade,
                    child: SlideTransition(
                      position: slide,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: color.withValues(alpha: 0.45), width: 1.5),
                            ),
                            child: Text(token.word,
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: color)),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${_roleIcons[token.role]} ${token.label}',
                              style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 16),

            // Next sentence button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${_sentenceIdx + 1} / ${_sentences.length}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _nextSentence,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight]),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Sonraki cümle', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// WORD BUILDER ANIMATION
// Aviation technical words broken into morphemes with animation
// ─────────────────────────────────────────────────────────────

class _WordBuilderAnimation extends StatefulWidget {
  final LessonSection? section;
  const _WordBuilderAnimation({this.section});
  @override
  State<_WordBuilderAnimation> createState() => _WordBuilderAnimationState();
}

class _WordBuilderAnimationState extends State<_WordBuilderAnimation>
    with TickerProviderStateMixin {
  int _wordIdx = 0;
  late List<AnimationController> _morphCtrs;
  late AnimationController _assembleCtrl;
  bool _assembled = false;

  static const _morphColors = {
    'prefix': Color(0xFFDC2626),
    'root':   Color(0xFF2563EB),
    'suffix': Color(0xFF16A34A),
  };

  static const _defaultWords = [
    ('AIRWORTHINESS', [
      WordMorpheme('AIR', 'root', 'hava'),
      WordMorpheme('WORTH', 'root', 'değer'),
      WordMorpheme('I', 'suffix', 'bağlaç'),
      WordMorpheme('NESS', 'suffix', 'durum/nitelik'),
    ]),
    ('UNSERVICEABLE', [
      WordMorpheme('UN', 'prefix', 'olumsuzluk'),
      WordMorpheme('SERVICE', 'root', 'hizmet'),
      WordMorpheme('ABLE', 'suffix', 'yeteneğinde'),
    ]),
    ('PRESSURIZATION', [
      WordMorpheme('PRESSURE', 'root', 'basınç'),
      WordMorpheme('IZA', 'suffix', 'dönüşüm'),
      WordMorpheme('TION', 'suffix', 'eylem adı'),
    ]),
    ('DECOMPRESSION', [
      WordMorpheme('DE', 'prefix', 'ters/geri alma'),
      WordMorpheme('COMPRESS', 'root', 'sıkıştırma'),
      WordMorpheme('ION', 'suffix', 'eylem adı'),
    ]),
    ('MALFUNCTIONING', [
      WordMorpheme('MAL', 'prefix', 'kötü/hatalı'),
      WordMorpheme('FUNCTION', 'root', 'işlev'),
      WordMorpheme('ING', 'suffix', 'devam eden eylem'),
    ]),
  ];

  List<(String, List<WordMorpheme>)> get _words =>
      widget.section?.wordMorphemes ?? _defaultWords;

  @override
  void initState() {
    super.initState();
    _assembleCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _buildMorphControllers();
    _startEntry();
  }

  void _buildMorphControllers() {
    _assembled = false;
    final morphs = _words[_wordIdx].$2;
    _morphCtrs = List.generate(morphs.length, (i) =>
        AnimationController(vsync: this, duration: const Duration(milliseconds: 400)));
  }

  void _startEntry() {
    _assembleCtrl.reset();
    for (int i = 0; i < _morphCtrs.length; i++) {
      _morphCtrs[i].reset();
      Future.delayed(Duration(milliseconds: 200 + i * 250), () {
        if (mounted) _morphCtrs[i].forward();
      });
    }
    Future.delayed(Duration(milliseconds: 200 + _morphCtrs.length * 250 + 200), () {
      if (mounted) {
        setState(() => _assembled = true);
        _assembleCtrl.forward();
      }
    });
  }

  void _nextWord() {
    for (final c in _morphCtrs) { c.dispose(); }
    setState(() => _wordIdx = (_wordIdx + 1) % _words.length);
    _buildMorphControllers();
    _startEntry();
  }

  @override
  void dispose() {
    _assembleCtrl.dispose();
    for (final c in _morphCtrs) { c.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (word, morphemes) = _words[_wordIdx];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _morphColors.entries.map((e) {
                final labels = {'prefix': 'Önek', 'root': 'Kök', 'suffix': 'Sonek'};
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 12, height: 12,
                          decoration: BoxDecoration(color: e.value, shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                      Text(labels[e.key]!, style: TextStyle(fontSize: 11, color: e.value, fontWeight: FontWeight.w700)),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Morpheme cards — staggered entry
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(morphemes.length, (i) {
                final m = morphemes[i];
                final color = _morphColors[m.type] ?? AppColors.primary;
                final slide = Tween<Offset>(begin: const Offset(0, -0.8), end: Offset.zero)
                    .animate(CurvedAnimation(parent: _morphCtrs[i], curve: Curves.bounceOut));
                return SlideTransition(
                  position: slide,
                  child: FadeTransition(
                    opacity: _morphCtrs[i],
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: color, width: 2),
                            ),
                            child: Text(m.part,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: color, letterSpacing: 1)),
                          ),
                          const SizedBox(height: 4),
                          Text(m.meaning,
                              style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            // Assembled word
            if (_assembled)
              FadeTransition(
                opacity: _assembleCtrl,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.7, end: 1.0)
                      .animate(CurvedAnimation(parent: _assembleCtrl, curve: Curves.elasticOut)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFF1E3A5F), AppColors.primary],
                          begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 16, offset: const Offset(0, 5))],
                    ),
                    child: Text(word,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w900,
                            color: Colors.white, letterSpacing: 2)),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // Navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${_wordIdx + 1} / ${_words.length}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _nextWord,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E3A5F),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Sonraki kelime', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// COMPARE CONTRAST ANIMATION
// Two-panel side-by-side comparison with staggered row reveal
// ─────────────────────────────────────────────────────────────

class _CompareContrastAnimation extends StatefulWidget {
  final LessonSection? section;
  const _CompareContrastAnimation({this.section});
  @override
  State<_CompareContrastAnimation> createState() => _CompareContrastAnimationState();
}

class _CompareContrastAnimationState extends State<_CompareContrastAnimation>
    with TickerProviderStateMixin {
  late List<AnimationController> _rowCtrs;
  late AnimationController _headerCtrl;

  static const _defaultContrast = ContrastPair(
    leftLabel: 'MAYDAY',
    rightLabel: 'PAN-PAN',
    leftColor: Color(0xFFDC2626),
    rightColor: Color(0xFFD97706),
    leftEmoji: '🚨',
    rightEmoji: '⚠️',
    rows: [
      ('Hayati tehlike mevcut', 'Acil durum — can tehlikesi yok'),
      ('3 kez tekrarlanır', '3 kez tekrarlanır'),
      ('Motor yangını, çarpışma riski', 'Yakıt azlığı, tıbbi durum'),
      ('En yüksek öncelik — tüm trafik kesilir', 'Yüksek öncelik'),
      ('"MAYDAY MAYDAY MAYDAY"', '"PAN-PAN PAN-PAN PAN-PAN"'),
      ('Fransızca: "m\'aider" (yardım et)', 'Fransızca: "panne" (arıza)'),
    ],
  );

  ContrastPair get _pair => widget.section?.contrastPair ?? _defaultContrast;

  @override
  void initState() {
    super.initState();
    final rows = _pair.rows;
    _headerCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..forward();
    _rowCtrs = List.generate(rows.length, (i) =>
        AnimationController(vsync: this, duration: const Duration(milliseconds: 350)));
    for (int i = 0; i < _rowCtrs.length; i++) {
      Future.delayed(Duration(milliseconds: 400 + i * 160), () {
        if (mounted) _rowCtrs[i].forward();
      });
    }
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    for (final c in _rowCtrs) { c.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pair = _pair;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Headers
            FadeTransition(
              opacity: _headerCtrl,
              child: Row(
                children: [
                  _buildHeader(pair.leftLabel, pair.leftColor, pair.leftEmoji, Alignment.centerLeft),
                  const SizedBox(width: 8),
                  _buildHeader(pair.rightLabel, pair.rightColor, pair.rightEmoji, Alignment.centerRight),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Rows
            ...List.generate(pair.rows.length, (i) {
              final (left, right) = pair.rows[i];
              final leftSlide = Tween<Offset>(begin: const Offset(-0.4, 0), end: Offset.zero)
                  .animate(CurvedAnimation(parent: _rowCtrs[i], curve: Curves.easeOut));
              final rightSlide = Tween<Offset>(begin: const Offset(0.4, 0), end: Offset.zero)
                  .animate(CurvedAnimation(parent: _rowCtrs[i], curve: Curves.easeOut));

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SlideTransition(
                        position: leftSlide,
                        child: FadeTransition(
                          opacity: _rowCtrs[i],
                          child: _buildCell(left, pair.leftColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    // VS divider
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          width: 24, height: 24,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: const Center(
                            child: Text('vs', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: AppColors.textHint)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: SlideTransition(
                        position: rightSlide,
                        child: FadeTransition(
                          opacity: _rowCtrs[i],
                          child: _buildCell(right, pair.rightColor),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String label, Color color, String emoji, Alignment align) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildCell(String text, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(text,
          style: TextStyle(fontSize: 12, color: color.withValues(alpha: 0.9), fontWeight: FontWeight.w600, height: 1.4)),
    );
  }
}
