abstract class AuthResult<T> {
  final T? user;
  final String? error;
  
  AuthResult({this.user, this.error});
}

class AuthSuccess<T> extends AuthResult<T> {
  AuthSuccess(T user) : super(user: user);
}

class AuthFailure<T> extends AuthResult<T> {
  AuthFailure(String error) : super(error: error);
}

abstract class AuthService<T> {
  T? get currentUser;
  Stream<T?> get authStateChanges;

  Future<AuthResult<T>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthResult<T>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<void> checkUserValidity();
}