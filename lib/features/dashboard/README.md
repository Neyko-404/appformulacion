# Dashboard

| Campo | Valor |
| --- | --- |
| Feature | Dashboard |
| Sprint | 5B |
| Estado | Dashboard Intelligence implementado |

## Objetivo

Ofrecer una pantalla de inicio accionable que reúna el estado de estudio, una recomendación determinista y el progreso diario sin asumir propiedad sobre datos de otras features.

## Alcance

Incluye saludo, acción principal de estudio, insight contextual, compañero, resumen de hoy, objetivo y cursos activos. Cada bloque consume contratos públicos de solo lectura y conserva errores secundarios de forma localizada.

## Fuera de alcance

CRUD de cursos, control del temporizador, gráficos, predicciones, IA generativa, calendario, sincronización, notificaciones y backend.

## Estructura y widgets

- `DashboardPage`: composición responsive, actualización manual y estados parciales.
- `PrimaryStudyActionCard`: inicia, continúa o retoma la sesión según el estado público.
- `DashboardInsightCard`: presenta una recomendación determinista y su acción asociada.
- `StudyCompanionCard`: nombre y mensaje del compañero.
- `FocusGoalCard`: objetivo y duración preferida.
- `AnalyticsSummaryCard`: resumen compacto de tiempo, sesiones, interrupciones y curso destacado.
- `CoursesCard`: vista resumida de cursos activos y acceso a Academic Tracker.

## Estado y providers

`DashboardState` contiene únicamente `StudentProfile`, `StudyCompanion`, carga y error seguro. `DashboardNotifier` consulta ambos elementos mediante `OnboardingRepository`. `dashboardOnboardingRepositoryProvider` adapta la composición pública existente sin crear otro repositorio.

La tarjeta de cursos consume `activeCoursesProvider`, muestra hasta tres cursos activos, la cantidad total o el estado vacío, y navega hacia Academic Tracker. Dashboard no es propietario de `Course` ni importa Data o Presentation de esa feature.

El botón de enfoque consume `activeStudySummaryProvider`, navega a `/focus` y cambia a “Continuar sesión” cuando existe una sesión activa. Dashboard no controla el ticker ni el temporizador.

Durante una sesión running muestra el tiempo restante proporcionado por la API pública; durante una sesión paused muestra “En pausa”. Dashboard no recalcula progreso ni ejecuta controles de la sesión.

## Companion Integration

Dashboard reutiliza `CompanionMessageService` y `FocusCompanionCard`. Sin sesión muestra “¿Listo para estudiar?”; con sesión utiliza el estado y tiempo suministrados por `activeStudySummaryProvider`. La tarjeta no consulta el repositorio de Study Engine ni calcula el temporizador.

## Integración

Authentication aporta `AuthSession` mediante `publicAuthSessionProvider`. Onboarding conserva la propiedad del perfil, compañero y persistencia. Dashboard no importa Data, Firebase ni Isar y no navega desde su Notifier. GoRouter expone `/dashboard` después de sesión verificada y onboarding completo.

## Analytics Foundation

Dashboard muestra el resumen read-only de hoy: tiempo estudiado, sesiones completadas, curso con mayor tiempo e interrupciones registradas. Consume exclusivamente `dashboardTodayAnalyticsProvider`; no consulta fuentes ni calcula métricas. “Ver progreso” navega a `/analytics`.

Sprint 5C añade una línea compacta de tendencia semanal con iconografía Material y copy neutral. El mensaje y la dirección llegan en la proyección pública de Analytics; Dashboard no compara periodos, no calcula porcentajes y no accede a fuentes históricas.

## Dashboard Intelligence

La jerarquía visual es: encabezado, acción principal, insight, compañero, resumen de hoy, objetivo y cursos. La acción principal se deriva de `activeStudySummaryProvider`: inicia cuando no hay sesión, continúa una sesión activa o retoma una sesión pausada.

`DashboardInsightService` es puro y aplica prioridades explícitas sobre datos ya disponibles: sesión activa, sesión pausada, ausencia de cursos, ausencia de actividad, interrupciones elevadas, progreso significativo y actividad completada. La entrada representa explícitamente si Analytics y Courses están disponibles; carga o error nunca se interpretan como cero o lista vacía. Si una fuente secundaria es desconocida y no hay sesión activa, muestra un insight neutral sin acción. No usa aleatoriedad, red, IA ni persistencia.

La carga inicial solo bloquea por perfil y compañero, datos esenciales de esta pantalla. Analytics y Courses muestran carga o error dentro de su propia sección; un fallo parcial no oculta la acción de estudio ni el resto del Dashboard. La actualización manual se serializa, solicita otra lectura de perfil y compañero y fuerza una lectura nueva de Analytics. Conserva el resumen anterior mientras Analytics actualiza y aísla un fallo de esa fuente. Courses y Study Engine permanecen reactivos mediante sus notifiers; el gesto no invalida decorativamente sus proyecciones ni escribe en repositorios.

Dashboard integra Authentication, Onboarding, Study Engine, Academic Tracker y Analytics exclusivamente mediante APIs públicas. No importa capas Data o Presentation ajenas, no duplica cálculos analíticos y no controla el temporizador.

## Pruebas

Las pruebas usan sesión y repositorio en memoria mediante overrides. No usan Firebase, red ni disco.

## UX Guidelines

Dashboard es la pantalla raíz y no muestra navegación hacia atrás. La acción principal aparece antes que la información secundaria; el compañero usa lenguaje humano y las tarjetas mantienen semántica, iconografía, contraste temático y adaptación a texto ampliado. Los accesos a Focus, Courses y Analytics usan rutas existentes y preservan el regreso.

## AI CONTEXT

Esta feature implementa Dashboard Intelligence Sprint 5B mediante reglas deterministas y contratos públicos read-only. Una IA no puede añadir repositorios, recalcular Analytics, controlar Study Engine, generar recomendaciones con IA, crear rachas, gráficos o sincronización sin autorización.

## Historial de cambios

| Versión | Fecha | Estado | Descripción | Autor |
| --- | --- | --- | --- | --- |
| 0.1.0 | 12 de julio de 2026 | En desarrollo | Base responsive del Dashboard Sprint 3A. | Equipo Focusly |
| 0.2.0 | 12 de julio de 2026 | Implementado | Dashboard Intelligence Sprint 5B. | Equipo Focusly |
| 0.2.1 | 12 de julio de 2026 | Implementado | Proyección visual de tendencia semanal Sprint 5C. | Equipo Focusly |
