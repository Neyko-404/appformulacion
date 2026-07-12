# Study Engine

| Campo | Valor |
| --- | --- |
| Feature | Study Engine |
| Requisito | RF-005 |
| Sprint | 4A |
| Estado | Core implementado |

## Propósito y alcance

Gestionar sesiones de concentración con curso opcional, duración seleccionable, pausa, reanudación, finalización, cancelación, restauración e historial local.

## Fuera de alcance

Ciclos Pomodoro completos, descansos, anti-distracciones, mascota animada, recompensas, rachas, notificaciones, sonidos, estadísticas, IA y sincronización.

## Entidad, modos y estados

`StudySession` conserva identidad, propietario, `courseId` opcional, modo, estado, duración planificada, duración acumulada y timestamps. `StudyMode` incluye focus y freeStudy. Los estados son ready, running, paused, completed y cancelled, con transiciones validadas por `StudySessionEngine`.

## Estrategia temporal y reloj

La fuente de verdad running es `plannedEndAt - StudyClock.now()`. El ticker solo refresca Presentation. Pausar materializa el foco acumulado y elimina `plannedEndAt`; reanudar calcula un nuevo final. No se persisten Timer o Stopwatch y no se promete ejecución continua en background.

## Repositorio y persistencia

Las sesiones ready no se persisten; se guarda desde running. `StudySessionRepository` limita consultas por propietario y garantiza una sola activa. Producción compone Isar Community mediante modelo, mapper y data source; tests usan `InMemoryStudySessionRepository`. Los enums son strings y las duraciones segundos.

## Integraciones

Courses se consume mediante `activeCoursesProvider`; solo se persiste `courseId`. Dashboard consume `activeStudySummaryProvider` y no controla el temporizador. El ciclo de vida reconcilia al volver a foreground.

Antes de iniciar, la selecciÃ³n se valida nuevamente contra los cursos activos del usuario. Una sesiÃ³n ya iniciada conserva su asociaciÃ³n aunque el curso cambie despuÃ©s. Al completar o cancelar, la sesiÃ³n deja de ser activa y Presentation conserva temporalmente el resultado mientras el registro terminal permanece en el historial.

## Rutas y pruebas

`/focus` restaura o inicia sesión y `/focus/history` presenta registros recientes. Las pruebas ordinarias usan reloj fake y memoria, sin Firebase, red o binarios descargados. La reapertura Isar se valida manualmente o en CI preparado.

## Privacidad y pendientes

No se guardan correos, tokens ni contenido completo de cursos. 4B, 4C y 4D mantienen pendientes mascota interactiva, capacidades anti-distracción, notificaciones y evolución avanzada.

## UX Guidelines

Focus e historial son pantallas secundarias con AppBar y regreso gestionado por GoRouter. Los controles mantienen jerarquía clara, los resultados terminales ofrecen una salida explícita y los estados vacíos explican cómo generar contenido. Las duraciones visibles respetan singular y plural.

## AI CONTEXT

Esta feature implementa RF-005 Sprint 4A. Una IA debe preservar timestamps como fuente temporal, reloj inyectable, aislamiento y API pública. No puede añadir background permanente, notificaciones, bloqueo, estadísticas o gamificación sin autorización.

## Historial de cambios

| Versión | Fecha | Estado | Descripción | Autor |
| --- | --- | --- | --- | --- |
| 0.1.0 | 12 de julio de 2026 | Implementado | Study Engine Core basado en timestamps. | Equipo Focusly |
