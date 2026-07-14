final class CompanionMotionProfile {
  const CompanionMotionProfile({
    required this.breathingDuration,
    required this.blinkDuration,
    required this.blinkInterval,
    required this.tailDuration,
    required this.poseTransitionDuration,
    required this.celebrationDuration,
    required this.breathingAmplitude,
    required this.tailAmplitude,
    required this.celebrationLift,
    required this.animationsEnabled,
  });

  final Duration breathingDuration;
  final Duration blinkDuration;
  final Duration blinkInterval;
  final Duration tailDuration;
  final Duration poseTransitionDuration;
  final Duration celebrationDuration;
  final double breathingAmplitude;
  final double tailAmplitude;
  final double celebrationLift;
  final bool animationsEnabled;

  bool get hasContinuousMotion =>
      animationsEnabled &&
      (breathingAmplitude > 0 ||
          tailAmplitude > 0 ||
          blinkInterval > Duration.zero);
}
