import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/hearts_service.dart';
import '../providers/app_providers.dart';

const int _adRewardAmount = 5;

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
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) return '${h}s ${m.toString().padLeft(2, '0')}d';
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
              isEmpty ? _fmt(_remaining) : '${widget.count}',
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
              // Sol: ikon + metin
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
                      'Reklam izleyerek +5 ❤️ kazan',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Sağ: reklam butonu
              WatchAdButton(compact: true),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Reklam izle butonu (yeniden kullanılabilir) ───────────────────────────────

/// Reklam izleyerek +5 ❤️ kazandıran buton.
/// [compact] → banner içi küçük stil, false → tam genişlik büyük stil.
class WatchAdButton extends ConsumerStatefulWidget {
  final bool compact;
  final VoidCallback? onRewarded;
  const WatchAdButton({super.key, this.compact = false, this.onRewarded});

  @override
  ConsumerState<WatchAdButton> createState() => _WatchAdButtonState();
}

class _WatchAdButtonState extends ConsumerState<WatchAdButton> {
  bool _loading = false;
  bool _watched = false;

  Future<void> _watch() async {
    final adService = ref.read(adServiceProvider);

    if (!adService.isSupported) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reklam bu platformda desteklenmiyor.')),
      );
      return;
    }

    if (!adService.isAdReady) {
      setState(() => _loading = true);
      await adService.load();
      for (int i = 0; i < 10; i++) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (adService.isAdReady) break;
      }
      if (!mounted) return;
      setState(() => _loading = false);
    }

    if (!adService.isAdReady) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Şu an reklam mevcut değil. Biraz sonra tekrar dene.'),
        ),
      );
      return;
    }

    await adService.show(
      onRewarded: () async {
        await ref.read(heartsProvider.notifier).addFromAd(_adRewardAmount);
        if (mounted) {
          setState(() => _watched = true);
          widget.onRewarded?.call();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final adService = ref.read(adServiceProvider);
    if (!adService.isSupported) return const SizedBox.shrink();

    if (_watched) {
      return widget.compact
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '✅ +5 ❤️',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          : Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('✅', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 8),
                  Text(
                    '+5 ❤️ kazanıldı!',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.successDark,
                    ),
                  ),
                ],
              ),
            );
    }

    if (widget.compact) {
      return GestureDetector(
        onTap: _loading ? null : _watch,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: _loading
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    color: AppColors.error,
                    strokeWidth: 2,
                  ),
                )
              : const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_circle_filled, color: AppColors.error, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '+5 ❤️ İzle',
                      style: TextStyle(
                        color: AppColors.error,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
        ),
      );
    }

    // Tam genişlik buton
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _loading ? null : _watch,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: _loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_circle_outline, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Reklam İzle  +5 ❤️',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ],
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
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) return '$h saat ${m.toString().padLeft(2, '0')} dakika';
    if (m > 0) return '$m dakika ${s.toString().padLeft(2, '0')} saniye';
    return '$s saniye';
  }

  @override
  Widget build(BuildContext context) {
    final hearts = ref.watch(heartsProvider).value;
    final currentCount = hearts?.count ?? widget.count;
    final isFull = currentCount >= HeartsService.maxHearts;

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

          // Geri sayım
          if (widget.resetTime != null) ...[
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
                          'Otomatik yenileme',
                          style: const TextStyle(fontSize: 12, color: AppColors.errorDark),
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

          // Reklam butonu — kalpler dolmamışsa göster
          if (!isFull) ...[
            const SizedBox(height: 16),
            // Ayırıcı + açıklama
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'ya da hemen kazan',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 12),
            WatchAdButton(compact: false),
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

/// Kalp yetersizse sheet açar. true → devam et, false → iptal.
Future<bool> showNoHeartsDialog(
  BuildContext context,
  WidgetRef ref,
  int cost,
) async {
  HeartsState? nullable = ref.read(heartsProvider).value;
  if (nullable == null) {
    await Future.delayed(const Duration(milliseconds: 300));
    nullable = ref.read(heartsProvider).value;
  }
  if (nullable == null) return true;
  final heartsState = nullable;

  if (heartsState.count >= cost) return true;

  final remaining = heartsState.resetTime != null
      ? heartsState.resetTime!.difference(DateTime.now())
      : Duration.zero;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => ProviderScope(
      parent: ProviderScope.containerOf(context),
      child: _HeartsBottomSheet(
        count: heartsState.count,
        resetTime: heartsState.resetTime,
        remaining: remaining.isNegative ? Duration.zero : remaining,
      ),
    ),
  );

  final updated = ref.read(heartsProvider).value;
  if (updated != null && updated.count >= cost) return true;
  return false;
}
