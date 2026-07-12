# Onboarding

| Campo | Valor |
| --- | --- |
| Feature | Onboarding |
| Requisito | RF-002 |
| Sprint | 2B |
| Estado | Implementado con persistencia local |

## Propósito

Recopilar el contexto académico mínimo, una preferencia inicial y la identidad provisional del compañero de estudio para un usuario autenticado y verificado.

## Alcance Sprint 2B

- perfil académico inicial;
- objetivo principal;
- duración preferida de enfoque;
- compañero virtual de especie gato;
- flujo multipaso con revisión y corrección;
- guard central de onboarding;
- persistencia local por usuario que sobrevive al reinicio.

## Fuera de alcance

Dashboard, Firestore, sincronización remota, horarios, VAK, diagnóstico, Pomodoro, IA, flashcards, Analytics, notificaciones, OCR, calendario, evolución y accesorios.

## Estructura

- `domain/`: entidades, contrato y validaciones puras.
- `data/models/`: colecciones locales propias de Isar.
- `data/mappers/`: conversión explícita entre persistencia y Domain.
- `data/data_sources/`: consultas y transacciones locales.
- `data/repositories/`: repositorio productivo y fake de pruebas.
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

## Persistencia local y composición

La implementación productiva utiliza Isar Community `3.3.2`, elegida porque su conjunto estable de runtime, binarios y generación es compatible con el toolchain actual. `StudentProfileLocalModel` y `StudyCompanionLocalModel` permanecen en Data y conservan la identidad de dominio separada del identificador interno.

`OnboardingLocalDataSource` encapsula consultas y una única transacción para perfil y compañero. `IsarOnboardingRepository` aplica mappers, normaliza fallos y considera completo el onboarding solo cuando ambos registros son válidos y pertenecen al mismo `userId`. Un fallo de lectura o dato corrupto produce un error recuperable independiente del flujo de onboarding. La base se abre una vez durante bootstrap y se inyecta mediante Riverpod.

`InMemoryOnboardingRepository` queda exclusivamente para pruebas y overrides explícitos. No se elimina información local al cerrar sesión; cada usuario consulta solamente sus propios registros.

## Esquema y migraciones

La política inicial corresponde al esquema local versión 1. Los cambios futuros deben ser preferentemente aditivos, conservar las identidades de dominio y probarse antes de release. No se eliminarán ni renombrarán campos sin una estrategia explícita de conservación o un descarte documentado y autorizado. Isar compara schemas al abrir; cualquier migración que pueda perder datos exige revisión humana.

Los enums se almacenan mediante nombres textuales estables. Valores desconocidos o datos parciales se tratan como onboarding incompleto y no se convierten silenciosamente.

## Comportamiento tras reinicio

Después de completar el flujo, los datos sobreviven al cierre y reapertura. El router consulta el repositorio mediante el Notifier y dirige al usuario verificado con datos completos a `/home-placeholder`. Un fallo dirige a `/onboarding-error`, donde puede reintentarse sin asumir que el usuario carece de datos. El router no lee Isar directamente.

## Seguridad y privacidad

No se almacenan correo, contraseña, diagnósticos, VAK ni datos médicos. Un usuario solo consulta registros mediante su propio `userId`.

## Pruebas

Las pruebas unitarias ordinarias cubren entidades, mappers, integridad, repositorio, fallos, Notifier, guard y widgets mediante fakes herméticos de `OnboardingLocalDataSource`; no descargan Isar Core ni usan red o disco real. La transacción del data source se valida manualmente o en CI preparado ejecutando la aplicación con los binarios aportados por `isar_community_flutter_libs`, incluyendo escritura conjunta, aislamiento, cierre y reapertura. Esta validación nativa queda separada de `flutter test` para mantener la suite reproducible sin red.

## Validación manual

Completar el flujo con un usuario verificado, cerrar y reabrir la aplicación, comprobar el placeholder y verificar aislamiento al alternar entre dos usuarios de prueba. Durante esta validación debe confirmarse también que una interrupción de almacenamiento no deja solo uno de los dos registros.

## AI CONTEXT

Esta feature implementa RF-002 Sprint 2B con Isar Community `3.3.2`. Una IA no puede añadir Dashboard, sincronización remota, diagnóstico, Pomodoro o datos académicos. Debe preservar modelos Isar dentro de Data, transacciones atómicas, aislamiento por usuario y el guard central.

## Historial de cambios

| Versión | Fecha | Estado | Descripción | Autor |
| --- | --- | --- | --- | --- |
| 0.1.0 | 12 de julio de 2026 | Implementado | Flujo inicial y repositorio temporal Sprint 2A. | Equipo Focusly |
| 0.2.0 | 12 de julio de 2026 | Implementado | Persistencia local definitiva con Isar Community 3.3.2 para Sprint 2B. | Equipo Focusly |
