import 'package:fcmchatapp/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fcmchatapp/services/firebase_auth_service.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late FirebaseAuthService authService;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();

    authService = FirebaseAuthService(
      firebaseAuth: mockFirebaseAuth,
    );
  });

  group('AuthService Tests', () {
    test('Successful login returns AuthSuccess', () async {
      // Arrange
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => mockUserCredential);

      when(() => mockUserCredential.user).thenReturn(mockUser);

      // Act
      final result = await authService.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(result, isA<AuthSuccess>());
      expect((result as AuthSuccess).user, mockUser);
    });

    test('Failed login returns AuthFailure with correct error message', () async {
      // Arrange
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

      // Act
      final result = await authService.signInWithEmailAndPassword(
        email: 'fail@example.com',
        password: 'wrongpass',
      );

      // Assert
      expect(result, isA<AuthFailure>());
      expect((result as AuthFailure), 'No user found with this email');
    });
  });
}
