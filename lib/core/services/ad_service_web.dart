import 'dart:async';
import 'dart:js_interop';

// Global JS fonksiyonları — web/index.html'de tanımlı
@JS('fliqAdConfig')
external void _fliqAdConfig();

@JS('fliqShowRewardedAd')
external void _fliqShowRewardedAd(JSFunction onViewed, JSFunction onComplete);

/// Web (AdSense H5 Games) reklam servisi.
/// AdSense onayı alındıktan sonra gerçek reklamlar gösterilir;
/// onay öncesinde veya reklam yokken buton görünür ama ad akışı hemen tamamlanır.
class AdService {
  bool get isSupported => true;

  /// AdSense on-demand yüklediği için her zaman hazır sayılır.
  bool get isAdReady => true;

  Future<void> initialize() async {
    try {
      _fliqAdConfig();
    } catch (_) {}
  }

  Future<void> load() async {}

  /// Rewarded ad gösterir. Kullanıcı izlerse [onRewarded] çağrılır.
  Future<void> show({required void Function() onRewarded}) async {
    final completer = Completer<void>();

    void onViewed() {
      onRewarded();
    }

    void onComplete() {
      if (!completer.isCompleted) completer.complete();
    }

    try {
      _fliqShowRewardedAd(onViewed.toJS, onComplete.toJS);
    } catch (_) {
      // adBreak tanımlı değilse (reklam engelleyici vs.) sessizce atla
      completer.complete();
    }

    await completer.future;
  }
}
