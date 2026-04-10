import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/league_constants.dart';
import '../../core/services/auth_service.dart';
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

final isPremiumProvider = AsyncNotifierProvider<PremiumNotifier, bool>(() => PremiumNotifier());

class PremiumNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    // Auth değişince RevenueCat'i yeniden başlat
    final user = ref.watch(authStateProvider).value;
    final service = ref.read(subscriptionServiceProvider);
    if (user != null) {
      await service.init(user.uid);
    }
    return service.isPremium;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(subscriptionServiceProvider).isPremium,
    );
  }
}

// ── League Providers ──────────────────────────────────────────────────────────

final leaderboardProvider = StreamProvider.family<List<LeagueMemberModel>, ({int leagueId, String role})>(
  (ref, params) {
    final season = LeagueConstants.currentSeasonKey;
    return LeagueService.leaderboardStream(season, params.leagueId, params.role);
  },
);
