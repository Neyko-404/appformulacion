enum InsightCategory {
  progress,
  consistency,
  focus,
  interruption,
  course,
  motivation,
  general,
}

enum InsightPriority { critical, high, medium, low }

enum InsightAction {
  continueFocus,
  startFocus,
  openAnalytics,
  openCourses,
  reviewProgress,
  none,
}

final class StudyInsight {
  const StudyInsight({
    required this.id,
    required this.category,
    required this.priority,
    required this.title,
    required this.message,
    required this.action,
    required this.createdFromRule,
  });

  final String id;
  final InsightCategory category;
  final InsightPriority priority;
  final String title;
  final String message;
  final InsightAction action;
  final String createdFromRule;
}

final class InsightCollection {
  const InsightCollection(this.values);
  const InsightCollection.empty() : values = const [];

  final List<StudyInsight> values;
}

final class InsightDashboardSummary {
  const InsightDashboardSummary({
    required this.hasActiveSession,
    required this.hasCourses,
  });

  final bool hasActiveSession;
  final bool hasCourses;
}

final class InsightProfileProjection {
  const InsightProfileProjection({this.preferredFocusMinutes});

  final int? preferredFocusMinutes;
}
