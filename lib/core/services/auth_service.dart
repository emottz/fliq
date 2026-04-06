import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _google = GoogleSignIn(
    clientId: '560944576659-07uh0u45a5rgnaed27c9v00rnvn3vioj.apps.googleusercontent.com',
  );

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;
  bool get isSignedIn => _auth.currentUser != null;

  Future<UserCredential> signUpWithEmail(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> signInWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    final googleUser = await _google.signIn();
    if (googleUser == null) return null;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return _auth.signInWithCredential(credential);
  }

  Future<void> sendPasswordReset(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() async {
    await _google.signOut();
    await _auth.signOut();
  }

  String errorMessage(String code) => switch (code) {
        'email-already-in-use' => 'Bu e-posta adresi zaten kullanımda.',
        'weak-password' => 'Şifre en az 6 karakter olmalıdır.',
        'user-not-found' => 'Bu e-posta ile kayıtlı kullanıcı bulunamadı.',
        'wrong-password' || 'invalid-credential' => 'E-posta veya şifre hatalı.',
        'invalid-email' => 'Geçersiz e-posta adresi.',
        'too-many-requests' => 'Çok fazla deneme. Lütfen bekleyin.',
        'network-request-failed' => 'İnternet bağlantısı hatası.',
        'user-disabled' => 'Bu hesap devre dışı bırakıldı.',
        _ => 'Bir hata oluştu. Lütfen tekrar deneyin.',
      };
}
