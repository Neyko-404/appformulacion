# Contexto arquitectónico operativo para IA

| Campo | Valor |
| --- | --- |
| Documento | `ARCHITECT_CONTEXT.md` |
| Proyecto | Focusly |
| Versión | 1.0.0 |
| Estado | Approved |
| Última actualización | 11 de julio de 2026 |
| Autor | Equipo Focusly |
| Responsable técnico | Gary Nivin Quispe |

## Índice

1. [Propósito](#1-propósito)
2. [Fuentes de verdad](#2-fuentes-de-verdad)
3. [Identidad del producto](#3-identidad-del-producto)
4. [Product Pillars](#4-product-pillars)
5. [Arquitectura oficial](#5-arquitectura-oficial)
6. [Golden Rules](#6-golden-rules)
7. [Estructura operativa del repositorio](#7-estructura-operativa-del-repositorio)
8. [Estructura de una feature](#8-estructura-de-una-feature)
9. [Flujo de datos](#9-flujo-de-datos)
10. [Comunicación entre features](#10-comunicación-entre-features)
11. [Reglas de estado y navegación](#11-reglas-de-estado-y-navegación)
12. [Persistencia y Offline First](#12-persistencia-y-offline-first)
13. [Backend e IA](#13-backend-e-ia)
14. [Seguridad](#14-seguridad)
15. [Reglas para generación de código por IA](#15-reglas-para-generación-de-código-por-ia)
16. [Acciones prohibidas](#16-acciones-prohibidas)
17. [Checklist antes de entregar un cambio](#17-checklist-antes-de-entregar-un-cambio)
18. [Escalamiento de dudas](#18-escalamiento-de-dudas)
19. [AI CONTEXT](#19-ai-context)
20. [Historial de cambios](#20-historial-de-cambios)

## 1. Propósito

Este archivo es un resumen operativo para IA que genere o modifique código de Focusly. Reúne decisiones aprobadas y reglas mínimas de trabajo para reducir errores arquitectónicos.

No reemplaza, amplía ni modifica la documentación oficial. Ante una omisión o contradicción, prevalecen las fuentes de verdad de la sección 2 y la IA debe detenerse si esas fuentes no permiten resolverla.

## 2. Fuentes de verdad

| Documento | Responsabilidad |
| --- | --- |
| [`00_DOCUMENTATION_STANDARD.md`](../docs/MASTER_PROJECT_GUIDE/00_DOCUMENTATION_STANDARD.md) | Define estructura, redacción, versionado, estados, referencias y reglas de contexto para IA. |
| [`01_PROJECT_VISION.md`](../docs/MASTER_PROJECT_GUIDE/01_PROJECT_VISION.md) | Define identidad, público, problema, pilares y principios del producto. |
| [`02_PRODUCT_REQUIREMENTS.md`](../docs/MASTER_PROJECT_GUIDE/02_PRODUCT_REQUIREMENTS.md) | Define alcance funcional, prioridades, dependencias de producto y criterios de aceptación. |
| [`03_SYSTEM_ARCHITECTURE.md`](../docs/MASTER_PROJECT_GUIDE/03_SYSTEM_ARCHITECTURE.md) | Define estructura técnica, tecnologías aprobadas, límites, dependencias y reglas arquitectónicas. |

Orden de consulta: estándar para documentar, visión para preservar identidad, PRD para determinar qué construir y arquitectura para determinar cómo construirlo. Este resumen nunca tiene precedencia sobre ellos.

## 3. Identidad del producto

Focusly es un acompañante personal de estudio que integra organización académica, concentración, aprendizaje activo, refuerzo de memoria, motivación positiva y bienestar.

Su público principal son estudiantes de educación superior que gestionan múltiples responsabilidades y necesitan claridad, continuidad y menor carga mental. El producto preserva la autonomía del estudiante, no realiza su trabajo académico, evita mecanismos punitivos, minimiza datos, protege privacidad y prioriza una relación sostenible con el estudio.

## 4. Product Pillars

- Academic Organization
- Deep Focus
- AI Learning
- Memory Reinforcement
- Gamification
- Wellbeing

Toda feature debe vincularse con al menos un pilar sin contradecir los demás. Los nombres y significados oficiales se consultan en Project Vision.

## 5. Arquitectura oficial

Las decisiones siguientes son obligatorias e inmutables sin aprobación humana:

| Área | Decisión aprobada |
| --- | --- |
| Organización | Feature First |
| Capas | Clean Architecture simplificada |
| Composición | Modular |
| Datos | Offline First |
| Estado | Riverpod |
| Navegación | GoRouter |
| Persistencia local | Isar |
| Cliente HTTP | Dio |
| Backend | FastAPI |
| Autenticación | Firebase Authentication |
| IA | Google Gemini únicamente a través de FastAPI |
| Lenguaje backend | Python |

No proponer ni introducir alternativas durante una implementación ordinaria.

## 6. Golden Rules

1. El dominio no depende de Flutter.
2. Flutter nunca accede directamente a Gemini.
3. La UI no contiene lógica de negocio.
4. Presentation no accede directamente a Dio, Isar o APIs del dispositivo.
5. Una feature no importa detalles internos de otra.
6. Core no depende de features.
7. Platform encapsula capacidades del dispositivo.
8. No se crean carpetas, abstracciones o capas sin una necesidad real.
9. No se introducen dependencias circulares.
10. Toda modificación arquitectónica requiere aprobación humana previa.
11. Los modelos externos se transforman antes de cruzar hacia Domain o Presentation.
12. El estado durable pertenece a repositorios, no a widgets ni Notifiers.

## 7. Estructura operativa del repositorio

### 7.1. Rutas principales

| Ruta | Responsabilidad |
| --- | --- |
| `.github/` | Workflows y plantillas de colaboración. |
| `.ai/` | Contexto operativo subordinado a `docs/`. |
| `assets/` | Recursos estáticos declarados por la aplicación. |
| `backend/` | Servidor, validación, autorización, orquestación e integraciones remotas. |
| `docs/` | Documentación oficial y fuente de verdad. |
| `integration_test/` | Pruebas de recorridos integrados. |
| `lib/` | Código de producción de la aplicación Flutter. |
| `scripts/` | Automatización reproducible del repositorio. |
| `test/` | Pruebas unitarias y de componentes. |

### 7.2. Rutas dentro de `lib/`

| Ruta | Responsabilidad |
| --- | --- |
| `app/` | Widget raíz, router, tema y composición de alto nivel. |
| `config/` | Configuración pública, inmutable y validada por entorno. |
| `core/` | Primitivas técnicas estables, genéricas y sin dependencia de features. |
| `foundation/` | Composición raíz, providers globales e inicialización. |
| `services/` | Coordinadores transversales con contratos explícitos. |
| `platform/` | Adaptadores de dispositivo y sistema operativo. |
| `shared/` | Componentes reutilizables sin semántica exclusiva de una feature. |
| `features/` | Capacidades de negocio organizadas mediante Feature First. |
| `main.dart` | Entrada mínima que delega al bootstrap. |

Crear una ruta solo cuando exista contenido aprobado para ella; no crear carpetas vacías para completar el árbol.

## 8. Estructura de una feature

```text
lib/features/<feature_name>/
├── presentation/
├── domain/
├── data/
└── README.md
```

- `presentation/`: UI, estados, Notifiers y Providers de interacción; depende de Domain.
- `domain/`: entidades, value objects, contratos, políticas y casos de uso; no conoce frameworks ni detalles externos.
- `data/`: data sources, modelos, mappers e implementaciones de repositorios; convierte datos externos al dominio.
- `README.md`: propósito, alcance, contratos públicos, dependencias, estrategia de datos y pruebas de la feature.

Crear subcarpetas solo cuando tengan responsabilidad y contenido reales.

## 9. Flujo de datos

```text
UI
→ Notifier
→ Use Case o contrato de dominio
→ Repository
→ Data Source
→ Isar o Backend
→ Repository
→ Notifier
→ UI
```

La dirección protege al dominio de detalles externos. Los datos se mapean al cruzar límites y los errores se convierten en fallos propios antes de llegar a Presentation.

No crear Use Cases ceremoniales que solo reenvíen llamadas. Son necesarios cuando aportan política, validación, coordinación, reutilización o aislamiento comprobable.

## 10. Comunicación entre features

### 10.1. Mecanismos permitidos

- contrato público de dominio;
- provider público de solo lectura;
- navegación por destino público;
- coordinador transversal en `services/`;
- persistencia con propietario único y acceso mediante contrato.

### 10.2. Prohibiciones

- importar `presentation/` o `data/` de otra feature;
- compartir modelos de persistencia;
- usar Notifiers como servicios de negocio;
- acceder a colecciones propiedad de otro módulo;
- introducir dependencias circulares;
- usar navegación como mecanismo de sincronización de datos.

Si una coordinación no tiene propietario claro, detenerse y solicitar una decisión; no moverla automáticamente a `core/`, `shared/` o `services/`.

## 11. Reglas de estado y navegación

### 11.1. Riverpod

- Notifiers orquestan eventos de Presentation y producen estados inmutables.
- Providers componen e inyectan dependencias y definen su ciclo de vida.
- El estado durable siempre se conserva mediante repositorios.
- `BuildContext` nunca se almacena ni se recibe dentro de Notifiers.
- Los estados inicial, carga, datos, vacío y error se modelan cuando aplican.
- La UI observa el estado mínimo necesario; no usa providers como variables globales mutables.

### 11.2. GoRouter

- Usar rutas declarativas, nombradas y centralmente compuestas.
- Aplicar guards y redirecciones centrales para sesión y onboarding.
- Tratar deep links como entradas no confiables.
- Validar paths, parámetros, permisos y existencia de recursos.
- No usar `Navigator.push` directamente como estrategia principal.
- Transportar datos complejos por identificador, no como estado durable de navegación.

## 12. Persistencia y Offline First

- Isar es la fuente local estructurada para entidades, cache y sincronización.
- SharedPreferences se limita a preferencias pequeñas, simples, no sensibles y no relacionales.
- La UI lee primero desde la fuente local mediante repositorios.
- Una escritura se valida, confirma localmente y genera una operación pendiente cuando requiere sincronización.
- No descartar conflictos silenciosamente ni aplicar una regla global de «último cambio gana».
- Las operaciones reintentables deben ser idempotentes o usar una clave de idempotencia.
- Los estados `local`, `pending`, `synced`, `failed` y `conflict` son visibles cuando correspondan.
- La cola de sincronización no depende de que una pantalla permanezca abierta.
- Los modelos de Isar permanecen en Data y nunca se exponen a Domain o Presentation.

## 13. Backend e IA

Flujo obligatorio:

```text
Flutter
→ FastAPI
→ Google Gemini
```

- Secretos, claves, prompts de sistema y selección de capacidades viven en backend.
- El backend valida identidad, permisos, límites, entradas y pertenencia de recursos.
- Flutter no conoce claves, prompts internos ni modelos propios del proveedor.
- Las respuestas externas se validan y transforman a contratos propios.
- Los resultados de IA son orientativos, potencialmente incorrectos y revisables por el usuario.
- Los fallos externos se normalizan; sus detalles internos no llegan al cliente.
- Los handlers remotos delegan en casos de uso y no concentran reglas ni prompts extensos.

## 14. Seguridad

- Usar HTTPS para toda comunicación remota.
- Mantener tokens fuera de logs, analytics y mensajes de error.
- Aplicar mínimo privilegio a datos, permisos y operaciones.
- Validar en cliente por experiencia y en servidor por seguridad.
- Mantener secretos fuera del repositorio y de assets.
- Solicitar permisos en contexto, con finalidad y alternativa ante rechazo.
- No registrar contenido académico completo ni datos personales innecesarios.
- No exponer stack traces, respuestas internas o errores del proveedor.
- Confirmar acciones destructivas y comunicar consecuencias.
- Verificar autorización por recurso; conocer un identificador no concede acceso.

## 15. Reglas para generación de código por IA

Antes de modificar código, la IA debe:

1. Identificar la feature propietaria.
2. Identificar la capa correcta.
3. Leer el `README.md` de la feature si existe.
4. Revisar dependencias permitidas y contratos públicos.
5. Proponer el cambio mínimo que resuelva el requisito.
6. Incluir pruebas proporcionales al riesgo y a las capas afectadas.
7. Actualizar documentación cuando corresponda.
8. Mostrar los archivos que pretende modificar antes de ampliar el alcance.
9. Detenerse y solicitar aclaración si faltan decisiones.
10. No asumir permiso para cambiar arquitectura.

También debe comprobar el PRD antes de inferir comportamiento y evitar crear estructura futura que la tarea actual no necesita.

## 16. Acciones prohibidas

La IA no debe:

- modificar varios módulos sin justificar alcance e impacto;
- crear utilidades genéricas sin propietario y consumidores reales;
- introducir paquetes nuevos sin autorización;
- cambiar tecnologías aprobadas;
- crear secretos o claves de ejemplo reales;
- mover lógica de negocio a widgets;
- acceder directamente a red o base local desde Presentation;
- borrar archivos sin explicar impacto y obtener autoridad suficiente;
- cambiar el alcance del producto;
- marcar una feature como terminada sin pruebas y documentación;
- duplicar contratos, clientes o fuentes de verdad;
- ocultar una excepción arquitectónica dentro de una implementación.

## 17. Checklist antes de entregar un cambio

- [ ] La feature y la capa propietarias son correctas.
- [ ] La dirección de dependencias cumple la arquitectura.
- [ ] No existen imports internos entre features ni ciclos.
- [ ] Las pruebas cubren comportamiento principal, errores y casos borde relevantes.
- [ ] Los errores externos se transforman y ofrecen recuperación segura.
- [ ] No se introducen secretos, exposición de datos ni permisos innecesarios.
- [ ] Persistencia, sincronización e idempotencia están tratadas cuando aplican.
- [ ] La documentación y el `README.md` afectado están actualizados.
- [ ] El formato y el análisis estático finalizan correctamente.
- [ ] Las pruebas aplicables finalizan correctamente.
- [ ] El impacto sobre otras features está identificado y validado por contratos.
- [ ] Los archivos modificados coinciden con el alcance autorizado.

## 18. Escalamiento de dudas

La IA debe detenerse, explicar el conflicto y solicitar aclaración cuando:

- exista contradicción entre documentos oficiales;
- falte un contrato necesario;
- una solicitud exija cambiar la arquitectura;
- se requiera instalar una dependencia;
- puedan afectarse datos existentes o migraciones;
- cambien permisos, autenticación, autorización o seguridad;
- no esté claro el propietario de una funcionalidad;
- la única solución aparente incumpla una Golden Rule;
- una decisión irreversible exceda el alcance autorizado.

No resolver estas dudas inventando convenciones, excepciones o permisos.

## 19. AI CONTEXT

- Este archivo es un resumen operativo para IA.
- No reemplaza ni modifica la documentación oficial.
- Cualquier contradicción se resuelve a favor de los documentos bajo `docs/`.
- Una IA no puede aprobar sus propios cambios arquitectónicos.
- Las omisiones requieren consultar las fuentes de verdad; no autorizan inferencias libres.
- Una decisión arquitectónica nueva exige propuesta explícita y aprobación humana previa.

## 20. Historial de cambios

| Versión | Fecha | Estado | Descripción | Autor |
| --- | --- | --- | --- | --- |
| 1.0.0 | 11 de julio de 2026 | Approved | Creación del contexto arquitectónico operativo para IA de Focusly. | Equipo Focusly |
