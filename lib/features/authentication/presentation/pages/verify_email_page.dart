import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/authentication/presentation/providers/auth_providers.dart';
import 'package:focusly/features/authentication/presentation/widgets/auth_page_layout.dart';
import 'package:focusly/features/authentication/presentation/widgets/auth_status_message.dart';
import 'package:focusly/features/authentication/presentation/widgets/auth_submit_button.dart';

class VerifyEmailPage extends ConsumerWidget {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authNotifierProvider);
    final email = state.session.user?.email;

    return AuthPageLayout(
      title: 'Verifica tu correo',
      subtitle: email == null || email.isEmpty
          ? 'Revisa tu correo para continuar.'
          : 'Enviamos instrucciones a $email.',
      children: [
        const Text(
          'La entrega puede tardar unos minutos. Revisa también la carpeta de '
          'correo no deseado.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        AuthStatusMessage(state: state),
        const SizedBox(height: 16),
        AuthSubmitButton(
          label: 'Ya verifiqué',
          isLoading: state.isLoading,
          onPressed: ref.read(authNotifierProvider.notifier).reloadSession,
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: state.isLoading
              ? null
              : ref.read(authNotifierProvider.notifier).sendEmailVerification,
          child: const Text('Reenviar verificación'),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: state.isLoading
              ? null
              : ref.read(authNotifierProvider.notifier).signOut,
          child: const Text('Cerrar sesión'),
        ),
      ],
    );
  }
}
