import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fcmchatapp/models/user_profile.dart';
import 'package:fcmchatapp/services/auth_service.dart';

class DatabaseService implements AuthService<User> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  DatabaseService({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore;

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // User profile management
  Stream<UserProfile?> watchUserProfile(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snapshot) => snapshot.exists ? UserProfile.fromFirestore(snapshot) : null);
  }

  Future<UserProfile?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.exists ? UserProfile.fromFirestore(doc) : null;
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    await _firestore
        .collection('users')
        .doc(profile.uid)
        .update(profile.toFirestore());
  }

  // Auth implementations
  @override
  Future<AuthResult<User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update last active timestamp
      await _updateLastActive(userCredential.user!.uid);
      
      return AuthSuccess(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return AuthFailure(_mapAuthError(e));
    }
  }

  @override
  Future<AuthResult<User>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user profile
      final profile = UserProfile(
        uid: userCredential.user!.uid,
        email: email,
        displayName: name,
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(profile.toFirestore());

      return AuthSuccess(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return AuthFailure(_mapAuthError(e));
    }
  }

  Future<void> _updateLastActive(String uid) async {
    await _firestore.collection('users').doc(uid).update({
      'lastActiveAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> checkUserValidity() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        await user.getIdToken(true);
        await _updateLastActive(user.uid);
      } catch (e) {
        await _firebaseAuth.signOut();
      }
    }
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'invalid-email':
        return 'Please enter a valid email';
      case 'weak-password':
        return 'Password is too weak';
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}