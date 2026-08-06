import 'package:get_it/get_it.dart';
import 'package:imdad/shared/database/app_database.dart';
import 'package:imdad/shared/database/dao/user_dao.dart';
import 'package:imdad/shared/services/shared_preferences_service.dart';
import 'package:imdad/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:imdad/features/authentication/domain/repositories/auth_repository.dart';
import 'package:imdad/shared/database/dao/employee_dao.dart';
import 'package:imdad/shared/database/dao/department_dao.dart';
import 'package:imdad/shared/database/dao/store_dao.dart';
import 'package:imdad/shared/database/dao/item_dao.dart';
import 'package:imdad/shared/database/dao/custody_dao.dart';
import 'package:imdad/shared/database/dao/audit_dao.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Services
  getIt.registerLazySingleton<SharedPreferencesService>(() => SharedPreferencesService());

  // Database
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // DAOs
  getIt.registerLazySingleton<UserDao>(() => UserDao(getIt<AppDatabase>()));
  getIt.registerLazySingleton<EmployeeDao>(() => EmployeeDao(getIt<AppDatabase>()));
  getIt.registerLazySingleton<DepartmentDao>(() => DepartmentDao(getIt<AppDatabase>()));
  getIt.registerLazySingleton<StoreDao>(() => StoreDao(getIt<AppDatabase>()));
  getIt.registerLazySingleton<ItemDao>(() => ItemDao(getIt<AppDatabase>()));
  getIt.registerLazySingleton<CustodyDao>(() => CustodyDao(getIt<AppDatabase>()));
  getIt.registerLazySingleton<AuditDao>(() => AuditDao(getIt<AppDatabase>()));

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      userDao: getIt<UserDao>(),
      prefs: getIt<SharedPreferencesService>(),
    ),
  );
}
