import 'package:flutter/material.dart';

/// Duolingo tarzı streak kutlama overlay'i.
/// Kullanım: showStreakCelebration(context, streakDays: 3);
Future<void> showStreakCelebration(
  BuildContext context, {
  required int streakDays,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'streak',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder: (_, anim, __, child) => FadeTransition(
      opacity: anim,
      child: child,
    ),
    pageBuilder: (context, _, __) => _StreakDialog(streakDays: streakDays),
  );
}

class _StreakDialog extends StatefulWidget {
  final int streakDays;
  const _StreakDialog({required this.streakDays});

  @override
  State<_StreakDialog> createState() => _StreakDialogState();
}

class _StreakDialogState extends State<_StreakDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _bounce;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeIn = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    );

    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.3, end: 1.25), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.25, end: 0.9), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.05), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 15),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    _bounce = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -18.0), weight: 30),
      TweenSequenceItem(tween: Tween(begin: -18.0, end: 0.0), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 0.0), weight: 20),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

    _ctrl.forward();

    // 2.5 saniye sonra otomatik kapat
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFirst = widget.streakDays == 1;

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: FadeTransition(
            opacity: _fadeIn,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C2E),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B00).withValues(alpha: 0.3),
                    blurRadius: 40,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ateş emoji (zıplayan + scale)
                  AnimatedBuilder(
                    animation: _ctrl,
                    builder: (_, __) => Transform.translate(
                      offset: Offset(0, _bounce.value),
                      child: Transform.scale(
                        scale: _scale.value,
                        child: const Text(
                          '🔥',
                          style: TextStyle(fontSize: 72),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Streak sayısı
                  Text(
                    '${widget.streakDays} Günlük Seri!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Alt mesaj
                  Text(
                    isFirst
                        ? 'Harika bir başlangıç! 🚀\nHer gün bir adım daha.'
                        : widget.streakDays >= 7
                            ? 'Muhteşem! Haftayı doldurdun! ✈️'
                            : 'Böyle devam et!\nYarın da burada ol.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Streak noktaları (7 günlük görsel)
                  _StreakDots(streakDays: widget.streakDays),

                  const SizedBox(height: 20),
                  const Text(
                    'Devam etmek için dokun',
                    style: TextStyle(color: Color(0xFF555566), fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StreakDots extends StatelessWidget {
  final int streakDays;
  const _StreakDots({required this.streakDays});

  @override
  Widget build(BuildContext context) {
    final days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    final today = DateTime.now().weekday; // 1=Mon, 7=Sun

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(7, (i) {
        final dayIndex = i + 1; // 1-7
        final isPast = dayIndex < today &&
            dayIndex >= (today - streakDays).clamp(1, 7);
        final isToday = dayIndex == today;
        final isFuture = dayIndex > today;

        Color dotColor;
        if (isToday) {
          dotColor = const Color(0xFFFF6B00);
        } else if (isPast) {
          dotColor = const Color(0xFFFF9A3C);
        } else {
          dotColor = const Color(0xFF2A2A3E);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 300 + i * 60),
                width: isToday ? 36 : 30,
                height: isToday ? 36 : 30,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                  boxShadow: isToday
                      ? [
                          BoxShadow(
                            color: const Color(0xFFFF6B00).withValues(alpha: 0.5),
                            blurRadius: 10,
                          )
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    isToday || isPast ? '🔥' : '',
                    style: TextStyle(fontSize: isToday ? 18 : 14),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                days[i],
                style: TextStyle(
                  fontSize: 10,
                  color: isFuture
                      ? const Color(0xFF444455)
                      : const Color(0xFF888899),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
