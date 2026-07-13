abstract final class RouteNames {
  static const login = 'login';
  static const register = 'register';
  static const forgotPassword = 'forgot-password';
  static const authLoading = 'auth-loading';
  static const verifyEmail = 'verify-email';
  static const onboarding = 'onboarding';
  static const onboardingError = 'onboarding-error';
  static const dashboard = 'dashboard';
  static const courses = 'courses';
  static const courseNew = 'course-new';
  static const courseEdit = 'course-edit';
  static const focus = 'focus';
  static const focusHistory = 'focus-history';
  static const analytics = 'analytics';
  static const companionCustomization = 'companion-customization';
}

abstract final class RoutePaths {
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const authLoading = '/auth-loading';
  static const verifyEmail = '/verify-email';
  static const onboarding = '/onboarding';
  static const onboardingError = '/onboarding-error';
  static const dashboard = '/dashboard';
  static const courses = '/courses';
  static const courseNew = '/courses/new';
  static const courseEditPattern = '/courses/:courseId/edit';
  static String courseEdit(String courseId) => '/courses/$courseId/edit';
  static const focus = '/focus';
  static const focusHistory = '/focus/history';
  static const analytics = '/analytics';
  static const companionCustomization = '/companion/customization';
}
