import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/onboarding/onboarding_providers.dart';

class OnboardingErrorPage extends ConsumerWidget {
  const OnboardingErrorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Focusly')),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.storage_outlined, size: 64),
                const SizedBox(height: 20),
                Text(
                  state.errorMessage ??
                      'No pudimos consultar tu configuración guardada.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: state.isInitializing
                      ? null
                      : ref
                            .read(onboardingNotifierProvider.notifier)
                            .retryInitialization,
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
