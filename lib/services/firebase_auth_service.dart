import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcmchatapp/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth_service.dart';

class FirebaseAuthService implements AuthService<User> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthService({
    required FirebaseAuth firebaseAuth,
    FirebaseFirestore? firestore,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore ?? FirebaseFirestore.instance;
  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<AuthResult<User>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // 1. Create user in Firebase Auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Save user data in Firestore (without waiting for completion)
      unawaited(
        _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
              'name': name,
              'email': email,
              'createdAt': FieldValue.serverTimestamp(),
            })
            .catchError((e) {
              debugPrint('Firestore write error: $e');
            }),
      );

      // 3. Wait for Firestore write to complete
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get()
          .then((snapshot) {
            if (!snapshot.exists) {
              throw Exception('User data not saved');
            }
          });

      return AuthSuccess(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return AuthFailure(_mapSignupError(e));
    } catch (e) {
      return AuthFailure('Registration failed. Please try again.');
    }
  }

  String _mapSignupError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'invalid-email':
        return 'Please enter a valid email';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled';
      case 'weak-password':
        return 'Password is too weak';
      default:
        return 'Registration failed. Please try again.';
    }
  }

  @override
  Future<AuthResult<User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final emailError = Validators.validateEmail(email);
      if (emailError != null) return AuthFailure(emailError);

      final passwordError = Validators.validatePassword(password);
      if (passwordError != null) return AuthFailure(passwordError);

      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return AuthSuccess(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return AuthFailure(_mapFirebaseError(e));
    } catch (e) {
      return AuthFailure('An unexpected error occurred');
    }
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      default:
        return 'Login failed. Please try again';
    }
  }

  @override
  Future<void> checkUserValidity() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        await user.getIdToken(true);
      } catch (e) {
        await _firebaseAuth.signOut();
      }
    }
  }
}
