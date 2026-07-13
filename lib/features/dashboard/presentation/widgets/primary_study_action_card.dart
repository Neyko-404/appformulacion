import 'package:flutter/material.dart';
import 'package:focusly/features/study_engine/study_engine_public_providers.dart';
import 'package:focusly/shared/presentation/app_spacing.dart';

final class PrimaryStudyActionCard extends StatelessWidget {
  const PrimaryStudyActionCard({
    required this.study,
    required this.preferredMinutes,
    required this.courseLabel,
    required this.onOpen,
    super.key,
  });

  final ActiveStudySummary study;
  final int preferredMinutes;
  final String courseLabel;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final paused = study.isPaused;
    final title = study.session == null
        ? 'Comenzar sesión'
        : paused
        ? 'Retomar sesión'
        : 'Continuar sesión';
    final detail = study.session == null
        ? 'Sesión sugerida de $preferredMinutes min'
        : '$courseLabel · ${paused ? 'Pausada' : 'En curso'} · ${_remaining(study.remaining)}';
    return Semantics(
      button: true,
      label: '$title. $detail',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.xSmall),
              Text(detail),
              const SizedBox(height: AppSpacing.medium),
              FilledButton.icon(
                onPressed: onOpen,
                icon: Icon(paused ? Icons.play_arrow : Icons.timer_outlined),
                label: Text(title),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _remaining(Duration value) {
    final hours = value.inHours;
    final minutes = value.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
    return hours == 0 ? '$minutes:$seconds' : '$hours:$minutes:$seconds';
  }
}
