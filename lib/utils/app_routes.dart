import 'package:fcmchatapp/views/pages/home_page.dart';
import 'package:fcmchatapp/views/pages/login_page.dart';
import 'package:fcmchatapp/views/pages/profile_page.dart';
import 'package:fcmchatapp/views/pages/signup_page.dart';
import 'package:flutter/material.dart';

class Routes {
  //* Private constructor to prevent instantiation
  Routes._();
  
  //* Route names
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String chat = '/chat';
  static const String profile = '/profile';
  
  // *Helper method to get all routes
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginPage(),
      signup: (context) => const SignupPage(),
      home: (context) => const HomePage(),
      profile: (context) => const ProfilePage(),
    };
  }
}