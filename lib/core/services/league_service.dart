import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/league_member_model.dart';
import '../constants/league_constants.dart';

class LeagueService {
  static final _sb = Supabase.instance.client;

  static String _boardKey(String season, int leagueId, String role) {
    final safeRole = role.isEmpty ? 'student' : role;
    return '${safeRole}_${season}_$leagueId';
  }

  // ── Gerçek zamanlı liderlik tablosu ────────────────────────────────────────
  static Stream<List<LeagueMemberModel>> leaderboardStream(
      String season, int leagueId, String role) {
    final key = _boardKey(season, leagueId, role);
    return _sb
        .from('league_members')
        .stream(primaryKey: ['id'])
        .eq('board_key', key)
        .limit(30)
        .map((rows) {
          final list = rows
              .map((r) => LeagueMemberModel.fromSupabase(r))
              .toList();
          list.sort((a, b) => b.weeklyXp.compareTo(a.weeklyXp));
          return list;
        });
  }

  // ── Kullanıcıyı liğe ekle / güncelle ──────────────────────────────────────
  static Future<void> joinLeague({
    required String season,
    required int leagueId,
    required int weeklyXp,
    required String role,
  }) async {
    final user = _sb.auth.currentUser;
    if (user == null) return;
    final safeRole = role.isEmpty ? 'student' : role;
    final key = _boardKey(season, leagueId, safeRole);

    await _sb.from('league_members').upsert({
      'uid':          user.id,
      'board_key':    key,
      'season':       season,
      'league_id':    leagueId,
      'role':         safeRole,
      'display_name': user.userMetadata?['full_name'] ?? user.email ?? 'Kullanıcı',
      'photo_url':    user.userMetadata?['avatar_url'],
      'weekly_xp':    weeklyXp,
      'streak_days':  0,
      'updated_at':   DateTime.now().toIso8601String(),
    }, onConflict: 'uid,board_key');
  }

  // ── Haftalık XP güncelle ──────────────────────────────────────────────────
  static Future<void> addWeeklyXp({
    required String season,
    required int leagueId,
    required int amount,
    required int streakDays,
    required String role,
  }) async {
    final user = _sb.auth.currentUser;
    if (user == null) return;
    final safeRole = role.isEmpty ? 'student' : role;
    final key = _boardKey(season, leagueId, safeRole);

    // Mevcut XP'i al, üstüne ekle
    final existing = await _sb
        .from('league_members')
        .select('weekly_xp')
        .eq('uid', user.id)
        .eq('board_key', key)
        .maybeSingle();

    final currentXp = (existing?['weekly_xp'] as int?) ?? 0;

    await _sb.from('league_members').upsert({
      'uid':          user.id,
      'board_key':    key,
      'season':       season,
      'league_id':    leagueId,
      'role':         safeRole,
      'display_name': user.userMetadata?['full_name'] ?? user.email ?? 'Kullanıcı',
      'photo_url':    user.userMetadata?['avatar_url'],
      'weekly_xp':    currentXp + amount,
      'streak_days':  streakDays,
      'updated_at':   DateTime.now().toIso8601String(),
    }, onConflict: 'uid,board_key');
  }

  // ── Hafta geçişini kontrol et → yeni lig ID döndür ───────────────────────
  static Future<int> checkSeasonTransition(int currentLeagueId, String role) async {
    final prefs = await SharedPreferences.getInstance();
    final storedSeason = prefs.getString('league_season') ?? '';
    final newSeason = LeagueConstants.currentSeasonKey;

    if (storedSeason == newSeason) return currentLeagueId;

    int newLeagueId = currentLeagueId;

    if (storedSeason.isNotEmpty) {
      final uid = _sb.auth.currentUser?.id;
      if (uid != null) {
        try {
          final key = _boardKey(storedSeason, currentLeagueId, role);
          final rows = await _sb
              .from('league_members')
              .select('uid, weekly_xp')
              .eq('board_key', key)
              .order('weekly_xp', ascending: false)
              .limit(30);

          final uids = rows.map((r) => r['uid'] as String).toList();
          final rank = uids.indexOf(uid) + 1;
          final total = uids.length;

          if (rank > 0) {
            if (rank <= 5 && currentLeagueId < 20) {
              newLeagueId = currentLeagueId + 1;
            } else if (total >= 10 && rank > (total - 5) && currentLeagueId > 1) {
              newLeagueId = currentLeagueId - 1;
            }
          }
        } catch (_) {}
      }
    }

    await prefs.setString('league_season', newSeason);
    return newLeagueId;
  }

  // ── Kullanıcının bu haftaki XP'ini getir ─────────────────────────────────
  static Future<int> getMyWeeklyXp(String season, int leagueId, String role) async {
    final uid = _sb.auth.currentUser?.id;
    if (uid == null) return 0;
    final key = _boardKey(season, leagueId, role);
    final row = await _sb
        .from('league_members')
        .select('weekly_xp')
        .eq('uid', uid)
        .eq('board_key', key)
        .maybeSingle();
    return (row?['weekly_xp'] as int?) ?? 0;
  }
}
