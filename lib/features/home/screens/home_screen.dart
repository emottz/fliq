import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/rank_constants.dart';
import '../../../shared/providers/app_providers.dart';

class HomeScreen extends ConsumerWidget {
  final Widget child;
  const HomeScreen({super.key, required this.child});

  static const _tabs = [
    (path: '/home/exams', icon: Icons.quiz_outlined, activeIcon: Icons.quiz, label: 'Sınavlar'),
    (path: '/home/lessons', icon: Icons.school_outlined, activeIcon: Icons.school, label: 'Dersler'),
    (path: '/home/profile', icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profil'),
  ];

  int _tabIndex(String path) {
    for (int i = 0; i < _tabs.length; i++) {
      if (path.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;
    final current = _tabIndex(location);
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: _XpStreakHeader(profileAsync: profileAsync),
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: current,
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.surfaceVariant,
        onDestinationSelected: (i) => context.go(_tabs[i].path),
        destinations: _tabs.map((t) => NavigationDestination(
          icon: Icon(t.icon),
          selectedIcon: Icon(t.activeIcon, color: AppColors.primary),
          label: t.label,
        )).toList(),
      ),
    );
  }
}

class _XpStreakHeader extends StatelessWidget {
  final AsyncValue profileAsync;
  const _XpStreakHeader({required this.profileAsync});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          const Text(
            'FLIQ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              letterSpacing: 2,
            ),
          ),
          const Spacer(),
          profileAsync.when(
            data: (profile) {
              if (profile == null) return const SizedBox();
              final rank = RankConstants.getRankForXp(profile.totalXp);
              return Row(
                children: [
                  const Icon(Icons.local_fire_department, color: AppColors.streakFlame, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${profile.streakDays}',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.bolt, color: AppColors.xpOrange, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${profile.totalXp} XP',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const SizedBox(width: 12),
                  Text(rank.emoji, style: const TextStyle(fontSize: 18)),
                ],
              );
            },
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
    );
  }
}
