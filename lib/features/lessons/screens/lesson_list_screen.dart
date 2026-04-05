import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/lessons/lesson_content_data.dart';
import '../../../data/models/lesson_content_model.dart';
import '../../../data/models/user_profile_model.dart';
import '../../../shared/providers/app_providers.dart';

class LessonListScreen extends ConsumerWidget {
  const LessonListScreen({super.key});

  static const _minLevels = {
    'grammar_1': ProficiencyLevel.beginner,
    'grammar_2': ProficiencyLevel.beginner,
    'vocab_1': ProficiencyLevel.beginner,
    'fill_1': ProficiencyLevel.beginner,
    'grammar_3': ProficiencyLevel.elementary,
    'vocab_2': ProficiencyLevel.elementary,
    'translation_1': ProficiencyLevel.elementary,
    'reading_1': ProficiencyLevel.intermediate,
    'grammar_4': ProficiencyLevel.intermediate,
    'completion_1': ProficiencyLevel.intermediate,
    'reading_2': ProficiencyLevel.advanced,
    'completion_2': ProficiencyLevel.advanced,
  };

  bool _isUnlocked(
    ProficiencyLevel userLevel,
    int idx,
    List<LessonContent> all,
    Set<String> completed,
  ) {
    if (idx == 0) return true;
    final prev = all[idx - 1];
    if (!completed.contains(prev.id)) return false;
    final minLevel = _minLevels[all[idx].id] ?? ProficiencyLevel.beginner;
    return userLevel.index >= minLevel.index;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return profileAsync.when(
      data: (profile) {
        final level = profile?.level ?? ProficiencyLevel.beginner;
        final lessons = LessonContentData.all;

        return FutureBuilder<Set<String>>(
          future: ref.read(userRepositoryProvider).getCompletedLessons(),
          builder: (context, snap) {
            final completed = snap.data ?? {};
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Lessons', style: AppTextStyles.heading2),
                      const SizedBox(height: 4),
                      Text(
                        'Your level: ${level.name.capitalize()}  •  ${completed.length}/${lessons.length} complete',
                        style: AppTextStyles.caption,
                      ),
                      const SizedBox(height: 20),
                      ...List.generate(lessons.length, (i) {
                        final lesson = lessons[i];
                        final isDone = completed.contains(lesson.id);
                        final isUnlocked = isDone || _isUnlocked(level, i, lessons, completed);
                        return _LessonTile(
                          lesson: lesson,
                          isUnlocked: isUnlocked,
                          isCompleted: isDone,
                          isLast: i == lessons.length - 1,
                          onTap: isUnlocked ? () => context.go('/lesson/${lesson.id}') : null,
                        );
                      }),
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
}

class _LessonTile extends StatelessWidget {
  final LessonContent lesson;
  final bool isUnlocked;
  final bool isCompleted;
  final bool isLast;
  final VoidCallback? onTap;

  const _LessonTile({
    required this.lesson,
    required this.isUnlocked,
    required this.isCompleted,
    required this.isLast,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? AppColors.success
                    : isUnlocked
                        ? AppColors.primary
                        : AppColors.divider,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : isUnlocked
                        ? Text(lesson.emoji, style: const TextStyle(fontSize: 18))
                        : const Icon(Icons.lock, color: Colors.white, size: 16),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 50,
                color: isCompleted
                    ? AppColors.success.withValues(alpha: 0.4)
                    : AppColors.divider,
              ),
          ],
        ),
        const SizedBox(width: 14),
        // Card
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.successLight
                    : isUnlocked
                        ? AppColors.surface
                        : AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isCompleted
                      ? AppColors.success.withValues(alpha: 0.4)
                      : isUnlocked
                          ? AppColors.divider
                          : AppColors.divider,
                  width: isUnlocked && !isCompleted ? 1 : 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lesson.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: isUnlocked ? AppColors.textPrimary : AppColors.textHint,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(lesson.subtitle,
                            style: AppTextStyles.caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            _chip(Icons.timer_outlined, lesson.estimatedTime, isUnlocked),
                            const SizedBox(width: 10),
                            _chip(Icons.layers_outlined, '${lesson.sectionCount} sections', isUnlocked),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (!isUnlocked)
                    const Icon(Icons.lock_outline, size: 18, color: AppColors.textHint)
                  else if (isCompleted)
                    const Icon(Icons.check_circle, size: 20, color: AppColors.success)
                  else
                    const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _chip(IconData icon, String label, bool active) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: active ? AppColors.textSecondary : AppColors.textHint),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: active ? AppColors.textSecondary : AppColors.textHint),
        ),
      ],
    );
  }
}

extension on String {
  String capitalize() => isEmpty ? this : this[0].toUpperCase() + substring(1);
}
