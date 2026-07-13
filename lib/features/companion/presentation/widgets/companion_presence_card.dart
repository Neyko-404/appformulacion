import 'package:flutter/material.dart';
import 'package:focusly/features/companion/domain/entities/companion_presentation_model.dart';
import 'package:focusly/features/companion/presentation/companion_visual_mapper.dart';

enum CompanionCardVariant { compact, standard, focus }

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
    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: visual.iconSize / 2,
              backgroundColor: visual.background,
              foregroundColor: visual.foreground,
              child: Icon(visual.icon),
            ),
            Positioned(
              right: -4,
              bottom: -4,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: visual.border),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: Icon(visual.expressionIcon, size: 16),
                ),
              ),
            ),
          ],
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
        if (action case final action?) ...[const SizedBox(width: 8), action],
      ],
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
