import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/airplane_logo.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with SingleTickerProviderStateMixin {
  bool _isSignUp = true;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _googleLoading = false;
  bool _guestLoading = false;
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _switchMode() {
    setState(() {
      _isSignUp = !_isSignUp;
      _error = null;
      _confirmCtrl.clear();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    try {
      final svc = ref.read(authServiceProvider);
      if (_isSignUp) {
        final hasSession = await svc.signUpWithEmail(_emailCtrl.text, _passCtrl.text);
        if (!hasSession && mounted) {
          // E-posta onayı gerekiyor — kullanıcıya bildir ve giriş moduna geç
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '✉️  ${_emailCtrl.text.trim()} adresine doğrulama e-postası gönderildi. '
                'E-postayı onayladıktan sonra giriş yapabilirsiniz.',
              ),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
          setState(() { _isSignUp = false; _error = null; });
        }
        // hasSession == true ise GoRouter otomatik yönlendirir
      } else {
        await svc.signInWithEmail(_emailCtrl.text, _passCtrl.text);
        // GoRouter will auto-redirect based on auth state change
      }
    } on AuthException catch (e) {
      setState(() => _error = ref.read(authServiceProvider).errorMessage(e.message));
    } catch (e) {
      setState(() => _error = ref.read(authServiceProvider).errorMessage(e.toString()));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _continueAsGuest() async {
    setState(() { _guestLoading = true; _error = null; });
    try {
      await ref.read(authServiceProvider).signInAnonymously();
    } catch (_) {
      if (mounted) setState(() => _error = 'Misafir girişi başarısız oldu.');
    } finally {
      if (mounted) setState(() => _guestLoading = false);
    }
  }

  Future<void> _googleSignIn() async {
    setState(() { _googleLoading = true; _error = null; });
    try {
      final result = await ref.read(authServiceProvider).signInWithGoogle();
      if (result == null && mounted) setState(() => _error = 'Google girişi iptal edildi.');
    } on AuthException catch (e) {
      setState(() => _error = ref.read(authServiceProvider).errorMessage(e.message));
    } catch (e) {
      if (mounted) setState(() => _error = ref.read(authServiceProvider).errorMessage(e.toString()));
    } finally {
      if (mounted) setState(() => _googleLoading = false);
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'Önce e-posta adresinizi girin.');
      return;
    }
    try {
      await ref.read(authServiceProvider).sendPasswordReset(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Şifre sıfırlama e-postası $email adresine gönderildi.'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (_) {
      setState(() => _error = 'E-posta gönderilemedi. Adresi kontrol edin.');
    }
  }

  // ── Form içeriği (mobil + masaüstü sağ panel ortak) ─────────────────────────
  List<Widget> _buildFormChildren({required bool showLogo}) {
    return [
      if (showLogo) ...[
        const Center(child: AirplaneLogo(size: 60)),
        const SizedBox(height: 12),
        Center(
          child: Text(
            _isSignUp ? 'Hesap oluştur, öğrenmeye başla' : 'Tekrar hoş geldin',
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
        ),
        if (_isSignUp) ...[
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFED7AA)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('🎁', style: TextStyle(fontSize: 18)),
                SizedBox(width: 10),
                Flexible(
                  child: Text(
                    '7 günlük ücretsiz deneme — kredi kartı gerekmez',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFFEA580C)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 28),
      ] else ...[
        // Masaüstü: küçük başlık
        Text(
          _isSignUp ? 'Hesap Oluştur' : 'Tekrar Hoş Geldin',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 4),
        Text(
          _isSignUp ? 'Birkaç saniyede başla' : 'Hesabına giriş yap',
          style: AppTextStyles.caption,
        ),
        const SizedBox(height: 24),
      ],

      // ── Tab toggle ────────────────────────────────────────────────────────
      Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            _TabBtn(label: 'Kayıt Ol',  selected: _isSignUp,  onTap: _isSignUp  ? null : _switchMode),
            _TabBtn(label: 'Giriş Yap', selected: !_isSignUp, onTap: !_isSignUp ? null : _switchMode),
          ],
        ),
      ),
      const SizedBox(height: 24),

      // ── Email ─────────────────────────────────────────────────────────────
      _Field(
        controller: _emailCtrl,
        label: 'E-posta',
        hint: 'ornek@email.com',
        keyboardType: TextInputType.emailAddress,
        prefixIcon: Icons.email_outlined,
        validator: (v) {
          if (v == null || v.trim().isEmpty) return 'E-posta boş olamaz';
          if (!v.contains('@') || !v.contains('.')) return 'Geçersiz e-posta';
          return null;
        },
      ),
      const SizedBox(height: 14),

      // ── Password ──────────────────────────────────────────────────────────
      _Field(
        controller: _passCtrl,
        label: 'Şifre',
        hint: '••••••••',
        obscure: _obscurePass,
        prefixIcon: Icons.lock_outline,
        suffixIcon: IconButton(
          icon: Icon(_obscurePass ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              size: 20, color: AppColors.textHint),
          onPressed: () => setState(() => _obscurePass = !_obscurePass),
        ),
        validator: (v) {
          if (v == null || v.isEmpty) return 'Şifre boş olamaz';
          if (v.length < 6) return 'En az 6 karakter olmalı';
          return null;
        },
      ),

      // ── Confirm password ──────────────────────────────────────────────────
      if (_isSignUp) ...[
        const SizedBox(height: 14),
        _Field(
          controller: _confirmCtrl,
          label: 'Şifreyi Onayla',
          hint: '••••••••',
          obscure: _obscureConfirm,
          prefixIcon: Icons.lock_outline,
          suffixIcon: IconButton(
            icon: Icon(_obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                size: 20, color: AppColors.textHint),
            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return 'Şifreyi tekrar girin';
            if (v != _passCtrl.text) return 'Şifreler eşleşmiyor';
            return null;
          },
        ),
      ],

      // ── Forgot password ───────────────────────────────────────────────────
      if (!_isSignUp) ...[
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _forgotPassword,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Şifremi unuttum',
                style: TextStyle(fontSize: 12, color: AppColors.primary)),
          ),
        ),
      ],

      // ── Error ─────────────────────────────────────────────────────────────
      if (_error != null) ...[
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.errorLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(_error!, style: const TextStyle(fontSize: 13, color: AppColors.error))),
            ],
          ),
        ),
      ],
      const SizedBox(height: 22),

      // ── Submit ────────────────────────────────────────────────────────────
      SizedBox(
        height: 52,
        child: ElevatedButton(
          onPressed: (_loading || _googleLoading) ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: _loading
              ? const SizedBox(width: 22, height: 22,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
              : Text(_isSignUp ? 'Kayıt Ol' : 'Giriş Yap',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ),
      ),
      const SizedBox(height: 20),

      // ── Divider ───────────────────────────────────────────────────────────
      Row(
        children: [
          const Expanded(child: Divider(color: AppColors.divider)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text('veya', style: AppTextStyles.caption),
          ),
          const Expanded(child: Divider(color: AppColors.divider)),
        ],
      ),
      const SizedBox(height: 20),

      // ── Google ────────────────────────────────────────────────────────────
      SizedBox(
        height: 52,
        child: OutlinedButton.icon(
          onPressed: (_loading || _googleLoading || _guestLoading) ? null : _googleSignIn,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            side: const BorderSide(color: AppColors.divider, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          icon: _googleLoading
              ? const SizedBox(width: 18, height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
              : const _GoogleIcon(),
          label: const Text('Google ile devam et',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ),
      ),
      const SizedBox(height: 12),

      // ── Misafir girişi ────────────────────────────────────────────────────
      Center(
        child: TextButton(
          onPressed: (_loading || _googleLoading || _guestLoading) ? null : _continueAsGuest,
          child: _guestLoading
              ? const SizedBox(
                  width: 18, height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textSecondary),
                )
              : const Text(
                  'Giriş yapmadan ilerle',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    decoration: TextDecoration.underline,
                  ),
                ),
        ),
      ),
      const SizedBox(height: 4),

    ];
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 720;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: isWide ? _buildWide() : _buildNarrow(),
    );
  }

  // ── Masaüstü: iki sütun ───────────────────────────────────────────────────
  Widget _buildWide() {
    return Row(
      children: [
        // Sol: marka paneli
        const Expanded(flex: 5, child: _HeroPanel()),
        // Sağ: form
        Expanded(
          flex: 4,
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _buildFormChildren(showLogo: false),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Mobil: tek sütun (mevcut) ─────────────────────────────────────────────
  Widget _buildNarrow() {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _buildFormChildren(showLogo: true),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Tab button ────────────────────────────────────────────────────────────────

class _TabBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  const _TabBtn({required this.label, required this.selected, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
            boxShadow: selected
                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 6, offset: const Offset(0, 2))]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Form field wrapper ────────────────────────────────────────────────────────

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscure;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    this.obscure = false,
    required this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
        prefixIcon: Icon(prefixIcon, color: AppColors.textHint, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
    );
  }
}

// ── Masaüstü sol marka paneli ─────────────────────────────────────────────────

class _HeroPanel extends StatelessWidget {
  const _HeroPanel();

  static const _features = [
    (Icons.quiz_rounded,            '1895+ soru, 6 farklı kategori'),
    (Icons.flight_rounded,          'Pilot, Kabin, AMT ve Öğrenci planları'),
    (Icons.emoji_events_rounded,    'Haftalık lig — kendi rolündekilerle yarış'),
    (Icons.bar_chart_rounded,       'Zayıf alan tespiti ve kişisel analiz'),
    (Icons.workspace_premium,       '7 günlük ücretsiz deneme'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDeep, AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo (beyaz)
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.flight, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Avialish',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 44),
              const Text(
                'Havacılık İngilizcesini\nProfesyonel Düzeyde Öğren',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'ICAO standartlarında hazırlanmış müfredat.\nMesleğine özel içerik, gerçek rekabet.',
                style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 40),
              ..._features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(f.$1, color: Colors.white, size: 15),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      f.$2,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Google "G" icon ───────────────────────────────────────────────────────────

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: const Text(
        'G',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF4285F4),
          height: 1.4,
        ),
      ),
    );
  }
}
