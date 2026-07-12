import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/study_engine/companion_message_service.dart';
import 'package:focusly/features/study_engine/domain/entities/study_session.dart';

void main() {
  const service = CompanionMessageService();
  const planned = Duration(minutes: 100);

  String message(StudySessionStatus status, Duration remaining) => service
      .message(status: status, remaining: remaining, plannedDuration: planned);

  test('ready is calm and actionable', () {
    expect(
      message(StudySessionStatus.ready, planned),
      'Todo listo. Comienza cuando quieras.',
    );
  });

  test('running uses stable derived threshold phases', () {
    expect(message(StudySessionStatus.running, planned), 'Ya comenzaste.');
    expect(
      message(StudySessionStatus.running, const Duration(minutes: 51)),
      'Ya comenzaste.',
    );
    expect(
      message(StudySessionStatus.running, const Duration(minutes: 50)),
      'Buen ritmo.',
    );
    expect(
      message(StudySessionStatus.running, const Duration(minutes: 21)),
      'Buen ritmo.',
    );
    expect(
      message(StudySessionStatus.running, const Duration(minutes: 20)),
      'Ya casi terminas.',
    );
    expect(
      message(StudySessionStatus.running, const Duration(minutes: 5)),
      'Último esfuerzo.',
    );
    expect(
      message(StudySessionStatus.running, Duration.zero),
      'Último esfuerzo.',
    );
  });

  test('paused, completed, and cancelled remain emotionally safe', () {
    expect(
      message(StudySessionStatus.paused, const Duration(minutes: 40)),
      'Tómate un momento. Continúa cuando estés listo.',
    );
    expect(
      message(StudySessionStatus.completed, Duration.zero),
      'Buen trabajo. Ahora descansa un poco.',
    );
    expect(
      message(StudySessionStatus.cancelled, const Duration(minutes: 30)),
      'No pasa nada. Puedes intentarlo nuevamente.',
    );
  });

  test('invalid planned duration is safe and deterministic', () {
    expect(
      service.message(
        status: StudySessionStatus.running,
        remaining: Duration.zero,
        plannedDuration: Duration.zero,
      ),
      'Ya comenzaste.',
    );
  });
}
