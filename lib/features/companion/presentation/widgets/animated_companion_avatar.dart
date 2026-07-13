import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:focusly/features/companion/domain/entities/companion_customization.dart';
import 'package:focusly/features/companion/domain/entities/companion_expression_state.dart';
import 'package:focusly/features/companion/domain/entities/companion_presentation_model.dart';
import 'package:focusly/features/companion/presentation/cat_painter.dart';
import 'package:focusly/features/companion/presentation/companion_cat_palette.dart';
import 'package:focusly/features/companion/presentation/models/companion_card_variant.dart';
import 'package:focusly/features/companion/presentation/services/companion_cat_pose_mapper.dart';
import 'package:focusly/features/companion/presentation/services/companion_motion_policy.dart';

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

  @override
  State<AnimatedCompanionAvatar> createState() =>
      _AnimatedCompanionAvatarState();
}

class _AnimatedCompanionAvatarState extends State<AnimatedCompanionAvatar>
    with TickerProviderStateMixin {
  late final AnimationController _base;
  late final AnimationController _celebration;

  @override
  void initState() {
    super.initState();
    _base = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8400),
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
  }

  @override
  void didUpdateWidget(covariant AnimatedCompanionAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncMotion();
    if (widget.model.context == CompanionContext.sessionCompleted &&
        oldWidget.model.context != CompanionContext.sessionCompleted &&
        !_reduceMotion) {
      _celebration.forward(from: 0);
    }
  }

  bool get _reduceMotion =>
      widget.reduceMotion ?? MediaQuery.disableAnimationsOf(context);

  void _syncMotion() {
    if (_reduceMotion) {
      _base.stop();
      _celebration.stop();
    } else if (!_base.isAnimating) {
      _base.repeat();
    }
  }

  @override
  void dispose() {
    _base.dispose();
    _celebration.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.size.isFinite || widget.size <= 0) {
      return Semantics(
        label: widget.semanticLabel,
        child: const Icon(Icons.pets),
      );
    }
    final expressionState = CompanionExpressionState(
      context: widget.model.context,
      mood: widget.model.mood,
      expression: widget.model.expression,
      message: widget.model.message,
      semanticLabel: widget.model.semanticLabel,
      emphasis: widget.model.emphasis,
      supportingMessage: widget.model.supportingMessage,
    );
    final customization = CompanionCustomization(
      ownerId: '',
      identity: CompanionIdentity(
        displayName: widget.model.displayName,
        selectedTheme: widget.model.theme,
        selectedAvatar: widget.model.avatar,
        preferredExpressionStyle: CompanionExpressionStyle.standard,
      ),
    );
    final pose = const CompanionCatPoseMapper().map(
      state: expressionState,
      customization: customization,
      variant: widget.variant,
    );
    final profile = CompanionMotionPolicy.resolve(
      pose: pose,
      context: widget.model.context,
      variant: widget.variant,
      reduceMotion: _reduceMotion,
    );
    final palette = CompanionCatPalette.fromTheme(
      Theme.of(context),
      widget.model.theme,
    );
    return Semantics(
      image: true,
      label: widget.semanticLabel,
      child: RepaintBoundary(
        child: SizedBox.square(
          dimension: widget.size,
          child: AnimatedBuilder(
            animation: Listenable.merge([_base, _celebration]),
            builder: (context, _) {
              final phase = _base.value * math.pi * 2;
              final blinkWindow = ((_base.value * 2) % 1);
              final blink = profile.animationsEnabled && pose.blinkEnabled
                  ? (blinkWindow > .94
                        ? math.sin((blinkWindow - .94) / .06 * math.pi)
                        : 0.0)
                  : 0.0;
              return CustomPaint(
                painter: CatPainter(
                  pose: pose,
                  palette: palette,
                  breath: math.sin(phase) * profile.breathingAmplitude,
                  blink: blink,
                  tail: math.sin(phase * 1.2) * profile.tailAmplitude,
                  celebration:
                      math.sin(_celebration.value * math.pi) *
                      (profile.celebrationLift * 10),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
