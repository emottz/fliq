import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/auth_service.dart';
import '../../data/datasources/asset_question_source.dart';
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
  }

  Future<void> updateStreak() async {
    final repo = ref.read(userRepositoryProvider);
    await repo.updateStreak();
    final updated = await repo.getProfile();
    state = AsyncData(updated);
  }
}
