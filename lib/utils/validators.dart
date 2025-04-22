class Validators {
  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$',
  );

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please enter an email address';
    }
    if (!_emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter your password';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    final passwordError = validatePassword(password);
    if (passwordError != null) return passwordError;
    
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }
  
  static String? validateName(String? name) {
  if (name == null || name.isEmpty) {
    return 'Please enter your name';
  }
  if (name.length < 3) {
    return 'Name must be at least 3 characters';
  }
  return null;
}
}