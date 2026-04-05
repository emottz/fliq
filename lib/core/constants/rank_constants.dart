class RankInfo {
  final String title;
  final int xpRequired;
  final String emoji;

  const RankInfo({
    required this.title,
    required this.xpRequired,
    required this.emoji,
  });
}

class RankConstants {
  RankConstants._();

  static const List<RankInfo> ranks = [
    RankInfo(title: 'Student Pilot', xpRequired: 0, emoji: '🎓'),
    RankInfo(title: 'Private Pilot', xpRequired: 200, emoji: '✈️'),
    RankInfo(title: 'Commercial Pilot', xpRequired: 600, emoji: '🛫'),
    RankInfo(title: 'Senior First Officer', xpRequired: 1200, emoji: '🛩️'),
    RankInfo(title: 'Captain', xpRequired: 2500, emoji: '🏅'),
    RankInfo(title: 'Chief Pilot', xpRequired: 5000, emoji: '🌟'),
    RankInfo(title: 'Aviation Expert', xpRequired: 10000, emoji: '🏆'),
  ];

  static RankInfo getRankForXp(int xp) {
    RankInfo current = ranks.first;
    for (final rank in ranks) {
      if (xp >= rank.xpRequired) {
        current = rank;
      } else {
        break;
      }
    }
    return current;
  }

  static RankInfo? getNextRank(int xp) {
    for (int i = 0; i < ranks.length - 1; i++) {
      if (xp >= ranks[i].xpRequired && xp < ranks[i + 1].xpRequired) {
        return ranks[i + 1];
      }
    }
    return null;
  }

  static double getProgressToNextRank(int xp) {
    for (int i = 0; i < ranks.length - 1; i++) {
      if (xp >= ranks[i].xpRequired && xp < ranks[i + 1].xpRequired) {
        final rangeStart = ranks[i].xpRequired;
        final rangeEnd = ranks[i + 1].xpRequired;
        return (xp - rangeStart) / (rangeEnd - rangeStart);
      }
    }
    return 1.0;
  }
}
