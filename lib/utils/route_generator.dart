import 'package:fcmchatapp/utils/app_routes.dart';
import 'package:fcmchatapp/views/pages/profile_page.dart';
import 'package:fcmchatapp/views/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:fcmchatapp/views/pages/login_page.dart';
import 'package:fcmchatapp/views/pages/home_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case Routes.signup:
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case Routes.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());  
      default:
        return _errorRoute(settings.name);
    }
  }

  static Route<dynamic> _errorRoute(String? routeName) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('No route defined for $routeName'),
        ),
      ),
    );
  }
}