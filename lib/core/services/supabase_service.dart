import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/user_profile_model.dart';

/// Supabase tabanlı server-side veri işlemleri.
/// (Eski firestore_service.dart'ın yerini alır.)
class SupabaseService {
  static final _sb = Supabase.instance.client;

  static String? get _uid => _sb.auth.currentUser?.id;

  // ── Onboarding kaydı ──────────────────────────────────────────────────────
  static Future<void> saveOnboarding(UserProfileModel p) async {
    final uid = _uid;
    if (uid == null) return;
    await _sb.from('users').upsert({
      'id':                  uid,
      'email':               _sb.auth.currentUser?.email ?? '',
      'role':                p.role,
      'license_level':       p.licenseLevel,
      'native_language':     p.nativeLanguage,
      'english_level':       p.englishLevel,
      'flying_environment':  p.flyingEnvironment,
      'flight_hours':        p.flightHours,
      'hardest_area':        p.hardestArea,
      'goal':                p.goal,
      'daily_time':          p.dailyTime,
      'exam_timeline':       p.examTimeline,
      'prev_icao_attempt':   p.prevIcaoAttempt,
      'league_id':           p.leagueId,
      'onboarding_at':       DateTime.now().toIso8601String(),
      'updated_at':          DateTime.now().toIso8601String(),
    });
  }

  // ── Assessment kaydı ──────────────────────────────────────────────────────
  static Future<void> saveAssessment(
    UserProfileModel p,
    Map<String, Map<String, int>> categoryResults,
  ) async {
    final uid = _uid;
    if (uid == null) return;
    await _sb.from('users').upsert({
      'id':               uid,
      'level':            p.level.name,
      'weak_categories':  p.weakCategories,
      'category_results': categoryResults,
      'assessment_at':    DateTime.now().toIso8601String(),
      'updated_at':       DateTime.now().toIso8601String(),
    });
  }

  // ── Admin: tüm kullanıcılar ───────────────────────────────────────────────
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final rows = await _sb
        .from('users')
        .select()
        .order('onboarding_at', ascending: false)
        .limit(200);
    return List<Map<String, dynamic>>.from(rows);
  }
}
