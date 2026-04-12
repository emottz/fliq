import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/hearts_service.dart';
import '../providers/app_providers.dart';

const int _adRewardAmount = 5;

/// Üst barda gösterilen kalp sayacı. Tıklanınca kalan süreyi gösterir.
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
    // Her dakika kalpleri kontrol et (dolum zamanı geçmiş olabilir)
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
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        _updateRemaining();
      });
    }
  }

  @override
  void didUpdateWidget(_HeartsChip old) {
    super.didUpdateWidget(old);
    _ticker?.cancel();
    _ticker = null;
    _updateRemaining();
    if (widget.resetTime != null) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        _updateRemaining();
      });
    }
  }

  void _updateRemaining() {
    if (!mounted) return;
    if (widget.resetTime == null) {
      setState(() => _remaining = Duration.zero);
      return;
    }
    final diff = widget.resetTime!.difference(DateTime.now());
    setState(() => _remaining = diff.isNegative ? Duration.zero : diff);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String _formatCountdown(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) return '${h}s ${m.toString().padLeft(2, '0')}d';
    if (m > 0) return '${m}d ${s.toString().padLeft(2, '0')}s';
    return '${s}s';
  }

  Color get _color {
    if (widget.count == 0) return Colors.grey;
    if (widget.count <= 5) return Colors.orange;
    return const Color(0xFFEF4444); // kırmızı
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = widget.count == 0;

    return GestureDetector(
      onTap: () => _showHeartsSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: _color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '❤️',
              style: TextStyle(
                fontSize: 14,
                color: isEmpty ? Colors.grey : null,
              ),
            ),
            const SizedBox(width: 4),
            isEmpty
                ? Text(
                    _formatCountdown(_remaining),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _color,
                    ),
                  )
                : Text(
                    '${widget.count}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _color,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _showHeartsSheet(BuildContext context) {
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
  bool _adLoading = false;
  bool _adWatched = false; // bu oturumda reklam izlendi mi

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
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String _formatCountdown(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) return '$h saat ${m.toString().padLeft(2, '0')} dakika';
    if (m > 0) return '$m dakika ${s.toString().padLeft(2, '0')} saniye';
    return '$s saniye';
  }

  Future<void> _watchAd() async {
    final adService = ref.read(adServiceProvider);
    if (!adService.isSupported) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reklam bu platformda desteklenmiyor.')),
      );
      return;
    }

    if (!adService.isAdReady) {
      setState(() => _adLoading = true);
      await adService.load();
      // Birkaç saniye bekle
      for (int i = 0; i < 10; i++) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (adService.isAdReady) break;
      }
      if (!mounted) return;
      setState(() => _adLoading = false);
    }

    if (!adService.isAdReady) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Şu an reklam mevcut değil. Biraz sonra tekrar dene.')),
      );
      return;
    }

    await adService.show(
      onRewarded: () async {
        await ref.read(heartsProvider.notifier).addFromAd(_adRewardAmount);
        if (mounted) setState(() => _adWatched = true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hearts = ref.watch(heartsProvider).value;
    final currentCount = hearts?.count ?? widget.count;
    final isFull = currentCount >= HeartsService.maxHearts;
    final adService = ref.read(adServiceProvider);

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.viewInsetsOf(context).bottom + 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tutamaç
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
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
                    currentCount == 0 ? 'Kalbiniz bitti!' : 'Günlük Haklar',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '$currentCount / ${HeartsService.maxHearts} kalp',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Kalp çubuğu
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: currentCount / HeartsService.maxHearts,
              minHeight: 12,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                currentCount == 0 ? Colors.grey : const Color(0xFFEF4444),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Maliyet bilgisi
          _CostRow(icon: '📚', label: 'Ders başlatma', cost: HeartsService.lessonCost),
          const SizedBox(height: 8),
          _CostRow(icon: '📝', label: 'Sınav başlatma', cost: HeartsService.examCost),

          // Geri sayım (kalpler bittiyse)
          if (widget.resetTime != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFCA5A5)),
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
                          style: TextStyle(fontSize: 12, color: Color(0xFF991B1B)),
                        ),
                        Text(
                          _formatCountdown(_remaining),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Reklam izle butonu (dolu değilse ve platform destekliyorsa)
          if (adService.isSupported && !isFull) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: _adWatched
                  ? Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
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
                              color: Color(0xFF15803D),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ElevatedButton(
                      onPressed: _adLoading ? null : _watchAd,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: _adLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
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
            color: Color(0xFFEF4444),
          ),
        ),
      ],
    );
  }
}

/// Kalp yokken gösterilen dialog. true → devam et, false → iptal.
Future<bool> showNoHeartsDialog(
  BuildContext context,
  WidgetRef ref,
  int cost,
) async {
  final heartsState = ref.read(heartsProvider).value;
  if (heartsState == null) return false;

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

  // Reklam izleyip kalp doldu mu kontrol et
  final updated = ref.read(heartsProvider).value;
  if (updated != null && updated.count >= cost) return true;
  return false;
}
