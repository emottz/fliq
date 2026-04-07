import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/user_profile_model.dart';

class FirestoreService {
  static final _db = FirebaseFirestore.instance;

  // ── Onboarding kaydı ──────────────────────────────────────────────────────
  static Future<void> saveOnboarding(UserProfileModel p) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await _db.collection('users').doc(uid).set({
      'uid': uid,
      'email': FirebaseAuth.instance.currentUser?.email ?? '',
      'role': p.role,
      'licenseLevel': p.licenseLevel,
      'nativeLanguage': p.nativeLanguage,
      'englishLevel': p.englishLevel,
      'flyingEnvironment': p.flyingEnvironment,
      'flightHours': p.flightHours,
      'hardestArea': p.hardestArea,
      'goal': p.goal,
      'dailyTime': p.dailyTime,
      'examTimeline': p.examTimeline,
      'prevIcaoAttempt': p.prevIcaoAttempt,
      'onboardingAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // ── Assessment kaydı ──────────────────────────────────────────────────────
  static Future<void> saveAssessment(
    UserProfileModel p,
    Map<String, Map<String, int>> categoryResults,
  ) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await _db.collection('users').doc(uid).set({
      'level': p.level.name,
      'weakCategories': p.weakCategories,
      'categoryResults': categoryResults,
      'assessmentAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // ── Admin: tüm kullanıcılar ───────────────────────────────────────────────
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final snap = await _db
        .collection('users')
        .orderBy('onboardingAt', descending: true)
        .get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }
}
