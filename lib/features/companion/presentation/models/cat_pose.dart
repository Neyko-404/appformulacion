enum CatMouthStyle { neutral, smile, focused, relaxed, cheering }

final class CatPose {
  const CatPose({
    required this.eyeOpenness,
    required this.mouthStyle,
    required this.earTilt,
    required this.headTilt,
    required this.bodyScale,
    required this.tailAngle,
    required this.pawLift,
    required this.verticalOffset,
    required this.blinkEnabled,
    required this.breatheEnabled,
    required this.tailMotionEnabled,
    required this.celebrationEnabled,
  });

  final double eyeOpenness;
  final CatMouthStyle mouthStyle;
  final double earTilt;
  final double headTilt;
  final double bodyScale;
  final double tailAngle;
  final double pawLift;
  final double verticalOffset;
  final bool blinkEnabled;
  final bool breatheEnabled;
  final bool tailMotionEnabled;
  final bool celebrationEnabled;

  @override
  bool operator ==(Object other) =>
      other is CatPose &&
      other.eyeOpenness == eyeOpenness &&
      other.mouthStyle == mouthStyle &&
      other.earTilt == earTilt &&
      other.headTilt == headTilt &&
      other.bodyScale == bodyScale &&
      other.tailAngle == tailAngle &&
      other.pawLift == pawLift &&
      other.verticalOffset == verticalOffset &&
      other.blinkEnabled == blinkEnabled &&
      other.breatheEnabled == breatheEnabled &&
      other.tailMotionEnabled == tailMotionEnabled &&
      other.celebrationEnabled == celebrationEnabled;

  @override
  int get hashCode => Object.hash(
    eyeOpenness,
    mouthStyle,
    earTilt,
    headTilt,
    bodyScale,
    tailAngle,
    pawLift,
    verticalOffset,
    blinkEnabled,
    breatheEnabled,
    tailMotionEnabled,
    celebrationEnabled,
  );
}
