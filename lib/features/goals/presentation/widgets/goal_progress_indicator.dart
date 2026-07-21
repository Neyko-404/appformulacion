import 'package:flutter/material.dart';

class GoalProgressIndicator extends StatelessWidget {
  const GoalProgressIndicator({
    required this.value,
    required this.label,
    super.key,
  });

  final double value;
  final String label;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    value: '${(value * 100).round()} %',
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 10,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
    ),
  );
}
