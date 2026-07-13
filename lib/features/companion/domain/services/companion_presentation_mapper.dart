import 'package:focusly/features/companion/domain/entities/companion_customization.dart';
import 'package:focusly/features/companion/domain/entities/companion_expression_state.dart';
import 'package:focusly/features/companion/domain/entities/companion_presentation_model.dart';
import 'package:focusly/features/companion/domain/entities/companion_state.dart';

final class CompanionPresentationMapper {
  const CompanionPresentationMapper();

  CompanionPresentationModel map({
    required CompanionSnapshot snapshot,
    required CompanionCustomization customization,
  }) => CompanionPresentationModel(
    displayName: customization.identity.displayName,
    theme: customization.identity.selectedTheme,
    avatar: customization.identity.selectedAvatar,
    mood: snapshot.mood,
    expression: snapshot.expression,
    message: snapshot.message,
    accentColorKey: customization.identity.selectedTheme.name,
  );

  CompanionPresentationModel mapExpression({
    required CompanionExpressionState expressionState,
    required CompanionCustomization customization,
  }) => CompanionPresentationModel(
    displayName: customization.identity.displayName,
    theme: customization.identity.selectedTheme,
    avatar: customization.identity.selectedAvatar,
    mood: expressionState.mood,
    expression: expressionState.expression,
    message: expressionState.message,
    semanticLabel: expressionState.semanticLabel,
    emphasis: expressionState.emphasis,
    supportingMessage: expressionState.supportingMessage,
    context: expressionState.context,
    accentColorKey: customization.identity.selectedTheme.name,
  );
}
