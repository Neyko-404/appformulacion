enum CatMouthStyle { neutral, smile, focused, relaxed, cheering }

enum CatAccentStyle { forehead, ears, mask, cheeks, chest }

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
    this.accentStyle = CatAccentStyle.forehead,
  }) : assert(eyeOpenness >= 0 && eyeOpenness <= 1),
       assert(earTilt >= -0.5 && earTilt <= 0.5),
       assert(headTilt >= -0.5 && headTilt <= 0.5),
       assert(bodyScale >= 0.8 && bodyScale <= 1.2),
       assert(tailAngle >= -1 && tailAngle <= 1),
       assert(pawLift >= 0 && pawLift <= 1),
       assert(verticalOffset >= -0.2 && verticalOffset <= 0.2);

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
  final CatAccentStyle accentStyle;

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
      other.celebrationEnabled == celebrationEnabled &&
      other.accentStyle == accentStyle;

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
    accentStyle,
  );
}
