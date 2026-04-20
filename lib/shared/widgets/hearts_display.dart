import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/hearts_service.dart';
import '../providers/app_providers.dart';

// ── Üst bar kalp sayacı ───────────────────────────────────────────────────────

/// Üst barda gösterilen kalp sayacı. Tıklanınca bilgi sheet'i açar.
class HeartsDisplay extends ConsumerStatefulWidget {
  const HeartsDisplay({super.key});

  @override
  ConsumerState<HeartsDisplay> createState() => _HeartsDisplayState();
}

class _HeartsDisplayState extends ConsumerState<HeartsDisplay> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(minutes: 1), (_) {
      ref.read(heartsProvider.notifier).refresh();
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = ref.watch(isPremiumProvider).value ?? false;
    if (isPremium) return const SizedBox.shrink();

    final async = ref.watch(heartsProvider);
    return async.when(
      data: (s) => _HeartsChip(count: s.count, resetTime: s.resetTime),
      loading: () => _HeartsChip(count: HeartsService.maxHearts, resetTime: null),
      error: (_, __) => const SizedBox(),
    );
  }
}

class _HeartsChip extends StatefulWidget {
  final int count;
  final DateTime? resetTime;
  const _HeartsChip({required this.count, required this.resetTime});

  @override
  State<_HeartsChip> createState() => _HeartsChipState();
}

class _HeartsChipState extends State<_HeartsChip> {
  Timer? _ticker;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    if (widget.resetTime != null) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _updateRemaining());
    }
  }

  @override
  void didUpdateWidget(_HeartsChip old) {
    super.didUpdateWidget(old);
    _ticker?.cancel();
    _ticker = null;
    _updateRemaining();
    if (widget.resetTime != null) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _updateRemaining());
    }
  }

  void _updateRemaining() {
    if (!mounted) return;
    if (widget.resetTime == null) { setState(() => _remaining = Duration.zero); return; }
    final diff = widget.resetTime!.difference(DateTime.now());
    setState(() => _remaining = diff.isNegative ? Duration.zero : diff);
  }

  @override
  void dispose() { _ticker?.cancel(); super.dispose(); }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (m > 0) return '${m}d ${s.toString().padLeft(2, '0')}s';
    return '${s}s';
  }

  Color get _color {
    if (widget.count == 0) return AppColors.locked;
    if (widget.count <= 5) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = widget.count == 0;
    return GestureDetector(
      onTap: () => _showSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: _color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('❤️', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              isEmpty && widget.resetTime != null ? _fmt(_remaining) : '${widget.count}',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _color),
            ),
          ],
        ),
      ),
    );
  }

  void _showSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => ProviderScope(
        parent: ProviderScope.containerOf(context),
        child: _HeartsBottomSheet(
          count: widget.count,
          resetTime: widget.resetTime,
          remaining: _remaining,
        ),
      ),
    );
  }
}

// ── Haklar bitti — ana ekran banner'ı ────────────────────────────────────────

/// Sınavlar ekranının üstünde gösterilen "Hakkın bitti" motivasyon barı.
/// Yalnızca hearts == 0 olduğunda görünür.
class HeartsEmptyBanner extends ConsumerWidget {
  const HeartsEmptyBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumProvider).value ?? false;
    if (isPremium) return const SizedBox.shrink();
    final hearts = ref.watch(heartsProvider).value;
    if (hearts == null || hearts.count > 0) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.errorDark, AppColors.error],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Text('❤️', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Günlük hakkın bitti!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Her 20 dakikada +5 ❤️ otomatik dolar',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Kalp bilgi bottom sheet ───────────────────────────────────────────────────

class _HeartsBottomSheet extends ConsumerStatefulWidget {
  final int count;
  final DateTime? resetTime;
  final Duration remaining;
  const _HeartsBottomSheet({
    required this.count,
    required this.resetTime,
    required this.remaining,
  });

  @override
  ConsumerState<_HeartsBottomSheet> createState() => _HeartsBottomSheetState();
}

class _HeartsBottomSheetState extends ConsumerState<_HeartsBottomSheet> {
  Timer? _ticker;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.remaining;
    if (widget.resetTime != null) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        final diff = widget.resetTime!.difference(DateTime.now());
        setState(() => _remaining = diff.isNegative ? Duration.zero : diff);
      });
    }
  }

  @override
  void dispose() { _ticker?.cancel(); super.dispose(); }

  String _formatCountdown(Duration d) {
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (m > 0) return '$m dakika ${s.toString().padLeft(2, '0')} saniye';
    return '$s saniye';
  }

  @override
  Widget build(BuildContext context) {
    final hearts = ref.watch(heartsProvider).value;
    final currentCount = hearts?.count ?? widget.count;
    final regenTime = hearts?.resetTime ?? widget.resetTime;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.viewInsetsOf(context).bottom + 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tutamaç
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 20),

          // Başlık
          Row(
            children: [
              const Text('❤️', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentCount == 0 ? 'Günlük hakkın bitti!' : 'Günlük Haklar',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '$currentCount / ${HeartsService.maxHearts} kalp',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Kalp çubuğu
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: currentCount / HeartsService.maxHearts,
              minHeight: 10,
              backgroundColor: AppColors.divider,
              valueColor: AlwaysStoppedAnimation<Color>(
                currentCount == 0 ? AppColors.locked : AppColors.error,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Maliyet satırları
          _CostRow(icon: '📚', label: 'Ders başlatma', cost: HeartsService.lessonCost),
          const SizedBox(height: 8),
          _CostRow(icon: '📝', label: 'Sınav başlatma', cost: HeartsService.examCost),

          // Sonraki regen geri sayımı
          if (regenTime != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.errorBorder),
              ),
              child: Row(
                children: [
                  const Text('⏰', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sonraki +5 ❤️',
                          style: TextStyle(fontSize: 12, color: AppColors.errorDark),
                        ),
                        Text(
                          _formatCountdown(_remaining),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (regenTime == null && currentCount < HeartsService.maxHearts) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Text('💡', style: TextStyle(fontSize: 18)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Her 20 dakikada +5 ❤️ otomatik dolar',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CostRow extends StatelessWidget {
  final String icon;
  final String label;
  final int cost;
  const _CostRow({required this.icon, required this.label, required this.cost});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
        Text(
          '❤️ $cost',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.error,
          ),
        ),
      ],
    );
  }
}

// ── showNoHeartsDialog ────────────────────────────────────────────────────────

/// Kalp yetersizse merkezi popup açar. true → devam et, false → iptal.
/// Premium kullanıcılar her zaman true döner (sınırsız hak).
Future<bool> showNoHeartsDialog(
  BuildContext context,
  WidgetRef ref,
  int cost,
) async {
  final isPremium = ref.read(isPremiumProvider).value ?? false;
  if (isPremium) return true;

  HeartsState? nullable = ref.read(heartsProvider).value;
  if (nullable == null) {
    for (int i = 0; i < 6; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      nullable = ref.read(heartsProvider).value;
      if (nullable != null) break;
    }
  }
  if (nullable == null) return true;
  if (nullable.count >= cost) return true;
  // ignore: use_build_context_synchronously
  final result = await showGeneralDialog<bool>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder: (ctx, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutBack);
      return ScaleTransition(scale: curved, child: FadeTransition(opacity: anim, child: child));
    },
    pageBuilder: (ctx, _, __) => ProviderScope(
      parent: ProviderScope.containerOf(context),
      child: _NoHeartsDialog(cost: cost),
    ),
  );

  return result == true;
}

// ── Kalp bitti popup ──────────────────────────────────────────────────────────

class _NoHeartsDialog extends ConsumerStatefulWidget {
  final int cost;
  const _NoHeartsDialog({required this.cost});

  @override
  ConsumerState<_NoHeartsDialog> createState() => _NoHeartsDialogState();
}

class _NoHeartsDialogState extends ConsumerState<_NoHeartsDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceCtrl;
  late Animation<double> _bounceAnim;
  Timer? _countdownTicker;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();

    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _bounceAnim = Tween<double>(begin: 0.0, end: -8.0).animate(
      CurvedAnimation(parent: _bounceCtrl, curve: Curves.easeInOut),
    );

    _startCountdown();
  }

  void _startCountdown() {
    final regenTime = ref.read(heartsProvider).value?.resetTime;
    if (regenTime == null) return;
    final diff = regenTime.difference(DateTime.now());
    _remaining = diff.isNegative ? Duration.zero : diff;
    _countdownTicker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final rt = ref.read(heartsProvider).value?.resetTime;
      if (rt == null) { setState(() => _remaining = Duration.zero); return; }
      final d = rt.difference(DateTime.now());
      setState(() => _remaining = d.isNegative ? Duration.zero : d);
    });
  }

  @override
  void dispose() {
    _bounceCtrl.dispose();
    _countdownTicker?.cancel();
    super.dispose();
  }

  String _fmtCountdown(Duration d) {
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (m > 0) return '${m}d ${s.toString().padLeft(2, '0')}sn';
    return '${s}sn';
  }

  @override
  Widget build(BuildContext context) {
    final hasCountdown = _remaining > Duration.zero;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 40,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Kırmızı header ────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFB91C1C), Color(0xFFEF4444)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  children: [
                    // Zıplayan kalpler
                    AnimatedBuilder(
                      animation: _bounceAnim,
                      builder: (_, __) => Transform.translate(
                        offset: Offset(0, _bounceAnim.value),
                        child: const Text('❤️', style: TextStyle(fontSize: 52)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Hakkın Bitti!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Her 20 dakikada +5 ❤️ otomatik dolar',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                    // Geri sayım
                    if (hasCountdown) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.timer_outlined, color: Colors.white70, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              'Sonraki +5 ❤️: ${_fmtCountdown(_remaining)}',
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
                  ],
                ),
              ),

              // ── Seçenekler ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 8),
                child: Column(
                  children: [
                    // Premium butonu
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(false);
                        final router = GoRouter.maybeOf(context);
                        if (router != null) {
                          router.push('/subscription');
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF92400E), Color(0xFFF59E0B), Color(0xFFFCD34D)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFF59E0B).withValues(alpha: 0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('👑', style: TextStyle(fontSize: 18)),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sınırsız Premium',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'Hiç kalp bitmesin • Tüm içerikler',
                                  style: TextStyle(color: Colors.white70, fontSize: 11),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Bekle linki
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(false),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Bekle',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
