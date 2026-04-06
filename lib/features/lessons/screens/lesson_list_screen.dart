import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/lessons/lesson_content_data.dart';
import '../../../data/models/lesson_content_model.dart';
import '../../../data/models/user_profile_model.dart';
import '../../../shared/providers/app_providers.dart';

class LessonListScreen extends ConsumerStatefulWidget {
  const LessonListScreen({super.key});

  @override
  ConsumerState<LessonListScreen> createState() => _LessonListScreenState();
}

class _LessonListScreenState extends ConsumerState<LessonListScreen> {
  int _refreshKey = 0;
  bool _completing = false;

  static const _minLevels = {
    // Başlangıç
    'grammar_1': ProficiencyLevel.beginner,
    'grammar_2': ProficiencyLevel.beginner,
    'grammar_5': ProficiencyLevel.beginner,
    'vocab_1': ProficiencyLevel.beginner,
    'vocab_3': ProficiencyLevel.beginner,
    'vocab_4': ProficiencyLevel.beginner,
    'fill_1': ProficiencyLevel.beginner,
    'fill_2': ProficiencyLevel.beginner,
    // Temel
    'grammar_3': ProficiencyLevel.elementary,
    'vocab_2': ProficiencyLevel.elementary,
    'vocab_5': ProficiencyLevel.elementary,
    'translation_1': ProficiencyLevel.elementary,
    'translation_2': ProficiencyLevel.elementary,
    'fill_3': ProficiencyLevel.elementary,
    'reading_3': ProficiencyLevel.elementary,
    // Orta
    'reading_1': ProficiencyLevel.intermediate,
    'grammar_4': ProficiencyLevel.intermediate,
    'grammar_6': ProficiencyLevel.intermediate,
    'vocab_6': ProficiencyLevel.intermediate,
    'reading_4': ProficiencyLevel.intermediate,
    'fill_4': ProficiencyLevel.intermediate,
    'translation_3': ProficiencyLevel.intermediate,
    'completion_1': ProficiencyLevel.intermediate,
    // İleri
    'grammar_7': ProficiencyLevel.advanced,
    'vocab_7': ProficiencyLevel.advanced,
    'reading_5': ProficiencyLevel.advanced,
    'reading_2': ProficiencyLevel.advanced,
    'completion_3': ProficiencyLevel.advanced,
    'fill_5': ProficiencyLevel.advanced,
    'translation_4': ProficiencyLevel.advanced,
    'reading_6': ProficiencyLevel.advanced,
    'completion_2': ProficiencyLevel.advanced,
  };

  static const _levelGroups = [
    (ProficiencyLevel.beginner, 'Başlangıç', '🌱', Color(0xFF10B981)),
    (ProficiencyLevel.elementary, 'Temel', '✈️', Color(0xFF3B82F6)),
    (ProficiencyLevel.intermediate, 'Orta', '🛫', Color(0xFF8B5CF6)),
    (ProficiencyLevel.advanced, 'İleri', '🏆', Color(0xFFF59E0B)),
  ];

  static ProficiencyLevel? _nextLevel(ProficiencyLevel current) {
    switch (current) {
      case ProficiencyLevel.beginner:
        return ProficiencyLevel.elementary;
      case ProficiencyLevel.elementary:
        return ProficiencyLevel.intermediate;
      case ProficiencyLevel.intermediate:
        return ProficiencyLevel.advanced;
      case ProficiencyLevel.advanced:
        return null;
    }
  }

  static String _levelLabel(ProficiencyLevel level) => switch (level) {
        ProficiencyLevel.beginner => 'Başlangıç',
        ProficiencyLevel.elementary => 'Temel',
        ProficiencyLevel.intermediate => 'Orta',
        ProficiencyLevel.advanced => 'İleri',
      };

  bool _isUnlocked(ProficiencyLevel userLevel, int idx, List<LessonContent> all, Set<String> completed) {
    if (idx == 0) return true;
    final prev = all[idx - 1];
    if (!completed.contains(prev.id)) return false;
    final minLevel = _minLevels[all[idx].id] ?? ProficiencyLevel.beginner;
    return userLevel.index >= minLevel.index;
  }

  Future<void> _completeLeague(ProficiencyLevel userLevel, List<LessonContent> lessons) async {
    if (_completing) return;
    setState(() => _completing = true);

    final repo = ref.read(userRepositoryProvider);
    // Mevcut ligin tüm derslerini tamamla
    for (final lesson in lessons) {
      final minLevel = _minLevels[lesson.id] ?? ProficiencyLevel.beginner;
      if (minLevel == userLevel) {
        await repo.markLessonComplete(lesson.id);
      }
    }

    // Bir sonraki seviyeye geç
    final next = _nextLevel(userLevel);
    if (next != null) {
      final profile = await repo.getProfile();
      if (profile != null) {
        await ref
            .read(userProfileProvider.notifier)
            .saveLevel(profile.copyWith(level: next));
      }
    }

    if (mounted) {
      setState(() {
        _completing = false;
        _refreshKey++;
      });

      final next = _nextLevel(userLevel);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            next != null
                ? '${_levelLabel(userLevel)} ligi tamamlandı! ${_levelLabel(next)} seviyesine geçildi.'
                : 'Tüm dersler tamamlandı! 🎉',
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);

    return profileAsync.when(
      data: (profile) {
        final level = profile?.level ?? ProficiencyLevel.beginner;
        final lessons = LessonContentData.all;

        return FutureBuilder<Set<String>>(
          key: ValueKey(_refreshKey),
          future: ref.read(userRepositoryProvider).getCompletedLessons(),
          builder: (context, snap) {
            final completed = snap.data ?? {};
            final doneCount = completed.length;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // ── Başlık ────────────────────────────────────
                      _ProgressHeader(
                        level: level,
                        done: doneCount,
                        total: lessons.length,
                        levelLabel: _levelLabel(level),
                      ),

                      const SizedBox(height: 12),

                      // ── Ligi Tamamla Butonu ───────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _CompleteLeagueButton(
                          levelLabel: _levelLabel(level),
                          isLoading: _completing,
                          onTap: () => _completeLeague(level, lessons),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ── Yol ──────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: _buildPath(context, lessons, level, completed),
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      error: (_, __) => const SizedBox(),
    );
  }

  List<Widget> _buildPath(
    BuildContext context,
    List<LessonContent> lessons,
    ProficiencyLevel userLevel,
    Set<String> completed,
  ) {
    final widgets = <Widget>[];

    ProficiencyLevel? lastGroupLevel;

    for (int i = 0; i < lessons.length; i++) {
      final lesson = lessons[i];
      final isDone = completed.contains(lesson.id);
      final isUnlocked = isDone || _isUnlocked(userLevel, i, lessons, completed);
      final isActive = isUnlocked && !isDone;
      final isNextUp = isActive &&
          (i == 0 || completed.contains(lessons[i - 1].id));

      final minLevel = _minLevels[lesson.id] ?? ProficiencyLevel.beginner;
      if (minLevel != lastGroupLevel) {
        lastGroupLevel = minLevel;
        final groupInfo = _levelGroups.firstWhere((g) => g.$1 == minLevel);
        final isGroupLocked = userLevel.index < minLevel.index;
        widgets.add(_LevelSectionHeader(
          emoji: groupInfo.$3,
          label: groupInfo.$2,
          color: groupInfo.$4,
          isLocked: isGroupLocked,
        ));
      }

      // Bağlantı çizgisi (ilk düğüm hariç)
      if (i > 0) {
        widgets.add(_Connector(done: completed.contains(lessons[i - 1].id)));
      }

      widgets.add(_LessonNode(
        lesson: lesson,
        isDone: isDone,
        isUnlocked: isUnlocked,
        isNextUp: isNextUp,
        index: i,
        onTap: isUnlocked ? () => context.go('/lesson/${lesson.id}') : null,
      ));
    }

    return widgets;
  }
}

// ── Ligi tamamla butonu ───────────────────────────────────────────────────────

class _CompleteLeagueButton extends StatelessWidget {
  final String levelLabel;
  final bool isLoading;
  final VoidCallback onTap;

  const _CompleteLeagueButton({
    required this.levelLabel,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7ED),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFFED7AA), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Color(0xFFEA580C),
                ),
              )
            else
              const Text('⚡', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Text(
              isLoading
                  ? 'Tamamlanıyor...'
                  : '$levelLabel ligini tamamla (Test)',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFFEA580C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── İlerleme başlığı ─────────────────────────────────────────────────────────

class _ProgressHeader extends StatelessWidget {
  final ProficiencyLevel level;
  final int done;
  final int total;
  final String levelLabel;

  const _ProgressHeader({
    required this.level,
    required this.done,
    required this.total,
    required this.levelLabel,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? done / total : 0.0;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Öğrenme Yolun', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  levelLabel,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                '$done',
                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
              ),
              Text(
                ' / $total ders',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: pct),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOut,
              builder: (_, v, __) => LinearProgressIndicator(
                value: v,
                minHeight: 8,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Seviye bölüm başlığı ──────────────────────────────────────────────────────

class _LevelSectionHeader extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;
  final bool isLocked;

  const _LevelSectionHeader({
    required this.emoji,
    required this.label,
    required this.color,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = isLocked ? AppColors.textHint : color;
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                isLocked ? '🔒' : emoji,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: effectiveColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Divider(color: effectiveColor.withOpacity(0.3), thickness: 1),
              ),
              if (isLocked) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$label seviyesi gerekli',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textHint,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ── Bağlantı çizgisi ──────────────────────────────────────────────────────────

class _Connector extends StatelessWidget {
  final bool done;
  const _Connector({required this.done});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: const Size(2, 32),
        painter: _ConnectorPainter(done: done),
      ),
    );
  }
}

class _ConnectorPainter extends CustomPainter {
  final bool done;
  _ConnectorPainter({required this.done});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = done ? AppColors.success.withOpacity(0.6) : AppColors.divider
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    if (done) {
      canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);
    } else {
      const dashH = 5.0;
      const gapH = 4.0;
      double y = 0;
      while (y < size.height) {
        canvas.drawLine(
          Offset(size.width / 2, y),
          Offset(size.width / 2, (y + dashH).clamp(0, size.height)),
          paint,
        );
        y += dashH + gapH;
      }
    }
  }

  @override
  bool shouldRepaint(_ConnectorPainter old) => old.done != done;
}

// ── Ders düğümü ───────────────────────────────────────────────────────────────

class _LessonNode extends StatefulWidget {
  final LessonContent lesson;
  final bool isDone;
  final bool isUnlocked;
  final bool isNextUp;
  final int index;
  final VoidCallback? onTap;

  const _LessonNode({
    required this.lesson,
    required this.isDone,
    required this.isUnlocked,
    required this.isNextUp,
    required this.index,
    this.onTap,
  });

  @override
  State<_LessonNode> createState() => _LessonNodeState();
}

class _LessonNodeState extends State<_LessonNode>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
    if (widget.isNextUp) _pulse.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  Color get _nodeColor {
    if (widget.isDone) return AppColors.success;
    if (widget.isUnlocked) return AppColors.primary;
    return const Color(0xFFD1D5DB);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        children: [
          // Düğüm
          AnimatedBuilder(
            animation: _scale,
            builder: (_, child) => Transform.scale(
              scale: widget.isNextUp ? _scale.value : 1.0,
              child: child,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Sonraki ders için parlama halkası
                if (widget.isNextUp)
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.15),
                    ),
                  ),
                // Ana düğüm
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _nodeColor,
                    boxShadow: widget.isUnlocked
                        ? [
                            BoxShadow(
                              color: _nodeColor.withOpacity(0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : null,
                  ),
                  child: Center(
                    child: widget.isDone
                        ? const Icon(Icons.check_rounded, color: Colors.white, size: 32)
                        : widget.isUnlocked
                            ? Text(widget.lesson.emoji,
                                style: const TextStyle(fontSize: 30))
                            : const Icon(Icons.lock_outline, color: Colors.white, size: 26),
                  ),
                ),
                // Tamamlandı rozeti
                if (widget.isDone)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Center(
                        child: Icon(Icons.star_rounded, color: AppColors.xpOrange, size: 14),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Başlık
          SizedBox(
            width: 140,
            child: Text(
              widget.lesson.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: widget.isNextUp ? FontWeight.w700 : FontWeight.w500,
                color: widget.isUnlocked ? AppColors.textPrimary : AppColors.textHint,
              ),
            ),
          ),

          // Sonraki ders chip'i
          if (widget.isNextUp) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Başla →',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
