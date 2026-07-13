import 'package:focusly/features/companion/domain/entities/companion_customization.dart';
import 'package:focusly/features/companion/domain/entities/companion_expression_state.dart';
import 'package:focusly/features/companion/domain/entities/companion_state.dart';

final class CompanionPresentationModel {
  const CompanionPresentationModel({
    required this.displayName,
    required this.theme,
    required this.avatar,
    required this.mood,
    required this.expression,
    required this.message,
    required this.accentColorKey,
    this.semanticLabel = '',
    this.emphasis = CompanionEmphasis.normal,
    this.supportingMessage,
  });

  final String displayName;
  final CompanionTheme theme;
  final CompanionAppearance avatar;
  final CompanionMood mood;
  final CompanionExpression expression;
  final String message;
  final String accentColorKey;
  final String semanticLabel;
  final CompanionEmphasis emphasis;
  final String? supportingMessage;
}
