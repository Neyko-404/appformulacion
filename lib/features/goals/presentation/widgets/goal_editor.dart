import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focusly/shared/presentation/app_spacing.dart';

class GoalEditor extends StatelessWidget {
  const GoalEditor({
    required this.title,
    required this.description,
    required this.enabled,
    required this.controller,
    required this.minimum,
    required this.maximum,
    required this.unit,
    required this.onEnabledChanged,
    super.key,
  });

  final String title;
  final String description;
  final bool enabled;
  final TextEditingController controller;
  final int minimum;
  final int maximum;
  final String unit;
  final ValueChanged<bool> onEnabledChanged;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: Text(title),
            subtitle: Text(description),
            value: enabled,
            onChanged: onEnabledChanged,
          ),
          if (enabled) ...[
            const SizedBox(height: AppSpacing.small),
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: title,
                suffixText: unit,
                helperText: 'Entre $minimum y $maximum',
              ),
              validator: (raw) {
                final value = int.tryParse(raw?.trim() ?? '');
                if (value == null) return 'Ingresa un número válido.';
                if (value < minimum || value > maximum) {
                  return 'El valor debe estar entre $minimum y $maximum.';
                }
                return null;
              },
            ),
          ],
        ],
      ),
    ),
  );
}
