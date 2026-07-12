import 'package:flutter/material.dart';

class AuthLoadingPage extends StatelessWidget {
  const AuthLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Semantics(
            label: 'Comprobando sesión',
            liveRegion: true,
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
