import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/rank_constants.dart';
import '../../../data/models/user_profile_model.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/coupon_bottom_sheet.dart';
import '../../../shared/widgets/premium_upsell_card.dart' show PremiumMemberBadge, PremiumUpsellCard, AuthorizedMemberBadge;
import '../../../shared/widgets/xp_progress_bar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return profileAsync.when(
      data: (profile) {
        if (profile == null) return const SizedBox();
        final role = profile.role.isNotEmpty ? profile.role : 'pilot';
        final rank = RankConstants.getRankForXp(profile.totalXp, role);

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Profil', style: AppTextStyles.heading2),
                  const SizedBox(height: 20),
                  // ── Google kullanıcı bilgileri ─────────────────────────────
                  _UserInfoCard(),
                  const SizedBox(height: 16),
                  // ── Premium / Yetkili durum ────────────────────────────────
                  const AuthorizedMemberBadge(),
                  PremiumMemberBadge(onTap: () => context.push('/subscription')),
                  const PremiumUpsellCard(source: 'profile'),
                  // Rank badge
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(rank.emoji, style: const TextStyle(fontSize: 56)),
                        const SizedBox(height: 8),
                        Text(
                          rank.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          role.replaceAll('_', ' ').toUpperCase(),
                          style: const TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // XP bar
                  XpProgressBar(xp: profile.totalXp, role: role),
                  const SizedBox(height: 20),
                  // Stats grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.6,
                    children: [
                      _StatCard(
                        label: 'Toplam XP',
                        value: profile.totalXp.toString(),
                        icon: Icons.bolt,
                        iconColor: AppColors.xpOrange,
                      ),
                      _StatCard(
                        label: 'Seri',
                        value: '${profile.streakDays} gün',
                        icon: Icons.local_fire_department,
                        iconColor: AppColors.streakFlame,
                      ),
                      _StatCard(
                        label: 'Seviye',
                        value: _levelName(profile.level),
                        icon: Icons.signal_cellular_alt,
                        iconColor: AppColors.primary,
                      ),
                      _StatCard(
                        label: 'Sınav Tarihi',
                        value: profile.targetExamDate != null
                            ? DateFormat('dd.MM.yyyy').format(profile.targetExamDate!)
                            : '—',
                        icon: Icons.calendar_today_outlined,
                        iconColor: AppColors.textSecondary,
                      ),
                    ],
                  ),
                  if (profile.targetExamDate != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.timer_outlined, color: AppColors.primary, size: 22),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Sınava kalan gün', style: AppTextStyles.caption),
                              Text(
                                '${profile.targetExamDate!.difference(DateTime.now()).inDays} gün',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  // ── Kupon kodu ─────────────────────────────────────────
                  _CouponTile(),
                  const SizedBox(height: 12),
                  // ── Çıkış butonu ───────────────────────────────────────
                  OutlinedButton.icon(
                    onPressed: () async {
                      await ref.read(authServiceProvider).signOut();
                      if (context.mounted) context.go('/auth');
                    },
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: const Text('Çıkış Yap'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),

                  const SizedBox(height: 8),
                  const Text('Rütbeler', style: AppTextStyles.heading3),
                  const SizedBox(height: 12),
                  ...RankConstants.ranksForRole(role).map((r) {
                    final unlocked = profile.totalXp >= r.xpRequired;
                    final isCurrent = r.title == rank.title;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isCurrent ? AppColors.surfaceVariant : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isCurrent ? AppColors.primary : AppColors.divider,
                          width: isCurrent ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(r.emoji, style: TextStyle(fontSize: 24, color: unlocked ? null : AppColors.locked)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: unlocked ? AppColors.textPrimary : AppColors.textHint,
                                  ),
                                ),
                                Text('${r.xpRequired} XP gerekli', style: AppTextStyles.caption),
                              ],
                            ),
                          ),
                          if (isCurrent)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text('Mevcut',
                                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                            )
                          else if (unlocked)
                            const Icon(Icons.check_circle, color: AppColors.success, size: 20)
                          else
                            const Icon(Icons.lock_outline, color: AppColors.textHint, size: 18),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      error: (_, __) => const SizedBox(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: AppTextStyles.caption),
                Text(value, style: AppTextStyles.bodyBold, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return const SizedBox();

    final name = user.userMetadata?['full_name'] as String? ??
        user.userMetadata?['name'] as String? ??
        user.email ??
        'Kullanıcı';
    final photoUrl = user.userMetadata?['avatar_url'] as String?;
    final isGoogle = user.appMetadata['provider'] == 'google';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.surfaceVariant,
            backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
            child: photoUrl == null
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 14),
          // İsim & e-posta
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Google rozeti
          if (isGoogle)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Google',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

String _levelName(ProficiencyLevel level) => switch (level) {
      ProficiencyLevel.beginner => 'Başlangıç',
      ProficiencyLevel.elementary => 'Temel',
      ProficiencyLevel.intermediate => 'Orta',
      ProficiencyLevel.advanced => 'İleri',
    };

class _CouponTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showCouponBottomSheet(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF16A34A).withValues(alpha: 0.35)),
        ),
        child: const Row(
          children: [
            Icon(Icons.local_offer_outlined, color: Color(0xFF16A34A), size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kupon Kodum Var', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF15803D))),
                  Text('Kodu girerek premium veya özel erişim kazan', style: TextStyle(fontSize: 11, color: Color(0xFF16A34A))),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Color(0xFF16A34A), size: 20),
          ],
        ),
      ),
    );
  }
}
