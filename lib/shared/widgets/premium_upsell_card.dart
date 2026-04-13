import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../providers/app_providers.dart';

// ── Compact gold chip for headers / nav bars ──────────────────────────────────

/// Küçük altın chip: premium değilse "👑 Pro" butonu gösterir,
/// premium ise "👑" rozeti gösterir.
class PremiumChip extends ConsumerWidget {
  const PremiumChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumProvider).value ?? false;

    if (isPremium) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF92400E), AppColors.rankGold],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text('👑', style: TextStyle(fontSize: 14)),
      );
    }

    return GestureDetector(
      onTap: () => context.push('/subscription'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.warning.withValues(alpha: 0.45)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('👑', style: TextStyle(fontSize: 13)),
            SizedBox(width: 4),
            Text(
              'Pro',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.warning,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Full upsell card (exam/lesson/profile screens) ────────────────────────────

/// Altın gradient upsell kartı. Zaten premium olan kullanıcılara
/// otomatik olarak gizlenir.
class PremiumUpsellCard extends ConsumerWidget {
  /// 'exams' | 'lessons' | 'profile' — bağlama göre farklı yazı gösterir.
  final String source;
  final EdgeInsetsGeometry margin;

  const PremiumUpsellCard({
    super.key,
    required this.source,
    this.margin = const EdgeInsets.only(bottom: 16),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumProvider).value ?? false;
    if (isPremium) return const SizedBox.shrink();
    // Sidebar dar olduğu için ayrı kompakt layout kullan
    if (source == 'sidebar') return _SidebarCard(margin: margin);
    return _UpsellCard(source: source, margin: margin);
  }
}

class _UpsellCard extends StatelessWidget {
  final String source;
  final EdgeInsetsGeometry margin;
  const _UpsellCard({required this.source, required this.margin});

  String get _subtitle => switch (source) {
        'exams'   => 'Tüm sınav modları · Lig şampiyonası · Sınırsız pratik',
        'lessons' => 'Tüm dersleri aç · Mesleğine özel müfredat · Lig',
        'profile' => 'Mesleğine özel içerik · Lig · Tüm soru bankası',
        _         => 'Aylık \$10\'dan başlayan fiyatlarla tüm özellikleri aç',
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/subscription'),
      child: Container(
        margin: margin,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF92400E), AppColors.warning, AppColors.rankGold],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.warning.withValues(alpha: 0.28),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            const Text('👑', style: TextStyle(fontSize: 26)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Avialish Premium',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _subtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Planlar →',
                style: TextStyle(
                  color: Color(0xFF92400E),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sidebar kompakt kart (dar alan için) ─────────────────────────────────────

/// Sol nav sidebar gibi dar (≤220px) alanlarda kullanılan dikey layout.
class _SidebarCard extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  const _SidebarCard({required this.margin});

  static const _gradient = LinearGradient(
    colors: [Color(0xFF92400E), AppColors.warning, AppColors.rankGold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/subscription'),
      child: Container(
        margin: margin,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: _gradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.warning.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text('👑', style: TextStyle(fontSize: 16)),
                SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Avialish Premium',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Planları Gör →',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF92400E),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Premium member badge (profile screen) ─────────────────────────────────────

/// Profil ekranında gösterilen "Avialish Premium" üye rozeti.
/// Sadece premium kullanıcılara gösterilir.
class PremiumMemberBadge extends ConsumerWidget {
  const PremiumMemberBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumProvider).value ?? false;
    if (!isPremium) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF92400E), AppColors.warning, AppColors.rankGold],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.warning.withValues(alpha: 0.22),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        children: [
          Text('👑', style: TextStyle(fontSize: 24)),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Avialish Premium',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Tüm içeriklere erişimin aktif',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          Spacer(),
          Icon(Icons.check_circle_rounded, color: Colors.white, size: 22),
        ],
      ),
    );
  }
}
