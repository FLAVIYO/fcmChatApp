// test/views/pages/login_page_test.dart
import 'package:fcmchatapp/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fcmchatapp/views/pages/login_page.dart';
import '../../mocks.dart';

void main() {
  late MockAuthService mockAuthService;
  late MockNavigationService mockNavigationService;

  setUp(() {
    mockAuthService = MockAuthService();
    mockNavigationService = MockNavigationService();

    // Register fallback values
    registerFallbackValue(AuthSuccess<User>(MockUser()));
  });

  testWidgets('LoginPage shows email and password fields', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(navigationService: null, authService: null,),
      ),
    );

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('Successful login navigates to home', (tester) async {
    when(() => mockAuthService.signInWithEmailAndPassword(
      email: any(),
      password: any(),
    )).thenAnswer((_) async => AuthSuccess(MockUser()));

    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(
          authService: mockAuthService,
          navigationService: mockNavigationService,
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    verify(() => mockNavigationService.clearStackAndNavigate('/home')).called(1);
  });
}