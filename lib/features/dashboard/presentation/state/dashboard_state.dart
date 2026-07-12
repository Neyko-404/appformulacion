import 'package:focusly/features/onboarding/domain/entities/student_profile.dart';
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';

final class DashboardState {
  const DashboardState({
    this.profile,
    this.companion,
    this.isLoading = true,
    this.errorMessage,
  });

  final StudentProfile? profile;
  final StudyCompanion? companion;
  final bool isLoading;
  final String? errorMessage;

  DashboardState copyWith({
    StudentProfile? profile,
    StudyCompanion? companion,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DashboardState(
      profile: profile ?? this.profile,
      companion: companion ?? this.companion,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DashboardState &&
            other.profile == profile &&
            other.companion == companion &&
            other.isLoading == isLoading &&
            other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => Object.hash(profile, companion, isLoading, errorMessage);
}
