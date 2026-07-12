# Dashboard

| Campo | Valor |
| --- | --- |
| Feature | Dashboard |
| Sprint | 3A |
| Estado | Foundation en desarrollo |

## Objetivo

Ofrecer una base responsive para presentar el contexto inicial del estudiante después de Authentication y Onboarding.

## Alcance

Incluye saludo derivado de la sesión, compañero, objetivo de enfoque, racha provisional, estado vacío de cursos y acceso informativo a una futura sesión.

## Fuera de alcance

CRUD de cursos, Pomodoro, flashcards, IA, Analytics, calendario, estadísticas reales, sincronización, notificaciones y backend.

## Estructura y widgets

- `DashboardPage`: composición responsive y estados de carga o error.
- `StudyCompanionCard`: nombre y mensaje del compañero.
- `FocusGoalCard`: objetivo y duración preferida.
- `FocusStreakCard`: placeholder fijo de cero días, reemplazable por datos reales.
- `CoursesCard`: estado vacío; su acción permanece deshabilitada.

## Estado y providers

`DashboardState` contiene únicamente `StudentProfile`, `StudyCompanion`, carga y error seguro. `DashboardNotifier` consulta ambos elementos mediante `OnboardingRepository`. `dashboardOnboardingRepositoryProvider` adapta la composición pública existente sin crear otro repositorio.

La tarjeta de cursos consume `activeCoursesProvider`, muestra hasta tres cursos activos, la cantidad total o el estado vacío, y navega hacia Academic Tracker. Dashboard no es propietario de `Course` ni importa Data o Presentation de esa feature.

El botón de enfoque consume `activeStudySummaryProvider`, navega a `/focus` y cambia a “Continuar sesión” cuando existe una sesión activa. Dashboard no controla el ticker ni el temporizador.

## Integración

Authentication aporta `AuthSession` mediante `publicAuthSessionProvider`. Onboarding conserva la propiedad del perfil, compañero y persistencia. Dashboard no importa Data, Firebase ni Isar y no navega desde su Notifier. GoRouter expone `/dashboard` después de sesión verificada y onboarding completo.

## Pruebas

Las pruebas usan sesión y repositorio en memoria mediante overrides. No usan Firebase, red ni disco.

## AI CONTEXT

Esta feature implementa solo Dashboard Foundation Sprint 3A. Una IA no puede añadir repositorios, progreso real, cursos, Pomodoro, IA, Analytics o sincronización sin autorización. Debe reutilizar los contratos públicos de Authentication y Onboarding.

## Historial de cambios

| Versión | Fecha | Estado | Descripción | Autor |
| --- | --- | --- | --- | --- |
| 0.1.0 | 12 de julio de 2026 | En desarrollo | Base responsive del Dashboard Sprint 3A. | Equipo Focusly |
