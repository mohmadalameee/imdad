import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdad/features/authentication/presentation/screens/login_screen.dart';
import 'package:imdad/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:imdad/features/authentication/presentation/providers/auth_providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Watch auth state so the router is recreated when authentication changes.
  final authState = ref.watch(authProvider);

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
    // Synchronous redirect using the watched auth state.
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isLoginRoute = state.location == '/login';

      if (!isLoggedIn && !isLoginRoute) return '/login';
      if (isLoggedIn && isLoginRoute) return '/dashboard';
      return null;
    },
  );
});
