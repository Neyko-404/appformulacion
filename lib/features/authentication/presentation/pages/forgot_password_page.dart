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

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final validator = ref.watch(authValidatorProvider);
    final isLoading = authState is AuthLoading;

    return AuthPageLayout(
      title: 'Recupera tu acceso',
      subtitle: 'Te indicaremos cómo continuar de forma segura.',
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthFormField(
                key: const Key('forgot-email'),
                controller: _emailController,
                label: 'Correo',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: validator.validateEmail,
                onFieldSubmitted: (_) => _submit(isLoading),
              ),
              const SizedBox(height: 16),
              AuthStatusMessage(state: authState),
              const SizedBox(height: 16),
              AuthSubmitButton(
                label: 'Enviar instrucciones',
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
        .requestPasswordReset(email: _emailController.text);
  }
}
