import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final _sb = Supabase.instance.client;

  final GoogleSignIn? _google = kIsWeb
      ? null
      : GoogleSignIn(
          clientId: '560944576659-07uh0u45a5rgnaed27c9v00rnvn3vioj.apps.googleusercontent.com',
        );

  Stream<User?> get authStateChanges =>
      _sb.auth.onAuthStateChange.map((s) => s.session?.user);

  User? get currentUser => _sb.auth.currentUser;
  bool get isSignedIn => _sb.auth.currentUser != null;

  /// Kayıt ol. Session açıldıysa true, e-posta onayı bekliyorsa false döner.
  Future<bool> signUpWithEmail(String email, String password) async {
    final res = await _sb.auth.signUp(
      email: email.trim(),
      password: password,
    );
    if (res.user == null) throw Exception('Kayıt başarısız.');
    return res.session != null;
  }

  Future<void> signInWithEmail(String email, String password) async {
    await _sb.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<User?> signInWithGoogle() async {
    if (kIsWeb) {
      await _sb.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: '${Uri.base.origin}/auth/callback',
      );
      return null; // Web: redirect flow, user geldiğinde onAuthStateChange tetiklenir
    }

    // Mobil: google_sign_in → idToken → Supabase
    final googleUser = await _google!.signIn();
    if (googleUser == null) return null;
    final googleAuth = await googleUser.authentication;
    final res = await _sb.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: googleAuth.idToken!,
      accessToken: googleAuth.accessToken,
    );
    return res.user;
  }

  Future<void> signInAnonymously() async {
    await _sb.auth.signInAnonymously();
  }

  Future<void> sendPasswordReset(String email) async {
    await _sb.auth.resetPasswordForEmail(
      email.trim(),
      redirectTo: kIsWeb ? '${Uri.base.origin}/' : null,
    );
  }

  Future<void> signOut() async {
    await _google?.signOut();
    await _sb.auth.signOut();
  }

  String errorMessage(String msg) {
    final m = msg.toLowerCase();
    if (m.contains('invalid') || m.contains('credentials') || m.contains('wrong password'))
      return 'E-posta veya şifre hatalı.';
    if (m.contains('already') || m.contains('exists') || m.contains('registered'))
      return 'Bu e-posta adresi zaten kullanımda.';
    if (m.contains('not confirmed') || m.contains('email_not_confirmed') || m.contains('confirm'))
      return 'E-posta adresinizi doğrulayın, ardından giriş yapın.';
    if (m.contains('too many') || m.contains('rate limit'))
      return 'Çok fazla deneme. Lütfen biraz bekleyin.';
    if (m.contains('weak') || m.contains('password'))
      return 'Şifre en az 6 karakter olmalıdır.';
    if (m.contains('network') || m.contains('connection') || m.contains('timeout'))
      return 'İnternet bağlantısı hatası.';
    if (m.contains('user not found') || m.contains('no user'))
      return 'Bu e-posta ile kayıtlı kullanıcı bulunamadı.';
    // Tanımlanamayan hata — orijinal mesajı göster
    return msg;
  }
}
