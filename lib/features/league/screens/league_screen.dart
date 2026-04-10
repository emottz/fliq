import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/league_constants.dart';
import '../../../data/models/league_member_model.dart';
import '../../../shared/providers/app_providers.dart';

class LeagueScreen extends ConsumerStatefulWidget {
  const LeagueScreen({super.key});

  @override
  ConsumerState<LeagueScreen> createState() => _LeagueScreenState();
}

class _LeagueScreenState extends ConsumerState<LeagueScreen> {
  @override
  void initState() {
    super.initState();
    // Hafta geçişini kontrol et
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProfileProvider.notifier).checkLeagueTransition();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);

    return profileAsync.when(
      data: (profile) {
        if (profile == null) return const SizedBox();
        final leagueId = profile.leagueId;
        final league = LeagueConstants.getLeague(leagueId);
        final season = LeagueConstants.currentSeasonKey;
        final myUid = FirebaseAuth.instance.currentUser?.uid ?? '';

        return ref.watch(leaderboardProvider((leagueId: leagueId, role: profile.role))).when(
          data: (members) => _LeagueBody(
            league: league,
            members: members,
            myUid: myUid,
            season: season,
            weeklyXp: members
                .where((m) => m.uid == myUid)
                .map((m) => m.weeklyXp)
                .firstOrNull ?? 0,
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (_, __) => _LeagueBody(
            league: league,
            members: const [],
            myUid: myUid,
            season: season,
            weeklyXp: 0,
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (_, __) => const SizedBox(),
    );
  }
}

class _LeagueBody extends StatelessWidget {
  final LeagueInfo league;
  final List<LeagueMemberModel> members;
  final String myUid;
  final String season;
  final int weeklyXp;

  const _LeagueBody({
    required this.league,
    required this.members,
    required this.myUid,
    required this.season,
    required this.weeklyXp,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final seasonEnd = LeagueConstants.seasonEnd;
    final daysLeft = seasonEnd.difference(now).inDays;
    final hoursLeft = seasonEnd.difference(now).inHours % 24;

    final myRank = members.indexWhere((m) => m.uid == myUid) + 1;
    final total = members.length;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: CustomScrollView(
          slivers: [
            // ── Lig başlığı ──────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  children: [
                    _LeagueBanner(league: league, daysLeft: daysLeft, hoursLeft: hoursLeft),
                    const SizedBox(height: 12),
                    // Kullanıcının özeti
                    _MyStatRow(
                      rank: myRank,
                      total: total,
                      weeklyXp: weeklyXp,
                    ),
                    const SizedBox(height: 16),
                    // Açıklama
                    _ZoneLegend(total: total),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // ── Liderlik tablosu ─────────────────────────────────────────────
            if (members.isEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(
                    child: Text(
                      'Henüz kimse yok.\nBu haftaki ilk XP\'ini kazan!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverList.builder(
                  itemCount: members.length,
                  itemBuilder: (context, i) {
                    final member = members[i];
                    final rank = i + 1;
                    final isMe = member.uid == myUid;
                    final isPromo = rank <= 5 && total >= 10;
                    final isDemote = total >= 10 && rank > (total - 5);

                    return _LeaderboardRow(
                      rank: rank,
                      member: member,
                      isMe: isMe,
                      isPromo: isPromo,
                      isDemote: isDemote,
                      leagueId: league.id,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Banner ────────────────────────────────────────────────────────────────────

class _LeagueBanner extends StatelessWidget {
  final LeagueInfo league;
  final int daysLeft;
  final int hoursLeft;

  const _LeagueBanner({
    required this.league,
    required this.daysLeft,
    required this.hoursLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [league.color, league.color.withValues(alpha: 0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: league.color.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(league.emoji, style: const TextStyle(fontSize: 52)),
          const SizedBox(height: 8),
          Text(
            league.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            league.subtitle,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer_outlined, color: Colors.white70, size: 14),
                const SizedBox(width: 6),
                Text(
                  daysLeft > 0
                      ? '$daysLeft gün $hoursLeft saat kaldı'
                      : '$hoursLeft saat kaldı',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Kullanıcı özet satırı ─────────────────────────────────────────────────────

class _MyStatRow extends StatelessWidget {
  final int rank;
  final int total;
  final int weeklyXp;

  const _MyStatRow({
    required this.rank,
    required this.total,
    required this.weeklyXp,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MiniStat(label: 'Sıran', value: rank == 0 ? '—' : '#$rank'),
        const SizedBox(width: 10),
        _MiniStat(label: 'Bu hafta XP', value: weeklyXp.toString()),
        const SizedBox(width: 10),
        _MiniStat(label: 'Toplam oyuncu', value: total.toString()),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

// ── Zon açıklaması ────────────────────────────────────────────────────────────

class _ZoneLegend extends StatelessWidget {
  final int total;
  const _ZoneLegend({required this.total});

  @override
  Widget build(BuildContext context) {
    if (total < 10) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          'Lig dolduğunda yükselme/düşme bölgeleri aktif olur',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      );
    }
    return Row(
      children: [
        _ZonePill(color: const Color(0xFF22C55E), label: '↑ Yükseliyor (ilk 5)'),
        const SizedBox(width: 8),
        _ZonePill(color: const Color(0xFFEF4444), label: '↓ Düşüyor (son 5)'),
      ],
    );
  }
}

class _ZonePill extends StatelessWidget {
  final Color color;
  final String label;
  const _ZonePill({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// ── Leaderboard satırı ────────────────────────────────────────────────────────

class _LeaderboardRow extends StatelessWidget {
  final int rank;
  final LeagueMemberModel member;
  final bool isMe;
  final bool isPromo;
  final bool isDemote;
  final int leagueId;

  const _LeaderboardRow({
    required this.rank,
    required this.member,
    required this.isMe,
    required this.isPromo,
    required this.isDemote,
    required this.leagueId,
  });

  @override
  Widget build(BuildContext context) {
    Color? borderColor;
    Color rowBg = isMe ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surface;

    if (isPromo) borderColor = const Color(0xFF22C55E);
    if (isDemote) borderColor = const Color(0xFFEF4444);
    if (isMe) borderColor = AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: rowBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: borderColor ?? AppColors.divider,
          width: isMe ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Sıra
          SizedBox(
            width: 32,
            child: Text(
              rank <= 3
                  ? ['🥇', '🥈', '🥉'][rank - 1]
                  : '#$rank',
              style: TextStyle(
                fontSize: rank <= 3 ? 20 : 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 10),
          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.surfaceVariant,
            backgroundImage: member.photoUrl != null
                ? NetworkImage(member.photoUrl!)
                : null,
            child: member.photoUrl == null
                ? Text(
                    member.displayName.isNotEmpty
                        ? member.displayName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 10),
          // İsim + rol
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        isMe ? '${member.displayName} (Sen)' : member.displayName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isMe ? FontWeight.w700 : FontWeight.w600,
                          color: isMe ? AppColors.primary : AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department,
                        color: AppColors.streakFlame, size: 12),
                    const SizedBox(width: 3),
                    Text(
                      '${member.streakDays} gün',
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // XP
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${member.weeklyXp}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.xpOrange,
                ),
              ),
              const Text(
                'XP',
                style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),
            ],
          ),
          // Zone badge
          if (isPromo || isDemote) ...[
            const SizedBox(width: 8),
            Icon(
              isPromo ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
              size: 16,
              color: isPromo ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
            ),
          ],
        ],
      ),
    );
  }
}
