import 'package:flutter/material.dart';

class LeagueInfo {
  final int id;
  final String name;
  final String emoji;
  final String subtitle;
  final Color color;
  final Color colorLight;

  const LeagueInfo({
    required this.id,
    required this.name,
    required this.emoji,
    required this.subtitle,
    required this.color,
    required this.colorLight,
  });
}

class LeagueConstants {
  static const List<LeagueInfo> leagues = [
    LeagueInfo(id: 1,  name: 'Wright Flyer',        emoji: '🪁', subtitle: '1903 · İlk motorlu uçak',            color: Color(0xFFCD7F32), colorLight: Color(0xFFF5E6D3)),
    LeagueInfo(id: 2,  name: 'Blériot XI',           emoji: '🛩️', subtitle: 'Manş geçişi efsanesi',               color: Color(0xFFCD7F32), colorLight: Color(0xFFF5E6D3)),
    LeagueInfo(id: 3,  name: 'Fokker Dr.I',          emoji: '🎯', subtitle: 'WWI triplane',                       color: Color(0xFFCD7F32), colorLight: Color(0xFFF5E6D3)),
    LeagueInfo(id: 4,  name: 'Sopwith Camel',        emoji: '🐪', subtitle: 'WWI\'in en ünlü avcısı',             color: Color(0xFFCD7F32), colorLight: Color(0xFFF5E6D3)),
    LeagueInfo(id: 5,  name: 'Douglas DC-3',         emoji: '✈️', subtitle: 'Sivil havacılığı değiştiren uçak',   color: Color(0xFF9E9E9E), colorLight: Color(0xFFF0F0F0)),
    LeagueInfo(id: 6,  name: 'Spitfire',             emoji: '🌀', subtitle: 'WWII\'nin sembolü',                  color: Color(0xFF9E9E9E), colorLight: Color(0xFFF0F0F0)),
    LeagueInfo(id: 7,  name: 'P-51 Mustang',         emoji: '🐎', subtitle: 'Uzun menzilli WWII savaşçısı',       color: Color(0xFF9E9E9E), colorLight: Color(0xFFF0F0F0)),
    LeagueInfo(id: 8,  name: 'B-29 Superfortress',   emoji: '💣', subtitle: 'Stratejik bombardıman kalesi',       color: Color(0xFF9E9E9E), colorLight: Color(0xFFF0F0F0)),
    LeagueInfo(id: 9,  name: 'Me-262',               emoji: '⚡', subtitle: 'İlk jet savaş uçağı',               color: Color(0xFFFFD700), colorLight: Color(0xFFFFFAE0)),
    LeagueInfo(id: 10, name: 'F-86 Sabre',           emoji: '🗡️', subtitle: 'Kore\'nin gökyüzü hakimi',           color: Color(0xFFFFD700), colorLight: Color(0xFFFFFAE0)),
    LeagueInfo(id: 11, name: 'MiG-15',               emoji: '⭐', subtitle: 'Sovyet jet efsanesi',                color: Color(0xFFFFD700), colorLight: Color(0xFFFFFAE0)),
    LeagueInfo(id: 12, name: 'F-104 Starfighter',    emoji: '🚀', subtitle: 'Uzay çağı savaşçısı',               color: Color(0xFFFFD700), colorLight: Color(0xFFFFFAE0)),
    LeagueInfo(id: 13, name: 'Concorde',             emoji: '🏃', subtitle: 'Sesin 2 katı yolcu uçağı',          color: Color(0xFF4FC3F7), colorLight: Color(0xFFE0F7FA)),
    LeagueInfo(id: 14, name: 'F-14 Tomcat',          emoji: '🐱', subtitle: 'Top Gun\'ın yıldızı',               color: Color(0xFF4FC3F7), colorLight: Color(0xFFE0F7FA)),
    LeagueInfo(id: 15, name: 'SR-71 Blackbird',      emoji: '🦅', subtitle: 'Mach 3+ casus uçağı',              color: Color(0xFF4FC3F7), colorLight: Color(0xFFE0F7FA)),
    LeagueInfo(id: 16, name: 'F-15 Eagle',           emoji: '🦁', subtitle: 'Hiç düşürülmemiş efsane',           color: Color(0xFF4FC3F7), colorLight: Color(0xFFE0F7FA)),
    LeagueInfo(id: 17, name: 'F-16 Fighting Falcon', emoji: '🦆', subtitle: '4000+ operasyonel',                 color: Color(0xFF9C27B0), colorLight: Color(0xFFF3E5F5)),
    LeagueInfo(id: 18, name: 'Eurofighter Typhoon',  emoji: '🌪️', subtitle: 'Avrupa\'nın en iyisi',              color: Color(0xFF9C27B0), colorLight: Color(0xFFF3E5F5)),
    LeagueInfo(id: 19, name: 'F-22 Raptor',          emoji: '👁️', subtitle: '5. nesil stealth hakimi',           color: Color(0xFF9C27B0), colorLight: Color(0xFFF3E5F5)),
    LeagueInfo(id: 20, name: 'F-35 Lightning II',    emoji: '🌩️', subtitle: 'Modern havacılığın zirvesi',        color: Color(0xFF00BCD4), colorLight: Color(0xFFE0FFFF)),
  ];

  static LeagueInfo getLeague(int id) {
    final idx = (id - 1).clamp(0, leagues.length - 1);
    return leagues[idx];
  }

  static String tierLabel(int id) {
    if (id <= 4)  return 'Bronz';
    if (id <= 8)  return 'Gümüş';
    if (id <= 12) return 'Altın';
    if (id <= 16) return 'Platin';
    return 'Elmas';
  }

  /// ISO-8601 hafta anahtarı: "2026-W15"
  static String get currentSeasonKey {
    final now = DateTime.now();
    final week = _isoWeek(now);
    return '${now.year}-W${week.toString().padLeft(2, '0')}';
  }

  static int _isoWeek(DateTime date) {
    final thursday = date.add(Duration(days: 4 - date.weekday));
    final jan1 = DateTime(thursday.year, 1, 1);
    final firstThursday = jan1.add(
      Duration(days: (4 - jan1.weekday + 7) % 7),
    );
    return ((thursday.difference(firstThursday).inDays) / 7).ceil() + 1;
  }

  /// O haftanın pazar günü (bitiş)
  static DateTime get seasonEnd {
    final now = DateTime.now();
    final daysUntilSunday = DateTime.sunday - now.weekday;
    return DateTime(now.year, now.month, now.day + daysUntilSunday, 23, 59, 59);
  }
}
