# Authentication

| Campo | Valor |
| --- | --- |
| Feature | Authentication |
| Requisito | RF-001 |
| Sprint | 1A |
| Estado | En desarrollo |

## Propósito

Proporcionar los contratos y flujos públicos iniciales de acceso, registro, recuperación y cierre de sesión sin integrar todavía un proveedor de identidad de producción.

## Alcance de Sprint 1A

- entidad de usuario y contrato de repositorio independientes de frameworks;
- validación de correo, contraseña, confirmación y campos obligatorios;
- estados explícitos y orquestación con Riverpod;
- rutas públicas `/login`, `/register` y `/forgot-password`;
- páginas Material 3 responsive y accesibles;
- repositorio determinista en memoria para desarrollo y pruebas;
- errores funcionales seguros y confirmación de recuperación no reveladora.

## Fuera de alcance

Firebase, persistencia de sesión, autenticación social o biométrica, eliminación real de cuenta, onboarding, rutas protegidas, perfiles, backend, analytics y deep links de recuperación.

## Estructura

```text
authentication/
├── authentication_providers.dart  # Composición temporal de la feature.
├── presentation/  # Páginas, widgets, estado, Notifier y providers.
├── domain/        # Entidad, errores, contrato y validaciones.
├── data/          # Adaptador temporal en memoria.
└── README.md
```

No se añadieron Use Cases en Sprint 1A: las operaciones solo reenviarían el contrato sin aportar política, coordinación reutilizable o aislamiento adicional. La validación permanece en `AuthValidator` y la orquestación de presentación en `AuthNotifier`.

### Composición de providers

- `authentication_providers.dart` es el composition root de la feature: conecta `AuthRepository` con el adaptador temporal en memoria y expone el stream de sesión.
- `presentation/providers/auth_providers.dart` compone únicamente validación y estado de presentación: declara `AuthValidator` y `AuthNotifier`, y reexporta el contrato de composición para facilitar overrides en pruebas.

No debe crearse un provider adicional para el mismo propósito. La sustitución futura del adaptador se realizará en `authentication_providers.dart` sin cambiar Presentation.

## Contratos públicos

- `AuthUser`: identidad mínima e inmutable.
- `AuthRepository`: sesión actual, stream de sesión, login, registro, recuperación y cierre.
- `AuthValidator`: reglas funcionales de entrada.
- `AuthState`: estados observables de la operación.
- `authRepositoryProvider`: punto reemplazable de composición.
- `authNotifierProvider`: orquestación de presentación.

## Flujo de estado

```text
Initial → Loading → Authenticated
                  → PasswordResetSent
                  → Unauthenticated
                  → Error seguro
```

Mientras existe `Loading`, se ignoran envíos adicionales. Una nueva operación reemplaza cualquier error anterior por el estado de carga.

## Navegación

GoRouter controla las tres rutas públicas. No existen guards, redirects de onboarding, dashboard ni rutas protegidas en esta fase.

## Repositorio temporal

`InMemoryAuthRepository` no es una implementación de producción, no representa seguridad real y no persiste la sesión al cerrar la aplicación. Conserva únicamente fingerprints no seguros para simular credenciales y nunca almacena contraseñas en texto plano. Será sustituido por `FirebaseAuthRepository` en Sprint 1B.

## Estrategia de pruebas

- unit tests para validaciones y entidad;
- tests del contrato temporal, stream y mensajes seguros;
- tests del Notifier, concurrencia y transiciones;
- widget tests para formularios, carga y navegación;
- tests del router para rutas públicas y fallback.

Las pruebas no dependen de red, archivos, almacenamiento, Firebase ni temporizadores reales.

## Reglas de seguridad

- no revelar si una cuenta existe durante recuperación;
- no mostrar errores técnicos;
- no conservar contraseñas en texto plano;
- no registrar credenciales o datos personales;
- mantener el proveedor real detrás de `AuthRepository`;
- no tratar el adaptador en memoria como mecanismo seguro.

## Dependencias permitidas

Flutter, Dart, Riverpod y GoRouter ya aprobados por la arquitectura. La feature no añade paquetes.

## AI CONTEXT

Esta feature implementa únicamente RF-001 en alcance Sprint 1A. Una IA puede ampliar pruebas o corregir el comportamiento aprobado, pero no puede integrar Firebase, añadir rutas protegidas, crear perfiles ni cambiar contratos o arquitectura sin autorización. Antes de modificarla debe leer los documentos maestros y este README.

## Historial de cambios

| Versión | Fecha | Estado | Descripción | Autor |
| --- | --- | --- | --- | --- |
| 0.1.0 | 11 de julio de 2026 | En desarrollo | Implementación inicial del vertical slice Authentication Sprint 1A. | Equipo Focusly |
