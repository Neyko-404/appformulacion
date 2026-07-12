import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/app/router/route_names.dart';
import 'package:focusly/features/academic_tracker/academic_tracker_providers.dart';
import 'package:focusly/features/academic_tracker/domain/entities/course.dart';
import 'package:focusly/features/authentication/auth_session_provider.dart';
import 'package:focusly/shared/presentation/app_spacing.dart';
import 'package:go_router/go_router.dart';

class CourseFormPage extends ConsumerStatefulWidget {
  const CourseFormPage({this.courseId, super.key});
  final String? courseId;

  @override
  ConsumerState<CourseFormPage> createState() => _CourseFormPageState();
}

class _CourseFormPageState extends ConsumerState<CourseFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _code;
  late final TextEditingController _credits;
  CourseVisualIdentity _identity = CourseVisualIdentity.ocean;
  bool _loadingCourse = false;
  bool _notFound = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _code = TextEditingController();
    _credits = TextEditingController();
    if (widget.courseId != null) {
      _loadingCourse = true;
      Future<void>.microtask(_loadCourse);
    }
  }

  Future<void> _loadCourse() async {
    final userId = ref.read(publicAuthSessionProvider).user?.id;
    final course = userId == null
        ? null
        : await ref
              .read(courseRepositoryProvider)
              .getById(userId, widget.courseId!);
    if (!mounted) return;
    if (course == null) {
      setState(() {
        _loadingCourse = false;
        _notFound = true;
      });
      return;
    }
    _name.text = course.name;
    _code.text = course.code ?? '';
    _credits.text = course.credits?.toString() ?? '';
    setState(() {
      _identity = course.visualIdentity;
      _loadingCourse = false;
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _code.dispose();
    _credits.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courseState = ref.watch(courseNotifierProvider);
    final validator = ref.read(courseValidatorProvider);
    final editing = widget.courseId != null;
    return Scaffold(
      appBar: AppBar(title: Text(editing ? 'Editar curso' : 'Nuevo curso')),
      body: SafeArea(
        child: _loadingCourse
            ? const Center(child: CircularProgressIndicator())
            : _notFound
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('No pudimos encontrar ese curso.'),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => _leaveForm(context),
                      child: const Text('Volver a cursos'),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xLarge),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _name,
                            decoration: const InputDecoration(
                              labelText: 'Nombre',
                            ),
                            validator: (value) => validator.name(value ?? ''),
                          ),
                          const SizedBox(height: AppSpacing.large),
                          TextFormField(
                            controller: _code,
                            decoration: const InputDecoration(
                              labelText: 'Código opcional',
                            ),
                            validator: validator.code,
                          ),
                          const SizedBox(height: AppSpacing.large),
                          TextFormField(
                            controller: _credits,
                            decoration: const InputDecoration(
                              labelText: 'Créditos opcionales',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return null;
                              }
                              final parsed = int.tryParse(value);
                              return parsed == null
                                  ? 'Ingresa un número válido.'
                                  : validator.credits(parsed);
                            },
                          ),
                          const SizedBox(height: AppSpacing.xLarge),
                          DropdownButtonFormField<CourseVisualIdentity>(
                            initialValue: _identity,
                            decoration: const InputDecoration(
                              labelText: 'Identidad visual',
                            ),
                            items: CourseVisualIdentity.values
                                .map(
                                  (value) => DropdownMenuItem(
                                    value: value,
                                    child: Text(value.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _identity = value);
                              }
                            },
                          ),
                          if (courseState.errorMessage != null) ...[
                            const SizedBox(height: AppSpacing.large),
                            Text(
                              courseState.errorMessage!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                          const SizedBox(height: AppSpacing.xLarge),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: courseState.isWriting
                                      ? null
                                      : () => _leaveForm(context),
                                  child: const Text('Cancelar'),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.medium),
                              Expanded(
                                child: FilledButton(
                                  onPressed: courseState.isWriting
                                      ? null
                                      : _submit,
                                  child: Text(
                                    editing ? 'Guardar cambios' : 'Crear curso',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final creditsText = _credits.text.trim();
    final saved = await ref
        .read(courseNotifierProvider.notifier)
        .save(
          courseId: widget.courseId,
          name: _name.text,
          code: _code.text,
          credits: creditsText.isEmpty ? null : int.tryParse(creditsText),
          visualIdentity: _identity,
        );
    if (saved && mounted) _leaveForm(context);
  }

  void _leaveForm(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(RoutePaths.courses);
    }
  }
}
