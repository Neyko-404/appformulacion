import 'package:firebase_auth/firebase_auth.dart';

final class FirebaseAuthUserData {
  const FirebaseAuthUserData({
    required this.id,
    required this.email,
    required this.emailVerified,
  });

  final String id;
  final String? email;
  final bool emailVerified;
}

class FirebaseAuthService {
  FirebaseAuthService(FirebaseAuth firebaseAuth) : _firebaseAuth = firebaseAuth;

  final FirebaseAuth _firebaseAuth;

  FirebaseAuthUserData? get currentUser => _mapUser(_firebaseAuth.currentUser);

  Stream<FirebaseAuthUserData?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map(_mapUser);
  }

  Future<FirebaseAuthUserData> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _requireUser(credential.user);
  }

  Future<FirebaseAuthUserData> signUp({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _requireUser(credential.user);
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw StateError('Email verification requires an authenticated user.');
    }
    await user.sendEmailVerification();
  }

  Future<FirebaseAuthUserData?> reloadCurrentUser() async {
    await _firebaseAuth.currentUser?.reload();
    return _mapUser(_firebaseAuth.currentUser);
  }

  Future<void> signOut() => _firebaseAuth.signOut();

  FirebaseAuthUserData _requireUser(User? user) {
    final data = _mapUser(user);
    if (data == null) {
      throw StateError('Firebase returned no user for the auth operation.');
    }
    return data;
  }

  FirebaseAuthUserData? _mapUser(User? user) {
    if (user == null) {
      return null;
    }
    return FirebaseAuthUserData(
      id: user.uid,
      email: user.email,
      emailVerified: user.emailVerified,
    );
  }
}
