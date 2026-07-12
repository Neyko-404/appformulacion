# Academic Tracker

| Campo | Valor |
| --- | --- |
| Feature | Academic Tracker |
| Requisito | RF-004 |
| Sprint | 3B |
| Estado | Cursos implementados localmente |

## Propósito y alcance

Gestionar el primer subdominio académico real: crear, listar, editar, archivar, restaurar y eliminar cursos con persistencia local y aislamiento por usuario.

## Fuera de alcance

Horarios, aulas, docentes, notas, evaluaciones, tareas, calendario, OCR, sincronización, estadísticas, Pomodoro, IA y flashcards.

## Course e invariantes

`Course` conserva identidad de dominio, propietario, nombre normalizado, código opcional normalizado, créditos opcionales, identidad visual estable, estado y fechas. El nombre tiene entre 2 y 80 caracteres; el código hasta 20; los créditos entre 0 y 30. `createdAt` se conserva y `updatedAt` cambia al editar.

`CourseVisualIdentity` ofrece ocean, forest, sunset, violet, amber y rose sin depender de Flutter. `CourseStatus` distingue active y archived.

## Contrato y persistencia

`CourseRepository` define observación, consultas y operaciones de escritura siempre limitadas por `ownerId`. Producción compone `IsarCourseRepository` sobre `CourseLocalDataSource`; las pruebas pueden usar `InMemoryCourseRepository`.

`CourseLocalModel` almacena enums como nombres estables y mantiene `courseId` separado del Id interno. `CourseMapper` rechaza valores desconocidos. El schema se registra desde bootstrap. Las escrituras Isar usan transacciones y no descargan binarios durante tests ordinarios.

## API pública y navegación

`activeCoursesProvider` expone únicamente cursos activos, cantidad, carga y error seguro. Dashboard lo consume sin importar Data o Presentation. Las rutas `/courses`, `/courses/new` y `/courses/:courseId/edit` requieren sesión, verificación y onboarding completo.

## Archivado y eliminación

Archivar es la acción primaria y conserva los datos. Restaurar y eliminar definitivamente se ofrecen desde archivados; la eliminación exige confirmación y no ejecuta cascadas.

## Dashboard

Dashboard presenta hasta tres cursos activos y la cantidad total. Academic Tracker conserva la propiedad de Course y de sus operaciones.

## Pruebas, privacidad y migraciones

Las pruebas usan fakes herméticos sin Firebase, red o disco. La persistencia nativa y reapertura se validan manualmente o en CI preparado. Los cursos se separan por `ownerId`; no almacenan correo ni secretos. Los cambios futuros de schema deben ser aditivos o incluir una migración probada antes de release.

## UX Guidelines

Las pantallas de cursos usan AppBar y navegación secundaria con GoRouter. Los formularios siempre ofrecen guardar o cancelar, los estados vacíos orientan la siguiente acción y las cantidades visibles respetan singular y plural. Las acciones destructivas requieren confirmación explícita.

## AI CONTEXT

Esta feature implementa únicamente cursos de RF-004 Sprint 3B. Una IA no puede añadir horarios, notas, tareas, OCR, sincronización o cascadas sin autorización. Debe preservar aislamiento, contratos públicos y modelos Isar dentro de Data.

## Historial de cambios

| Versión | Fecha | Estado | Descripción | Autor |
| --- | --- | --- | --- | --- |
| 0.1.0 | 12 de julio de 2026 | Implementado | Vertical slice local de cursos Sprint 3B. | Equipo Focusly |
