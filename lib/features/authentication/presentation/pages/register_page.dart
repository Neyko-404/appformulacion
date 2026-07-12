import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/app/router/route_names.dart';
import 'package:focusly/features/authentication/presentation/providers/auth_providers.dart';
import 'package:focusly/features/authentication/presentation/state/auth_state.dart';
import 'package:focusly/features/authentication/presentation/widgets/auth_form_field.dart';
import 'package:focusly/features/authentication/presentation/widgets/auth_page_layout.dart';
import 'package:focusly/features/authentication/presentation/widgets/auth_status_message.dart';
import 'package:focusly/features/authentication/presentation/widgets/auth_submit_button.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmationController = TextEditingController();
  bool _obscurePassword = true;
  bool _acceptedTerms = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(authNotifierProvider.notifier).reset();
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final validator = ref.watch(authValidatorProvider);
    final isLoading = authState is AuthLoading;

    return AuthPageLayout(
      title: 'Crea tu cuenta',
      subtitle: 'Configura un acceso personal para comenzar.',
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthFormField(
                key: const Key('register-email'),
                controller: _emailController,
                label: 'Correo',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: validator.validateEmail,
              ),
              const SizedBox(height: 16),
              AuthFormField(
                key: const Key('register-password'),
                controller: _passwordController,
                label: 'Contraseña',
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.next,
                validator: validator.validatePassword,
                suffixIcon: IconButton(
                  tooltip: _obscurePassword
                      ? 'Mostrar contraseñas'
                      : 'Ocultar contraseñas',
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AuthFormField(
                key: const Key('register-confirmation'),
                controller: _confirmationController,
                label: 'Confirmar contraseña',
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                validator: (value) => validator.validatePasswordConfirmation(
                  value,
                  _passwordController.text,
                ),
                onFieldSubmitted: (_) => _submit(isLoading),
              ),
              const SizedBox(height: 8),
              FormField<bool>(
                initialValue: _acceptedTerms,
                validator: validator.validateTermsAccepted,
                builder: (field) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _acceptedTerms,
                        onChanged: isLoading
                            ? null
                            : (value) {
                                final accepted = value ?? false;
                                setState(() => _acceptedTerms = accepted);
                                field.didChange(accepted);
                              },
                        title: const Text(
                          'Acepto las condiciones provisionales',
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          'Los términos definitivos están pendientes.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      if (field.hasError)
                        Padding(
                          padding: const EdgeInsets.only(left: 12, top: 8),
                          child: Text(
                            field.errorText!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              AuthStatusMessage(state: authState),
              const SizedBox(height: 16),
              AuthSubmitButton(
                label: 'Crear cuenta',
                isLoading: isLoading,
                onPressed: () => _submit(isLoading),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: isLoading ? null : () => context.goNamed(RouteNames.login),
          child: const Text('Volver a iniciar sesión'),
        ),
      ],
    );
  }

  void _submit(bool isLoading) {
    if (isLoading || !_formKey.currentState!.validate()) {
      return;
    }
    ref
        .read(authNotifierProvider.notifier)
        .signUp(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }
}
