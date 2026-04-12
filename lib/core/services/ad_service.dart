import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Gerçek ID'leri --dart-define ile geç:
//   flutter run --dart-define=ADMOB_ANDROID=ca-app-pub-xxxx/yyyy
//               --dart-define=ADMOB_IOS=ca-app-pub-xxxx/zzzz
const _androidId = String.fromEnvironment('ADMOB_ANDROID');
const _iosId = String.fromEnvironment('ADMOB_IOS');

/// Test ID'leri (yayın öncesi gerçeklerle değiştirilmeli).
const _testAndroid = 'ca-app-pub-3940256099942544/5224354917';
const _testIos = 'ca-app-pub-3940256099942544/1712485313';

/// Ödüllü video reklam servisi.
/// Web'de veya AdMob key eksikse tüm metotlar sessizce çalışmaz.
class AdService {
  RewardedAd? _ad;
  bool _loading = false;
  bool _available = false;

  bool get isSupported {
    if (kIsWeb) return false;
    if (defaultTargetPlatform == TargetPlatform.android) return true;
    if (defaultTargetPlatform == TargetPlatform.iOS) return true;
    return false;
  }

  String get _adUnitId {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _iosId.isNotEmpty ? _iosId : _testIos;
    }
    return _androidId.isNotEmpty ? _androidId : _testAndroid;
  }

  bool get isAdReady => _available && _ad != null;

  /// AdMob'u başlatır (app başlangıcında bir kez çağrılmalı).
  Future<void> initialize() async {
    if (!isSupported) return;
    try {
      await MobileAds.instance.initialize();
      await load();
    } catch (_) {}
  }

  /// Reklamı önceden yükler.
  Future<void> load() async {
    if (!isSupported || _loading) return;
    _loading = true;
    try {
      await RewardedAd.load(
        adUnitId: _adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _ad = ad;
            _available = true;
            _loading = false;
          },
          onAdFailedToLoad: (error) {
            _ad = null;
            _available = false;
            _loading = false;
          },
        ),
      );
    } catch (_) {
      _loading = false;
    }
  }

  /// Reklamı gösterir. Kullanıcı ödülü kazanırsa [onRewarded] çağrılır.
  /// Reklam bittikten sonra otomatik yeni reklam yüklenir.
  Future<void> show({required VoidCallback onRewarded}) async {
    if (!isSupported || _ad == null) return;

    final ad = _ad!;
    _ad = null;
    _available = false;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        load(); // bir sonraki izleme için önceden yükle
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        load();
      },
    );

    await ad.show(
      onUserEarnedReward: (ad, reward) => onRewarded(),
    );
  }
}
