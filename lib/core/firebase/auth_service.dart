import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Simple wrapper around [FirebaseAuth].
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Currently signed-in user (قد يكون null عند عدم تسجيل الدخول).
  User? get currentUser => _auth.currentUser;

  /// Stream to listen to authentication changes in the app (يتغير عند تسجيل الدخول/الخروج).
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// Sign up with email/password and return the created credential.
  /// Example:
  /// ```dart
  /// await AuthService.instance.signUpWithEmail('demo@mail.com', 'StrongPass123');
  /// ```
  Future<UserCredential> signUpWithEmail(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('Auth sign-up failed: ${e.code}');
      rethrow;
    }
  }

  /// Login with email/password.
  /// مثال: `await AuthService.instance.signInWithEmail(email, pass);`
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('Auth sign-in failed: ${e.code}');
      rethrow;
    }
  }

  /// Sign out current user.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      debugPrint('Auth sign-out failed: ${e.code}');
      rethrow;
    }
  }

  /// Quick helper to know if someone is logged in.
  bool get isLoggedIn => _auth.currentUser != null;
}
