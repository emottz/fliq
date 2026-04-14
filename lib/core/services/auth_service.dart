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

  Future<void> signUpWithEmail(String email, String password) async {
    final res = await _sb.auth.signUp(
      email: email.trim(),
      password: password,
    );
    if (res.user == null) throw Exception('Kayıt başarısız.');
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

  Future<void> sendPasswordReset(String email) async {
    await _sb.auth.resetPasswordForEmail(email.trim());
  }

  Future<void> signOut() async {
    await _google?.signOut();
    await _sb.auth.signOut();
  }

  String errorMessage(String code) => switch (code) {
        'user_already_exists'       => 'Bu e-posta adresi zaten kullanımda.',
        'weak_password'             => 'Şifre en az 6 karakter olmalıdır.',
        'invalid_credentials'       => 'E-posta veya şifre hatalı.',
        'email_not_confirmed'       => 'E-posta adresinizi doğrulayın.',
        'user_not_found'            => 'Bu e-posta ile kayıtlı kullanıcı bulunamadı.',
        'too_many_requests'         => 'Çok fazla deneme. Lütfen bekleyin.',
        'network_failure'           => 'İnternet bağlantısı hatası.',
        _                           => 'Bir hata oluştu. Lütfen tekrar deneyin.',
      };
}
