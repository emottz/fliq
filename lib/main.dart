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
      // ignore: avoid_print
      print('FLIQ_ERROR_WIDGET: ${details.exception}\n${details.stack}');
      // Küçük kırmızı nokta göster — tamamen boş yerine hata olduğunu belirtir
      return Container(
        color: Colors.transparent,
        alignment: Alignment.topLeft,
        child: Tooltip(
          message: details.exception.toString(),
          child: const SizedBox(width: 8, height: 8),
        ),
      );
    };

    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
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
