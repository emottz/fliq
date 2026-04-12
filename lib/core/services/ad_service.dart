// Platform'a göre doğru implementasyonu seç:
//   Web  → ad_service_web.dart  (AdSense H5 Games / JS interop)
//   Diğer → ad_service_mobile.dart (Google AdMob)
export 'ad_service_mobile.dart' if (dart.library.html) 'ad_service_web.dart';
