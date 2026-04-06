// ⚠️  Bu dosyayı Firebase Console'dan alacağınız değerlerle doldurun.
//
// Adımlar:
// 1. https://console.firebase.google.com adresine gidin
// 2. Proje oluşturun → "Web uygulaması ekle" → uygulama adını girin
// 3. Görünen firebaseConfig değerlerini aşağıya kopyalayın
// 4. Authentication → Sign-in method → Email/Password ve Google'ı etkinleştirin
// 5. Google için → Web client ID'yi alın, web/index.html'e ekleyin (oradaki yorum satırına bakın)

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return web;
    }
  }

  // Firebase Console → Proje Ayarları → Web uygulamanızın yapılandırması
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  );

  // Android için google-services.json dosyasını android/app/ klasörüne ekleyin
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  );

  // iOS için GoogleService-Info.plist dosyasını ios/Runner/ klasörüne ekleyin
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    iosBundleId: 'com.example.fliq',
  );
}
