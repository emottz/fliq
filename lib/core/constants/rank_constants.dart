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

  // ── Pilot rütbeleri ───────────────────────────────────────────────────────
  static const List<RankInfo> pilotRanks = [
    RankInfo(title: 'Öğrenci Pilot',  xpRequired: 0,     emoji: '🎓'),
    RankInfo(title: 'Özel Pilot',     xpRequired: 200,   emoji: '✈️'),
    RankInfo(title: 'Ticari Pilot',   xpRequired: 600,   emoji: '🛫'),
    RankInfo(title: 'Kıdemli YKP',   xpRequired: 1200,  emoji: '🛩️'),
    RankInfo(title: 'Kaptan',         xpRequired: 2500,  emoji: '🏅'),
    RankInfo(title: 'Baş Pilot',      xpRequired: 5000,  emoji: '🌟'),
    RankInfo(title: 'ICAO Uzmanı',    xpRequired: 10000, emoji: '🏆'),
  ];

  // ── Kabin Görevlisi rütbeleri ─────────────────────────────────────────────
  static const List<RankInfo> cabinRanks = [
    RankInfo(title: 'Stajyer Kabin',         xpRequired: 0,     emoji: '🎓'),
    RankInfo(title: 'Kabin Görevlisi',        xpRequired: 200,   emoji: '💺'),
    RankInfo(title: 'Kıdemli Kabin',          xpRequired: 600,   emoji: '🌸'),
    RankInfo(title: 'Kabin Lideri',           xpRequired: 1200,  emoji: '🏅'),
    RankInfo(title: 'Kabin Amiri',            xpRequired: 2500,  emoji: '👑'),
    RankInfo(title: 'Kıdemli Kabin Amiri',   xpRequired: 5000,  emoji: '🌟'),
    RankInfo(title: 'Havacılık Uzmanı',       xpRequired: 10000, emoji: '🏆'),
  ];

  // ── AMT (Uçak Bakım Teknisyeni) rütbeleri ────────────────────────────────
  static const List<RankInfo> amtRanks = [
    RankInfo(title: 'Stajyer Teknisyen',  xpRequired: 0,     emoji: '🎓'),
    RankInfo(title: 'B1/B2 Adayı',       xpRequired: 200,   emoji: '🔧'),
    RankInfo(title: 'Lisanslı Teknisyen', xpRequired: 600,   emoji: '⚙️'),
    RankInfo(title: 'Kıdemli AMT',        xpRequired: 1200,  emoji: '🔩'),
    RankInfo(title: 'Kalite Muayene',     xpRequired: 2500,  emoji: '🔍'),
    RankInfo(title: 'Bakım Müdürü',       xpRequired: 5000,  emoji: '🌟'),
    RankInfo(title: 'EASA Uzmanı',        xpRequired: 10000, emoji: '🏆'),
  ];

  // ── Öğrenci rütbeleri ─────────────────────────────────────────────────────
  static const List<RankInfo> studentRanks = [
    RankInfo(title: 'Yeni Başlayan', xpRequired: 0,     emoji: '🌱'),
    RankInfo(title: 'Başlangıç',    xpRequired: 200,   emoji: '📚'),
    RankInfo(title: 'Temel Düzey',  xpRequired: 600,   emoji: '✈️'),
    RankInfo(title: 'Orta Düzey',   xpRequired: 1200,  emoji: '🛫'),
    RankInfo(title: 'İleri Düzey',  xpRequired: 2500,  emoji: '🏅'),
    RankInfo(title: 'Uzman',        xpRequired: 5000,  emoji: '🌟'),
    RankInfo(title: 'Usta',         xpRequired: 10000, emoji: '🏆'),
  ];

  // Geriye uyumluluk için
  static const List<RankInfo> ranks = pilotRanks;

  static List<RankInfo> ranksForRole(String role) {
    switch (role) {
      case 'cabin_crew': return cabinRanks;
      case 'amt':        return amtRanks;
      case 'student':    return studentRanks;
      default:           return pilotRanks;
    }
  }

  static RankInfo getRankForXp(int xp, [String role = 'pilot']) {
    final list = ranksForRole(role);
    RankInfo current = list.first;
    for (final rank in list) {
      if (xp >= rank.xpRequired) {
        current = rank;
      } else {
        break;
      }
    }
    return current;
  }

  static RankInfo? getNextRank(int xp, [String role = 'pilot']) {
    final list = ranksForRole(role);
    for (int i = 0; i < list.length - 1; i++) {
      if (xp >= list[i].xpRequired && xp < list[i + 1].xpRequired) {
        return list[i + 1];
      }
    }
    return null;
  }

  static double getProgressToNextRank(int xp, [String role = 'pilot']) {
    final list = ranksForRole(role);
    for (int i = 0; i < list.length - 1; i++) {
      if (xp >= list[i].xpRequired && xp < list[i + 1].xpRequired) {
        final rangeStart = list[i].xpRequired;
        final rangeEnd = list[i + 1].xpRequired;
        return (xp - rangeStart) / (rangeEnd - rangeStart);
      }
    }
    return 1.0;
  }
}
