import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/coupon_service.dart';
import '../providers/app_providers.dart';

/// Herhangi bir sayfadan çağrılabilen kupon giriş bottom sheet'i.
void showCouponBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _CouponSheet(),
  );
}

// ── Bottom sheet ──────────────────────────────────────────────────────────────

class _CouponSheet extends ConsumerStatefulWidget {
  const _CouponSheet();
  @override
  ConsumerState<_CouponSheet> createState() => _CouponSheetState();
}

class _CouponSheetState extends ConsumerState<_CouponSheet> {
  final _ctrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  Future<void> _preview() async {
    final code = _ctrl.text.trim();
    if (code.isEmpty) { setState(() => _error = 'Kupon kodunu gir.'); return; }

    setState(() { _loading = true; _error = null; });
    try {
      final svc = ref.read(couponServiceProvider);
      final preview = await svc.previewCoupon(code);
      if (!mounted) return;
      setState(() => _loading = false);

      if (preview.isDiscountCoupon) {
        // İndirim kuponu → subscription ekranına indirimli git
        Navigator.of(context).pop();
        if (!mounted) return;
        context.go('/subscription?coupon=${preview.code}&discount=${preview.discountPercent}');
      } else {
        _showConfirm(preview);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _loading = false;
      });
    }
  }

  void _showConfirm(CouponPreview preview) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 260),
      transitionBuilder: (_, anim, __, child) => ScaleTransition(
        scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
        child: FadeTransition(opacity: anim, child: child),
      ),
      pageBuilder: (ctx, _, __) => _ConfirmDialog(
        preview: preview,
        onConfirm: () => _redeem(preview),
      ),
    );
  }

  Future<void> _redeem(CouponPreview preview) async {
    setState(() { _loading = true; _error = null; });
    try {
      final svc = ref.read(couponServiceProvider);
      final uid = Supabase.instance.client.auth.currentUser?.id;
      if (uid == null) throw Exception('Giriş yapılmamış.');

      final result = await svc.redeemCoupon(preview.code);
      if (result.plan == 'authorized') {
        await svc.activateAuthorizedFromCoupon(uid: uid, code: result.code);
      } else if (result.plan == 'discount' || result.plan.startsWith('discount_')) {
        // Güvenlik: indirim kuponu buraya düşmemeli
        throw Exception('Bu kupon indirim kuponu, premium açmaz.');
      } else {
        await svc.activatePremiumFromCoupon(
          uid: uid,
          plan: result.plan,
          code: result.code,
          durationDays: result.durationDays,
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _loading = false;
      });
      return;
    }
    if (!mounted) return;
    setState(() => _loading = false);

    Navigator.of(context).pop();
    if (!mounted) return;
    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      transitionDuration: const Duration(milliseconds: 350),
      transitionBuilder: (_, anim, __, child) => ScaleTransition(
        scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
        child: FadeTransition(opacity: anim, child: child),
      ),
      pageBuilder: (ctx, _, __) => _CelebrationDialog(preview: preview),
    );

    if (!mounted) return;
    context.go('/home/profile');
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Başlık
          Row(
            children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.local_offer_outlined, size: 20, color: Color(0xFF16A34A)),
              ),
              const SizedBox(width: 12),
              const Text(
                'Kupon Kodu Gir',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Input satırı
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  autofocus: true,
                  textCapitalization: TextCapitalization.characters,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 2),
                  decoration: InputDecoration(
                    hintText: 'KUPON KODUNU GİR',
                    hintStyle: const TextStyle(color: AppColors.textHint, letterSpacing: 1, fontWeight: FontWeight.w500, fontSize: 13),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFF),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.divider)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.divider)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF16A34A), width: 1.5)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  onSubmitted: (_) => _preview(),
                ),
              ),
              const SizedBox(width: 10),
              _loading
                  ? const SizedBox(width: 52, height: 52, child: Center(child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Color(0xFF16A34A)))))
                  : GestureDetector(
                      onTap: _preview,
                      child: Container(
                        width: 52, height: 52,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFF16A34A), Color(0xFF15803D)]),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [BoxShadow(color: const Color(0xFF16A34A).withValues(alpha: 0.35), blurRadius: 8, offset: const Offset(0, 3))],
                        ),
                        child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 22),
                      ),
                    ),
            ],
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Row(children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 15),
              const SizedBox(width: 6),
              Expanded(child: Text(_error!, style: const TextStyle(fontSize: 12, color: AppColors.error))),
            ]),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Onay dialog'u ─────────────────────────────────────────────────────────────

class _ConfirmDialog extends StatelessWidget {
  final CouponPreview preview;
  final VoidCallback onConfirm;
  const _ConfirmDialog({required this.preview, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final expiresAt = preview.expiresAt;
    final expiryStr = expiresAt != null
        ? '${expiresAt.day}.${expiresAt.month.toString().padLeft(2,'0')}.${expiresAt.year}'
        : 'Süresiz';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 40, offset: const Offset(0, 12))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF14532D), Color(0xFF16A34A)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(children: [
                  const Text('🎟️', style: TextStyle(fontSize: 42)),
                  const SizedBox(height: 10),
                  const Text('Kupon Bulundu!', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text('Kuponu uygulamak istiyor musun?', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13), textAlign: TextAlign.center),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _DetailRow(icon: Icons.workspace_premium_rounded, label: 'Plan', value: preview.planLabel, color: const Color(0xFF16A34A)),
                    const SizedBox(height: 10),
                    _DetailRow(icon: Icons.timer_outlined, label: 'Süre', value: preview.durationLabel, color: AppColors.primary),
                    if (expiresAt != null) ...[
                      const SizedBox(height: 10),
                      _DetailRow(icon: Icons.event_outlined, label: 'Bitiş', value: expiryStr, color: const Color(0xFFD97706)),
                    ],
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () { Navigator.of(context).pop(); onConfirm(); },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFF16A34A), Color(0xFF15803D)]),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [BoxShadow(color: const Color(0xFF16A34A).withValues(alpha: 0.35), blurRadius: 12, offset: const Offset(0, 4))],
                        ),
                        child: const Text('✅  Kuponu Uygula', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: Text('İptal', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
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

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _DetailRow({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
          const Spacer(),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color)),
        ],
      ),
    );
  }
}

// ── Kutlama dialog'u ──────────────────────────────────────────────────────────

class _CelebrationDialog extends StatefulWidget {
  final CouponPreview preview;
  const _CelebrationDialog({required this.preview});
  @override
  State<_CelebrationDialog> createState() => _CelebrationDialogState();
}

class _CelebrationDialogState extends State<_CelebrationDialog> with TickerProviderStateMixin {
  late AnimationController _bounceCtrl;
  late AnimationController _sparkCtrl;
  late Animation<double> _bounceAnim;
  late Animation<double> _sparkAnim;

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
    _sparkCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..repeat();
    _bounceAnim = Tween<double>(begin: 0, end: -10).animate(CurvedAnimation(parent: _bounceCtrl, curve: Curves.easeInOut));
    _sparkAnim  = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _sparkCtrl,  curve: Curves.linear));
  }

  @override
  void dispose() { _bounceCtrl.dispose(); _sparkCtrl.dispose(); super.dispose(); }

  bool get _isAuthorized => widget.preview.isAuthorized;

  @override
  Widget build(BuildContext context) {
    final expiresAt = widget.preview.expiresAt;
    final expiryStr = expiresAt != null
        ? '${expiresAt.day}.${expiresAt.month.toString().padLeft(2,'0')}.${expiresAt.year} tarihine kadar'
        : 'Süresiz kullanım';

    final headerGradient = _isAuthorized
        ? const LinearGradient(colors: [Color(0xFF7F1D1D), Color(0xFFDC2626), Color(0xFFEF4444)], begin: Alignment.topLeft, end: Alignment.bottomRight)
        : const LinearGradient(colors: [Color(0xFF78350F), Color(0xFFD97706), Color(0xFFFBBF24), Color(0xFFFDE68A)], begin: Alignment.topLeft, end: Alignment.bottomRight);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 50, offset: const Offset(0, 16))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
                decoration: BoxDecoration(
                  gradient: headerGradient,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: Listenable.merge([_bounceAnim, _sparkAnim]),
                      builder: (_, __) => Stack(
                        alignment: Alignment.center,
                        children: [
                          ...List.generate(6, (i) {
                            final r = 52.0;
                            return Positioned(
                              left: 60 + r * 0.8 * (0.5 + 0.5 * (i % 2 == 0 ? 1 : -1)) * (1 - _sparkAnim.value % 0.5),
                              top:  60 + r * (i / 6),
                              child: Opacity(
                                opacity: (0.6 - (_sparkAnim.value * 0.4)).clamp(0.0, 1.0),
                                child: Text(_isAuthorized ? ['⭐','✨','🔴','⭐','✨','🔴'][i] : ['✨','⭐','💫','✨','⭐','💫'][i], style: const TextStyle(fontSize: 14)),
                              ),
                            );
                          }),
                          Transform.translate(
                            offset: Offset(0, _bounceAnim.value),
                            child: Text(_isAuthorized ? '🔴' : '👑', style: const TextStyle(fontSize: 64)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isAuthorized ? 'Yetkili Üye! 🎉' : 'Premium Aktif! 🎉',
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, shadows: [Shadow(color: Colors.black26, blurRadius: 6)]),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.preview.planLabel,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              // Alt bilgi + buton
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time_rounded, color: AppColors.textSecondary, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(expiryStr, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text('Harika! 🚀', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
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
