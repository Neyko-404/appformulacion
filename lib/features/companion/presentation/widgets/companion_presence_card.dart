import 'package:flutter/material.dart';
import 'package:focusly/features/companion/domain/entities/companion_presentation_model.dart';
import 'package:focusly/features/companion/presentation/companion_visual_mapper.dart';
import 'package:focusly/features/companion/presentation/models/companion_card_variant.dart';
import 'package:focusly/features/companion/presentation/widgets/animated_companion_avatar.dart';

class CompanionPresenceCard extends StatelessWidget {
  const CompanionPresenceCard({
    required this.model,
    this.variant = CompanionCardVariant.standard,
    this.action,
    super.key,
  });

  final CompanionPresentationModel model;
  final CompanionCardVariant variant;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final visual = CompanionVisualMapper.map(
      context,
      theme: model.theme,
      avatar: model.avatar,
      expression: model.expression,
      emphasis: model.emphasis,
    );
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    Widget mainContent() => Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedCompanionAvatar(
          model: model,
          variant: variant,
          size: switch (variant) {
            CompanionCardVariant.compact => 56,
            CompanionCardVariant.standard => 80,
            CompanionCardVariant.focus => 96,
          },
          semanticLabel: '${model.displayName}, ${model.semanticLabel}',
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                model.displayName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              AnimatedSwitcher(
                duration: reducedMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 250),
                child: Text(model.message, key: ValueKey(model.message)),
              ),
              if (model.supportingMessage case final supporting?) ...[
                const SizedBox(height: 4),
                Text(supporting, style: Theme.of(context).textTheme.bodySmall),
              ],
            ],
          ),
        ),
      ],
    );
    final content = LayoutBuilder(
      builder: (context, constraints) {
        final stackAction =
            action != null &&
            (constraints.maxWidth < 360 ||
                MediaQuery.textScalerOf(context).scale(1) > 1.3);
        if (stackAction) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              mainContent(),
              const SizedBox(height: 8),
              Align(alignment: Alignment.centerRight, child: action),
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: mainContent()),
            if (action case final action?) ...[
              const SizedBox(width: 8),
              action,
            ],
          ],
        );
      },
    );
    return Semantics(
      container: true,
      label: '${model.displayName}, ${model.semanticLabel}',
      child: Card(
        elevation: 0,
        color: variant == CompanionCardVariant.focus
            ? Theme.of(context).colorScheme.surfaceContainerLow
            : visual.background,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: visual.border),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(
            variant == CompanionCardVariant.compact ? 12 : 16,
          ),
          child: content,
        ),
      ),
    );
  }
}
