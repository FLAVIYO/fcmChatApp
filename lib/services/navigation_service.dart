import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState!.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<dynamic> replaceWith(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<void> clearStackAndNavigate(
    String routeName, {
    dynamic arguments,
  }) async {
    try {
      //* Ensure we have a valid context
      if (navigatorKey.currentState == null) {
        debugPrint('Navigator state is null');
        return;
      }

      //* Clear all routes and navigate
      await navigatorKey.currentState!.pushNamedAndRemoveUntil(
        routeName,
        (route) => false,
        arguments: arguments,
      );
    } catch (e, stackTrace) {
      debugPrint('Navigation error: $e');
      debugPrint(stackTrace.toString());
      //* Fallback navigation
      if (navigatorKey.currentState != null) {
        navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
      }
    }
  }

  void goBack([dynamic result]) {
    return navigatorKey.currentState!.pop(result);
  }

  //* Provides optional context access for dialogs/alerts
  BuildContext? get context => navigatorKey.currentState?.overlay?.context;
}
