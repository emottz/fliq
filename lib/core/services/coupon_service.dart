import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Kupon doğrulama ve kullanma servisi.
///
/// Firestore işlem (transaction) ile atomic kullanım sağlar —
/// aynı kupon iki kullanıcı tarafından aynı anda kullanılamaz.
class CouponService {
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  /// Kuponu kullanmadan önce bilgilerini döner (önizleme).
  /// Geçersizse exception fırlatır.
  Future<CouponPreview> previewCoupon(String rawCode) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception('Giriş yapılmamış.');

    final code = rawCode.trim().toUpperCase();
    if (code.isEmpty) throw Exception('Kupon kodu boş olamaz.');

    final snap = await _db.collection('coupons').doc(code).get();
    if (!snap.exists) throw Exception('Kupon kodu bulunamadı.');

    final data = snap.data()!;
    if (data['active'] != true) throw Exception('Bu kupon artık aktif değil.');

    final usedBy = List<String>.from(data['usedBy'] ?? []);
    if (usedBy.contains(uid)) throw Exception('Bu kuponu daha önce kullandın.');

    final usedCount = (data['usedCount'] ?? 0) as int;
    final singleUse = data['singleUse'] == true;
    final maxUses   = data['maxUses'] as int?;
    if (singleUse && usedCount >= 1) throw Exception('Bu kupon zaten kullanılmış.');
    if (maxUses != null && usedCount >= maxUses) throw Exception('Bu kuponun kullanım limiti doldu.');

    return CouponPreview(
      code:         code,
      plan:         data['plan'] as String? ?? 'student',
      durationDays: _parseDuration(data['durationDays']),
    );
  }

  /// Kuponu doğrular ve kullanır.
  ///
  /// Başarılı olursa `RedeemResult` döner.
  /// Hatalı/geçersiz kupon durumunda exception fırlatır.
  Future<RedeemResult> redeemCoupon(String rawCode) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception('Giriş yapılmamış.');

    final code = rawCode.trim().toUpperCase();
    if (code.isEmpty) throw Exception('Kupon kodu boş olamaz.');

    final ref = _db.collection('coupons').doc(code);

    return _db.runTransaction<RedeemResult>((tx) async {
      final snap = await tx.get(ref);

      if (!snap.exists) {
        throw Exception('Kupon kodu bulunamadı: $code');
      }

      final data = snap.data()!;

      // Aktif mi?
      if (data['active'] != true) {
        throw Exception('Bu kupon artık aktif değil.');
      }

      // Daha önce bu kullanıcı kullandı mı?
      final usedBy = List<String>.from(data['usedBy'] ?? []);
      if (usedBy.contains(uid)) {
        throw Exception('Bu kuponu daha önce kullandın.');
      }

      final usedCount = (data['usedCount'] ?? 0) as int;
      final singleUse = data['singleUse'] == true;
      final maxUses   = data['maxUses'] as int?;

      // Kullanım limiti aşıldı mı?
      if (singleUse && usedCount >= 1) {
        throw Exception('Bu kupon zaten kullanılmış.');
      }
      if (maxUses != null && usedCount >= maxUses) {
        throw Exception('Bu kuponun kullanım limiti doldu.');
      }

      // Plan ve süre bilgisi
      final plan         = data['plan'] as String? ?? 'student';
      final durationDays = _parseDuration(data['durationDays']);

      // Güncelle
      usedBy.add(uid);
      final newCount  = usedCount + 1;
      final newActive = singleUse ? false : (maxUses != null ? newCount < maxUses : true);

      tx.update(ref, {
        'usedCount': newCount,
        'usedBy':    usedBy,
        'active':    newActive,
      });

      return RedeemResult(plan: plan, code: code, durationDays: durationDays);
    });
  }

  /// Kuponu kullandıktan sonra kullanıcının premium durumunu Firestore'da ayarlar.
  /// [durationDays] == 0 → süresiz; > 0 → o gün kadar geçerli.
  Future<void> activatePremiumFromCoupon({
    required String uid,
    required String plan,
    required String code,
    required int durationDays,
  }) async {
    final data = <String, dynamic>{
      'isPremium':           true,
      'premiumPlan':         plan,
      'premiumSource':       'coupon',
      'couponCode':          code,
      'premiumActivatedAt':  FieldValue.serverTimestamp(),
      'premiumExpiresAt':    durationDays > 0
          ? Timestamp.fromDate(DateTime.now().add(Duration(days: durationDays)))
          : null,
    };
    await _db.collection('users').doc(uid).set(data, SetOptions(merge: true));
  }

  /// `durationDays` alanını güvenli okur.
  /// Firestore'da num (int/double) veya string olarak saklanmış olabilir.
  /// Null veya parse edilemeyen değer → 0 (süresiz).
  static int _parseDuration(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    final parsed = int.tryParse(value.toString());
    return parsed != null && parsed > 0 ? parsed : 0;
  }

  /// Uygulama açılışında: kupon kaynaklı premium süresi dolmuşsa iptal eder.
  Future<void> checkAndRevokeExpiredPremium(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      final data = doc.data();
      if (data == null) return;
      if (data['isPremium'] != true) return;
      if (data['premiumSource'] != 'coupon') return; // IAP aboneliği → dokunma

      final expiresAt = data['premiumExpiresAt'];
      if (expiresAt == null) return; // Süresiz kupon

      final expiry = (expiresAt as Timestamp).toDate();
      if (DateTime.now().isAfter(expiry)) {
        await _db.collection('users').doc(uid).update({
          'isPremium':      false,
          'premiumExpired': true,
        });
      }
    } catch (_) {}
  }
}

class CouponPreview {
  final String code;
  final String plan;
  final int durationDays;
  const CouponPreview({required this.code, required this.plan, required this.durationDays});

  String get planLabel => const {
    'pilot':      '✈️  Pilot',
    'cabin_crew': '💺  Kabin Görevlisi',
    'amt':        '🔧  Uçak Bakım Teknikeri',
    'student':    '🎓  Öğrenci',
    'free':       '🆓  Ücretsiz Erişim',
  }[plan] ?? plan;

  String get durationLabel =>
      durationDays == 0 ? 'Süresiz' : '$durationDays Gün';

  DateTime? get expiresAt => durationDays > 0
      ? DateTime.now().add(Duration(days: durationDays))
      : null;
}

class RedeemResult {
  final String plan;
  final String code;
  final int durationDays; // 0 = süresiz
  const RedeemResult({
    required this.plan,
    required this.code,
    required this.durationDays,
  });
}
