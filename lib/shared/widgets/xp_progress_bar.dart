import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/rank_constants.dart';

class XpProgressBar extends StatelessWidget {
  final int xp;

  const XpProgressBar({super.key, required this.xp});

  @override
  Widget build(BuildContext context) {
    final rank = RankConstants.getRankForXp(xp);
    final nextRank = RankConstants.getNextRank(xp);
    final progress = RankConstants.getProgressToNextRank(xp);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${rank.emoji} ${rank.title}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '$xp XP',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        if (nextRank != null) ...[
          const SizedBox(height: 4),
          Text(
            'Next: ${nextRank.title} (${nextRank.xpRequired} XP)',
            style: const TextStyle(fontSize: 11, color: AppColors.textHint),
          ),
        ],
      ],
    );
  }
}
