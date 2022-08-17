import 'package:get_it/get_it.dart';
import 'package:likeplay/core/repositories/hive_repository.dart';
import 'package:likeplay/core/repositories/playground_repository.dart';
import 'package:likeplay/core/repositories/user_repository.dart';
import 'package:likeplay/core/repositories_implementation/hive_repository_implementation.dart';
import 'package:sqflite_migration_service/sqflite_migration_service.dart';
import 'package:stacked_services/stacked_services.dart';
import '../repositories/navigation_handler.dart';
import '../repositories_implementation/playground_repository_impl.dart';
import '../repositories_implementation/user_repository_impl.dart';
import '../services/database_service.dart';
import '../services/secure_storage_service.dart';
import '../stores/onboard_store.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
// Register dependencies
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DatabaseMigrationService());
  locator.registerLazySingleton(() => DatabaseService());
  locator.registerLazySingleton<SecureStorageService>(
      () => SecureStorageServiceImpl());
  locator.registerLazySingleton<UserRepository>(
      () => UserRepositoryImplementation());
  locator.registerLazySingleton<PlayGroundRepository>(
      () => PlayGroundRepositoryImplementation());
  locator.registerLazySingleton<HiveRepository>(
      () => HiveRepositoryImp());
  locator.registerLazySingleton<NavigationHandler>(
    () => NavigationHandlerImpl(),
  );
  locator.registerLazySingleton(() => OnboardStore());
  
}
