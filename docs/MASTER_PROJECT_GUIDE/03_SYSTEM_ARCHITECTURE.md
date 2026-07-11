# Arquitectura del sistema Focusly

| Campo | Valor |
| --- | --- |
| Documento | `03_SYSTEM_ARCHITECTURE.md` |
| Proyecto | Focusly |
| Versión | 1.0.0 |
| Estado | Approved |
| Última actualización | 11 de julio de 2026 |
| Autor | Equipo Focusly |
| Responsable técnico | Gary Nivin Quispe |

## Índice

1. [Objetivo](#1-objetivo)
2. [Principios arquitectónicos](#2-principios-arquitectónicos)
3. [Arquitectura general](#3-arquitectura-general)
4. [Estructura oficial del repositorio](#4-estructura-oficial-del-repositorio)
5. [Arquitectura Flutter](#5-arquitectura-flutter)
6. [Organización de features](#6-organización-de-features)
7. [Gestión del estado](#7-gestión-del-estado)
8. [Navegación](#8-navegación)
9. [Persistencia](#9-persistencia)
10. [Comunicación con backend](#10-comunicación-con-backend)
11. [Backend](#11-backend)
12. [Integración IA](#12-integración-ia)
13. [Offline First](#13-offline-first)
14. [Seguridad](#14-seguridad)
15. [Logging](#15-logging)
16. [Manejo de errores](#16-manejo-de-errores)
17. [Comunicación entre features](#17-comunicación-entre-features)
18. [Dependency Rules](#18-dependency-rules)
19. [Bootstrap](#19-bootstrap)
20. [Architecture Fitness Rules](#20-architecture-fitness-rules)
21. [Definition of Done arquitectónica](#21-definition-of-done-arquitectónica)
22. [Referencias](#22-referencias)
23. [AI CONTEXT](#23-ai-context)
24. [Historial de cambios](#24-historial-de-cambios)

## 1. Objetivo

Definir la arquitectura oficial de Focusly, sus límites, responsabilidades, dependencias y reglas de evolución. Este documento es la fuente técnica principal para organizar el repositorio, implementar módulos, integrar capacidades externas y evaluar conformidad arquitectónica.

Las decisiones aquí registradas son obligatorias. Un cambio que las afecte requiere revisión arquitectónica, justificación explícita, actualización de versión y aprobación antes de modificar código.

## 2. Principios arquitectónicos

### 2.1. Modularidad

El sistema se divide por capacidades de negocio autocontenidas. Cada módulo expone contratos mínimos y oculta sus detalles. La modularidad debe permitir desarrollar, validar y evolucionar una feature sin conocer la implementación interna de las demás.

### 2.2. Mantenibilidad

El código debe revelar intención, mantener responsabilidades acotadas y hacer explícitas sus dependencias. Las reglas compartidas tendrán una única fuente; la duplicación deliberada requiere justificar por qué evita un acoplamiento mayor.

### 2.3. Escalabilidad

El crecimiento se realizará incorporando features o ampliando contratos estables, no acumulando lógica en archivos globales. Los límites deben soportar más datos, casos de uso y colaboradores sin convertir módulos centrales en dependencias universales.

### 2.4. Simplicidad

Se implementará la menor abstracción que preserve los límites aprobados. No se crearán capas, interfaces o servicios sin una responsabilidad actual y verificable. Clean Architecture se aplica de forma simplificada, no ceremonial.

### 2.5. Desacoplamiento

Las políticas de negocio no dependen de detalles de interfaz, almacenamiento, red o dispositivo. Las dependencias externas se acceden mediante contratos ubicados hacia el interior del módulo y adaptadores ubicados hacia el exterior.

### 2.6. Reutilización

Solo se comparte código estable y verdaderamente transversal. Una coincidencia visual o de implementación no basta para mover código a `shared/` o `core/`; primero debe demostrarse una semántica común.

### 2.7. Separación de responsabilidades

Cada unidad debe tener un motivo principal de cambio. Presentación coordina interacción, dominio expresa reglas, datos integra fuentes, plataforma encapsula capacidades del dispositivo y backend protege operaciones remotas y secretos.

## 3. Arquitectura general

### 3.1. Registro de decisiones aprobadas

| Área | Decisión oficial | Justificación |
| --- | --- | --- |
| Organización | Feature First | Mantiene juntas las piezas que cambian por una misma capacidad. |
| Capas | Clean Architecture simplificada | Protege el dominio sin imponer capas sin valor. |
| Composición | Modular | Limita impacto, propiedad y dependencias. |
| Estrategia de datos | Offline First | Mantiene disponibles los flujos esenciales y tolera conectividad intermitente. |
| Gestión de estado | Riverpod | Unifica composición, ciclo de vida, observación y pruebas del estado. |
| Navegación | GoRouter | Centraliza rutas declarativas, redirecciones y deep links. |
| Base de datos local | Isar | Proporciona persistencia local estructurada y consultas reactivas. |
| Cliente HTTP | Dio | Centraliza solicitudes, interceptores, cancelación, timeouts y normalización de errores. |
| Backend | FastAPI | Expone operaciones remotas tipadas y separa capacidades sensibles del cliente. |
| Autenticación | Firebase Authentication | Gestiona identidad y emisión de credenciales verificables. |
| Proveedor IA | Google Gemini, exclusivamente a través del backend | Evita exponer credenciales y permite aplicar control, validación y observabilidad. |
| Lenguaje backend | Python | Mantiene coherencia con el framework aprobado y el procesamiento del servidor. |

No se adoptarán alternativas para estas áreas sin una decisión arquitectónica posterior aprobada.

### 3.2. Modelo de alto nivel

```text
Usuario
  │
  ▼
Aplicación Flutter
  ├── Presentación y navegación
  ├── Estado y casos de uso
  ├── Persistencia local
  └── Adaptadores de plataforma
  │
  │ HTTPS autenticado
  ▼
Backend FastAPI
  ├── Validación y autorización
  ├── Casos de uso remotos
  ├── Orquestación de servicios
  └── Acceso controlado a Google Gemini
```

La aplicación local es responsable de la experiencia, los datos locales y la cola de sincronización. El backend es el límite de confianza para operaciones remotas, validación de credenciales, secretos y acceso al proveedor de IA.

### 3.3. Aplicación de Clean Architecture simplificada

Cada feature contiene tres capas:

```text
presentation ─────► domain ◄───── data
                         ▲
                         │ contratos
```

- `presentation/` depende de `domain/` para ejecutar comportamiento y representar estados.
- `data/` depende de contratos de `domain/` y los implementa.
- `domain/` no depende de las otras capas de la feature.
- La composición de implementaciones ocurre mediante providers, fuera de las entidades y casos de uso.

No se exige un caso de uso, repositorio o modelo separado cuando no existe una frontera real. Sí se exige cuando permite invertir una dependencia externa o aislar una regla de negocio.

### 3.4. Modularidad y crecimiento

Una nueva capacidad de negocio se incorpora como feature. Una capacidad transversal se ubica según su naturaleza: política técnica estable en `core/`, mecanismo de composición en `foundation/`, integración global en `services/`, acceso al dispositivo en `platform/` o elemento reutilizable y sin dominio en `shared/`.

El crecimiento no debe aumentar importaciones laterales entre features. Si varias features necesitan coordinarse, se define un contrato estrecho o un coordinador de aplicación, según las reglas de la sección 17.

## 4. Estructura oficial del repositorio

```text
focusly/
├── .github/
│   ├── workflows/
│   └── PULL_REQUEST_TEMPLATE.md
├── .ai/
│   ├── context/
│   └── rules/
├── assets/
│   ├── animations/
│   ├── fonts/
│   ├── icons/
│   └── images/
├── backend/
│   ├── app/
│   │   ├── api/
│   │   ├── core/
│   │   ├── domain/
│   │   ├── services/
│   │   └── main.py
│   ├── tests/
│   └── README.md
├── docs/
│   └── MASTER_PROJECT_GUIDE/
├── integration_test/
├── lib/
│   ├── app/
│   ├── config/
│   ├── core/
│   ├── features/
│   ├── foundation/
│   ├── platform/
│   ├── services/
│   ├── shared/
│   └── main.dart
├── scripts/
├── test/
├── analysis_options.yaml
├── pubspec.yaml
└── README.md
```

### 4.1. Responsabilidades en la raíz

| Ruta | Responsabilidad | Puede contener | No puede contener |
| --- | --- | --- | --- |
| `.github/` | Automatización y plantillas de colaboración. | Workflows, plantillas y configuración del repositorio. | Lógica de producto o secretos. |
| `.ai/` | Contexto operativo y reglas auxiliares para IA. | Instrucciones alineadas con documentación aprobada. | Decisiones que contradigan o sustituyan `docs/`. |
| `assets/` | Recursos estáticos declarados por la aplicación. | Imágenes, iconos, fuentes y animaciones optimizadas. | Credenciales, código o archivos sin uso declarado. |
| `backend/` | Aplicación de servidor y sus pruebas. | Entrada, validación, autorización, orquestación y adaptadores externos. | Código de interfaz Flutter o secretos versionados. |
| `docs/` | Fuentes documentales oficiales. | Estándares, visión, requisitos, arquitectura y guías aprobadas. | Artefactos generados que no sean necesarios para trazabilidad. |
| `integration_test/` | Validación de recorridos integrados. | Escenarios completos y utilidades exclusivas de prueba. | Lógica reutilizada por producción. |
| `lib/` | Código de producción de la aplicación Flutter. | Composición, features y capacidades transversales aprobadas. | Pruebas, secretos o scripts operativos. |
| `scripts/` | Automatización reproducible del repositorio. | Validadores, generación controlada y tareas de mantenimiento. | Reglas de negocio o credenciales embebidas. |
| `test/` | Pruebas automatizadas de unidades y componentes. | Tests, fixtures y fakes de alcance de prueba. | Código requerido en producción. |

Las carpetas se crearán cuando exista contenido aprobado para ellas; el árbol define ubicación y límites, no obliga a mantener directorios vacíos.

## 5. Arquitectura Flutter

### 5.1. `lib/main.dart`

- **Objetivo:** ser el punto de entrada mínimo del proceso.
- **Responsabilidad:** delegar el arranque al bootstrap correspondiente y reportar fallos fatales de inicialización.
- **Puede contener:** selección de configuración de arranque y llamada inicial.
- **No puede contener:** UI de negocio, rutas, acceso directo a datos, inicialización dispersa ni reglas funcionales.

### 5.2. `lib/app/`

- **Objetivo:** componer la aplicación como unidad ejecutable.
- **Responsabilidad:** widget raíz, router, tema global, observadores y ensamblaje de alto nivel.
- **Puede contener:** `app.dart`, configuración de rutas, guards, shell de aplicación y bootstrap específico del árbol de widgets.
- **No puede contener:** reglas de dominio, repositorios concretos, consultas locales ni llamadas HTTP.

### 5.3. `lib/config/`

- **Objetivo:** representar configuración inmutable por entorno.
- **Responsabilidad:** leer y validar valores públicos de configuración suministrados al arranque.
- **Puede contener:** tipos de entorno, endpoints públicos, feature flags aprobados y validadores de configuración.
- **No puede contener:** secretos, estado mutable, acceso a almacenamiento o comportamiento de features.

### 5.4. `lib/core/`

- **Objetivo:** alojar primitivas técnicas estables y agnósticas del producto.
- **Responsabilidad:** errores base, resultados, contratos técnicos, utilidades puras y constantes transversales justificadas.
- **Puede contener:** tipos `Result`, jerarquía de fallos, reloj abstracto, identificadores y validadores genéricos.
- **No puede contener:** lógica de una feature, widgets de negocio, implementaciones de plataforma ni un contenedor indiscriminado de utilidades.

### 5.5. `lib/foundation/`

- **Objetivo:** proporcionar mecanismos comunes de composición y ciclo de vida.
- **Responsabilidad:** providers raíz, observación global, inicializadores y coordinación técnica del arranque.
- **Puede contener:** composición de dependencias, observador de providers y registro de tareas de inicialización.
- **No puede contener:** entidades de negocio, UI de feature ni clientes externos usados directamente por presentación.

### 5.6. `lib/services/`

- **Objetivo:** encapsular servicios de aplicación transversales que coordinan más de una feature o adaptador.
- **Responsabilidad:** sincronización global, sesión, conectividad y coordinación transversal con contrato explícito.
- **Puede contener:** contratos y coordinadores de sesión, conectividad, sincronización y telemetría permitida.
- **No puede contener:** repositorios propios de una feature, widgets, entidades compartidas por conveniencia ni acceso sin abstracción desde UI.

### 5.7. `lib/platform/`

- **Objetivo:** aislar capacidades específicas del sistema operativo o dispositivo.
- **Responsabilidad:** adaptar notificaciones, permisos, ciclo de vida, archivos, reloj del dispositivo y conectividad.
- **Puede contener:** interfaces de adaptadores, implementaciones por plataforma y mapeo de errores nativos.
- **No puede contener:** decisiones de negocio, navegación, estado de pantallas ni acceso a módulos internos.

### 5.8. `lib/shared/`

- **Objetivo:** alojar componentes reutilizables sin semántica exclusiva de una feature.
- **Responsabilidad:** elementos visuales, extensiones y modelos de presentación verdaderamente transversales.
- **Puede contener:** design tokens, widgets genéricos, formatters y extensiones puras.
- **No puede contener:** lógica de negocio, repositorios, pantallas completas, entidades de dominio o componentes compartidos prematuramente.

### 5.9. `lib/features/`

- **Objetivo:** agrupar capacidades de negocio mediante Feature First.
- **Responsabilidad:** contener presentación, dominio, datos, pruebas relacionadas y documentación local de cada capacidad.
- **Puede contener:** una carpeta por feature con la estructura definida en la sección 6.
- **No puede contener:** archivos globales sin propietario, importaciones a detalles internos de otra feature ni infraestructura transversal duplicada.

## 6. Organización de features

### 6.1. Estructura oficial

```text
lib/features/<feature_name>/
├── presentation/
│   ├── controllers/
│   ├── pages/
│   ├── providers/
│   ├── state/
│   └── widgets/
├── domain/
│   ├── entities/
│   ├── repositories/
│   ├── services/
│   └── use_cases/
├── data/
│   ├── data_sources/
│   ├── models/
│   ├── repositories/
│   └── mappers/
└── README.md
```

Solo se crean subcarpetas con contenido. La estructura expresa destinos permitidos, no una obligación de producir archivos vacíos.

### 6.2. `presentation/`

Responsable de interacción, representación del estado y adaptación de eventos de usuario a operaciones del dominio. Puede contener widgets, páginas, estado inmutable, Notifiers y Providers propios de presentación. No puede consultar Dio, Isar, adaptadores de dispositivo ni modelos de transporte directamente.

### 6.3. `domain/`

Responsable del lenguaje y las políticas de la feature. Puede contener entidades, value objects, contratos de repositorio, servicios de dominio y casos de uso. Debe permanecer independiente de Flutter, Riverpod, Dio, Isar, FastAPI y detalles de serialización.

Los casos de uso se crean cuando encapsulan una operación, validación o coordinación significativa. No se exige una clase que solo reenvíe una llamada sin aportar política o aislamiento.

### 6.4. `data/`

Responsable de implementar contratos del dominio mediante fuentes locales y remotas. Puede contener modelos persistentes o de transporte, mappers, data sources y repositorios concretos. No puede exponer modelos externos hacia dominio o presentación.

### 6.5. `README.md`

Documenta propósito, alcance, contratos públicos, dependencias permitidas, estrategia de datos, estados relevantes y pruebas de la feature. No reemplaza los documentos maestros ni introduce decisiones incompatibles con ellos.

### 6.6. Límites de una feature

- Su API pública debe ser mínima y explícita.
- Sus detalles internos permanecen bajo su carpeta.
- Sus modelos de datos no se comparten con otras features.
- Sus entidades solo salen del módulo cuando forman parte de un contrato aprobado.
- La eliminación de la feature no debe exigir reescribir módulos no dependientes.
- Las pruebas deben reflejar sus capas y contratos, no rutas físicas arbitrarias.

## 7. Gestión del estado

Riverpod es el mecanismo oficial para composición y estado reactivo en Flutter.

### 7.1. Notifiers

- Orquestan eventos de presentación y producen estados inmutables.
- Dependen de casos de uso o contratos, no de fuentes de datos concretas.
- Representan explícitamente estado inicial, carga, datos, vacío y error cuando correspondan.
- Cancelan o ignoran resultados obsoletos cuando el ciclo de vida termina.
- No reciben `BuildContext` ni ejecutan navegación directa.

### 7.2. Providers

- Declaran dependencias, alcance, ciclo de vida y puntos de sustitución para pruebas.
- Los providers de una feature permanecen dentro de ella salvo contratos de composición global.
- Un provider no se utiliza como variable global mutable.
- La lectura imperativa se limita a eventos; la UI observa el estado necesario.
- Las dependencias concretas se conectan en providers de composición, no dentro del dominio.

### 7.3. Estado local

El estado efímero y exclusivo de un widget permanece local cuando no necesita compartirse, persistirse ni probarse de forma aislada. Ejemplos: foco visual, expansión temporal o valor de animación. No se elevará a un provider sin necesidad de ciclo de vida o coordinación.

### 7.4. Estado compartido

Se comparte únicamente el estado con un propietario claro y consumidores legítimos. La sesión, conectividad y sincronización pueden tener alcance de aplicación; el estado de una feature no se convierte en global para facilitar imports.

### 7.5. Estado persistente

Riverpod no es la fuente persistente. El estado durable se almacena mediante repositorios y se vuelve a observar desde providers. Un Notifier puede mantener una proyección en memoria, pero debe poder reconstruirla desde la fuente local oficial.

## 8. Navegación

GoRouter es el mecanismo oficial de navegación.

### 8.1. Rutas

- Las rutas se declaran en `app/` y usan nombres y paths estables.
- Cada feature expone destinos públicos sin revelar widgets o controladores internos a otras features.
- Los parámetros se validan antes de construir el destino.
- Los datos complejos se recuperan por identificador; no se transportan como estado durable de navegación.
- La navegación se inicia desde presentación mediante una abstracción o intención comprobable.

### 8.2. Rutas protegidas

La autorización de acceso se resuelve mediante redirecciones centrales basadas en el estado de sesión y onboarding. Un destino protegido no replica validaciones en cada página. Las redirecciones deben ser deterministas y evitar bucles.

### 8.3. Deep links

- Todo deep link se considera entrada no confiable.
- El path, parámetros, sesión y existencia del recurso se validan.
- Si el usuario debe autenticarse, se conserva solo un destino seguro y permitido.
- Un enlace inválido conduce a un estado recuperable, no a una excepción sin manejar.
- Las rutas públicas documentan compatibilidad antes de cambiar su formato.

### 8.4. Estructura

El router raíz pertenece a `app/`. Las definiciones de cada feature pueden componerse mediante descriptores públicos, pero las decisiones de redirección transversal permanecen centralizadas.

## 9. Persistencia

Isar es la base de datos local oficial para datos estructurados, cache y estado de sincronización.

### 9.1. Datos locales

- Cada colección tiene propietario, identificador estable y estrategia de migración.
- Los modelos de persistencia permanecen en `data/` y se convierten a entidades de dominio.
- Las escrituras relacionadas se agrupan de forma atómica cuando la consistencia lo requiera.
- Las consultas se encapsulan en data sources; presentación y dominio no conocen consultas de Isar.
- Ningún cambio destructivo de esquema se libera sin migración o política explícita de descarte seguro.

### 9.2. Cache

- La cache debe tener finalidad, propietario, vigencia y política de invalidación.
- Los datos cacheados no se confunden con datos confirmados por el usuario.
- La ausencia o expiración de cache no rompe el dominio; activa recuperación o estado degradado.
- La cache puede eliminarse sin perder información local considerada fuente de verdad.

### 9.3. Sincronización

- Todo registro sincronizable conserva identidad estable, versión o marca de modificación y estado de sincronización.
- Las operaciones pendientes son idempotentes o incluyen una clave que impida duplicados.
- Los conflictos nunca se resuelven descartando silenciosamente datos confirmados.
- La estrategia por entidad define precedencia, combinación o intervención del usuario.
- Los fallos mantienen la operación pendiente con causa normalizada y política de reintento.

### 9.4. Preferencias simples

SharedPreferences se utiliza únicamente para valores pequeños, no sensibles y no relacionales, como flags de primera ejecución o preferencias visuales. No almacena entidades, tokens, colas de sincronización, contenido académico ni información que requiera consultas o migración estructurada.

## 10. Comunicación con backend

Dio es el único cliente HTTP de la aplicación.

### 10.1. Cliente HTTP

Una instancia configurada centralmente define base URL, cabeceras comunes, codificación, cancelación y políticas de tiempo. Las features reciben data sources o clientes de servicio estrechos; no crean instancias independientes.

### 10.2. Interceptores

Los interceptores se limitan a responsabilidades transversales:

- adjuntar credenciales vigentes;
- incorporar identificadores de correlación;
- renovar credenciales mediante un flujo único y serializado;
- registrar metadatos permitidos;
- normalizar condiciones comunes.

No contienen reglas de negocio, navegación ni transformación de entidades.

### 10.3. Errores

Los errores de transporte se convierten a fallos tipados antes de salir de `data/`. Deben distinguir, como mínimo, cancelación, timeout, ausencia de conectividad, acceso no autorizado, validación, límite de uso, error remoto y respuesta inválida.

### 10.4. Timeouts y reintentos

- Los timeouts se configuran por clase de operación y se revisan con mediciones.
- Solo se reintentan automáticamente operaciones seguras o idempotentes.
- Se utiliza espera progresiva con límite y variación para evitar reintentos coordinados.
- Una cancelación del usuario no se reintenta.
- Las escrituras no idempotentes requieren clave de idempotencia o confirmación antes de repetirse.

### 10.5. Autenticación

La credencial emitida por Firebase Authentication se adjunta a solicitudes protegidas. El cliente no interpreta la credencial como autorización suficiente: el backend verifica autenticidad, vigencia y permisos para cada operación.

## 11. Backend

FastAPI aloja el backend y Python es su lenguaje oficial.

### 11.1. Responsabilidades

- exponer contratos remotos versionados;
- validar estructura, tamaño y semántica de entradas;
- verificar identidad y autorización;
- ejecutar casos de uso remotos;
- proteger secretos y credenciales de proveedores;
- aplicar límites, auditoría y observabilidad;
- normalizar respuestas y errores;
- coordinar servicios externos sin filtrar sus modelos al cliente.

### 11.2. Organización

- `api/` define entradas, salidas, dependencias de request y traducción de errores.
- `domain/` define políticas y modelos independientes del framework.
- `services/` orquesta integraciones y casos de aplicación del servidor.
- `core/` contiene configuración validada, seguridad, observabilidad y primitivas transversales.
- `main.py` crea la aplicación y registra ciclo de vida, rutas y manejadores globales.

Los handlers deben ser delgados: validan el límite, llaman a un caso de uso y traducen el resultado. No contienen prompts extensos, reglas de negocio ni acceso directo a proveedores.

### 11.3. IA

El backend construye solicitudes al proveedor, aplica plantillas versionadas, limita entradas, filtra datos, valida resultados y registra métricas seguras. La respuesta externa se adapta a un contrato propio antes de enviarse al cliente.

### 11.4. Validaciones

Toda entrada remota se considera no confiable. Se validan tipos, longitud, formato, pertenencia, permisos, límites y coherencia. La validación del cliente mejora la experiencia, pero no reemplaza la validación del servidor.

### 11.5. Autenticación y autorización

El backend verifica credenciales con el mecanismo oficial de identidad y deriva un identificador interno. La autorización se evalúa por recurso y operación; conocer un identificador no concede acceso. Los endpoints sensibles registran eventos de auditoría sin incluir contenido privado innecesario.

## 12. Integración IA

### 12.1. Flujo obligatorio

```text
Flutter
  │ solicitud autenticada y validada localmente
  ▼
FastAPI
  │ autorización, límites, orquestación y validación
  ▼
Google Gemini
```

Flutter nunca accede directamente a Gemini. Las claves, prompts de sistema, reglas de seguridad y selección de capacidades permanecen en el backend.

### 12.2. Reglas de integración

- La aplicación envía solo el contenido necesario y con consentimiento aplicable.
- El backend asigna un identificador de correlación y aplica límites de tamaño y uso.
- Los prompts son artefactos versionados y probados, no cadenas dispersas en handlers.
- La salida se valida contra un contrato propio antes de retornar.
- Los resultados se consideran no deterministas y potencialmente incorrectos.
- El cliente presenta estados de carga, cancelación, límite, rechazo y resultado inválido.
- No se registra contenido académico completo ni información personal en logs ordinarios.
- Los fallos del proveedor se traducen a errores propios; sus detalles internos no se exponen.

## 13. Offline First

### 13.1. Fuente de verdad

Para flujos Offline First, la aplicación lee primero desde la base local. La UI observa datos locales y no depende de una respuesta remota para mostrar información previamente disponible. El backend conserva la autoridad sobre operaciones que requieran validación remota, pero no reemplaza el estado local sin una reconciliación definida.

### 13.2. Flujo de escritura

```text
Acción del usuario
  ▼
Validación de dominio
  ▼
Transacción local + operación pendiente
  ▼
Actualización reactiva de UI
  ▼
Sincronización cuando existe conectividad
  ▼
Confirmación o conflicto persistido
```

### 13.3. Cola de operaciones

Cada operación pendiente debe contener identificador, tipo, entidad, versión, momento de creación, intentos, estado y causa del último fallo. La cola se procesa en orden compatible con dependencias y nunca depende de que una pantalla permanezca abierta.

### 13.4. Conflictos

La política se define por tipo de dato:

- datos independientes pueden combinarse;
- cambios sobre el mismo campo requieren versión y regla explícita;
- eliminaciones usan marcas hasta confirmación remota;
- información sensible o irreversible puede exigir intervención del usuario;
- ninguna política global de «último cambio gana» se aplica sin evaluar pérdida de datos.

### 13.5. Estados visibles

El dominio distingue `local`, `pending`, `synced`, `failed` y `conflict` cuando sean relevantes. Presentación traduce esos estados sin exponer detalles internos y ofrece reintento o resolución cuando corresponda.

### 13.6. Capacidades exclusivamente remotas

Una capacidad que no pueda operar sin conexión debe declararlo antes de consumir entrada del usuario. Puede encolar una solicitud solo si se preservan privacidad, vigencia del contexto y control de cancelación.

## 14. Seguridad

### 14.1. HTTPS

Toda comunicación remota usa HTTPS. No se permiten excepciones de validación de certificados en builds distribuibles. Los entornos se configuran mediante valores validados y no mediante URLs introducidas en features.

### 14.2. Tokens

- Los tokens no se guardan en logs, analytics ni mensajes de error.
- Su almacenamiento usa el mecanismo seguro de plataforma apropiado.
- La renovación se centraliza y evita solicitudes simultáneas duplicadas.
- El cierre de sesión elimina credenciales y estado sensible asociado.
- El backend valida firma, vigencia, emisor y audiencia antes de confiar en ellos.

### 14.3. Permisos

- Se solicitan en contexto, justo antes de usar la capacidad.
- Se explica finalidad y comportamiento si el usuario rechaza.
- No se solicita un permiso que no respalde una función activa.
- La denegación no bloquea capacidades no relacionadas.
- `platform/` encapsula la interacción y devuelve resultados tipados.

### 14.4. Validaciones

La aplicación valida por experiencia y el backend valida por seguridad. Se aplican controles de tamaño, formato, pertenencia y autorización. Los datos externos nunca se concatenan en instrucciones, consultas o rutas sin tratamiento apropiado.

### 14.5. Privacidad

- Se minimizan datos recopilados y enviados.
- La finalidad y retención se documentan por categoría.
- Los datos sensibles se excluyen de logs y mensajes diagnósticos.
- Las operaciones de exportación y eliminación son auditables.
- Ningún contenido del usuario se reutiliza para una finalidad nueva sin base y comunicación aprobadas.
- Los secretos se suministran por configuración segura y nunca se versionan.

## 15. Logging

### 15.1. Niveles

| Nivel | Uso |
| --- | --- |
| `debug` | Diagnóstico detallado exclusivo de entornos de desarrollo. |
| `info` | Eventos operativos esperados y cambios de ciclo de vida relevantes. |
| `warning` | Condición recuperable, degradación o reintento que merece seguimiento. |
| `error` | Operación fallida que requiere investigación o afecta un flujo. |
| `fatal` | Fallo no recuperable que impide iniciar o mantener el proceso principal. |

### 15.2. Reglas

- Cada evento usa nombre estable, nivel, timestamp, entorno e identificador de correlación cuando aplique.
- Se registran metadatos técnicos mínimos, no contenido académico, tokens, credenciales ni datos personales directos.
- Un error se registra una vez en el límite que lo maneja; las capas inferiores añaden contexto estructurado sin duplicar eventos.
- Los logs de desarrollo no habilitan información sensible en producción.
- La retención y acceso a logs siguen la clasificación de datos y el principio de mínimo privilegio.

## 16. Manejo de errores

### 16.1. Taxonomía

```text
Failure
├── ValidationFailure
├── AuthenticationFailure
├── AuthorizationFailure
├── ConnectivityFailure
├── TimeoutFailure
├── NotFoundFailure
├── ConflictFailure
├── RateLimitFailure
├── StorageFailure
├── RemoteFailure
└── UnexpectedFailure
```

La taxonomía puede especializarse sin exponer excepciones externas al dominio.

### 16.2. Flujo

1. La capa de origen captura la excepción externa.
2. `data/` o `platform/` la convierte a un fallo tipado con contexto seguro.
3. El repositorio devuelve un resultado explícito; no usa excepciones para resultados esperables.
4. El caso de uso conserva o traduce semántica de negocio.
5. El Notifier produce un estado recuperable.
6. Presentación comunica un mensaje accionable y conserva datos válidos.
7. Logging registra el evento en el límite responsable.

### 16.3. Reglas

- No se muestran stack traces ni mensajes de proveedores al usuario.
- Un error de una operación no invalida estados independientes.
- Los errores recuperables ofrecen reintento seguro o acción alternativa.
- Los fallos inesperados incluyen correlación sin revelar información sensible.
- La UI no interpreta códigos HTTP ni excepciones de base de datos.
- Los errores de sincronización permanecen asociados con la operación pendiente.

## 17. Comunicación entre features

### 17.1. Regla principal

Una feature no importa archivos internos de otra feature. Solo puede usar un contrato público aprobado y estable, o delegar la coordinación a una capa de aplicación.

### 17.2. Mecanismos permitidos

1. **Navegación por destino público:** para transferir control sin compartir implementación.
2. **Contrato de dominio público:** para una capacidad estable que otra feature necesita invocar.
3. **Provider público de solo lectura:** para observar un estado transversal explícitamente expuesto.
4. **Coordinador en `services/`:** para un caso de aplicación que atraviesa varias features.
5. **Persistencia compartida por contrato:** solo cuando existe un propietario único; los consumidores no acceden a sus tablas.

### 17.3. Prohibiciones

- importar `presentation/` o `data/` de otra feature;
- leer colecciones locales propiedad de otro módulo;
- reutilizar un Notifier como servicio de negocio;
- exportar modelos de transporte o persistencia;
- crear un archivo global para evitar definir un contrato;
- usar navegación como canal de sincronización de datos;
- generar dependencias circulares directas o indirectas.

### 17.4. Propiedad de contratos

El proveedor de una capacidad conserva el contrato junto a su dominio. Si el contrato representa una coordinación transversal y no pertenece a una sola feature, reside en `services/`. Solo los tipos sin semántica de negocio pueden ascender a `core/` o `shared/`.

## 18. Dependency Rules

### 18.1. Matriz de dependencias Flutter

| Origen | Puede depender de | No puede depender de |
| --- | --- | --- |
| `app/` | `config/`, `foundation/`, contratos públicos de features, `shared/` | Detalles de `data/`, consultas locales o handlers HTTP. |
| `config/` | `core/` | Features, presentación, datos o plataforma. |
| `core/` | Biblioteca estándar y dependencias técnicas mínimas aprobadas | Features, `app/`, `shared/`, `services/` o `platform/`. |
| `foundation/` | `core/`, `config/`, contratos de `services/` y composición pública | UI de feature o reglas de dominio concretas. |
| `services/` | `core/`, contratos públicos de features y `platform/` por abstracción | Widgets o detalles internos de features. |
| `platform/` | `core/` y capacidades de dispositivo | Features, UI o reglas de negocio. |
| `shared/` | `core/` y Flutter para componentes visuales | Features, repositorios o servicios de aplicación. |
| `features/*/presentation` | Su `domain/`, `shared/`, `core/` y contratos públicos permitidos | Su `data/`, detalles de otras features, Dio o Isar. |
| `features/*/domain` | `core/` cuando sea estrictamente necesario | Flutter, Riverpod, presentación, datos, plataforma o dependencias externas. |
| `features/*/data` | Su `domain/`, `core/`, clientes y adaptadores inyectados | Presentación o detalles internos de otras features. |

### 18.2. Dirección obligatoria

```text
presentation ──► domain ◄── data
      │                         │
      └──── composición ────────┘
```

Presentation conoce Domain. Domain no conoce Presentation. Data implementa contratos de Domain. Core no depende de Features. Platform encapsula APIs del dispositivo. Features no conocen implementaciones internas de otras Features.

### 18.3. Reglas backend

- `api/` depende de casos de uso y modelos de entrada/salida, no de clientes externos directos.
- `domain/` no depende del framework web, proveedor de IA ni persistencia.
- `services/` implementa puertos y coordinación; no filtra modelos externos al dominio.
- `core/` no contiene casos de negocio.
- El punto de entrada compone dependencias; no ejecuta lógica de requests.

### 18.4. Ciclos y excepciones

Todo ciclo de imports es un fallo arquitectónico. Una excepción temporal requiere responsable, justificación, fecha de eliminación y prueba que impida expandirla. Las excepciones no alteran la regla oficial.

## 19. Bootstrap

### 19.1. Secuencia de inicio Flutter

1. `main.dart` establece el límite de errores fatales.
2. Se selecciona y valida la configuración del entorno.
3. Se inicializan bindings requeridos por la plataforma.
4. Se abre la persistencia local y se ejecutan migraciones.
5. Se preparan logging y observadores sin datos sensibles.
6. Se crean adaptadores de plataforma y clientes transversales.
7. Se construye el contenedor raíz de Riverpod con overrides de entorno.
8. Se inicia la observación de sesión, conectividad y sincronización.
9. Se monta el widget raíz y GoRouter resuelve el destino inicial.
10. Las tareas no críticas continúan después del primer frame y reportan fallos recuperables.

### 19.2. Reglas de bootstrap

- Las tareas tienen orden, timeout y clasificación crítica o diferible.
- Un fallo crítico muestra una recuperación controlada; no deja una pantalla vacía.
- Un fallo diferible no bloquea funciones independientes.
- La inicialización es idempotente durante pruebas y reinicios controlados.
- Ninguna feature inicializa servicios globales desde un widget.
- Los recursos abiertos se cierran en el ciclo de vida correspondiente.

### 19.3. Inicio backend

1. Se carga y valida configuración.
2. Se configura logging seguro.
3. Se construyen adaptadores y servicios.
4. Se registran rutas y manejadores de error.
5. Se validan dependencias críticas mediante lifecycle hooks.
6. La instancia anuncia disponibilidad solo cuando puede atender contratos esenciales.

## 20. Architecture Fitness Rules

Las siguientes reglas son obligatorias y deben automatizarse cuando sea viable:

| ID | Regla | Evidencia mínima |
| --- | --- | --- |
| AFR-001 | Existe un único H1 y la documentación arquitectónica mantiene numeración continua. | Validador Markdown. |
| AFR-002 | Ninguna feature importa `presentation/` o `data/` de otra feature. | Test de imports. |
| AFR-003 | `domain/` no importa Flutter, Riverpod, Dio, Isar ni adaptadores externos. | Análisis estático de imports. |
| AFR-004 | `core/` no depende de features. | Test de dependencias. |
| AFR-005 | `platform/` no contiene imports de features. | Test de dependencias. |
| AFR-006 | Presentation no accede directamente a red, base local o APIs de dispositivo. | Análisis de imports y revisión. |
| AFR-007 | Todos los repositorios concretos implementan contratos del dominio correspondiente. | Tests de compilación y contratos. |
| AFR-008 | Los modelos de persistencia y transporte no salen de `data/`. | Análisis de firmas públicas. |
| AFR-009 | Toda ruta protegida participa en la política central de redirección. | Tests del router. |
| AFR-010 | Solo existe una composición raíz de clientes HTTP, base local y sesión. | Test de construcción y búsqueda estructural. |
| AFR-011 | Ningún secreto o token aparece en código, assets, logs o control de versiones. | Escaneo de secretos. |
| AFR-012 | Las escrituras Offline First generan estado local y operación sincronizable coherentes. | Tests de repositorio. |
| AFR-013 | Las operaciones reintentables son idempotentes o tienen clave de idempotencia. | Tests de integración. |
| AFR-014 | Flutter no contiene credenciales ni acceso directo a Google Gemini. | Escaneo de dependencias y código. |
| AFR-015 | Los endpoints verifican identidad, autorización y validación de entrada. | Tests del backend. |
| AFR-016 | Los errores externos se convierten a fallos propios antes de llegar a presentación. | Tests por capa. |
| AFR-017 | Los logs excluyen campos sensibles definidos. | Tests del formateador y revisión. |
| AFR-018 | Cada feature mantiene un `README.md` alineado con sus contratos públicos. | Validador de estructura. |
| AFR-019 | No existen ciclos en el grafo de dependencias. | Análisis del grafo. |
| AFR-020 | El formato, análisis y pruebas aprobadas finalizan sin errores. | Pipeline de validación. |

Una regla que todavía no esté automatizada debe formar parte de la revisión obligatoria. La falta de automatización no autoriza su incumplimiento.

## 21. Definition of Done arquitectónica

Una feature cumple la arquitectura cuando se verifica todo lo siguiente:

### 21.1. Estructura y límites

- [ ] Reside en `lib/features/<feature_name>/` y solo contiene carpetas necesarias.
- [ ] Mantiene `presentation`, `domain`, `data` y `README.md` según sus responsabilidades.
- [ ] Expone una superficie pública mínima.
- [ ] No importa detalles internos de otras features.
- [ ] No introduce ciclos ni excepciones sin registrar.

### 21.2. Dominio y datos

- [ ] Las reglas de negocio se prueban sin Flutter ni servicios externos.
- [ ] Los contratos se ubican hacia el dominio y las implementaciones hacia datos.
- [ ] Los modelos externos se convierten antes de cruzar capas.
- [ ] Persistencia, cache y sincronización tienen propietario y política explícita.
- [ ] Las migraciones preservan o tratan deliberadamente datos existentes.
- [ ] Los conflictos y reintentos tienen comportamiento probado.

### 21.3. Presentación y estado

- [ ] Los Notifiers dependen de casos de uso o contratos.
- [ ] Los estados inicial, carga, datos, vacío y error están modelados cuando aplican.
- [ ] La UI no accede directamente a Dio, Isar ni APIs de plataforma.
- [ ] Providers tienen alcance y ciclo de vida justificados.
- [ ] Navegación y deep links validan parámetros y acceso.

### 21.4. Seguridad y operación

- [ ] Entradas, permisos y operaciones sensibles se validan en sus límites.
- [ ] No existen secretos, tokens o datos privados en código o logs.
- [ ] Los errores se normalizan y ofrecen recuperación segura.
- [ ] Logging y correlación siguen la clasificación aprobada.
- [ ] El comportamiento offline y la recuperación de conectividad están probados.

### 21.5. Calidad y documentación

- [ ] Cumple todas las Architecture Fitness Rules aplicables.
- [ ] Incluye pruebas unitarias, de componentes e integración proporcionales al riesgo.
- [ ] `README.md` describe propósito, contratos, dependencias y estrategia de datos.
- [ ] Los cambios arquitectónicos o excepciones están aprobados y documentados.
- [ ] Formato, análisis y pruebas finalizan correctamente.

## 22. Referencias

- [Estándar oficial de documentación](./00_DOCUMENTATION_STANDARD.md)
- [Visión del proyecto](./01_PROJECT_VISION.md)
- [Requisitos del producto](./02_PRODUCT_REQUIREMENTS.md)

## 23. AI CONTEXT

- **Qué representa este documento:** es la referencia técnica normativa para estructura, capas, dependencias, integración, seguridad, operación y crecimiento de Focusly.
- **Decisiones obligatorias:** Feature First, Clean Architecture simplificada, modularidad, Offline First y todas las selecciones registradas en la sección 3.1. Las reglas de dependencias, comunicación entre features y fitness rules también son obligatorias.
- **Qué no puede modificar una IA:** decisiones aprobadas, límites de carpetas, dirección de dependencias, flujo exclusivo de IA por backend, reglas de seguridad o excepciones arquitectónicas. Cualquier cambio requiere propuesta, impacto, actualización documental y aprobación humana previa.
- **Qué debe leer antes de generar código:** `00_DOCUMENTATION_STANDARD.md`, `01_PROJECT_VISION.md`, `02_PRODUCT_REQUIREMENTS.md`, este documento y el `README.md` de la feature afectada cuando exista.
- **Cómo debe actuar:** identificar primero la feature y capa propietarias; reutilizar solo contratos permitidos; generar la mínima estructura necesaria; incluir pruebas y documentación; detenerse si una solicitud contradice una regla o carece de decisión suficiente.
- **Prohibición de inferencia:** no convertir el árbol objetivo en autorización para crear carpetas vacías, no inventar contratos remotos, esquemas, secretos, versiones o excepciones, y no elegir tecnologías alternativas.

## 24. Historial de cambios

| Versión | Fecha | Estado | Descripción | Autor |
| --- | --- | --- | --- | --- |
| 1.0.0 | 11 de julio de 2026 | Approved | Creación y aprobación inicial de la arquitectura oficial del sistema Focusly. | Equipo Focusly |
