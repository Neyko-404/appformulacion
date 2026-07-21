# Analytics

| Campo | Valor |
| --- | --- |
| Feature | Analytics |
| Requisito | RF-009 |
| Sprint | 5D |
| Estado | Personalized Insights Engine implementado |

## Propósito y alcance

Analytics recalcula resúmenes diarios, semanales, mensuales y por curso a partir de sesiones, interrupciones relevantes y cursos existentes. Analytics no modifica ninguna fuente de datos.

## Filosofía read-only y fuentes

La feature consume contratos públicos mínimos de Study Engine, Academic Tracker y Authentication. El adaptador `ReadOnlyAnalyticsRepository` combina esas fuentes sin acceder a Isar, repositorios concretos, Data o Presentation de otras features. No persiste resultados analíticos.

## Métricas y definiciones

- Tiempo enfocado: suma `accumulatedFocusDuration` únicamente de sesiones completed.
- Completed, cancelled y active se contabilizan por separado. Ready no se persiste ni cuenta.
- Promedio: tiempo completed dividido entre sesiones completed; sin sesiones es cero.
- Días activos: fechas locales distintas con al menos una completed.
- Interrupciones: solo registros relevantes cerrados; su duración se presenta como tiempo fuera de Focusly, no como tiempo perdido.
- Sesiones libres: aportan tiempo y sesiones, pero no participan en rankings de cursos.
- Curso archivado: conserva su nombre. Curso eliminado: `Curso no disponible`.

El curso con mayor tiempo se desempata por sesiones completed, actividad más reciente, nombre alfabético y `courseId`. El mismo orden estable sirve como base para futuros resúmenes por cantidad.

## Intervalos temporales

Todos los rangos usan `[startInclusive, endExclusive)` en hora local. Sus límites se construyen como fechas civiles locales: el día termina en la medianoche civil siguiente, la semana comienza el lunes y termina en la medianoche del lunes siguiente, y el mes termina al inicio del siguiente mes. No se asume que un día siempre dura 24 horas ni que una semana siempre dura 168 horas. `AnalyticsClock` permite pruebas deterministas y evita `DateTime.now()` disperso.

## Entidades y cálculo

`DailyStudyAnalytics`, `WeeklyStudyAnalytics`, `MonthlyStudyAnalytics`, `CourseStudyAnalytics` y `StudyAnalyticsSummary` son inmutables e independientes de Flutter, Riverpod, Isar y Firebase. `AnalyticsCalculator` concentra filtrado, agregación y desempates sin consultar repositorios.

`TrendComparison`, `WeeklyTrend`, `MonthlyTrend`, `CourseTrend` y `StudyTrendSummary` modelan comparaciones inmutables. `TrendCalculator` recibe resúmenes ya calculados, produce valores actuales y anteriores, diferencia firmada, diferencia absoluta, porcentaje y dirección, y no accede a fuentes. `signedDifference` es `actual - anterior`; `absoluteDifference` es siempre su magnitud no negativa y nunca se usa para inferir crecimiento. Si el valor anterior es cero, el porcentaje es `null`: se comunica actividad nueva o falta de datos sin inventar un porcentaje ni dividir por cero. Cuando ambos periodos son cero, Dashboard omite la tendencia semanal.

Sprint 5C compara semana actual con anterior y mes actual con anterior para tiempo, sesiones, promedio, interrupciones, días activos y curso dominante. Los cursos se comparan por identidad y el mayor crecimiento se ordena por diferencia firmada descendente, nombre e identificador para resolver empates de forma estable. Las semanas anteriores parten de fechas civiles y conservan rangos `[startInclusive, endExclusive)` sin restar duraciones a medianoche.

## Repositorio y casos de uso

`AnalyticsRepository` ofrece una única lectura normalizada por propietario. `GetAnalyticsSummary` coordina reloj, rangos, lectura y calculador. No existen casos de uso que solo reenvíen llamadas.

## Personalized Insights Engine

`StudyInsightEngine` transforma `StudyAnalyticsSummary`, `StudyTrendSummary`, `InsightDashboardSummary` e `InsightProfileProjection` en una `InsightCollection`. Es un servicio puro: no usa Flutter, Riverpod, repositorios, Isar, Firebase, reloj, red, IA, aprendizaje ni aleatoriedad. Los resultados no contienen fechas y nunca se persisten.

Las categorías disponibles son progress, consistency, focus, interruption, course, motivation y general. Las prioridades critical, high, medium y low ordenan la presentación y no representan gravedad clínica. Las acciones son continueFocus, startFocus, openAnalytics, openCourses, reviewProgress y none.

Las únicas reglas actuales son: ausencia de actividad hoy, varias interrupciones hoy, aumento o disminución semanal comparable, cambio de curso dominante, al menos cinco días activos y ausencia de cursos. El lenguaje es neutral. Las candidatas se ordenan por prioridad, se deduplican por identidad y categoría, y se limitan a tres resultados.

## Estado, API pública y navegación

`AnalyticsNotifier` modela carga, datos, error y refresh conservando el último resumen válido. `analytics_public_providers.dart` expone proyecciones read-only de resumen, tendencia e insights sin Notifier ni operaciones de escritura. `/analytics` muestra cards de hoy, semana, mes, comparaciones, hasta tres insights y cursos sin gráficos.

Para Companion, `companionAnalyticsProvider` expone exclusivamente `focusMinutesToday`, `completedSessionsToday`, `interruptionCountToday`, `activeDaysThisWeek` y `weeklyTrend`. `activeDaysThisWeek` reutiliza el valor semanal ya calculado; no introduce métricas, lecturas ni cálculos nuevos y no expone el resumen interno.

Para Goals, `focusGoalsAnalyticsProvider` expone exclusivamente `focusMinutesToday`, `completedSessionsThisWeek` y `activeDaysThisWeek`. La proyección reutiliza el resumen diario y semanal ya calculado; no añade definiciones, agregaciones, persistencia ni operaciones de escritura.

La estrategia carga al montar el consumidor, permite invalidación explícita desde Dashboard y escucha una revisión pública de Study Engine. La revisión cambia únicamente ante sesiones persistentes o conteos de interrupciones relevantes; excluye el tiempo restante, por lo que los ticks normales no consultan Analytics. Las señales simultáneas se agrupan en una sola recarga pendiente.

## Dashboard, privacidad y limitaciones

Dashboard consume la API pública y no calcula métricas. Solo se procesan datos locales del propietario autenticado; no hay comparación entre usuarios ni envío remoto.

El lector público actual solicita un máximo alto al contrato histórico existente porque Study Engine todavía no ofrece paginación temporal. La lectura paginada o por rango sigue pendiente antes de volúmenes extensos.

## Fuera de alcance

Gráficos interactivos, IA, predicciones, recomendaciones automáticas, rankings entre usuarios, gamificación, logros, sincronización, exportación, filtros, notificaciones y persistencia analítica.

## Pruebas

Las pruebas usan reloj y fuentes fake, sin Firebase, Isar, red ni paquetes de mocking. Cubren límites temporales, estados, aislamiento, sesiones libres, cursos ausentes, interrupciones, promedios y desempates.

## AI CONTEXT

Analytics implementa RF-009 hasta Sprint 5D y es estrictamente read-only. Una IA debe mantener agregaciones, tendencias e insights en servicios puros, consumir contratos públicos, aislar por `ownerId` y no añadir persistencia, gráficos, predicciones, IA o gamificación sin autorización.

## Historial de cambios

| Versión | Fecha | Estado | Descripción | Autor |
| --- | --- | --- | --- | --- |
| 0.1.0 | 12 de julio de 2026 | Implementado | Analytics Foundation read-only. | Equipo Focusly |
| 0.1.1 | 12 de julio de 2026 | Implementado | Proyección diaria read-only para Dashboard Intelligence. | Equipo Focusly |
| 0.2.0 | 12 de julio de 2026 | Implementado | Comparaciones locales de Trends & Progress. | Equipo Focusly |
| 0.3.0 | 12 de julio de 2026 | Implementado | Personalized Insights Engine determinista. | Equipo Focusly |
| 0.3.1 | 20 de julio de 2026 | Implementado | Proyección pública mínima para progreso de FocusGoal. | Equipo Focusly |
