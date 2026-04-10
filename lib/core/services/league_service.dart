import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/league_member_model.dart';
import '../constants/league_constants.dart';

class LeagueService {
  static final _db = FirebaseFirestore.instance;

  // ── Firestore yolu (role ile ayrılmış) ────────────────────────────────────
  static CollectionReference _membersRef(String season, int leagueId, String role) {
    final safeRole = role.isEmpty ? 'student' : role;
    return _db
        .collection('league_boards')
        .doc('${safeRole}_${season}_$leagueId')
        .collection('members');
  }

  // ── Gerçek zamanlı liderlik tablosu ────────────────────────────────────────
  static Stream<List<LeagueMemberModel>> leaderboardStream(
      String season, int leagueId, String role) {
    return _membersRef(season, leagueId, role)
        .limit(30)
        .snapshots()
        .map((snap) {
          final list = snap.docs
              .map((d) => LeagueMemberModel.fromJson(
                  d.id, d.data() as Map<String, dynamic>))
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
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _membersRef(season, leagueId, role).doc(user.uid).set({
      'displayName': user.isAnonymous
          ? 'user_${user.uid.substring(user.uid.length - 6)}'
          : user.displayName ?? user.email ?? 'Kullanıcı',
      'photoUrl': user.photoURL,
      'weeklyXp': weeklyXp,
      'streakDays': 0,
      'role': role.isEmpty ? 'student' : role,
      'joinedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // ── Haftalık XP güncelle ──────────────────────────────────────────────────
  static Future<void> addWeeklyXp({
    required String season,
    required int leagueId,
    required int amount,
    required int streakDays,
    required String role,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _membersRef(season, leagueId, role).doc(user.uid).set({
      'displayName': user.isAnonymous
          ? 'user_${user.uid.substring(user.uid.length - 6)}'
          : user.displayName ?? user.email ?? 'Kullanıcı',
      'photoUrl': user.photoURL,
      'weeklyXp': FieldValue.increment(amount),
      'streakDays': streakDays,
      'role': role.isEmpty ? 'student' : role,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // ── Hafta geçişini kontrol et → yeni lig ID döndür ───────────────────────
  static Future<int> checkSeasonTransition(int currentLeagueId, String role) async {
    final prefs = await SharedPreferences.getInstance();
    final storedSeason = prefs.getString('league_season') ?? '';
    final newSeason = LeagueConstants.currentSeasonKey;

    if (storedSeason == newSeason) return currentLeagueId;

    int newLeagueId = currentLeagueId;

    // Eski sezon bitti: kullanıcının sıralamasına göre yükselt/düşür
    if (storedSeason.isNotEmpty) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        try {
          final snap = await _membersRef(storedSeason, currentLeagueId, role)
              .orderBy('weeklyXp', descending: true)
              .limit(30)
              .get();

          final uids = snap.docs.map((d) => d.id).toList();
          final rank = uids.indexOf(uid) + 1; // 1-indexed
          final total = uids.length;

          if (rank > 0) {
            if (rank <= 5 && currentLeagueId < 20) {
              newLeagueId = currentLeagueId + 1;
            } else if (total >= 10 && rank > (total - 5) && currentLeagueId > 1) {
              newLeagueId = currentLeagueId - 1;
            }
          }
        } catch (_) {
          // Firestore erişim hatası → mevcut lig korunur
        }
      }
    }

    await prefs.setString('league_season', newSeason);
    return newLeagueId;
  }

  // ── Kullanıcının bu haftaki XP'ini getir ─────────────────────────────────
  static Future<int> getMyWeeklyXp(String season, int leagueId, String role) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return 0;
    final doc = await _membersRef(season, leagueId, role).doc(uid).get();
    if (!doc.exists) return 0;
    return (doc.data() as Map<String, dynamic>)['weeklyXp'] as int? ?? 0;
  }
}
