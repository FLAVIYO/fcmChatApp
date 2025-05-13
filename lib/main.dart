import 'package:fcmchatapp/firebase_options.dart';
import 'package:fcmchatapp/services/auth_service.dart';
import 'package:fcmchatapp/services/database_service.dart';
import 'package:fcmchatapp/services/navigation_service.dart';
import 'package:fcmchatapp/utils/app_routes.dart';
import 'package:fcmchatapp/utils/route_generator.dart';
import 'package:fcmchatapp/utils/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  await setup();
  runApp(MyApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupfirebase();
  await setupServiceLocator();
  await checkUserValidity();
}

Future<void> setupfirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> checkUserValidity() async {
  final authService = getIt<AuthService<User>>();
  if (authService is DatabaseService) {
    await authService.checkUserValidity();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    
    final NavigationService navService = getIt<NavigationService>();
    final AuthService<User> authService = getIt<AuthService<User>>();
    final bool isLoggedIn = authService.currentUser != null;
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FCM Chat App',
      navigatorKey: navService.navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: GoogleFonts.openSansTextTheme(),
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: isLoggedIn ? Routes.home : Routes.login,
      routes: Routes.getRoutes(),
    );
  }
}