import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Ödeme altyapısı:
///   Mobil  → Google Play Billing  → /api/iap/verify
///   Web    → PayTR                → /api/paytr/create-checkout
class SubscriptionService {
  static final _sb = Supabase.instance.client;

  static const _serverBase = 'https://server.avialish.com'; // SERVER_BASE_URL
  static const _apiKey     = 'avialish_mobile_api_2024';    // FLUTTER_API_KEY

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

  // ── Google Play IAP aktivasyonu ──────────────────────────────────────────────

  Future<void> activatePremiumFromIap({
    required String uid,
    required String productId,
    String? purchaseToken,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_serverBase/api/iap/verify'),
        headers: {'Content-Type': 'application/json', 'x-api-key': _apiKey},
        body: jsonEncode({
          'uid':           uid,
          'productId':     productId,
          'purchaseToken': purchaseToken,
        }),
      );
      if (response.statusCode != 200) throw Exception('Server error ${response.statusCode}');
    } catch (_) {
      // Fallback: doğrudan DB'ye yaz
      await _sb.from('users').upsert({
        'id':                   uid,
        'is_premium':           true,
        'premium_plan':         productId,
        'premium_source':       'google_play',
        'premium_activated_at': DateTime.now().toIso8601String(),
      });
    }
  }

  // ── PayTR ödeme sayfası oluştur ─────────────────────────────────────────────

  Future<String> createCheckout({
    required String planKey,
    required bool annual,
    int discountPercent = 0,
    String? couponCode,
  }) async {
    final user = _sb.auth.currentUser;
    if (user == null) throw Exception('Giriş yapılmamış.');

    final response = await http.post(
      Uri.parse('$_serverBase/api/paytr/create-checkout'),
      headers: {'Content-Type': 'application/json', 'x-api-key': _apiKey},
      body: jsonEncode({
        'uid':     user.id,
        'email':   user.email ?? '',
        'name':    user.userMetadata?['full_name'] ?? '',
        'planKey': planKey,
        'annual':  annual,
        if (discountPercent > 0) 'discountPercent': discountPercent,
        if (couponCode != null)  'couponCode': couponCode,
      }),
    );

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(body['error'] ?? 'Ödeme sayfası oluşturulamadı.');
    }

    final url = (jsonDecode(response.body) as Map<String, dynamic>)['paymentPageUrl'] as String?;
    if (url == null || url.isEmpty) throw Exception('Ödeme sayfası oluşturulamadı.');
    return url;
  }
}
