import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/services/ad_service.dart';
import 'firebase_options.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      if (kIsWeb) {
        // ignore: avoid_print
        print('FLIQ_ERROR: ${details.exception}\n${details.stack}');
      }
    };

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    // AdMob başlat (web'de atla)
    if (!kIsWeb) {
      final adService = AdService();
      await adService.initialize();
    }

    runApp(const ProviderScope(child: FliqApp()));
  }, (error, stack) {
    // ignore: avoid_print
    print('FLIQ_ZONE_ERROR: $error\n$stack');
  });
}
