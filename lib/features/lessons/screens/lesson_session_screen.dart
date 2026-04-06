import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/lessons/lesson_content_data.dart';
import '../../../data/models/lesson_content_model.dart';
import '../../../shared/providers/app_providers.dart';
import '../widgets/lesson_card_widgets.dart';

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

    await ref.read(userRepositoryProvider).markLessonComplete(widget.lessonId);
    await ref.read(userProfileProvider.notifier).addXp(20);

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

  @override
  Widget build(BuildContext context) {
    final lesson = _lesson;
    if (lesson == null) {
      return Scaffold(
        appBar: AppBar(leading: BackButton(onPressed: () => context.go('/home/lessons'))),
        body: const Center(child: Text('Lesson not found')),
      );
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
                                'Pass the practice quiz to complete this lesson',
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

  void _showQuitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Leave Lesson?'),
        content: const Text('Your progress on this lesson won\'t be saved.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Stay')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/home/lessons');
            },
            child: const Text('Leave', style: TextStyle(color: AppColors.error)),
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

class _ContinueButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (isLoading || locked) ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          gradient: locked
              ? null
              : LinearGradient(
                  colors: isLast
                      ? [const Color(0xFF10B981), const Color(0xFF059669)]
                      : [AppColors.primary, const Color(0xFF1D4ED8)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          color: locked ? AppColors.divider : null,
          borderRadius: BorderRadius.circular(14),
          boxShadow: locked
              ? null
              : [
                  BoxShadow(
                    color: (isLast ? const Color(0xFF10B981) : AppColors.primary).withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (locked) ...[
                      const Icon(Icons.lock_outline, color: AppColors.textSecondary, size: 18),
                      const SizedBox(width: 8),
                      const Text(
                        'Complete Practice First',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ] else ...[
                      Text(
                        isLast ? 'Complete Lesson' : 'Continue',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        isLast ? Icons.check_circle_outline : Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ],
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
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
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
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
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
                    child: Text(widget.lesson.emoji,
                        style: const TextStyle(fontSize: 38)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Lesson Complete!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(
                widget.lesson.title,
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
              ),
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
                    Text(
                      '+20 XP',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.xpOrange,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text('earned', style: TextStyle(fontSize: 14, color: AppColors.xpOrange)),
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
                  child: const Text('Keep Going!',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
