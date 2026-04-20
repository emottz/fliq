import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/iap_constants.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/ad_service.dart';
import '../../core/services/hearts_service.dart';
import '../../core/services/vocabulary_service.dart';
import '../../core/services/iap_service.dart';
import '../../core/services/coupon_service.dart';
import '../../core/services/subscription_service.dart';
import '../../data/datasources/asset_question_source.dart';
import '../../data/models/user_profile_model.dart';
import '../../data/repositories/question_repository.dart';
import '../../data/repositories/user_repository.dart';

// ── Auth ──────────────────────────────────────────────────────────────────────

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StreamProvider<User?>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange
      .map((s) => s.session?.user);
});

final userRepositoryProvider = Provider<UserRepository>((ref) => UserRepository());

final questionRepositoryProvider = Provider<QuestionRepository>((ref) {
  return QuestionRepository(AssetQuestionSource());
});

final userProfileProvider = AsyncNotifierProvider<UserProfileNotifier, UserProfileModel?>(() {
  return UserProfileNotifier();
});

class UserProfileNotifier extends AsyncNotifier<UserProfileModel?> {
  @override
  Future<UserProfileModel?> build() async {
    final repo = ref.read(userRepositoryProvider);
    return repo.getProfile();
  }

  Future<void> saveProfile(UserProfileModel profile) async {
    final repo = ref.read(userRepositoryProvider);
    await repo.saveProfile(profile);
    state = AsyncData(profile);
  }

  Future<void> saveLevel(UserProfileModel profile) async {
    final repo = ref.read(userRepositoryProvider);
    await repo.saveLevel(profile);
    state = AsyncData(profile);
  }

  Future<void> addXp(int amount) async {
    final repo = ref.read(userRepositoryProvider);
    await repo.addXp(amount);
    final updated = await repo.getProfile();
    state = AsyncData(updated);

  }

  /// Streak günceller ve yeni gün ise yeni streak sayısını döndürür, aynı günse 0.
  Future<int> updateStreak() async {
    final repo = ref.read(userRepositoryProvider);
    final newStreak = await repo.updateStreak();
    final updated = await repo.getProfile();
    state = AsyncData(updated);
    return newStreak;
  }

}

// ── Subscription ──────────────────────────────────────────────────────────────

final subscriptionServiceProvider = Provider<SubscriptionService>((ref) => SubscriptionService());

final couponServiceProvider = Provider<CouponService>((ref) => CouponService());

/// Supabase realtime stream üzerinden premium durumu.
final isPremiumProvider = StreamProvider<bool>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(false);
  return ref.read(subscriptionServiceProvider).premiumStream(user.id);
});

/// Supabase stream üzerinden yetkili üye durumu.
final isAuthorizedProvider = StreamProvider<bool>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(false);
  return ref.read(couponServiceProvider).authorizedStream(user.id);
});

// ── Vocabulary / Sözlük ───────────────────────────────────────────────────────

final vocabularyServiceProvider =
    Provider<VocabularyService>((ref) => VocabularyService());

final learnedTermsProvider =
    AsyncNotifierProvider<LearnedTermsNotifier, Set<String>>(
        LearnedTermsNotifier.new);

class LearnedTermsNotifier extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() async =>
      ref.read(vocabularyServiceProvider).getLearnedTerms();

  Future<void> markLearned(String term) async {
    await ref.read(vocabularyServiceProvider).markLearned(term);
    state = AsyncData((state.value ?? {})..add(term));
  }
}

// ── Hearts ────────────────────────────────────────────────────────────────────

final heartsServiceProvider = Provider<HeartsService>((ref) => HeartsService());

typedef HeartsState = ({int count, DateTime? resetTime});

final heartsProvider =
    AsyncNotifierProvider<HeartsNotifier, HeartsState>(() => HeartsNotifier());

class HeartsNotifier extends AsyncNotifier<HeartsState> {
  @override
  Future<HeartsState> build() async {
    final svc = ref.read(heartsServiceProvider);
    return svc.getState();
  }

  /// Kalpleri kullanır. Yeterliyse true, değilse false döner.
  Future<bool> use(int cost) async {
    final svc = ref.read(heartsServiceProvider);
    final ok = await svc.useHearts(cost);
    if (ok) state = AsyncData(await svc.getState());
    return ok;
  }

  Future<void> refresh() async {
    final svc = ref.read(heartsServiceProvider);
    state = AsyncData(await svc.getState());
  }
}

// ── AdMob ─────────────────────────────────────────────────────────────────────

final adServiceProvider = Provider<AdService>((ref) => AdService());

// ── In-App Purchase ───────────────────────────────────────────────────────────

/// Kullanılabilir Play Store ürünlerini tutar.
final iapProductsProvider =
    AsyncNotifierProvider<IapProductsNotifier, List<ProductDetails>>(
      IapProductsNotifier.new,
    );

class IapProductsNotifier extends AsyncNotifier<List<ProductDetails>> {
  @override
  Future<List<ProductDetails>> build() async {
    if (kIsWeb) return [];
    final svc = IapService.instance;
    if (!svc.isSupported) return [];
    final available = await svc.isAvailable();
    if (!available) return [];
    return svc.queryProducts();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await IapService.instance.queryProducts());
  }
}

/// Satın alma akışını dinler ve Firestore'u günceller.
/// main.dart veya app.dart'ta bir kez initialize edilmeli.
final iapListenerProvider = Provider<void>((ref) {
  if (kIsWeb) return;
  if (!Platform.isAndroid && !Platform.isIOS) return;

  IapService.instance.initialize(
    onPurchase: (purchase) async {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        final uid = Supabase.instance.client.auth.currentUser?.id;
        if (uid != null) {
          try {
            final token = IapService.instance.androidPurchaseToken(purchase);
            final svc = ref.read(subscriptionServiceProvider);
            await svc.activatePremiumFromIap(
              uid: uid,
              productId: purchase.productID,
              purchaseToken: token,
            );
          } catch (_) {}
        }
        await IapService.instance.completePurchase(purchase);
      } else if (purchase.status == PurchaseStatus.error) {
        await IapService.instance.completePurchase(purchase);
      }
    },
  );

  ref.onDispose(() => IapService.instance.dispose());
});

/// Belirli bir rol+periyot için ProductDetails
final iapProductProvider =
    Provider.family<ProductDetails?, ({String roleKey, bool annual})>(
      (ref, params) {
        final products = ref.watch(iapProductsProvider).value ?? [];
        final targetId = IapConstants.productId(
          roleKey: params.roleKey,
          annual: params.annual,
        );
        try {
          return products.firstWhere((p) => p.id == targetId);
        } catch (_) {
          return null;
        }
      },
    );

