import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/lessons/lesson_content_data.dart';
import '../../../data/models/lesson_content_model.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/primary_button.dart';
import '../widgets/lesson_section_widgets.dart';

class LessonSessionScreen extends ConsumerStatefulWidget {
  final String lessonId;
  const LessonSessionScreen({super.key, required this.lessonId});

  @override
  ConsumerState<LessonSessionScreen> createState() => _LessonSessionScreenState();
}

class _LessonSessionScreenState extends ConsumerState<LessonSessionScreen> {
  final ScrollController _scroll = ScrollController();
  bool _completing = false;

  LessonContent? get _lesson => LessonContentData.findById(widget.lessonId);

  Future<void> _complete() async {
    if (_completing) return;
    setState(() => _completing = true);

    await ref.read(userRepositoryProvider).markLessonComplete(widget.lessonId);
    await ref.read(userProfileProvider.notifier).addXp(20);

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => _CompletionDialog(
          lesson: _lesson!,
          onContinue: () => context.go('/home/lessons'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scroll,
        slivers: [
          // ── Sticky header ──────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.go('/home/lessons'),
            ),
            title: Text(lesson.title, style: AppTextStyles.heading3),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: AppColors.divider),
            ),
          ),

          // ── Content ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // Lesson header card
                      _LessonHeaderCard(lesson: lesson),
                      const SizedBox(height: 28),

                      // Sections
                      ...List.generate(lesson.sections.length, (i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: LessonSectionWidget(
                            section: lesson.sections[i],
                            sectionIndex: i,
                          ),
                        );
                      }),

                      const SizedBox(height: 16),
                      PrimaryButton(
                        label: 'Complete Lesson  +20 XP',
                        isLoading: _completing,
                        onPressed: _complete,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonHeaderCard extends StatelessWidget {
  final LessonContent lesson;
  const _LessonHeaderCard({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Text(lesson.emoji, style: const TextStyle(fontSize: 44)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lesson.title,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(lesson.subtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _chip(Icons.timer_outlined, lesson.estimatedTime),
                    const SizedBox(width: 12),
                    _chip(Icons.layers_outlined, '${lesson.sectionCount} sections'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 13),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

class _CompletionDialog extends StatelessWidget {
  final LessonContent lesson;
  final VoidCallback onContinue;

  const _CompletionDialog({required this.lesson, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(lesson.emoji, style: const TextStyle(fontSize: 52)),
          const SizedBox(height: 12),
          const Text('Lesson Complete!', style: AppTextStyles.heading3),
          const SizedBox(height: 4),
          Text(lesson.title, style: AppTextStyles.caption, textAlign: TextAlign.center),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bolt, color: AppColors.xpOrange, size: 22),
                SizedBox(width: 6),
                Text('+20 XP Earned',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.xpOrange)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(label: 'Back to Lessons', onPressed: onContinue),
        ],
      ),
    );
  }
}
