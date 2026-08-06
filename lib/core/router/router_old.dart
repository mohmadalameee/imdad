import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import 'package:imdad/features/authentication/presentation/screens/login_screen.dart';
import 'package:imdad/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:imdad/core/di/injection.dart';
import 'package:imdad/features/authentication/domain/repositories/auth_repository.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authRepo = getIt<AuthRepository>();
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
    redirect: (context, state) async {
      final isLoggedIn = await authRepo.isLoggedIn();
      final isLoginRoute = state.location == '/login';
      if (!isLoggedIn && !isLoginRoute) return '/login';
      if (isLoggedIn && isLoginRoute) return '/dashboard';
      return null;
    },
  );
});
