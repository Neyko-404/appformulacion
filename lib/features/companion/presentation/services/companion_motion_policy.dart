import 'package:focusly/features/companion/domain/entities/companion_expression_state.dart';
import 'package:focusly/features/companion/presentation/models/cat_pose.dart';
import 'package:focusly/features/companion/presentation/models/companion_card_variant.dart';
import 'package:focusly/features/companion/presentation/models/companion_motion_profile.dart';

abstract final class CompanionMotionPolicy {
  static CompanionMotionProfile resolve({
    required CatPose pose,
    required CompanionContext context,
    required CompanionCardVariant variant,
    required bool reduceMotion,
  }) {
    final enabled = !reduceMotion;
    final compact = variant == CompanionCardVariant.compact;
    final focus = variant == CompanionCardVariant.focus;
    return CompanionMotionProfile(
      breathingDuration: const Duration(milliseconds: 3200),
      blinkDuration: const Duration(milliseconds: 180),
      blinkInterval: pose.blinkEnabled
          ? const Duration(milliseconds: 4200)
          : Duration.zero,
      tailDuration: Duration(milliseconds: focus ? 3600 : 2800),
      poseTransitionDuration: enabled
          ? const Duration(milliseconds: 300)
          : Duration.zero,
      celebrationDuration: enabled
          ? const Duration(milliseconds: 650)
          : Duration.zero,
      breathingAmplitude: enabled && pose.breatheEnabled && !compact
          ? (focus ? .008 : .015)
          : 0,
      tailAmplitude: enabled && pose.tailMotionEnabled && !compact
          ? (focus ? .06 : .12)
          : 0,
      celebrationLift:
          enabled &&
              pose.celebrationEnabled &&
              context == CompanionContext.sessionCompleted
          ? .09
          : 0,
      animationsEnabled:
          enabled &&
          (pose.breatheEnabled ||
              pose.blinkEnabled ||
              pose.tailMotionEnabled ||
              pose.celebrationEnabled),
    );
  }
}
