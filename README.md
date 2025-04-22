# FCM Chat App - Technical Documentation

## Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [Key Design Decisions](#key-design-decisions)
3. [Service Layer](#service-layer)
   - [Auth Service ](#Auth-layer)
   - [Navigation Service ](#Navigation-layer)
4. [State Management](#state-management)
5. [Routing System](#routing-system)
6. [Error Handling](#error-handling)
7. [Testing Strategy](#testing-strategy)
8. [Dependency Injection](#dependency-injection)
9. [Firebase Integration](#firebase-integration)
<!-- 10. [Key Packages](#key-packages)
11. [Test Coverage](#test-coverage)
12. [Folder Structure](#folder-structure) -->
13. [Getting Started](#getting-started)

## Architecture Overview

**The app follows a layered architecture with clear separation of concerns:**

~~~
Presentation Layer (UI)
↓
Business Logic Layer (Services)
↓
Data Layer (MModels)
 

lib/
├── services/
├── Data/
├── utils/
├── views/
│   ├── pages/
│   └── widgets/
test/
├── services/
├── routes/
└── views/
~~~

**Key characteristics:**

- Reactive UI using Flutter widgets
- Service-oriented business logic
- Firebase backend for authentication and data storage
- Dependency injection via GetIt
- Clean routing with named routes


## Key Design Decisions

### 1.Authentication Flow
✅ **Decision**: Email/password auth with Firebase Auth  

🔍 **Rationale**:
- Standard authentication method familiar to users
- Secure and managed by Firebase
- Easy to extend with social logins later

**Implementation:**
- Separate signIn and signUp methods
- Validation at both client and server levels
- Persistent auth state

### 2.Service Architecture
✅ **Decision**: Abstract service interfaces with Firebase implementations

🔍 **Rationale**:
- Easy to swap implementations (e.g., for testing)
- Clear contract between UI and business logic
- Separation of Firebase-specific code

### 3.Navigation System

✅**Decision:** Centralized navigation with service

🔍**Rationale:**
- Navigation available anywhere in app
- No need to pass BuildContext
- Easy to track navigation events
- Consistent behavior across app

## Service Layer

## Auth Service

**Responsibilities:**

- User authentication
- Session management
- ser data persistence

**Key Methods:**

```dart
Future<AuthResult<User>> signInWithEmailAndPassword({...})
Future<AuthResult<User>> signUpWithEmailAndPassword({...})
User? get currentUser
Stream<User?> get authStateChanges
```
**Error Handling:**

- Specific error messages for different failure cases
- Type-safe result objects (AuthSuccess/AuthFailure)

## Navigation Service

**Responsibilities:**

- App navigation management
- Route stack manipulation
- Parameter passing

**Key Methods:**

```bash
Future<void> navigateTo(String routeName, {arguments})
Future<void> replaceWith(String routeName, {arguments})
Future<void> clearStackAndNavigate(String routeName, {arguments})
void goBack([result])
```

## State Management

**Approach:** Service-based state management

**Components:**

- AuthService maintains auth state
- Streams for reactive updates
- Minimal local state in widgets

**Benefits:**

- No external state management needed
- Easy to understand and debug
- Naturally scales with app complexity


## Routing System

**Implementation:**

- Named routes with Routes class
- RouteGenerator for centralized routing
- Dynamic initial route based on auth state

**Example Route Definition:**

```bash
class Routes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginPage(),
      signup: (context) => const SignupPage(),
      home: (context) => const HomePage(),
    };
  }
}
```

## Error Handling

**Strategy:**

- Type-safe error results
- User-friendly messages
- Comprehensive logging
- Toast notifications for user feedback

**Components:**

- `AuthResult` with success/failure states
- `AppToasts` for user feedback
- `AppLogger` for debugging


## Testing Strategy

**Approach:**

- Unit tests for services
- Widget tests for critical UI
- Mock dependencies using Mockito

**Test Coverage:**

- ✅Auth service (success/failure cases) `92%`
- ✅Navigation service `85%`
- ✅Form validation `95%`
- ✅Route generation `85%`

## Dependency Injection

**Implementation:** `GetIt` service locator

Setup:

```bash 

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerLazySingleton(() => NavigationService());
  getIt.registerLazySingleton<AuthService<User>>(
    () => FirebaseAuthService(firebaseAuth: getIt())
  );
  // ... other registrations
}
```
**Benefits:**

- Easy access to services
- Simple mocking for tests
- Lazy initialization

## Firebase Integration

**Services Used:**

- Firebase Authentication
- Cloud Firestore

**Security Rules:**
```bash
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow create: if request.auth != null && request.auth.uid == userId;
      allow read, update, delete: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```


## Getting Started

**Prerequisites**

- Flutter SDK
- Firebase project
- GoogleServices files (Android/iOS)

**Setup:**


**1.Run** ```flutter pub get```

**2.Configure Firebase:**
```bash
flutterfire configure
```

**3.Generate mocks:**
```bash
dart run build_runner build
```
**4.Run the app:**
```bash
flutter run
```

### Testing

**Run all tests:**

```bash
flutter test
```
**Run specific test file:**
```bash
flutter test test/services/auth_service_test.dart
```
