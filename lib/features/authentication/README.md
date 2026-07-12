# Authentication

| Campo | Valor |
| --- | --- |
| Feature | Authentication |
| Requisito | RF-001 |
| Sprint | 1B |
| Estado | Implementado; validación manual pendiente |

## Propósito

Gestionar creación de cuenta, sesión persistente, recuperación, verificación de correo y cierre de sesión mediante contratos de dominio independientes del proveedor.

## Alcance Sprint 1B

- Firebase Authentication como implementación productiva;
- observación reactiva de sesión;
- registro e inicio con correo y contraseña;
- recuperación con confirmación no reveladora;
- envío y reenvío de verificación;
- recarga de sesión para confirmar verificación;
- cierre de sesión;
- guard central para rutas públicas, verificación y estado autenticado provisional.

## Fuera de alcance

Onboarding, perfiles, Dashboard, roles, eliminación definitiva de cuenta, proveedores sociales, biometría, teléfono, Firestore, Storage, Analytics, Isar, backend y datos académicos.

## Estructura y responsabilidades

- `domain/`: `AuthUser`, `AuthSession`, fallos, contrato y validaciones; no importa Firebase.
- `data/services/`: acceso estrecho al SDK mediante `FirebaseAuthService`.
- `data/repositories/`: adaptación Firebase–Domain y fake determinista en memoria.
- `presentation/`: estado, Notifier, formularios y páginas de sesión.
- `authentication_providers.dart`: composición productiva de SDK, servicio y repositorio.
- `auth_session_provider.dart`: API pública de sesión observable y de solo lectura para otras features.
- `presentation/providers/auth_providers.dart`: validación y estado de presentación.

## Contratos públicos

- `AuthSession`: usuario opcional y verificación en una única ubicación.
- `AuthRepository`: sesión actual/stream, login, registro, recuperación, verificación, recarga y logout.
- `publicAuthSessionProvider`: expone únicamente `AuthSession` observable. No permite ejecutar operaciones de autenticación ni filtra `AuthState` o `AuthNotifier`.

`AuthState`, `authRepositoryProvider` y `authNotifierProvider` son detalles de composición interna y de Presentation. Otras features deben consumir únicamente `publicAuthSessionProvider`.

`AuthUser` conserva únicamente `id` y `email`. `emailVerified` pertenece a `AuthSession` para no duplicar estado mutable del proveedor.

## Flujo de sesión

```text
Firebase authStateChanges
→ FirebaseAuthService
→ FirebaseAuthRepository
→ AuthSession
→ AuthNotifier
→ GoRouter refresh
```

La sesión global no se reemplaza por estados temporales de formulario. Carga, éxito y error se representan como operación y feedback sobre la sesión conocida.

## Verificación de correo

Después del registro se solicita verificación y la sesión permanece autenticada con `emailVerified: false`. `/verify-email` permite reenviar, recargar con “Ya verifiqué” y cerrar sesión. No se promete entrega inmediata ni se usan temporizadores complejos.

## Navegación y auth guard

- `/auth-loading`: resolución inicial de sesión.
- `/login`, `/register`, `/forgot-password`: públicas solo sin autenticación.
- `/verify-email`: destino obligatorio para sesión no verificada.
- `/authenticated`: placeholder temporal para sesión verificada; no es Dashboard.

Los redirects están centralizados en GoRouter y reaccionan al estado de dominio, nunca a llamadas directas del SDK.

## Errores

La capa Data traduce códigos externos a fallos funcionales: credenciales, correo, duplicidad, contraseña débil, intentos, red, usuario deshabilitado, operación no permitida e inesperado. Los detalles técnicos se registran mediante `AppLogger` y no llegan a Presentation.

La recuperación ignora de forma segura el caso de cuenta inexistente para no revelar registros.

## Seguridad

- contraseñas y tokens no se almacenan manualmente;
- los tipos Firebase permanecen en Data;
- Presentation depende solo de contratos y estado propios;
- mensajes y logs no incluyen credenciales;
- `InMemoryAuthRepository` es solo un fake, usa fingerprints no seguros y no persiste datos.

## Dependencias

Flutter, Dart, Riverpod, GoRouter, Firebase Core y Firebase Authentication. No se añadieron servicios Firebase adicionales.

## Estrategia de pruebas

Las pruebas usan fakes manuales, `InMemoryAuthRepository` y overrides de Riverpod. Cubren sesión, mapeo, errores, repositorio, Notifier, guards y widgets sin conexión, correos reales ni proyecto Firebase.

## Validación manual pendiente

1. Crear una cuenta real de prueba.
2. Confirmar el usuario en Firebase Console.
3. Verificar la pantalla y recepción del correo.
4. Confirmar el correo y pulsar “Ya verifiqué”.
5. Confirmar `/authenticated`, logout, nuevo login y recuperación.

## Pendientes

Onboarding deberá sustituir `/authenticated` en un sprint autorizado. La eliminación definitiva de cuenta y proveedores adicionales permanecen fuera de alcance.

## AI CONTEXT

Esta feature implementa RF-001 con Firebase Authentication. Una IA no puede añadir onboarding, perfiles, otros proveedores o servicios Firebase sin autorización. Debe preservar `AuthSession`, los límites Domain/Data/Presentation y los mensajes no reveladores.

## Historial de cambios

| Versión | Fecha | Estado | Descripción | Autor |
| --- | --- | --- | --- | --- |
| 0.1.0 | 11 de julio de 2026 | Reemplazado | Adaptador temporal Sprint 1A. | Equipo Focusly |
| 0.2.0 | 12 de julio de 2026 | Implementado | Firebase Authentication, sesión, verificación y guard central Sprint 1B. | Equipo Focusly |
