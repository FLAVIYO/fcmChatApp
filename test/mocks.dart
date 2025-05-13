// test/mocks.dart
import 'package:fcmchatapp/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fcmchatapp/services/auth_service.dart';
import 'package:fcmchatapp/services/navigation_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}
class MockAuthService extends Mock implements AuthService {}
class MockNavigationService extends Mock implements NavigationService {}
class MockFirebaseFirestore extends Mock implements DatabaseService {}
