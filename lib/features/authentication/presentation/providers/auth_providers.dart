import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdad/core/di/injection.dart';
import 'package:imdad/features/authentication/domain/repositories/auth_repository.dart';
import 'package:imdad/features/authentication/domain/entities/user.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepo = getIt<AuthRepository>();
  return AuthNotifier(authRepo);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;

  AuthNotifier(this.authRepository) : super(AuthState.initial());

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await authRepository.login(username, password);
      if (user != null) {
        state = state.copyWith(isLoading: false, user: user, isAuthenticated: true);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'اسم المستخدم أو كلمة المرور غير صحيحة',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await authRepository.logout();
    state = AuthState.initial();
  }
}

class AuthState {
  final bool isLoading;
  final User? user;
  final bool isAuthenticated;
  final String? error;

  AuthState({
    required this.isLoading,
    this.user,
    required this.isAuthenticated,
    this.error,
  });

  factory AuthState.initial() {
    return AuthState(
      isLoading: false,
      isAuthenticated: false,
      error: null,
    );
  }

  AuthState copyWith({
    bool? isLoading,
    User? user,
    bool? isAuthenticated,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: error ?? this.error,
    );
  }
}
