import 'dart:async';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../../../../shared/database/dao/user_dao.dart';
import '../../../../shared/services/shared_preferences_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final UserDao userDao;
  final SharedPreferencesService prefs;

  AuthRepositoryImpl({required this.userDao, required this.prefs});

  @override
  Future<User?> login(String username, String password) async {
    final userData = await userDao.getUserByUsername(username);
    if (userData == null) return null;
    // تحقق من كلمة المرور (في الإنتاج استخدم تشفير)
    if (userData['password'] != password) return null;
    // حفظ الجلسة
    await prefs.setLoggedIn(true);
    await prefs.setUserId(userData['id']);
    return User(
      id: userData['id'],
      username: userData['username'],
      fullName: userData['full_name'],
      role: userData['role'],
      isActive: userData['is_active'] == 1,
    );
  }

  @override
  Future<void> logout() async {
    await prefs.clear();
  }

  @override
  Future<bool> isLoggedIn() async {
    return await prefs.isLoggedIn();
  }
}
