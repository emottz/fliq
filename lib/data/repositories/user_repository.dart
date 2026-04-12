import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile_model.dart';
import '../lessons/lesson_content_data.dart';

class UserRepository {
  static const _keyProfile = 'user_profile';
  static const _keyOnboardingDone = 'onboarding_done';
  static const _keyAssessmentDone = 'assessment_done';
  static const _keyCompletedLessons = 'completed_lessons';
  static const _keyExamsTaken = 'exams_taken';
  static const freeTrialExams = 1; // Ücretsiz deneme hakkı (ömür boyu)

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<bool> get hasProfile async {
    final p = await _prefs;
    return p.getBool(_keyOnboardingDone) ?? false;
  }

  Future<bool> get hasLevel async {
    final p = await _prefs;
    return p.getBool(_keyAssessmentDone) ?? false;
  }

  Future<UserProfileModel?> getProfile() async {
    final p = await _prefs;
    final raw = p.getString(_keyProfile);
    if (raw == null) return null;
    return UserProfileModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveProfile(UserProfileModel profile) async {
    final p = await _prefs;
    await p.setString(_keyProfile, jsonEncode(profile.toJson()));
    await p.setBool(_keyOnboardingDone, true);
  }

  Future<void> saveLevel(UserProfileModel profile) async {
    final p = await _prefs;
    await p.setString(_keyProfile, jsonEncode(profile.toJson()));
    await p.setBool(_keyAssessmentDone, true);
  }

  Future<void> addXp(int amount) async {
    final profile = await getProfile();
    if (profile == null) return;
    await saveProfile(profile.copyWith(totalXp: profile.totalXp + amount));
  }

  /// Streaki günceller. Yeni gün ise yeni streak sayısını döndürür, aynı günse 0 döner.
  Future<int> updateStreak() async {
    final profile = await getProfile();
    if (profile == null) return 0;

    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    if (profile.lastActiveDate == todayStr) return 0;

    int newStreak = 1;
    if (profile.lastActiveDate != null) {
      final last = DateTime.tryParse(profile.lastActiveDate!);
      if (last != null) {
        final diff = today.difference(last).inDays;
        if (diff == 1) newStreak = profile.streakDays + 1;
      }
    }

    await saveProfile(profile.copyWith(
      streakDays: newStreak,
      lastActiveDate: todayStr,
    ));
    return newStreak;
  }

  Future<Set<String>> getCompletedLessons() async {
    final p = await _prefs;
    return (p.getStringList(_keyCompletedLessons) ?? []).toSet();
  }

  Future<void> markLessonComplete(String lessonId) async {
    final p = await _prefs;
    final current = await getCompletedLessons();
    current.add(lessonId);
    await p.setStringList(_keyCompletedLessons, current.toList());
  }

  Future<int> getExamsTaken() async {
    final p = await _prefs;
    return p.getInt(_keyExamsTaken) ?? 0;
  }

  Future<void> incrementExamsTaken() async {
    final p = await _prefs;
    final current = p.getInt(_keyExamsTaken) ?? 0;
    await p.setInt(_keyExamsTaken, current + 1);
  }

  /// Ücretsiz kullanıcı sınav alabilir mi? (ömür boyu 1 hak)
  Future<bool> canTakeExam({required bool isPremium}) async {
    if (isPremium) return true;
    return await getExamsTaken() < freeTrialExams;
  }

  /// Seviye tespitinden sonra kullanıcının seviyesinin altındaki dersleri
  /// tamamlanmış olarak işaretler; böylece o dersler atlayarak devam edilir.
  Future<void> skipLessonsForLevel(ProficiencyLevel level) async {
    final toSkip = LessonContentData.lessonIdsBeforeLevel(level);
    if (toSkip.isEmpty) return;
    final p = await _prefs;
    final current = await getCompletedLessons();
    current.addAll(toSkip);
    await p.setStringList(_keyCompletedLessons, current.toList());
  }

  Future<void> clearAll() async {
    final p = await _prefs;
    await p.clear();
  }
}
