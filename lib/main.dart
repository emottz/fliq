import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'core/constants/supabase_config.dart';
import 'core/services/ad_service.dart';

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

    // Release modda gri kutu yerine sayfa yenile butonu göster
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Material(
        color: Colors.transparent,
        child: Center(
          child: GestureDetector(
            onTap: () {
              // Sayfayı yenile
              if (kIsWeb) {
                // ignore: avoid_print
                print('FLIQ_ERROR_WIDGET: ${details.exception}');
              }
            },
            child: const SizedBox.shrink(),
          ),
        ),
      );
    };

    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );

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
