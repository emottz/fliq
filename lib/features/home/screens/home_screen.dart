import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/rank_constants.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/airplane_logo.dart';
import '../../../shared/widgets/hearts_display.dart';
import '../../../shared/widgets/premium_upsell_card.dart';

// Geniş ekran eşiği (px)
const _kWideBreakpoint = 720.0;

class HomeScreen extends ConsumerWidget {
  final Widget child;
  const HomeScreen({super.key, required this.child});

  static const _tabs = [
    (path: '/home/exams',   icon: Icons.quiz_outlined,        activeIcon: Icons.quiz,           label: 'Sınavlar'),
    (path: '/home/lessons', icon: Icons.school_outlined,      activeIcon: Icons.school,         label: 'Dersler'),
    (path: '/home/league',  icon: Icons.emoji_events_outlined, activeIcon: Icons.emoji_events,  label: 'Lig'),
    (path: '/home/profile', icon: Icons.person_outline,       activeIcon: Icons.person,         label: 'Profil'),
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
    final isWide = MediaQuery.sizeOf(context).width >= _kWideBreakpoint;

    if (isWide) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Row(
          children: [
            _SideNav(
              current: current,
              onTap: (i) => context.go(_tabs[i].path),
              profileAsync: profileAsync,
            ),
            const VerticalDivider(width: 1, thickness: 1, color: AppColors.divider),
            Expanded(child: child),
          ],
        ),
      );
    }

    // ── Dar ekran (mobil) ─────────────────────────────────────────────────────
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

// ── Masaüstü sol nav ──────────────────────────────────────────────────────────

class _SideNav extends StatelessWidget {
  final int current;
  final ValueChanged<int> onTap;
  final AsyncValue profileAsync;

  static const _tabs = HomeScreen._tabs;

  const _SideNav({
    required this.current,
    required this.onTap,
    required this.profileAsync,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Logo ────────────────────────────────────────────────────────────
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: AirplaneLogo(size: 40, showText: true),
          ),
          const SizedBox(height: 28),

          // ── Nav öğeleri ──────────────────────────────────────────────────────
          ...List.generate(_tabs.length, (i) {
            final tab = _tabs[i];
            final selected = i == current;
            return _NavItem(
              icon: selected ? tab.activeIcon : tab.icon,
              label: tab.label,
              selected: selected,
              onTap: () => onTap(i),
            );
          }),

          const Spacer(),

          // ── Premium CTA ──────────────────────────────────────────────────────
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: PremiumUpsellCard(
              source: 'sidebar',
              margin: EdgeInsets.only(bottom: 8),
            ),
          ),

          // ── XP / Seri bilgisi ────────────────────────────────────────────────
          _SideXpStreak(profileAsync: profileAsync),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.surfaceVariant : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SideXpStreak extends StatelessWidget {
  final AsyncValue profileAsync;
  const _SideXpStreak({required this.profileAsync});

  @override
  Widget build(BuildContext context) {
    return profileAsync.when(
      data: (profile) {
        if (profile == null) return const SizedBox();
        final rank = RankConstants.getRankForXp(profile.totalXp, profile.role);
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Text(rank.emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.bolt, color: AppColors.xpOrange, size: 14),
                        const SizedBox(width: 2),
                        Text(
                          '${profile.totalXp} XP',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.local_fire_department, color: AppColors.streakFlame, size: 14),
                        const SizedBox(width: 2),
                        Text(
                          '${profile.streakDays} gün seri',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const HeartsDisplay(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
    );
  }
}

// ── Mobil üst header ──────────────────────────────────────────────────────────

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
          const AirplaneLogo(size: 32, showText: true, horizontal: true),
          const Spacer(),
          const PremiumChip(),
          const SizedBox(width: 8),
          // Kalpler her zaman görünür (profile'dan bağımsız)
          const HeartsDisplay(),
          profileAsync.when(
            data: (profile) {
              if (profile == null) return const SizedBox();
              final rank = RankConstants.getRankForXp(profile.totalXp, profile.role);
              return Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(Icons.local_fire_department, color: AppColors.streakFlame, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${profile.streakDays}',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.bolt, color: AppColors.xpOrange, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${profile.totalXp} XP',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const SizedBox(width: 10),
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
