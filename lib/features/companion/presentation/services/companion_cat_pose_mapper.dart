import 'package:focusly/features/companion/domain/entities/companion_customization.dart';
import 'package:focusly/features/companion/domain/entities/companion_expression_state.dart';
import 'package:focusly/features/companion/domain/entities/companion_state.dart';
import 'package:focusly/features/companion/presentation/models/cat_pose.dart';
import 'package:focusly/features/companion/presentation/models/companion_card_variant.dart';

final class CompanionCatPoseMapper {
  const CompanionCatPoseMapper();

  CatPose map({
    required CompanionExpressionState state,
    required CompanionCustomization customization,
    CompanionCardVariant variant = CompanionCardVariant.standard,
  }) {
    final compact = variant == CompanionCardVariant.compact;
    final focus = variant == CompanionCardVariant.focus;
    final base = switch (state.expression) {
      CompanionExpression.normal => const CatPose(
        eyeOpenness: 1,
        mouthStyle: CatMouthStyle.neutral,
        earTilt: 0,
        headTilt: 0,
        bodyScale: 1,
        tailAngle: .15,
        pawLift: 0,
        verticalOffset: 0,
        blinkEnabled: true,
        breatheEnabled: true,
        tailMotionEnabled: true,
        celebrationEnabled: false,
      ),
      CompanionExpression.happy => const CatPose(
        eyeOpenness: .72,
        mouthStyle: CatMouthStyle.smile,
        earTilt: .04,
        headTilt: -.03,
        bodyScale: 1,
        tailAngle: .4,
        pawLift: 0,
        verticalOffset: 0,
        blinkEnabled: true,
        breatheEnabled: true,
        tailMotionEnabled: true,
        celebrationEnabled: false,
      ),
      CompanionExpression.thinking => const CatPose(
        eyeOpenness: .9,
        mouthStyle: CatMouthStyle.focused,
        earTilt: .12,
        headTilt: .06,
        bodyScale: 1,
        tailAngle: .08,
        pawLift: 0,
        verticalOffset: 0,
        blinkEnabled: true,
        breatheEnabled: true,
        tailMotionEnabled: true,
        celebrationEnabled: false,
      ),
      CompanionExpression.cheering => const CatPose(
        eyeOpenness: .8,
        mouthStyle: CatMouthStyle.cheering,
        earTilt: -.04,
        headTilt: 0,
        bodyScale: 1.02,
        tailAngle: .55,
        pawLift: .25,
        verticalOffset: -.03,
        blinkEnabled: true,
        breatheEnabled: false,
        tailMotionEnabled: true,
        celebrationEnabled: true,
      ),
      CompanionExpression.sleeping => const CatPose(
        eyeOpenness: 0,
        mouthStyle: CatMouthStyle.relaxed,
        earTilt: .08,
        headTilt: .04,
        bodyScale: .96,
        tailAngle: -.12,
        pawLift: 0,
        verticalOffset: .04,
        blinkEnabled: false,
        breatheEnabled: false,
        tailMotionEnabled: false,
        celebrationEnabled: false,
      ),
    };
    return CatPose(
      eyeOpenness: base.eyeOpenness,
      mouthStyle: base.mouthStyle,
      earTilt: base.earTilt,
      headTilt: base.headTilt,
      bodyScale: base.bodyScale,
      tailAngle: base.tailAngle,
      pawLift: base.pawLift,
      verticalOffset: base.verticalOffset,
      blinkEnabled: base.blinkEnabled && !compact,
      breatheEnabled: base.breatheEnabled && !compact,
      tailMotionEnabled: base.tailMotionEnabled && !compact,
      celebrationEnabled: base.celebrationEnabled && !compact && !focus,
    );
  }
}
