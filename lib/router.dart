import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hiswana_migas/core/error_page.dart';
import 'package:hiswana_migas/core/splash_screen.dart';
import 'package:hiswana_migas/features/auth/presentation/pages/login_page.dart';
import 'package:hiswana_migas/features/auth/presentation/pages/register_page.dart';
import 'package:hiswana_migas/features/auth/presentation/pages/reset_password_page.dart';
import 'package:hiswana_migas/features/auth/presentation/pages/welcome1_page.dart';
import 'package:hiswana_migas/features/auth/presentation/pages/welcome2_page.dart';
import 'package:hiswana_migas/features/home/presentation/pages/home_page.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/detail_post_entity.dart';
import 'package:hiswana_migas/features/social%20media/presentation/beranda_page.dart';
import 'package:hiswana_migas/features/social%20media/presentation/create_post_page.dart';
import 'package:hiswana_migas/features/social%20media/presentation/detail_post_page.dart';
import 'package:hiswana_migas/features/social%20media/presentation/edit_post_page.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/splashscreen',
    errorBuilder: (context, state) {
      return const ErrorPage();
    },
    observers: [CustomNavigatorObserver()],
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        pageBuilder: (context, state) => const MaterialPage(child: HomePage()),
      ),
      GoRoute(
        name: 'splashscreen',
        path: '/splashscreen',
        pageBuilder: (context, state) =>
            const MaterialPage(child: SplashScreen()),
      ),
      GoRoute(
        name: 'welcome1',
        path: '/welcome1',
        pageBuilder: (context, state) =>
            const MaterialPage(child: Welcome1Page()),
      ),
      GoRoute(
        name: 'welcome2',
        path: '/welcome2',
        pageBuilder: (context, state) =>
            const MaterialPage(child: Welcome2Page()),
      ),
      GoRoute(
        name: 'login',
        path: '/login',
        pageBuilder: (context, state) => const MaterialPage(child: LoginPage()),
      ),
      GoRoute(
        name: 'register',
        path: '/register',
        pageBuilder: (context, state) =>
            const MaterialPage(child: RegisterPage()),
      ),
      GoRoute(
        name: 'reset-password',
        path: '/reset-password',
        pageBuilder: (context, state) =>
            const MaterialPage(child: ResetPasswordPage()),
      ),
      GoRoute(
        name: 'beranda',
        path: '/beranda',
        pageBuilder: (context, state) =>
            const MaterialPage(child: BerandaPage()),
      ),
      GoRoute(
        name: 'create-post',
        path: '/create-post',
        pageBuilder: (context, state) =>
            const MaterialPage(child: CreatePostPage()),
      ),
      GoRoute(
        name: 'detail-post',
        path: '/detail-post',
        builder: (context, state) {
          final post = state.extra as DetailPostEntity;
          return DetailPostPage(post: post);
        },
      ),
      GoRoute(
        name: 'edit-post',
        path: '/edit-post',
        builder: (context, state) {
          final post = state.extra as DetailPostEntity;
          return EditPostPage(post: post);
        },
      ),
      GoRoute(
        name: 'error',
        path: '/error',
        pageBuilder: (context, state) {
          final errorMessage = state.extra as String?;
          return MaterialPage(child: ErrorPage(errorMessage: errorMessage));
        },
      ),
    ],
  );
}

class CustomNavigatorObserver extends NavigatorObserver {}
