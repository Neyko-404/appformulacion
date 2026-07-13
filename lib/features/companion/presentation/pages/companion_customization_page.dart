import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/companion/companion_customization_public.dart';
import 'package:focusly/features/companion/domain/entities/companion_customization.dart';
import 'package:focusly/shared/presentation/app_spacing.dart';
import 'package:go_router/go_router.dart';

class CompanionCustomizationPage extends ConsumerWidget {
  const CompanionCustomizationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customization = ref.watch(companionCustomizationProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Personalizar compañero')),
      body: SafeArea(
        child: customization.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => const Center(
            child: Text('No pudimos cargar la personalización.'),
          ),
          data: (value) => value == null
              ? const Center(child: Text('Personalización no disponible.'))
              : _CustomizationForm(initial: value),
        ),
      ),
    );
  }
}

class _CustomizationForm extends ConsumerStatefulWidget {
  const _CustomizationForm({required this.initial});

  final CompanionCustomization initial;

  @override
  ConsumerState<_CustomizationForm> createState() => _CustomizationFormState();
}

class _CustomizationFormState extends ConsumerState<_CustomizationForm> {
  late final TextEditingController _name;
  late CompanionTheme _theme;
  late CompanionAppearance _avatar;
  String? _error;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initial.identity.displayName)
      ..addListener(_refreshPreview);
    _theme = widget.initial.identity.selectedTheme;
    _avatar = widget.initial.identity.selectedAvatar;
  }

  @override
  void dispose() {
    _name
      ..removeListener(_refreshPreview)
      ..dispose();
    super.dispose();
  }

  void _refreshPreview() => setState(() => _error = null);

  @override
  Widget build(BuildContext context) {
    final visual = CompanionVisualMapper.map(
      context,
      theme: _theme,
      avatar: _avatar,
    );
    final previewName = _name.text.trim().isEmpty
        ? widget.initial.identity.displayName
        : _name.text.trim();
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xLarge),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Semantics(
                  container: true,
                  label:
                      'Vista previa de $previewName, tema ${visual.themeLabel}',
                  child: Card(
                    color: visual.background,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xLarge),
                      child: Row(
                        children: [
                          Icon(visual.icon, color: visual.foreground, size: 56),
                          const SizedBox(width: AppSpacing.large),
                          Expanded(
                            child: Text(
                              previewName,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(color: visual.foreground),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xLarge),
                TextField(
                  controller: _name,
                  maxLength: 20,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    errorText: _error,
                    helperText: 'Entre 1 y 20 caracteres',
                  ),
                ),
                const SizedBox(height: AppSpacing.large),
                Text('Avatar', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.small),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: CompanionAppearance.values.map((avatar) {
                    final option = CompanionVisualMapper.map(
                      context,
                      theme: _theme,
                      avatar: avatar,
                    );
                    return ChoiceChip(
                      selected: _avatar == avatar,
                      avatar: Icon(option.icon),
                      label: Text(option.avatarLabel),
                      onSelected: (_) => setState(() => _avatar = avatar),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.large),
                Text('Tema', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.small),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: CompanionTheme.values.map((theme) {
                    final option = CompanionVisualMapper.map(
                      context,
                      theme: theme,
                      avatar: _avatar,
                    );
                    return ChoiceChip(
                      selected: _theme == theme,
                      label: Text(option.themeLabel),
                      onSelected: (_) => setState(() => _theme = theme),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.xLarge),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    TextButton(
                      onPressed: _isSaving ? null : context.pop,
                      child: const Text('Cancelar'),
                    ),
                    FilledButton(
                      onPressed: _isSaving ? null : _save,
                      child: _isSaving
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Guardar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (_isSaving) return;
    final value = _name.text.trim();
    if (value.isEmpty || value.length > 20) {
      setState(() => _error = 'Ingresa un nombre de 1 a 20 caracteres.');
      return;
    }
    setState(() => _isSaving = true);
    final saved = await ref
        .read(companionCustomizationProvider.notifier)
        .save(displayName: value, theme: _theme, avatar: _avatar);
    if (!mounted) return;
    setState(() => _isSaving = false);
    if (saved) {
      context.pop();
    } else {
      setState(() => _error = 'No pudimos guardar. Inténtalo nuevamente.');
    }
  }
}
