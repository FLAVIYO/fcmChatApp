import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcmchatapp/services/database_service.dart';
import 'package:fcmchatapp/services/navigation_service.dart';
import 'package:fcmchatapp/services/profile_service.dart';
import 'package:fcmchatapp/utils/toast_config.dart';
import 'package:get_it/get_it.dart';
import 'package:fcmchatapp/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fcmchatapp/utils/app_logger.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Register Navigation services
  getIt.registerLazySingleton(() => NavigationService());

  // Register Firebase services first
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton(() => FirebaseStorage.instance);

  // Register core services
  getIt.registerLazySingleton(() => AppLogger());
  getIt.registerLazySingleton(() => AppToasts());
  
  // Register DatabaseService (implements AuthService)
  getIt.registerLazySingleton<AuthService<User>>(
    () => DatabaseService(
      firebaseAuth: getIt(),
      firestore: getIt(),
    ),
  );
  
  // Register ProfileService
  getIt.registerLazySingleton(() => ProfileService(
    firestore: getIt(),
    storage: getIt(),
    auth: getIt(),
  ));
}