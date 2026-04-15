import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/models/user_profile_model.dart';
import '../../features/splash/screens/splash_screen.dart';
import '../../features/auth/screens/auth_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/onboarding/screens/subscription_screen.dart';
import '../../features/assessment/screens/assessment_intro_screen.dart';
import '../../features/assessment/screens/assessment_screen.dart';
import '../../features/assessment/screens/assessment_analysis_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/exams/screens/exam_list_screen.dart';
import '../../features/exams/screens/exam_session_screen.dart';
import '../../features/exams/screens/exam_result_screen.dart';
import '../../features/lessons/screens/lesson_list_screen.dart';
import '../../features/lessons/screens/lesson_session_screen.dart';
import '../../features/admin/screens/admin_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/auth/screens/password_reset_screen.dart';

// Her uygulama başlangıcında splash bir kez gösterilir
bool _splashShown = false;
void markSplashShown() => _splashShown = true;

// Auth değişikliklerini GoRouter'a bildiren notifier
class _AuthNotifier extends ChangeNotifier {
  StreamSubscription<AuthState>? _sub;
  bool isRecovery = false;

  _AuthNotifier() {
    _sub = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      isRecovery = data.event == AuthChangeEvent.passwordRecovery;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final userRepo = UserRepository();
  final authNotifier = _AuthNotifier();

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: authNotifier,
    redirect: (context, state) async {
      final path = state.uri.path;

      // ── Splash henüz gösterilmediyse her zaman oraya git ──
      if (!_splashShown) {
        if (path == '/splash') return null;
        return '/splash';
      }

      // ── Admin paneli → yönlendirme yapma ──────────────────
      if (path == '/admin') return null;

      // ── Şifre sıfırlama recovery akışı ────────────────────
      if (authNotifier.isRecovery) {
        if (path == '/auth/reset-password') return null;
        return '/auth/reset-password';
      }

      final user = Supabase.instance.client.auth.currentUser;

      // ── Giriş yapılmamış → auth ekranı ────────────────────
      if (user == null) {
        if (path == '/auth') return null;
        return '/auth';
      }

      // ── Giriş yapılmış ama auth ekranındaysa → yönlendir ──
      if (path == '/auth') {
        final hasProfile = await userRepo.hasProfile;
        if (!hasProfile) return '/onboarding';
        final hasLevel = await userRepo.hasLevel;
        if (!hasLevel) return '/assessment-intro';
        return '/home/exams';
      }

      // ── Profil kontrolü ────────────────────────────────────
      const preAssessmentPaths = [
        '/assessment-intro',
        '/assessment',
        '/assessment-analysis',
      ];

      final hasProfile = await userRepo.hasProfile;
      if (!hasProfile) {
        if (path == '/onboarding') return null;
        return '/onboarding';
      }

      final hasLevel = await userRepo.hasLevel;
      if (!hasLevel) {
        if (preAssessmentPaths.contains(path)) return null;
        return '/assessment-intro';
      }

      if (path == '/onboarding' ||
          path == '/assessment-intro' ||
          path == '/assessment') {
        return '/home/exams';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/auth/reset-password',
        builder: (context, state) => const PasswordResetScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/assessment-intro',
        builder: (context, state) => const AssessmentIntroScreen(),
      ),
      GoRoute(
        path: '/assessment',
        builder: (context, state) => const AssessmentScreen(),
      ),
      GoRoute(
        path: '/assessment-analysis',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final rawResults = extra['categoryResults'] as Map<String, Map<String, int>>? ?? {};
          final levelName = extra['level'] as String? ?? 'beginner';
          final level = ProficiencyLevel.values.firstWhere(
            (l) => l.name == levelName,
            orElse: () => ProficiencyLevel.beginner,
          );
          return AssessmentAnalysisScreen(
            categoryResults: rawResults,
            level: level,
            totalCorrect: extra['totalCorrect'] as int? ?? 0,
            totalQuestions: extra['totalQuestions'] as int? ?? 15,
            role: extra['role'] as String? ?? 'student',
          );
        },
      ),
      GoRoute(
        path: '/subscription',
        builder: (context, state) => const SubscriptionScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => HomeScreen(child: child),
        routes: [
          GoRoute(
            path: '/home/exams',
            builder: (context, state) => const ExamListScreen(),
          ),
          GoRoute(
            path: '/home/lessons',
            builder: (context, state) => const LessonListScreen(),
          ),
GoRoute(
            path: '/home/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/exam/session',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ExamSessionScreen(config: extra ?? {});
        },
      ),
      GoRoute(
        path: '/exam/result',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ExamResultScreen(result: extra ?? {});
        },
      ),
      GoRoute(
        path: '/lesson/:lessonId',
        builder: (context, state) => LessonSessionScreen(
          lessonId: state.pathParameters['lessonId']!,
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Sayfa bulunamadı: ${state.uri}')),
    ),
  );
});
