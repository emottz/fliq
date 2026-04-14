import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import '../constants/iap_constants.dart';

/// Google Play Billing / App Store Connect satın alma servisi.
/// Web platformunda desteklenmez — orada iyzico kullanılır.
class IapService {
  IapService._();
  static final IapService instance = IapService._();

  // Web'de InAppPurchase.instance erişimi UnsupportedError fırlatır.
  // Lazy getter ile sadece mobilde erişilir.
  InAppPurchase get _iap => InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;

  /// Platform'un IAP destekleyip desteklemediği
  bool get isSupported => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  // ── Başlatma ─────────────────────────────────────────────────────────────

  /// Ana uygulama başlangıcında bir kez çağrılmalı.
  /// [onPurchase]: her satın alma güncellemesi için callback.
  void initialize({required void Function(PurchaseDetails) onPurchase}) {
    if (!isSupported) return;
    _purchaseSub?.cancel();
    _purchaseSub = _iap.purchaseStream.listen(
      (purchases) {
        for (final p in purchases) {
          onPurchase(p);
        }
      },
      onError: (_) {},
    );
  }

  void dispose() {
    _purchaseSub?.cancel();
    _purchaseSub = null;
  }

  // ── Ürün sorgulama ────────────────────────────────────────────────────────

  Future<bool> isAvailable() => _iap.isAvailable();

  Future<List<ProductDetails>> queryProducts() async {
    final response = await _iap.queryProductDetails(IapConstants.allProductIds);
    return response.productDetails;
  }

  /// Belirli bir ürünü döner, bulamazsa null.
  Future<ProductDetails?> getProduct(String productId) async {
    final products = await queryProducts();
    try {
      return products.firstWhere((p) => p.id == productId);
    } catch (_) {
      return null;
    }
  }

  // ── Satın alma ────────────────────────────────────────────────────────────

  Future<void> buy(ProductDetails product) async {
    final param = PurchaseParam(productDetails: product);
    // Abonelikler non-consumable olarak işlenir
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  // ── Satın almayı tamamla (Android zorunlu) ────────────────────────────────

  Future<void> completePurchase(PurchaseDetails purchase) async {
    if (purchase.pendingCompletePurchase) {
      await _iap.completePurchase(purchase);
    }
  }

  // ── Geçmiş satın almaları geri yükle ─────────────────────────────────────

  Future<void> restorePurchases() async {
    if (!isSupported) return;
    await _iap.restorePurchases();
  }

  // ── Android: satın alma token'ı ───────────────────────────────────────────

  /// Android satın alma token'ını döner (Cloud Function doğrulaması için).
  String? androidPurchaseToken(PurchaseDetails purchase) {
    if (!Platform.isAndroid) return null;
    final androidDetails = purchase.verificationData.serverVerificationData;
    return androidDetails.isNotEmpty ? androidDetails : null;
  }
}
