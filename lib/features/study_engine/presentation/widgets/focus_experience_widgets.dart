import 'package:flutter/material.dart';
import 'package:focusly/features/study_engine/domain/entities/study_session.dart';
import 'package:focusly/shared/presentation/app_spacing.dart';

double focusProgress({required Duration remaining, required Duration planned}) {
  if (planned <= Duration.zero) return 0;
  final elapsedSeconds = planned.inSeconds - remaining.inSeconds;
  return (elapsedSeconds / planned.inSeconds).clamp(0.0, 1.0);
}

String focusDurationLabel(Duration duration) {
  final minutes = duration.inMinutes;
  return minutes == 1 ? '1 minuto' : '$minutes minutos';
}

final class DurationSelector extends StatelessWidget {
  const DurationSelector({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final Duration selected;
  final ValueChanged<Duration> onSelected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Duración de la sesión',
      child: Wrap(
        spacing: AppSpacing.small,
        runSpacing: AppSpacing.small,
        children: [
          for (final minutes in const [15, 25, 40, 50])
            ChoiceChip(
              label: Text('$minutes min'),
              selected: selected.inMinutes == minutes,
              onSelected: (_) => onSelected(Duration(minutes: minutes)),
            ),
        ],
      ),
    );
  }
}

final class SessionStatusLabel extends StatelessWidget {
  const SessionStatusLabel({required this.paused, super.key});

  final bool paused;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      label: paused ? 'Estado: sesión pausada' : 'Estado: en curso',
      child: Chip(
        avatar: Icon(
          paused ? Icons.pause_circle_outline : Icons.play_circle_outline,
          size: 18,
        ),
        label: Text(paused ? 'Sesión pausada' : 'En curso'),
        backgroundColor: paused
            ? colors.secondaryContainer
            : colors.primaryContainer,
      ),
    );
  }
}

final class FocusTimerDisplay extends StatelessWidget {
  const FocusTimerDisplay({
    required this.remaining,
    required this.planned,
    super.key,
  });

  final Duration remaining;
  final Duration planned;

  @override
  Widget build(BuildContext context) {
    final safeRemaining = remaining.isNegative ? Duration.zero : remaining;
    final minutes = safeRemaining.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    final seconds = safeRemaining.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    final progress = focusProgress(remaining: safeRemaining, planned: planned);
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    return Semantics(
      label:
          'Tiempo restante: ${focusDurationLabel(safeRemaining)}, $seconds segundos. '
          'Progreso ${(progress * 100).round()} por ciento.',
      liveRegion: true,
      child: ExcludeSemantics(
        child: SizedBox.square(
          dimension: 248,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox.square(
                dimension: 224,
                child: TweenAnimationBuilder<double>(
                  duration: disableAnimations
                      ? Duration.zero
                      : const Duration(milliseconds: 250),
                  tween: Tween(end: progress),
                  builder: (context, value, _) => CircularProgressIndicator(
                    value: value.clamp(0, 1),
                    strokeWidth: 12,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '$minutes:$seconds',
                  key: const ValueKey('focus-timer-value'),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class SessionResultCard extends StatelessWidget {
  const SessionResultCard({
    required this.session,
    required this.courseLabel,
    required this.onHome,
    required this.onRestart,
    super.key,
  });

  final StudySession session;
  final String courseLabel;
  final VoidCallback onHome;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final completed = session.status == StudySessionStatus.completed;
    final suggestedBreak = session.plannedDuration.inMinutes <= 25 ? 5 : 10;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              completed ? Icons.check_circle_outline : Icons.info_outline,
              size: 64,
              color: completed
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: AppSpacing.large),
            Text(
              completed ? 'Sesión completada' : 'Sesión cancelada',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.medium),
            Text(
              completed
                  ? 'Buen trabajo. Has completado tu sesión.'
                  : 'La sesión fue cancelada. Puedes intentarlo nuevamente cuando quieras.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.large),
            _ResultRow(
              icon: Icons.timer_outlined,
              label: 'Tiempo enfocado',
              value: focusDurationLabel(session.accumulatedFocusDuration),
            ),
            _ResultRow(
              icon: Icons.menu_book_outlined,
              label: 'Actividad',
              value: courseLabel,
            ),
            if (completedAtLabel(session) case final completedAt?)
              _ResultRow(
                icon: Icons.event_available_outlined,
                label: 'Finalizada',
                value: completedAt,
              ),
            if (completed) ...[
              const SizedBox(height: AppSpacing.medium),
              Text(
                'Si te viene bien, toma un descanso de $suggestedBreak minutos antes de continuar.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: AppSpacing.xLarge),
            FilledButton(
              onPressed: onHome,
              child: const Text('Volver al inicio'),
            ),
            const SizedBox(height: AppSpacing.medium),
            OutlinedButton(
              onPressed: onRestart,
              child: const Text('Iniciar otra sesión'),
            ),
          ],
        ),
      ),
    );
  }

  String? completedAtLabel(StudySession value) {
    final date = value.completedAt;
    if (date == null) return null;
    final local = date.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '${local.day}/${local.month}/${local.year} $hour:$minute';
  }
}

final class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: AppSpacing.medium),
        Expanded(child: Text('$label: $value')),
      ],
    ),
  );
}
