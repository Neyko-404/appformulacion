import 'package:flutter/material.dart';
import 'package:focusly/features/authentication/presentation/state/auth_state.dart';

class AuthStatusMessage extends StatelessWidget {
  const AuthStatusMessage({required this.state, super.key});

  final AuthState state;

  @override
  Widget build(BuildContext context) {
    final message = state.errorMessage ?? state.message;
    final isError = state.errorMessage != null;

    if (message == null) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isError
              ? colorScheme.errorContainer
              : colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isError
                ? colorScheme.onErrorContainer
                : colorScheme.onSecondaryContainer,
          ),
        ),
      ),
    );
  }
}
