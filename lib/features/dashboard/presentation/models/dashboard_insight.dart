enum DashboardInsightAction {
  startFocus,
  continueFocus,
  openCourses,
  openAnalytics,
  none,
}

enum DashboardInsightTone { neutral, encouraging, informative }

final class DashboardInsight {
  const DashboardInsight({
    required this.title,
    required this.message,
    required this.actionType,
    required this.tone,
  }) : assert(title != ''),
       assert(message != '');

  final String title;
  final String message;
  final DashboardInsightAction actionType;
  final DashboardInsightTone tone;

  @override
  bool operator ==(Object other) =>
      other is DashboardInsight &&
      other.title == title &&
      other.message == message &&
      other.actionType == actionType &&
      other.tone == tone;

  @override
  int get hashCode => Object.hash(title, message, actionType, tone);
}
