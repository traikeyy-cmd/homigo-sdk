import 'package:firebase_auth/firebase_auth.dart';

class HomiGoFirebaseUser {
  final String uid;
  final String? email;
  final String? phoneNumber;
  final String? displayName;
  final String? photoUrl;
  final bool emailVerified;
  final bool isAnonymous;

  const HomiGoFirebaseUser({
    required this.uid,
    required this.emailVerified,
    required this.isAnonymous,
    this.email,
    this.phoneNumber,
    this.displayName,
    this.photoUrl,
  });

  factory HomiGoFirebaseUser.fromFirebase(User user) {
    return HomiGoFirebaseUser(
      uid: user.uid,
      email: user.email,
      phoneNumber: user.phoneNumber,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      emailVerified: user.emailVerified,
      isAnonymous: user.isAnonymous,
    );
  }
}

class HomiGoFirebaseAuth {
  final FirebaseAuth _auth;

  HomiGoFirebaseAuth({FirebaseAuth? auth})
    : _auth = auth ?? FirebaseAuth.instance;

  HomiGoFirebaseUser? get currentUser {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    return HomiGoFirebaseUser.fromFirebase(user);
  }

  Stream<HomiGoFirebaseUser?> get authStateChanges {
    return _auth.authStateChanges().map((user) {
      if (user == null) {
        return null;
      }

      return HomiGoFirebaseUser.fromFirebase(user);
    });
  }

  Stream<HomiGoFirebaseUser?> get userChanges {
    return _auth.userChanges().map((user) {
      if (user == null) {
        return null;
      }

      return HomiGoFirebaseUser.fromFirebase(user);
    });
  }

  Future<HomiGoFirebaseUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw StateError('Firebase Auth returned no user.');
    }

    return HomiGoFirebaseUser.fromFirebase(user);
  }

  Future<HomiGoFirebaseUser> createUserWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw StateError('Firebase Auth returned no user.');
    }

    return HomiGoFirebaseUser.fromFirebase(user);
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw StateError('No authenticated user.');
    }

    await user.sendEmailVerification();
  }

  Future<String?> getIdToken({bool forceRefresh = false}) async {
    return _auth.currentUser?.getIdToken(forceRefresh);
  }

  Future<void> reload() async {
    await _auth.currentUser?.reload();
  }

  Future<void> signOut() {
    return _auth.signOut();
  }
}
