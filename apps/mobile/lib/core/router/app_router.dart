import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/auth/presentation/login_screen.dart';
import 'package:mobile/features/auth/presentation/register_screen.dart';
import 'package:mobile/features/home/presentation/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mobile/features/team_builder/presentation/team_builder_screen.dart';

import 'package:mobile/features/leagues/presentation/leagues_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final isAuth = session != null;
      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';

      if (!isAuth && !isLoggingIn) return '/login';
      if (isAuth && isLoggingIn) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/team-builder',
        builder: (context, state) => const TeamBuilderScreen(),
      ),
      GoRoute(
        path: '/leagues',
        builder: (context, state) => const LeaguesScreen(),
      ),
    ],
  );
});

