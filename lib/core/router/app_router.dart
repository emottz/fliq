import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/repositories/user_repository.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/onboarding/screens/subscription_screen.dart';
import '../../features/assessment/screens/assessment_intro_screen.dart';
import '../../features/assessment/screens/assessment_screen.dart';
import '../../features/assessment/screens/assessment_analysis_screen.dart';
import '../../data/models/user_profile_model.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/exams/screens/exam_list_screen.dart';
import '../../features/exams/screens/exam_session_screen.dart';
import '../../features/exams/screens/exam_result_screen.dart';
import '../../features/lessons/screens/lesson_list_screen.dart';
import '../../features/lessons/screens/lesson_session_screen.dart';
import '../../features/profile/screens/profile_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final userRepo = UserRepository();

  return GoRouter(
    initialLocation: '/onboarding',
    redirect: (context, state) async {
      final hasProfile = await userRepo.hasProfile;
      final hasLevel = await userRepo.hasLevel;

      final path = state.uri.path;

      if (!hasProfile) {
        if (path == '/onboarding') return null;
        return '/onboarding';
      }

      const preAssessmentPaths = [
        '/assessment-intro',
        '/assessment',
        '/assessment-analysis',
        '/subscription',
      ];

      if (!hasLevel) {
        if (preAssessmentPaths.contains(path)) return null;
        return '/assessment-intro';
      }

      if (path == '/onboarding' ||
          path == '/assessment-intro' ||
          path == '/assessment' ||
          path == '/assessment-analysis' ||
          path == '/subscription') {
        return '/home/exams';
      }

      return null;
    },
    routes: [
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
      body: Center(child: Text('Page not found: ${state.uri}')),
    ),
  );
});
