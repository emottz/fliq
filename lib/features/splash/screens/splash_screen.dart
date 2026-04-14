import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoCtrl;
  late final AnimationController _textCtrl;
  late final AnimationController _dotsCtrl;
  late final AnimationController _glowCtrl;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _iconRotate;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _textOpacity;
  late final Animation<double> _subtitleOpacity;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();

    _logoCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _textCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _dotsCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat();
    _glowCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat(reverse: true);

    _logoScale = _logoCtrl.drive(
      Tween(begin: 0.25, end: 1.0).chain(CurveTween(curve: Curves.elasticOut)),
    );
    _logoOpacity = _logoCtrl.drive(
      Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: const Interval(0.0, 0.4))),
    );
    _iconRotate = _logoCtrl.drive(
      Tween(begin: -0.15, end: 0.0)
          .chain(CurveTween(curve: const Interval(0.2, 0.7, curve: Curves.easeOut))),
    );
    _textSlide = _textCtrl.drive(
      Tween(begin: const Offset(0, 0.6), end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeOutCubic)),
    );
    _textOpacity = _textCtrl.drive(
      Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: const Interval(0.0, 0.6))),
    );
    _subtitleOpacity = _textCtrl.drive(
      Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: const Interval(0.4, 1.0))),
    );
    _glow = _glowCtrl.drive(
      Tween(begin: 0.3, end: 0.9).chain(CurveTween(curve: Curves.easeInOut)),
    );

    _runSequence();
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;
    _logoCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    _textCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 1700));
    if (!mounted) return;
    markSplashShown();
    context.go('/auth');
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _dotsCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D4ED8),
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 3),

                // ── Logo ikonu ───────────────────────────────────
                AnimatedBuilder(
                  animation: _logoCtrl,
                  builder: (_, child) => Opacity(
                    opacity: _logoOpacity.value,
                    child: Transform.scale(scale: _logoScale.value, child: child),
                  ),
                  child: AnimatedBuilder(
                    animation: _glowCtrl,
                    builder: (_, child) => Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: _glow.value * 0.4),
                            blurRadius: 48,
                            spreadRadius: 10,
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: child,
                    ),
                    child: AnimatedBuilder(
                      animation: _iconRotate,
                      builder: (_, child) => Transform.rotate(
                        angle: _iconRotate.value * 2 * pi,
                        child: child,
                      ),
                      child: const Center(
                        child: Icon(Icons.flight, color: AppColors.primary, size: 62),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ── Uygulama adı ──────────────────────────────────
                ClipRect(
                  child: SlideTransition(
                    position: _textSlide,
                    child: FadeTransition(
                      opacity: _textOpacity,
                      child: const Text(
                        'Avialish',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // ── Alt başlık ───────────────────────────────────
                FadeTransition(
                  opacity: _subtitleOpacity,
                  child: const Text(
                    'HAVACILIK İNGİLİZCESİ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white60,
                      letterSpacing: 5,
                    ),
                  ),
                ),

                const Spacer(flex: 3),

                // ── Zıplayan noktalar ────────────────────────────
                FadeTransition(
                  opacity: _subtitleOpacity,
                  child: AnimatedBuilder(
                    animation: _dotsCtrl,
                    builder: (_, __) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (i) {
                        final t = (_dotsCtrl.value + i / 3) % 1.0;
                        final wave = t < 0.5 ? t * 2 : (1.0 - t) * 2;
                        final bounce = sin(wave * pi);
                        return Transform.translate(
                          offset: Offset(0, -10 * bounce),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3 + 0.7 * bounce),
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),

                const SizedBox(height: 52),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
