import 'package:flutter/material.dart';
import 'package:focusly/shared/presentation/app_spacing.dart';

class GoalsSectionError extends StatelessWidget {
  const GoalsSectionError({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.medium),
            OutlinedButton(onPressed: onRetry, child: const Text('Reintentar')),
          ],
        ),
      ),
    ),
  );
}
