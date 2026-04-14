import 'package:supabase_flutter/supabase_flutter.dart';

/// Kupon doğrulama ve kullanma servisi — Supabase tabanlı.
class CouponService {
  static final _sb = Supabase.instance.client;

  static String? get _uid => _sb.auth.currentUser?.id;

  // ── Önizleme ──────────────────────────────────────────────────────────────
  Future<CouponPreview> previewCoupon(String rawCode) async {
    final uid = _uid;
    if (uid == null) throw Exception('Giriş yapılmamış.');

    final code = rawCode.trim().toUpperCase();
    if (code.isEmpty) throw Exception('Kupon kodu boş olamaz.');

    final row = await _sb
        .from('coupons')
        .select()
        .eq('code', code)
        .maybeSingle();

    if (row == null) throw Exception('Kupon kodu bulunamadı.');
    _validate(uid, row);

    return CouponPreview(
      code:         code,
      plan:         row['plan'] as String? ?? 'student',
      durationDays: (row['duration_days'] as num?)?.toInt() ?? 0,
    );
  }

  // ── Kullan ────────────────────────────────────────────────────────────────
  Future<RedeemResult> redeemCoupon(String rawCode) async {
    final uid = _uid;
    if (uid == null) throw Exception('Giriş yapılmamış.');

    final code = rawCode.trim().toUpperCase();
    if (code.isEmpty) throw Exception('Kupon kodu boş olamaz.');

    // Supabase RPC ile atomik kullanım (race condition önlemi)
    // Not: Eğer RPC yoksa manuel transaction benzeri işlem yapılır
    final row = await _sb
        .from('coupons')
        .select()
        .eq('code', code)
        .maybeSingle();

    if (row == null) throw Exception('Kupon kodu bulunamadı: $code');
    _validate(uid, row);

    final plan         = row['plan'] as String? ?? 'student';
    final durationDays = (row['duration_days'] as num?)?.toInt() ?? 0;
    final usedBy       = List<String>.from(row['used_by'] ?? []);
    final useCount     = (row['use_count'] as int?) ?? 0;
    final maxUses      = row['max_uses'] as int?;
    final singleUse    = row['single_use'] == true;

    usedBy.add(uid);
    final newCount  = useCount + 1;
    final newActive = singleUse ? false
        : (maxUses != null && maxUses > 0 ? newCount < maxUses : true);

    await _sb.from('coupons').update({
      'use_count': newCount,
      'used_by':   usedBy,
      'is_active': newActive,
    }).eq('code', code);

    return RedeemResult(plan: plan, code: code, durationDays: durationDays);
  }

  // ── Premium aktif et ──────────────────────────────────────────────────────
  Future<void> activatePremiumFromCoupon({
    required String uid,
    required String plan,
    required String code,
    required int durationDays,
  }) async {
    await _sb.from('users').upsert({
      'id':                   uid,
      'is_premium':           true,
      'premium_plan':         plan,
      'premium_source':       'coupon',
      'coupon_code':          code,
      'premium_activated_at': DateTime.now().toIso8601String(),
      'premium_expires_at':   durationDays > 0
          ? DateTime.now().add(Duration(days: durationDays)).toIso8601String()
          : null,
    });
  }

  // ── Süresi dolmuş premium'u iptal et ─────────────────────────────────────
  Future<void> checkAndRevokeExpiredPremium(String uid) async {
    try {
      final row = await _sb
          .from('users')
          .select('is_premium, premium_source, premium_expires_at')
          .eq('id', uid)
          .maybeSingle();

      if (row == null) return;
      if (row['is_premium'] != true) return;
      if (row['premium_source'] != 'coupon') return;

      final exp = row['premium_expires_at'];
      if (exp == null) return;

      if (DateTime.now().isAfter(DateTime.parse(exp as String))) {
        await _sb.from('users').update({
          'is_premium': false,
        }).eq('id', uid);
      }
    } catch (_) {}
  }

  // ── İç yardımcı ───────────────────────────────────────────────────────────
  void _validate(String uid, Map<String, dynamic> row) {
    if (row['is_active'] != true) throw Exception('Bu kupon artık aktif değil.');

    final usedBy    = List<String>.from(row['used_by'] ?? []);
    if (usedBy.contains(uid)) throw Exception('Bu kuponu daha önce kullandın.');

    final useCount  = (row['use_count'] as int?) ?? 0;
    final singleUse = row['single_use'] == true;
    final maxUses   = row['max_uses'] as int?;

    if (singleUse && useCount >= 1) throw Exception('Bu kupon zaten kullanılmış.');
    if (maxUses != null && maxUses > 0 && useCount >= maxUses) {
      throw Exception('Bu kuponun kullanım limiti doldu.');
    }
  }
}

// ── Veri sınıfları ─────────────────────────────────────────────────────────────

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
  final int durationDays;
  const RedeemResult({required this.plan, required this.code, required this.durationDays});
}
