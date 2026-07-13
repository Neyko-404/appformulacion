final class InterruptionPolicy {
  const InterruptionPolicy();

  static const relevantThreshold = Duration(seconds: 5);

  bool isRelevant(Duration duration) =>
      !duration.isNegative && duration >= relevantThreshold;
}
