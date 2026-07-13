import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/app/router/route_names.dart';
import 'package:focusly/features/academic_tracker/presentation/pages/course_form_page.dart';
import 'package:focusly/features/academic_tracker/presentation/pages/course_list_page.dart';
import 'package:focusly/features/analytics/presentation/pages/analytics_page.dart';
import 'package:focusly/features/authentication/presentation/pages/auth_loading_page.dart';
import 'package:focusly/features/authentication/presentation/pages/forgot_password_page.dart';
import 'package:focusly/features/authentication/presentation/pages/login_page.dart';
import 'package:focusly/features/authentication/presentation/pages/register_page.dart';
import 'package:focusly/features/authentication/presentation/pages/verify_email_page.dart';
import 'package:focusly/features/authentication/presentation/providers/auth_providers.dart';
import 'package:focusly/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:focusly/features/onboarding/onboarding_providers.dart';
import 'package:focusly/features/onboarding/presentation/pages/onboarding_error_page.dart';
import 'package:focusly/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:focusly/features/study_engine/presentation/pages/focus_history_page.dart';
import 'package:focusly/features/study_engine/presentation/pages/focus_page.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier(0);
  ref
    ..onDispose(refresh.dispose)
    ..listen(authNotifierProvider, (previous, next) => refresh.value++)
    ..listen(onboardingNotifierProvider, (previous, next) => refresh.value++);

  final router = GoRouter(
    initialLocation: RoutePaths.authLoading,
    refreshListenable: refresh,
    redirect: (context, routeState) {
      final authState = ref.read(authNotifierProvider);
      final location = routeState.matchedLocation;

      if (authState.isInitializing) {
        return location == RoutePaths.authLoading
            ? null
            : RoutePaths.authLoading;
      }

      final session = authState.session;
      if (!session.isAuthenticated) {
        const publicRoutes = {
          RoutePaths.login,
          RoutePaths.register,
          RoutePaths.forgotPassword,
        };
        return publicRoutes.contains(location) ? null : RoutePaths.login;
      }

      if (!session.emailVerified) {
        return location == RoutePaths.verifyEmail
            ? null
            : RoutePaths.verifyEmail;
      }

      final onboarding = ref.read(onboardingNotifierProvider);
      if (onboarding.isInitializing) {
        return location == RoutePaths.authLoading
            ? null
            : RoutePaths.authLoading;
      }
      if (onboarding.errorMessage != null) {
        return location == RoutePaths.onboardingError
            ? null
            : RoutePaths.onboardingError;
      }
      if (!onboarding.isCompleted) {
        return location == RoutePaths.onboarding ? null : RoutePaths.onboarding;
      }

      final isCourseRoute =
          location == RoutePaths.courses ||
          location == RoutePaths.courseNew ||
          (location.startsWith('${RoutePaths.courses}/') &&
              location.endsWith('/edit'));
      final isFocusRoute =
          location == RoutePaths.focus || location == RoutePaths.focusHistory;
      return location == RoutePaths.dashboard ||
              location == RoutePaths.analytics ||
              isCourseRoute ||
              isFocusRoute
          ? null
          : RoutePaths.dashboard;
    },
    routes: [
      GoRoute(
        name: RouteNames.authLoading,
        path: RoutePaths.authLoading,
        builder: (context, state) => const AuthLoadingPage(),
      ),
      GoRoute(
        name: RouteNames.login,
        path: RoutePaths.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        name: RouteNames.register,
        path: RoutePaths.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        name: RouteNames.forgotPassword,
        path: RoutePaths.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        name: RouteNames.verifyEmail,
        path: RoutePaths.verifyEmail,
        builder: (context, state) => const VerifyEmailPage(),
      ),
      GoRoute(
        name: RouteNames.onboarding,
        path: RoutePaths.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        name: RouteNames.onboardingError,
        path: RoutePaths.onboardingError,
        builder: (context, state) => const OnboardingErrorPage(),
      ),
      GoRoute(
        name: RouteNames.dashboard,
        path: RoutePaths.dashboard,
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        name: RouteNames.courses,
        path: RoutePaths.courses,
        builder: (context, state) => const CourseListPage(),
      ),
      GoRoute(
        name: RouteNames.courseNew,
        path: RoutePaths.courseNew,
        builder: (context, state) => const CourseFormPage(),
      ),
      GoRoute(
        name: RouteNames.courseEdit,
        path: RoutePaths.courseEditPattern,
        builder: (context, state) =>
            CourseFormPage(courseId: state.pathParameters['courseId']),
      ),
      GoRoute(
        name: RouteNames.focus,
        path: RoutePaths.focus,
        builder: (context, state) => const FocusPage(),
      ),
      GoRoute(
        name: RouteNames.focusHistory,
        path: RoutePaths.focusHistory,
        builder: (context, state) => const FocusHistoryPage(),
      ),
      GoRoute(
        name: RouteNames.analytics,
        path: RoutePaths.analytics,
        builder: (context, state) => const AnalyticsPage(),
      ),
    ],
    errorBuilder: (context, state) => UnknownRoutePage(location: state.uri),
  );

  ref.onDispose(router.dispose);
  return router;
});

class UnknownRoutePage extends StatelessWidget {
  const UnknownRoutePage({required this.location, super.key});

  final Uri location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Focusly')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.explore_off_outlined, size: 48),
              const SizedBox(height: 16),
              Text(
                'Ruta no encontrada',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(location.path),
            ],
          ),
        ),
      ),
    );
  }
}
