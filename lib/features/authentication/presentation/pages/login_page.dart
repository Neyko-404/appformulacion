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

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final validator = ref.watch(authValidatorProvider);
    final isLoading = authState is AuthLoading;

    return AuthPageLayout(
      title: 'Inicia sesión',
      subtitle: 'Continúa con tu espacio personal de estudio.',
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthFormField(
                key: const Key('login-email'),
                controller: _emailController,
                label: 'Correo',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: validator.validateEmail,
              ),
              const SizedBox(height: 16),
              AuthFormField(
                key: const Key('login-password'),
                controller: _passwordController,
                label: 'Contraseña',
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                validator: validator.validatePassword,
                onFieldSubmitted: (_) => _submit(isLoading),
                suffixIcon: IconButton(
                  tooltip: _obscurePassword
                      ? 'Mostrar contraseña'
                      : 'Ocultar contraseña',
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
              AuthStatusMessage(state: authState),
              const SizedBox(height: 16),
              AuthSubmitButton(
                label: 'Iniciar sesión',
                isLoading: isLoading,
                onPressed: () => _submit(isLoading),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: isLoading
              ? null
              : () => context.goNamed(RouteNames.forgotPassword),
          child: const Text('Olvidé mi contraseña'),
        ),
        TextButton(
          onPressed: isLoading
              ? null
              : () => context.goNamed(RouteNames.register),
          child: const Text('Crear una cuenta'),
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
        .signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }
}
