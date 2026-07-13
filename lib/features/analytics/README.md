# Analytics

| Campo | Valor |
| --- | --- |
| Feature | Analytics |
| Requisito | RF-009 |
| Sprint | 5A |
| Estado | Analytics Foundation implementada |

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

## Repositorio y casos de uso

`AnalyticsRepository` ofrece una única lectura normalizada por propietario. `GetAnalyticsSummary` coordina reloj, rangos, lectura y calculador. No existen casos de uso que solo reenvíen llamadas.

## Estado, API pública y navegación

`AnalyticsNotifier` modela carga, datos, error y refresh conservando el último resumen válido. `analytics_public_providers.dart` expone a Dashboard únicamente la proyección de hoy, sin Notifier ni operaciones. `/analytics` muestra cards de hoy, semana, mes y cursos sin gráficos.

La estrategia carga al montar el consumidor, permite actualización explícita y escucha una revisión pública de Study Engine. La revisión cambia únicamente ante sesiones persistentes o conteos de interrupciones relevantes; excluye el tiempo restante, por lo que los ticks normales no consultan Analytics. Las señales simultáneas se agrupan en una sola recarga pendiente.

## Dashboard, privacidad y limitaciones

Dashboard consume la API pública y no calcula métricas. Solo se procesan datos locales del propietario autenticado; no hay comparación entre usuarios ni envío remoto.

El lector público actual solicita un máximo alto al contrato histórico existente porque Study Engine todavía no ofrece paginación temporal. Sprint 5B deberá incorporar lectura paginada o por rango antes de volúmenes extensos.

## Fuera de alcance

Gráficos, IA, predicciones, recomendaciones, rankings entre usuarios, gamificación, rachas nuevas, sincronización, exportación, filtros, notificaciones y persistencia analítica.

## Pruebas

Las pruebas usan reloj y fuentes fake, sin Firebase, Isar, red ni paquetes de mocking. Cubren límites temporales, estados, aislamiento, sesiones libres, cursos ausentes, interrupciones, promedios y desempates.

## AI CONTEXT

Analytics implementa RF-009 Sprint 5A y es estrictamente read-only. Una IA debe mantener las agregaciones en `AnalyticsCalculator`, consumir contratos públicos, aislar por `ownerId` y no añadir persistencia, gráficos, IA o gamificación sin autorización.

## Historial de cambios

| Versión | Fecha | Estado | Descripción | Autor |
| --- | --- | --- | --- | --- |
| 0.1.0 | 12 de julio de 2026 | Implementado | Analytics Foundation read-only. | Equipo Focusly |
