import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/lessons/lesson_content_data.dart';
import '../../../data/models/lesson_content_model.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/streak_celebration_overlay.dart';
import '../widgets/lesson_card_widgets.dart';
import '../../../shared/widgets/report_error_sheet.dart';

class LessonSessionScreen extends ConsumerStatefulWidget {
  final String lessonId;
  const LessonSessionScreen({super.key, required this.lessonId});

  @override
  ConsumerState<LessonSessionScreen> createState() => _LessonSessionScreenState();
}

class _LessonSessionScreenState extends ConsumerState<LessonSessionScreen>
    with TickerProviderStateMixin {
  late PageController _pageCtrl;
  int _currentPage = 0;
  bool _completing = false;

  late AnimationController _celebrationCtrl;
  bool _practicePassed = false;

  LessonContent? get _lesson => LessonContentData.findById(widget.lessonId);

  bool get _hasPractice =>
      _lesson?.sections.any((s) => s.type == LessonSectionType.practice) ?? false;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
    _celebrationCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _celebrationCtrl.dispose();
    super.dispose();
  }

  void _nextPage() {
    final lesson = _lesson!;
    if (_currentPage < lesson.sections.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _complete();
    }
  }

  Future<void> _complete() async {
    if (_completing) return;
    setState(() => _completing = true);

    final lesson = _lesson;
    await ref.read(userRepositoryProvider).markLessonComplete(widget.lessonId);
    await ref.read(userProfileProvider.notifier).addXp(20);
    final newStreak = await ref.read(userProfileProvider.notifier).updateStreak();
    if (mounted && newStreak > 0) {
      await showStreakCelebration(context, streakDays: newStreak);
    }

    // Remove category from weakCategories if all lessons in it are now done
    if (lesson != null) {
      final categoryId = lesson.categoryId;
      final profile = ref.read(userProfileProvider).value;
      if (profile != null && profile.weakCategories.contains(categoryId)) {
        final categoryLessons = LessonContentData.all
            .where((l) => l.categoryId == categoryId)
            .map((l) => l.id)
            .toSet();
        final completed = await ref.read(userRepositoryProvider).getCompletedLessons();
        if (categoryLessons.every((id) => completed.contains(id))) {
          final updated = profile.copyWith(
            weakCategories: profile.weakCategories.where((c) => c != categoryId).toList(),
          );
          await ref.read(userProfileProvider.notifier).saveProfile(updated);
        }
      }
    }

    if (mounted) {
      _celebrationCtrl.forward();
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => _CelebrationDialog(
          lesson: _lesson!,
          onContinue: () => context.go('/home/lessons'),
        ),
      );
    }
  }

  static const _freeLessonsCount = 5;

  @override
  Widget build(BuildContext context) {
    final lesson = _lesson;
    if (lesson == null) {
      return Scaffold(
        appBar: AppBar(leading: BackButton(onPressed: () => context.go('/home/lessons'))),
        body: const Center(child: Text('Ders bulunamadı')),
      );
    }

    final isPremium = ref.watch(isPremiumProvider).value ?? false;
    final lessonIndex = LessonContentData.all.indexWhere((l) => l.id == widget.lessonId);
    final isPremiumLocked = !isPremium && lessonIndex >= _freeLessonsCount;

    if (isPremiumLocked) {
      return _buildPaywallScreen(context, lesson);
    }

    final total = lesson.sections.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _showQuitDialog(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.close, size: 18, color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SegmentedProgress(
                      current: _currentPage,
                      total: total,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_currentPage + 1}/$total',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => showReportErrorSheet(
                      context,
                      screen: 'Ders',
                      lessonName: lesson.title,
                    ),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.flag_outlined,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Page title ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  lesson.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),

            // ── Cards ───────────────────────────────────────────
            Expanded(
              child: PageView.builder(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: total,
                itemBuilder: (_, i) => Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                      child: LessonCardWidget(
                        section: lesson.sections[i],
                        sectionIndex: i,
                        lessonEmoji: lesson.emoji,
                        lessonCategoryId: lesson.categoryId,
                        onPracticeResult: (passed) {
                          setState(() => _practicePassed = passed);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Continue button ──────────────────────────────────
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Hint when on last page but practice not passed
                      if (_currentPage == total - 1 && _hasPractice && !_practicePassed)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.lock_outline, size: 14, color: AppColors.textSecondary),
                              SizedBox(width: 5),
                              Text(
                                'Dersi tamamlamak için alıştırmayı geç',
                                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      _ContinueButton(
                        isLast: _currentPage == total - 1,
                        isLoading: _completing,
                        locked: _currentPage == total - 1 && _hasPractice && !_practicePassed,
                        onTap: _nextPage,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaywallScreen(BuildContext context, LessonContent lesson) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => context.go('/home/lessons'),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.arrow_back, size: 18, color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Ders önizleme kartı
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFF59E0B), width: 2),
                    ),
                    child: Column(
                      children: [
                        Text(lesson.emoji, style: const TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        Text(lesson.title, style: AppTextStyles.heading2, textAlign: TextAlign.center),
                        const SizedBox(height: 4),
                        Text(lesson.subtitle, style: AppTextStyles.caption, textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Kilit mesajı
                  const Icon(Icons.workspace_premium, color: Color(0xFFF59E0B), size: 40),
                  const SizedBox(height: 12),
                  const Text(
                    'Bu Ders Premium\'a Özel',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tüm 33 dersi açmak ve sınırsız pratik yapmak için FLIQ Premium\'a geç.',
                    style: AppTextStyles.caption,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.push('/subscription'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF59E0B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Premium\'a Geç  👑', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.go('/home/lessons'),
                    child: const Text('Şimdi Değil', style: TextStyle(color: AppColors.textSecondary)),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showQuitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Dersten Çık?'),
        content: const Text('Bu dersteki ilerlemeliğin kaydedilmeyecek.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Kal')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/home/lessons');
            },
            child: const Text('Çık', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

// ── Segmented progress bar ────────────────────────────────────────────────────

class _SegmentedProgress extends StatelessWidget {
  final int current;
  final int total;
  const _SegmentedProgress({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.only(right: i < total - 1 ? 3 : 0),
            height: 6,
            decoration: BoxDecoration(
              color: i <= current ? AppColors.primary : AppColors.divider,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }
}

// ── Continue button ───────────────────────────────────────────────────────────

class _ContinueButton extends StatefulWidget {
  final bool isLast;
  final bool isLoading;
  final bool locked;
  final VoidCallback onTap;
  const _ContinueButton({
    required this.isLast,
    required this.isLoading,
    required this.onTap,
    this.locked = false,
  });

  @override
  State<_ContinueButton> createState() => _ContinueButtonState();
}

class _ContinueButtonState extends State<_ContinueButton> with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _scale = Tween<double>(begin: 1.0, end: 1.03)
        .animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
    if (!widget.locked && !widget.isLoading) _pulse.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(_ContinueButton old) {
    super.didUpdateWidget(old);
    if (widget.locked || widget.isLoading) {
      _pulse.stop();
    } else if (!_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (widget.isLoading || widget.locked) ? null : widget.onTap,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            gradient: widget.locked
                ? null
                : LinearGradient(
                    colors: widget.isLast
                        ? [const Color(0xFF10B981), const Color(0xFF059669)]
                        : [AppColors.primary, const Color(0xFF1D4ED8)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
            color: widget.locked ? AppColors.divider : null,
            borderRadius: BorderRadius.circular(14),
            boxShadow: widget.locked
                ? null
                : [
                    BoxShadow(
                      color: (widget.isLast ? const Color(0xFF10B981) : AppColors.primary).withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.locked) ...[
                        const Icon(Icons.lock_outline, color: AppColors.textSecondary, size: 18),
                        const SizedBox(width: 8),
                        const Text('Önce Alıştırmayı Tamamla',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 15, fontWeight: FontWeight.w600)),
                      ] else ...[
                        Text(
                          widget.isLast ? 'Dersi Tamamla' : 'Devam',
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          widget.isLast ? Icons.check_circle_outline : Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// ── Celebration dialog ────────────────────────────────────────────────────────

class _CelebrationDialog extends StatefulWidget {
  final LessonContent lesson;
  final VoidCallback onContinue;
  const _CelebrationDialog({required this.lesson, required this.onContinue});

  @override
  State<_CelebrationDialog> createState() => _CelebrationDialogState();
}

class _CelebrationDialogState extends State<_CelebrationDialog>
    with TickerProviderStateMixin {
  late AnimationController _ctrl;
  late AnimationController _confettiCtrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  static const _confettiColors = [
    Color(0xFF2563EB), Color(0xFF10B981), Color(0xFFF59E0B),
    Color(0xFFEF4444), Color(0xFF8B5CF6), Color(0xFF06B6D4),
  ];

  late final List<_ConfettiParticle> _particles;

  @override
  void initState() {
    super.initState();
    final rng = math.Random();
    _particles = List.generate(22, (i) => _ConfettiParticle(
      x: rng.nextDouble(),
      delay: rng.nextDouble() * 0.4,
      speed: 0.5 + rng.nextDouble() * 0.5,
      size: 5.0 + rng.nextDouble() * 6,
      color: _confettiColors[i % _confettiColors.length],
      angle: rng.nextDouble() * math.pi * 2,
      spin: (rng.nextDouble() - 0.5) * 8,
    ));

    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 550));
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();

    _confettiCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
    _confettiCtrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _confettiCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Konfeti katmanı
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _confettiCtrl,
                  builder: (_, __) => CustomPaint(
                    painter: _ConfettiPainter(_particles, _confettiCtrl.value),
                  ),
                ),
              ),
              // İçerik
              Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ScaleTransition(
                      scale: _scale,
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF10B981), Color(0xFF059669)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF10B981).withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(widget.lesson.emoji, style: const TextStyle(fontSize: 38)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Ders Tamamlandı!',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(widget.lesson.title, style: AppTextStyles.caption, textAlign: TextAlign.center),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bolt, color: AppColors.xpOrange, size: 24),
                          SizedBox(width: 6),
                          Text('+20 XP', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.xpOrange)),
                          SizedBox(width: 4),
                          Text('kazanıldı', style: TextStyle(fontSize: 14, color: AppColors.xpOrange)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: widget.onContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Devam Et!',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfettiParticle {
  final double x;
  final double delay;
  final double speed;
  final double size;
  final Color color;
  final double angle;
  final double spin;
  const _ConfettiParticle({
    required this.x, required this.delay, required this.speed,
    required this.size, required this.color, required this.angle, required this.spin,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double t;
  _ConfettiPainter(this.particles, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final progress = ((t - p.delay) * p.speed).clamp(0.0, 1.0);
      if (progress <= 0) continue;
      final opacity = progress < 0.8 ? 1.0 : (1.0 - (progress - 0.8) / 0.2);
      final x = p.x * size.width;
      final y = progress * size.height * 1.1 - size.height * 0.05;
      final rotation = p.angle + p.spin * progress;
      final paint = Paint()..color = p.color.withOpacity(opacity.clamp(0.0, 1.0));
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);
      canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.5), paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}
