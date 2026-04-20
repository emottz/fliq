import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase tabanlı abonelik servisi.
/// iyzico ödeme akışı Supabase Edge Functions üzerinden yapılır.
class SubscriptionService {
  static final _sb = Supabase.instance.client;

  // ── Premium durumu ──────────────────────────────────────────────────────────

  Future<bool> get isPremium async {
    final uid = _sb.auth.currentUser?.id;
    if (uid == null) return false;
    try {
      final row = await _sb
          .from('users')
          .select('is_premium, premium_expires_at')
          .eq('id', uid)
          .maybeSingle();
      if (row == null || row['is_premium'] != true) return false;
      final exp = row['premium_expires_at'];
      if (exp != null && DateTime.now().isAfter(DateTime.parse(exp))) return false;
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Gerçek zamanlı premium stream — ödeme/kupon tamamlanınca otomatik güncellenir.
  Stream<bool> premiumStream(String uid) async* {
    // Initial fetch
    yield await isPremium;

    // Poll every 30 seconds for updates (avoids Realtime WebSocket issues on web)
    await for (final _ in Stream.periodic(const Duration(seconds: 30))) {
      try {
        yield await isPremium;
      } catch (_) {
        yield false;
      }
    }
  }

  // ── Google Play / App Store IAP aktivasyonu ─────────────────────────────────

  Future<void> activatePremiumFromIap({
    required String uid,
    required String productId,
    String? purchaseToken,
  }) async {
    try {
      if (purchaseToken != null && purchaseToken.isNotEmpty) {
        // Supabase Edge Function üzerinden sunucu doğrulaması
        await _sb.functions.invoke('verify-google-play-purchase', body: {
          'uid': uid,
          'productId': productId,
          'purchaseToken': purchaseToken,
        });
      } else {
        await _sb.from('users').upsert({
          'id': uid,
          'is_premium': true,
          'premium_plan': productId,
          'premium_source': 'iap',
          'premium_activated_at': DateTime.now().toIso8601String(),
        });
      }
    } catch (_) {
      await _sb.from('users').upsert({
        'id': uid,
        'is_premium': true,
        'premium_plan': productId,
        'premium_source': 'iap',
        'premium_activated_at': DateTime.now().toIso8601String(),
      });
    }
  }

  // ── PayTR ödeme sayfası oluştur ─────────────────────────────────────────────

  Future<String> createCheckout({
    required String planKey,
    required bool annual,
  }) async {
    final user = _sb.auth.currentUser;
    if (user == null) throw Exception('Giriş yapılmamış.');

    final res = await _sb.functions.invoke('create-paytr-checkout', body: {
      'planKey': planKey,
      'annual': annual,
      'email': user.email ?? '',
      'name': user.userMetadata?['full_name'] ?? '',
    });

    if (res.status != 200) {
      final err = (res.data as Map<String, dynamic>?)?['error'] as String?;
      throw Exception(err ?? 'Ödeme sayfası oluşturulamadı.');
    }

    final url = (res.data as Map<String, dynamic>?)?['paymentPageUrl'] as String?;
    if (url == null || url.isEmpty) throw Exception('Ödeme sayfası oluşturulamadı.');
    return url;
  }
}
