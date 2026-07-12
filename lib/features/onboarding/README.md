# Onboarding

| Campo | Valor |
| --- | --- |
| Feature | Onboarding |
| Requisito | RF-002 |
| Sprint | 2A |
| Estado | Implementado con persistencia temporal |

## Propósito

Recopilar el contexto académico mínimo, una preferencia inicial y la identidad provisional del compañero de estudio para un usuario autenticado y verificado.

## Alcance Sprint 2A

- perfil académico inicial;
- objetivo principal;
- duración preferida de enfoque;
- compañero virtual de especie gato;
- flujo multipaso con revisión y corrección;
- guard central de onboarding;
- almacenamiento en memoria por usuario.

## Fuera de alcance

Dashboard, Isar, Firestore, sincronización, horarios, VAK, diagnóstico, Pomodoro, IA, flashcards, Analytics, notificaciones, OCR, calendario, evolución y accesorios.

## Estructura

- `domain/`: entidades, contrato y validaciones puras.
- `data/`: repositorio temporal en memoria.
- `presentation/`: estado, Notifier y páginas.
- `onboarding_providers.dart`: composición reemplazable y reloj inyectable.

## Entidades y contrato

- `StudentProfile`: universidad, carrera, ciclo, objetivo y preferencia; no almacena correo.
- `StudyCompanion`: gato con nombre y apariencia provisional estable.
- `OnboardingRepository`: consulta, recuperación, guardado atómico y limpieza por usuario.

## Flujo

```text
Bienvenida
→ Perfil académico
→ Objetivo
→ Preferencias
→ Compañero
→ Resumen
→ /home-placeholder
```

Los datos parciales permanecen en `OnboardingState` mientras la aplicación sigue abierta. Se puede avanzar, retroceder y corregir antes de guardar.

## Validaciones

Universidad y carrera obligatorias; ciclo entre 1 y 12; objetivo y apariencia obligatorios; enfoque limitado a 15, 25, 40 o 50 minutos; nombre normalizado, seguro y de hasta 24 caracteres.

## Navegación e integración

Onboarding consume únicamente `publicAuthSessionProvider`, la API pública de solo lectura que expone `AuthSession`. No importa Presentation o Data de Authentication ni puede ejecutar login, registro o logout. Un usuario sin sesión va a login; no verificado a verificación; verificado sin onboarding a `/onboarding`; completado a `/home-placeholder`.

## Repositorio temporal

`InMemoryOnboardingRepository` separa datos por `userId` y guarda perfil/compañero como una unidad coherente. No persiste al reiniciar la aplicación y será sustituido por una implementación Isar en Sprint 2B.

## Seguridad y privacidad

No se almacenan correo, contraseña, diagnósticos, VAK ni datos médicos. Un usuario solo consulta registros mediante su propio `userId`.

## Pruebas

Las pruebas cubren entidades, validaciones, aislamiento, atomicidad, Notifier, flujo, guard y widgets mediante fakes y overrides, sin Firebase real ni red.

## Validación manual

Completar el flujo con un usuario verificado, retroceder y corregir, finalizar, comprobar el placeholder y verificar que un reinicio completo pierde los datos hasta Sprint 2B.

## AI CONTEXT

Esta feature implementa únicamente RF-002 Sprint 2A. Una IA no puede añadir persistencia, Dashboard, diagnóstico, Pomodoro o datos académicos. Debe preservar el aislamiento por usuario y el guard central.

## Historial de cambios

| Versión | Fecha | Estado | Descripción | Autor |
| --- | --- | --- | --- | --- |
| 0.1.0 | 12 de julio de 2026 | Implementado | Flujo inicial y repositorio temporal Sprint 2A. | Equipo Focusly |
