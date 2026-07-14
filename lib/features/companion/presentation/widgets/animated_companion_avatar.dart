import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:focusly/features/companion/domain/entities/companion_customization.dart';
import 'package:focusly/features/companion/domain/entities/companion_expression_state.dart';
import 'package:focusly/features/companion/domain/entities/companion_presentation_model.dart';
import 'package:focusly/features/companion/presentation/companion_cat_palette.dart';
import 'package:focusly/features/companion/presentation/models/cat_pose.dart';
import 'package:focusly/features/companion/presentation/models/companion_card_variant.dart';
import 'package:focusly/features/companion/presentation/models/companion_motion_profile.dart';
import 'package:focusly/features/companion/presentation/services/companion_cat_pose_mapper.dart';
import 'package:focusly/features/companion/presentation/services/companion_motion_policy.dart';
import 'package:focusly/features/companion/presentation/study_cat_painter.dart';

class AnimatedCompanionAvatar extends StatefulWidget {
  const AnimatedCompanionAvatar({
    required this.model,
    required this.variant,
    required this.size,
    required this.semanticLabel,
    this.reduceMotion,
    super.key,
  });

  final CompanionPresentationModel model;
  final CompanionCardVariant variant;
  final double size;
  final String semanticLabel;
  final bool? reduceMotion;

  static const avatarKey = Key('animated-companion-avatar');
  static const paintKey = Key('animated-companion-paint');
  static const fallbackKey = Key('animated-companion-fallback');

  @override
  State<AnimatedCompanionAvatar> createState() =>
      _AnimatedCompanionAvatarState();
}

class _AnimatedCompanionAvatarState extends State<AnimatedCompanionAvatar>
    with TickerProviderStateMixin {
  late final AnimationController _breathing;
  late final AnimationController _blink;
  late final AnimationController _tail;
  late final AnimationController _celebration;
  bool _celebratedCurrentCompletion = false;

  @override
  void initState() {
    super.initState();
    _breathing = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );
    _blink = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    );
    _tail = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );
    _celebration = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMotion();
    _syncCelebration();
  }

  @override
  void didUpdateWidget(covariant AnimatedCompanionAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model.context != CompanionContext.sessionCompleted) {
      _celebratedCurrentCompletion = false;
      _celebration.reset();
    }
    _syncMotion();
    _syncCelebration();
  }

  bool get _reduceMotion =>
      widget.reduceMotion ?? MediaQuery.disableAnimationsOf(context);

  void _syncMotion() {
    if (!_hasRenderableAvatar) {
      _stopContinuousMotion();
      _celebration.stop();
      return;
    }
    final profile = _motionProfile;
    _breathing.duration = profile.breathingDuration;
    _blink.duration = profile.blinkInterval == Duration.zero
        ? const Duration(milliseconds: 1)
        : profile.blinkInterval;
    _tail.duration = profile.tailDuration;
    _celebration.duration = profile.celebrationDuration == Duration.zero
        ? const Duration(milliseconds: 1)
        : profile.celebrationDuration;
    if (!profile.animationsEnabled) {
      _stopContinuousMotion();
      _celebration.stop();
      return;
    }
    _syncRepeating(_breathing, profile.breathingAmplitude > 0);
    _syncRepeating(_blink, profile.blinkInterval > Duration.zero);
    _syncRepeating(_tail, profile.tailAmplitude > 0);
  }

  void _syncRepeating(AnimationController controller, bool enabled) {
    if (enabled && !controller.isAnimating) {
      controller.repeat();
    } else if (!enabled) {
      controller
        ..stop()
        ..value = 0;
    }
  }

  void _stopContinuousMotion() {
    for (final controller in [_breathing, _blink, _tail]) {
      controller
        ..stop()
        ..value = 0;
    }
  }

  void _syncCelebration() {
    if (!_hasRenderableAvatar ||
        widget.model.context != CompanionContext.sessionCompleted ||
        _celebratedCurrentCompletion) {
      return;
    }
    _celebratedCurrentCompletion = true;
    if (_motionProfile.celebrationLift > 0) {
      _celebration.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _breathing.dispose();
    _blink.dispose();
    _tail.dispose();
    _celebration.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasRenderableAvatar) {
      return _fallback;
    }
    final resolvedSize = widget.size;
    final pose = _pose;
    final profile = _motionProfile;
    final palette = CompanionCatPalette.fromTheme(
      Theme.of(context),
      widget.model.theme,
    );
    if (!palette.isVisible) return _fallback;
    return Semantics(
      image: true,
      label: widget.semanticLabel,
      child: SizedBox.square(
        key: AnimatedCompanionAvatar.avatarKey,
        dimension: resolvedSize,
        child: RepaintBoundary(
          child: AnimatedSwitcher(
            duration: profile.poseTransitionDuration,
            layoutBuilder: (currentChild, previousChildren) => Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [...previousChildren, ?currentChild],
            ),
            child: AnimatedBuilder(
              key: ValueKey(pose),
              animation: Listenable.merge([
                _breathing,
                _blink,
                _tail,
                _celebration,
              ]),
              builder: (context, _) {
                final blinkFraction = profile.blinkInterval == Duration.zero
                    ? 0.0
                    : (profile.blinkDuration.inMicroseconds /
                              profile.blinkInterval.inMicroseconds)
                          .clamp(0.01, 0.25);
                final blinkStart = 1 - blinkFraction;
                final blink =
                    profile.animationsEnabled &&
                        pose.blinkEnabled &&
                        _blink.value >= blinkStart
                    ? math.sin(
                        (_blink.value - blinkStart) / blinkFraction * math.pi,
                      )
                    : 0.0;
                return CustomPaint(
                  key: AnimatedCompanionAvatar.paintKey,
                  size: Size.square(resolvedSize),
                  painter: StudyCatPainter(
                    pose: pose,
                    palette: palette,
                    breath:
                        math.sin(_breathing.value * math.pi * 2) *
                        profile.breathingAmplitude,
                    blink: blink,
                    tail:
                        math.sin(_tail.value * math.pi * 2) *
                        profile.tailAmplitude,
                    celebration:
                        math.sin(_celebration.value * math.pi) *
                        profile.celebrationLift,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget get _fallback => Semantics(
    label: widget.semanticLabel,
    child: const SizedBox.square(
      key: AnimatedCompanionAvatar.fallbackKey,
      dimension: 48,
      child: Icon(Icons.pets, size: 32),
    ),
  );

  bool get _hasRenderableAvatar => widget.size.isFinite && widget.size > 0;

  CompanionExpressionState get _expressionState => CompanionExpressionState(
    context: widget.model.context,
    mood: widget.model.mood,
    expression: widget.model.expression,
    message: widget.model.message,
    semanticLabel: widget.model.semanticLabel,
    emphasis: widget.model.emphasis,
    supportingMessage: widget.model.supportingMessage,
  );

  CompanionCustomization get _customization => CompanionCustomization(
    ownerId: '',
    identity: CompanionIdentity(
      displayName: widget.model.displayName,
      selectedTheme: widget.model.theme,
      selectedAvatar: widget.model.avatar,
      preferredExpressionStyle: CompanionExpressionStyle.standard,
    ),
  );

  CatPose get _pose => const CompanionCatPoseMapper().map(
    state: _expressionState,
    customization: _customization,
    variant: widget.variant,
  );

  CompanionMotionProfile get _motionProfile => CompanionMotionPolicy.resolve(
    pose: _pose,
    context: widget.model.context,
    variant: widget.variant,
    reduceMotion: _reduceMotion,
  );
}
