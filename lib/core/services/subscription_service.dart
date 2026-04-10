import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

// Çalıştırma: flutter run --dart-define=RC_KEY_ANDROID=YOUR_KEY
// Build:      flutter build appbundle --dart-define=RC_KEY_ANDROID=YOUR_KEY
const _rcKeyAndroid = String.fromEnvironment('RC_KEY_ANDROID');
const _rcKeyIos = String.fromEnvironment('RC_KEY_IOS');

/// RevenueCat'i saran abonelik servisi.
/// Web veya API key yoksa tüm metotlar güvenli biçimde hayır döner.
class SubscriptionService {
  bool get isSupported {
    if (kIsWeb) return false;
    if (defaultTargetPlatform == TargetPlatform.android) return _rcKeyAndroid.isNotEmpty;
    if (defaultTargetPlatform == TargetPlatform.iOS) return _rcKeyIos.isNotEmpty;
    return false;
  }

  String get _apiKey => defaultTargetPlatform == TargetPlatform.iOS ? _rcKeyIos : _rcKeyAndroid;

  Future<void> init(String userId) async {
    if (!isSupported) return;
    try {
      await Purchases.configure(
        PurchasesConfiguration(_apiKey)..appUserID = userId,
      );
    } catch (_) {}
  }

  Future<bool> get isPremium async {
    if (!isSupported) return false;
    try {
      final info = await Purchases.getCustomerInfo();
      return info.entitlements.active.containsKey('premium');
    } catch (_) {
      return false;
    }
  }

  Future<Offerings?> getOfferings() async {
    if (!isSupported) return null;
    try {
      return await Purchases.getOfferings();
    } catch (_) {
      return null;
    }
  }

  /// Paketi satın alır. (true, null) → başarılı, (false, null) → iptal edildi,
  /// (false, mesaj) → hata.
  Future<(bool, String?)> purchasePackage(Package package) async {
    if (!isSupported) return (false, 'Bu platformda satın alma desteklenmiyor.');
    try {
      final result = await Purchases.purchasePackage(package);
      final active = result.customerInfo.entitlements.active.containsKey('premium');
      return (active, null);
    } on PurchasesError catch (e) {
      if (e.code == PurchasesErrorCode.purchaseCancelledError) return (false, null);
      return (false, e.message);
    } catch (e) {
      return (false, e.toString());
    }
  }

  /// Önceki satın alımları geri yükler.
  Future<bool> restorePurchases() async {
    if (!isSupported) return false;
    try {
      final info = await Purchases.restorePurchases();
      return info.entitlements.active.containsKey('premium');
    } catch (_) {
      return false;
    }
  }

  void addListener(void Function(CustomerInfo) listener) {
    if (!isSupported) return;
    Purchases.addCustomerInfoUpdateListener(listener);
  }

  void removeListener(void Function(CustomerInfo) listener) {
    if (!isSupported) return;
    Purchases.removeCustomerInfoUpdateListener(listener);
  }
}
