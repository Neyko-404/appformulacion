# Goals

| Campo | Valor |
| --- | --- |
| Feature | Goals |
| Sprint | 8A — Study Goals & Healthy Habits |
| Versión | 1.0.0 |
| Estado | Implementado |
| Última actualización | 20 de julio de 2026 |
| Responsable técnico | Equipo Focusly |

## 1. Propósito

Goals permite definir metas de estudio cuantitativas, opcionales y flexibles. Las metas orientan el trabajo académico; no bloquean funciones, califican al estudiante ni aplican castigos.

## 2. Alcance de Sprint 8A

El alcance incluye una meta diaria de minutos, una meta semanal de sesiones completadas y una meta semanal de días activos. Cada meta puede activarse, editarse o desactivarse mediante un guardado explícito. La ruta `/goals` ofrece configuración y consulta, y Dashboard presenta un resumen read-only.

## 3. Filosofía saludable

No existen fracaso diario, rachas obligatorias, puntos, monedas, rankings ni comparación entre usuarios. Completar o superar una meta limita el indicador visual a su máximo y utiliza copy neutral. El estudiante puede ajustar sus metas cuando quiera.

## 4. Modelo de dominio

`FocusGoal` es el único concepto oficial para metas medibles. Conserva `ownerId`, fechas y tres targets opcionales. Un target nulo representa una meta desactivada. La entidad valida identidad, orden temporal y límites, y expone operaciones puras para actualizar o desactivar cada dimensión.

No existe una entidad sinónima denominada `StudyGoals`.

## 5. Progreso derivado

`FocusGoalProgress` representa el resultado de una dimensión habilitada: target, valor actual, restante, ratio acotado y estado de finalización. `FocusGoalsProgress` agrupa las tres dimensiones. Son valores derivados y nunca se persisten.

`FocusGoalsProgressCalculator` recibe un `FocusGoal` y `FocusGoalsAnalyticsProjection`. El cálculo es puro, determinista y no utiliza reloj, Riverpod, Flutter, Isar ni repositorios.

## 6. Analytics como fuente

Analytics expone de forma read-only los minutos estudiados hoy, las sesiones completadas esta semana y los días activos de la semana. Goals no accede a Data o Presentation de Analytics y no replica agregaciones.

## 7. Persistencia

`FocusGoalLocalModel` almacena únicamente la configuración y sus fechas. `ownerId` tiene índice único con reemplazo y el repositorio actualiza atómicamente el registro existente. El identificador interno de Isar no forma parte de la identidad de dominio. El progreso y las métricas analíticas no se guardan.

## 8. Repositorio y casos de uso

`FocusGoalRepository` declara lectura por propietario y guardado. La implementación productiva usa Isar Community; `InMemoryFocusGoalRepository` permite pruebas aisladas. `GetFocusGoal`, `SaveFocusGoal` y `GetFocusGoalsProgress` coordinan únicamente operaciones con valor propio.

Los fallos `invalidData`, `storage`, `corruptedData` y `unexpected` se convierten en mensajes seguros sin exponer detalles internos.

## 9. Estado y API pública

`FocusGoalsNotifier` reacciona a la sesión y a la proyección analítica, descarta resultados de otro usuario, serializa guardados y conserva datos válidos durante la escritura. Las sugerencias 25 minutos, 3 sesiones y 3 días se muestran sin persistirse automáticamente.

`goals_public_providers.dart` expone a Dashboard solo carga, error seguro, resumen de progreso y refresh. No expone Isar, repositorios ni operaciones de escritura.

## 10. Pantalla y Dashboard

`FocusGoalsPage` permite activar, desactivar, validar y guardar las tres metas. Los límites son 5–480 minutos diarios, 1–35 sesiones semanales y 1–7 días activos. Dashboard muestra solo metas activas, ratios ya calculados y acceso a configuración; conserva el objetivo cualitativo del perfil como contexto secundario.

## 11. Accesibilidad y responsive

La pantalla usa controles con etiquetas, teclado numérico, validaciones visibles, regiones semánticas para mensajes y un indicador de progreso que comunica su valor sin depender únicamente del color. El contenido tiene scroll, ancho máximo y soporte para tema claro, oscuro y texto ampliado.

## 12. Privacidad

La configuración se almacena localmente y se aísla por `ownerId`. No existe sincronización remota, comparación entre estudiantes ni envío de metas a Firebase.

## 13. Fuera de alcance

Hábitos avanzados, planner, notificaciones, metas por curso, recompensas, logros, monedas, rankings, predicciones, IA, calendario, tareas y sincronización remota permanecen fuera del Sprint 8A.

## 14. AI CONTEXT

Goals debe conservar `FocusGoal` como único concepto de dominio para metas medibles. Una IA no debe crear sinónimos, persistir progreso, recalcular Analytics, añadir gamificación, usar fuentes remotas ni modificar documentos maestros sin autorización explícita.

## 15. Historial de cambios

| Versión | Fecha | Estado | Descripción | Autor |
| --- | --- | --- | --- | --- |
| 1.0.0 | 20 de julio de 2026 | Implementado | Sprint 8A con FocusGoal, progreso derivado, persistencia local, página y Dashboard. | Equipo Focusly |
