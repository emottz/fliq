import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// iyzico tabanlı abonelik servisi.
/// Ödeme akışı Cloud Functions üzerinden yapılır,
/// isPremium durumu doğrudan Firestore'dan okunur.
class SubscriptionService {
  FirebaseFirestore get _db => FirebaseFirestore.instance;
  FirebaseFunctions get _fn => FirebaseFunctions.instance;

  // ── Premium durumu ──────────────────────────────────────────────────────────

  Future<bool> get isPremium async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return false;
    try {
      final doc = await _db.collection('users').doc(uid).get();
      return doc.data()?['isPremium'] == true;
    } catch (_) {
      return false;
    }
  }

  /// Gerçek zamanlı premium stream — ödeme tamamlanınca otomatik güncellenir.
  Stream<bool> premiumStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snap) => snap.data()?['isPremium'] == true);
  }

  // ── iyzico ödeme sayfası oluştur ────────────────────────────────────────────

  /// Başarılı olursa iyzico ödeme sayfasının URL'ini döner,
  /// hata varsa exception fırlatır.
  Future<String> createCheckout({
    required String planKey,
    required bool annual,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Giriş yapılmamış.');

    final callable = _fn.httpsCallable('createIyzicoCheckout');
    final result = await callable.call({
      'planKey': planKey,
      'annual': annual,
      'email': user.email ?? '',
      'name': user.displayName ?? '',
    });

    final url = result.data['paymentPageUrl'] as String?;
    if (url == null || url.isEmpty) throw Exception('Ödeme sayfası oluşturulamadı.');
    return url;
  }
}
