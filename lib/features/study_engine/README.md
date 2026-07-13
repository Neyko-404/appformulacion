# Study Engine

| Campo | Valor |
| --- | --- |
| Feature | Study Engine |
| Requisito | RF-005 |
| Sprint | 4D |
| Estado | Anti-Distraction Foundation implementada |

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

Antes de iniciar, la selección se valida nuevamente contra los cursos activos del usuario. Una sesión ya iniciada conserva su asociación aunque el curso cambie después. Al completar o cancelar, la sesión deja de ser activa y Presentation conserva temporalmente el resultado mientras el registro terminal permanece en el historial.

## Rutas y pruebas

`/focus` restaura o inicia sesión y `/focus/history` presenta registros recientes. Las pruebas ordinarias usan reloj fake y memoria, sin Firebase, red o binarios descargados. La reapertura Isar se valida manualmente o en CI preparado.

## Privacidad y pendientes

No se guardan correos, tokens ni contenido completo de cursos. 4B, 4C y 4D mantienen pendientes mascota interactiva, capacidades anti-distracción, notificaciones y evolución avanzada.

## UX Guidelines

Focus e historial son pantallas secundarias con AppBar y regreso gestionado por GoRouter. Los controles mantienen jerarquía clara, los resultados terminales ofrecen una salida explícita y los estados vacíos explican cómo generar contenido. Las duraciones visibles respetan singular y plural.

## Sprint 4B — Focus Experience

La preparación presenta duración, curso opcional y sesión libre con controles accesibles. Running y paused derivan tiempo y progreso del estado actual; las animaciones no calculan ni persisten tiempo. El regreso durante una sesión exige decidir entre continuar, salir manteniéndola activa o cancelar con confirmación.

Completed presenta resumen, actividad y una sugerencia conceptual de descanso de 5 o 10 minutos sin crear temporizadores ni persistencia. Cancelled utiliza lenguaje neutral y conserva el registro actual. El historial muestra estados naturales, duración, curso y fecha, con carga, vacío y recuperación de error.

Las microinteracciones utilizan únicamente APIs nativas breves, respetan la reducción de movimiento y nunca alteran timestamps. El temporizador tiene Semantics, cifras tabulares, progreso limitado y layout centrado responsive.

Permanecen fuera de alcance: mascota animada, anti-distracción, notificaciones, sonidos, recompensas, estadísticas avanzadas, Pomodoro automático y Break Engine.

## Companion Integration

Sprint 4C integra al compañero de estudio como apoyo visual discreto en ready, running, paused, completed y cancelled. `CompanionMessageService` es puro, determinista y deriva mensajes exclusivamente del estado, tiempo restante y duración planificada. Durante running conserva el mismo mensaje dentro de cada fase y cambia únicamente al cruzar los umbrales de 50 %, 20 % y 5 % restante.

`FocusCompanionCard` recibe avatar, nombre y mensaje; no consulta repositorios ni controla la sesión. La tarjeta permanece subordinada al temporizador y no incorpora IA, Random, chat, animaciones complejas, sonidos, recompensas, rachas ni notificaciones.

Sprint 6C integra `CompanionPresenceCard` mediante la API pública de Companion en ready, running, paused, retorno, completed y cancelled. Study Engine aporta estado y duraciones ya disponibles; su motor temporal no conoce expresiones y no depende de Companion Domain. El temporizador conserva la jerarquía principal.

## AI CONTEXT

Esta feature implementa RF-005 Sprint 4A. Una IA debe preservar timestamps como fuente temporal, reloj inyectable, aislamiento y API pública. No puede añadir background permanente, notificaciones, bloqueo, estadísticas o gamificación sin autorización.

## Sprint 4D — Anti-Distraction Foundation

Una interrupción representa que Focusly dejó de estar visible mientras una sesión estaba en estado running. `AppLifecycleState` no permite conocer qué aplicación se abrió ni qué hizo el usuario fuera de Focusly. Presentation agrupa `inactive`, `hidden`, `paused` y `detached` como una única salida, y reconcilia al recibir `resumed`.

`InterruptionPolicy` clasifica como relevante una salida de al menos cinco segundos. Las salidas más breves se descartan y no generan feedback. El tiempo continúa derivándose de timestamps; al regresar, la sesión puede completarse si venció fuera de la aplicación.

Las interrupciones relevantes se almacenan como entidades Isar separadas, aisladas por propietario y sesión. Esto mantiene `StudySession` pequeño, facilita el historial y permite restaurar una interrupción abierta después de la terminación del proceso. Solo se reconcilian timestamps al iniciar: no se promete observación mientras el proceso estuvo terminado.

El retorno presenta copy neutral y acciones para continuar, pausar o cancelar. El compañero usa `interruptedReturn` sin IA, aleatoriedad, penalizaciones ni cambios permanentes. El historial muestra únicamente el conteo relevante por sesión.

Privacidad: los registros permanecen localmente, no incluyen nombres ni paquetes de otras aplicaciones, no se envían a servidores y no requieren acceso al uso de aplicaciones. Usage Access queda pendiente de auditoría futura. También permanecen pendientes las notificaciones y la anti-distracción avanzada.

## Historial de cambios

| Versión | Fecha | Estado | Descripción | Autor |
| --- | --- | --- | --- | --- |
| 0.1.0 | 12 de julio de 2026 | Implementado | Study Engine Core basado en timestamps. | Equipo Focusly |
