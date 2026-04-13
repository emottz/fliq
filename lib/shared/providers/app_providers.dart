import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/league_constants.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/ad_service.dart';
import '../../core/services/hearts_service.dart';
import '../../core/services/league_service.dart';
import '../../core/services/subscription_service.dart';
import '../../data/datasources/asset_question_source.dart';
import '../../data/models/league_member_model.dart';
import '../../data/models/user_profile_model.dart';
import '../../data/repositories/question_repository.dart';
import '../../data/repositories/user_repository.dart';

// ── Auth ──────────────────────────────────────────────────────────────────────

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authServiceProvider).authStateChanges;
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

    // Lig haftalık XP'i de güncelle
    if (updated != null) {
      final season = LeagueConstants.currentSeasonKey;
      await LeagueService.addWeeklyXp(
        season: season,
        leagueId: updated.leagueId,
        amount: amount,
        streakDays: updated.streakDays,
        role: updated.role,
      );
    }
  }

  /// Streak günceller ve yeni gün ise yeni streak sayısını döndürür, aynı günse 0.
  Future<int> updateStreak() async {
    final repo = ref.read(userRepositoryProvider);
    final newStreak = await repo.updateStreak();
    final updated = await repo.getProfile();
    state = AsyncData(updated);
    return newStreak;
  }

  /// Hafta geçişini kontrol eder, gerekirse lig değiştirir
  Future<void> checkLeagueTransition() async {
    final profile = state.valueOrNull;
    if (profile == null) return;
    final role = profile.role.isEmpty ? 'student' : profile.role;
    final newLeagueId = await LeagueService.checkSeasonTransition(profile.leagueId, role);
    if (newLeagueId != profile.leagueId) {
      final updated = profile.copyWith(leagueId: newLeagueId);
      final repo = ref.read(userRepositoryProvider);
      await repo.saveProfile(updated);
      state = AsyncData(updated);
    }
    // Liğe katıl (yeni sezon veya ilk kez)
    final season = LeagueConstants.currentSeasonKey;
    await LeagueService.joinLeague(
      season: season,
      leagueId: newLeagueId,
      weeklyXp: await LeagueService.getMyWeeklyXp(season, newLeagueId, role),
      role: role,
    );
  }
}

// ── Subscription ──────────────────────────────────────────────────────────────

final subscriptionServiceProvider = Provider<SubscriptionService>((ref) => SubscriptionService());

/// Firestore stream üzerinden gerçek zamanlı premium durumu.
/// Ödeme tamamlanınca Cloud Function Firestore'u günceller → otomatik yansır.
final isPremiumProvider = StreamProvider<bool>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(false);
  return ref.read(subscriptionServiceProvider).premiumStream(user.uid);
});

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

  /// Reklam ödülü ile kalp ekler.
  Future<void> addFromAd(int amount) async {
    final svc = ref.read(heartsServiceProvider);
    await svc.addHearts(amount);
    state = AsyncData(await svc.getState());
  }

  Future<void> refresh() async {
    final svc = ref.read(heartsServiceProvider);
    state = AsyncData(await svc.getState());
  }
}

// ── AdMob ─────────────────────────────────────────────────────────────────────

final adServiceProvider = Provider<AdService>((ref) => AdService());

// ── League Providers ──────────────────────────────────────────────────────────

final leaderboardProvider = StreamProvider.family<List<LeagueMemberModel>, ({int leagueId, String role})>(
  (ref, params) {
    final season = LeagueConstants.currentSeasonKey;
    return LeagueService.leaderboardStream(season, params.leagueId, params.role);
  },
);
