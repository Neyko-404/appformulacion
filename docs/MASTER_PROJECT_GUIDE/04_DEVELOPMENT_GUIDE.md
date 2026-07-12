# Guía oficial de desarrollo de Focusly

| Campo | Valor |
| --- | --- |
| Documento | `04_DEVELOPMENT_GUIDE.md` |
| Proyecto | Focusly |
| Versión | 1.0.0 |
| Estado | Approved |
| Última actualización | 11 de julio de 2026 |
| Autor | Equipo Focusly |
| Responsable técnico | Gary Nivin Quispe |

## Índice

1. [Objetivo](#1-objetivo)
2. [Filosofía de desarrollo](#2-filosofía-de-desarrollo)
3. [Flujo oficial de desarrollo](#3-flujo-oficial-de-desarrollo)
4. [Git Workflow](#4-git-workflow)
5. [Convención de commits](#5-convención-de-commits)
6. [Pull Request Workflow](#6-pull-request-workflow)
7. [Code Review Standards](#7-code-review-standards)
8. [Desarrollo de features](#8-desarrollo-de-features)
9. [Documentación obligatoria](#9-documentación-obligatoria)
10. [Estrategia de testing](#10-estrategia-de-testing)
11. [Definition of Ready](#11-definition-of-ready)
12. [Definition of Done](#12-definition-of-done)
13. [Quality Gates](#13-quality-gates)
14. [Manejo de deuda técnica](#14-manejo-de-deuda-técnica)
15. [Manejo de incidencias](#15-manejo-de-incidencias)
16. [Reglas para colaboración con IA](#16-reglas-para-colaboración-con-ia)
17. [Checklist antes del merge](#17-checklist-antes-del-merge)
18. [Checklist antes del release](#18-checklist-antes-del-release)
19. [Roadmap de desarrollo](#19-roadmap-de-desarrollo)
20. [Referencias](#20-referencias)
21. [AI CONTEXT](#21-ai-context)
22. [Historial de cambios](#22-historial-de-cambios)

## 1. Objetivo

Definir la forma oficial de planificar, implementar, validar, revisar, integrar y liberar cambios en Focusly. Esta guía establece reglas de trabajo verificables para desarrolladores humanos y asistentes de IA.

El documento regula el proceso de ingeniería. El alcance funcional y las decisiones técnicas pertenecen a sus fuentes oficiales y no se redefinen aquí.

## 2. Filosofía de desarrollo

### 2.1. Simplicidad

Resolver el problema aprobado con el menor cambio completo. No crear generalizaciones, capas o configuraciones para necesidades hipotéticas.

### 2.2. Mantenibilidad

El código debe revelar intención, conservar límites claros y permitir que otra persona comprenda el cambio sin depender de conversaciones privadas. Toda decisión no evidente debe quedar documentada en su fuente adecuada.

### 2.3. Calidad integrada

La calidad se construye durante el trabajo. Pruebas, seguridad, accesibilidad, manejo de errores y documentación no son actividades opcionales al final de una tarea.

### 2.4. Documentación primero

Antes de implementar, confirmar que el comportamiento esperado y las restricciones están aprobados. Si falta una decisión, documentarla y obtener revisión antes de convertirla en código.

### 2.5. Cambios pequeños

Cada cambio debe tener un propósito principal, un diff revisable y una vía clara de reversión. Un cambio grande se divide por resultados verificables, sin dejar estados intermedios inseguros.

### 2.6. Evolución continua

Mejorar mediante ciclos breves de evidencia, revisión y aprendizaje. La evolución no autoriza ampliar alcance ni posponer indefinidamente deuda conocida.

## 3. Flujo oficial de desarrollo

```text
Idea
  ↓
Requisitos
  ↓
Arquitectura
  ↓
Implementación
  ↓
Testing
  ↓
Documentación
  ↓
Review
  ↓
Merge
  ↓
Release
```

| Etapa | Resultado exigido |
| --- | --- |
| Idea | Problema y valor esperado expresados sin asumir una solución. |
| Requisitos | Alcance, prioridad y criterios de aceptación aprobados. |
| Arquitectura | Propietario, límites y dependencias confirmados; decisión nueva aprobada cuando corresponda. |
| Implementación | Cambio mínimo completo, legible y alineado con las fuentes oficiales. |
| Testing | Evidencia automatizada y manual proporcional al riesgo. |
| Documentación | Fuentes y guías afectadas actualizadas en el mismo cambio. |
| Review | Observaciones técnicas y funcionales resueltas. |
| Merge | Quality Gates aprobados y trazabilidad completa. |
| Release | Artefacto validado, cambios comunicados y recuperación preparada. |

No se omiten etapas; pueden combinarse dentro de una tarea pequeña si sus evidencias siguen siendo identificables.

## 4. Git Workflow

### 4.1. Ramas oficiales

| Rama | Propósito | Origen habitual | Destino |
| --- | --- | --- | --- |
| `main` | Estado liberable y versiones publicadas. | `develop` o `hotfix/*`. | Release; no recibe trabajo directo. |
| `develop` | Integración del próximo conjunto de cambios. | `main` y ramas de trabajo. | `main` mediante PR de release. |
| `feature/*` | Nueva capacidad aprobada. | `develop`. | `develop`. |
| `bugfix/*` | Corrección no urgente de un defecto. | `develop`. | `develop`. |
| `hotfix/*` | Corrección urgente de una versión liberada. | `main`. | `main` y posteriormente `develop`. |
| `docs/*` | Cambio exclusivo de documentación. | `develop`, salvo corrección de release. | Rama de origen. |
| `refactor/*` | Mejora interna sin cambio funcional intencional. | `develop`. | `develop`. |
| `chore/*` | Mantenimiento, configuración o preparación del repositorio. | `develop` o `main` según alcance. | Rama de origen aprobada. |

### 4.2. Nombres de ramas

Formato:

```text
<tipo>/<identificador-opcional>-<descripcion-breve>
```

Reglas:

- usar minúsculas y guiones;
- describir un único propósito;
- incluir el identificador de trabajo cuando exista;
- evitar nombres personales, fechas sin contexto y términos como `temp` o `misc`.

Ejemplos:

```text
feature/142-approved-workflow
bugfix/205-invalid-state
docs/update-development-guide
```

### 4.3. Integración

- Toda integración a `develop` o `main` se realiza mediante Pull Request.
- Se prefiere squash merge para que el cambio integrado sea una unidad coherente.
- La rama se actualiza con su destino antes del merge y resuelve conflictos de forma explícita.
- No se reescribe historia compartida sin coordinación.
- Las ramas se eliminan después de integrarse.
- Un hotfix integrado en `main` se incorpora también a `develop` para evitar regresiones.

## 5. Convención de commits

Focusly adopta Conventional Commits.

### 5.1. Formato

```text
<tipo>(<alcance>): <descripcion>

[cuerpo opcional]

[pie opcional]
```

### 5.2. Tipos

| Tipo | Uso |
| --- | --- |
| `feat` | Incorpora comportamiento aprobado. |
| `fix` | Corrige comportamiento defectuoso. |
| `docs` | Modifica únicamente documentación. |
| `refactor` | Cambia estructura interna sin alterar comportamiento esperado. |
| `test` | Añade o corrige pruebas. |
| `style` | Ajusta formato sin cambiar comportamiento. |
| `perf` | Mejora rendimiento con evidencia. |
| `build` | Cambia proceso de construcción o dependencias autorizadas. |
| `ci` | Cambia automatización de integración o entrega. |
| `chore` | Realiza mantenimiento que no encaja en los tipos anteriores. |

### 5.3. Reglas y ejemplos

- Escribir la descripción en imperativo, minúscula y sin punto final.
- Mantener el asunto breve y explicar el motivo en el cuerpo cuando no sea evidente.
- Usar un alcance estable y reconocible.
- Indicar cambios incompatibles con `!` y explicar su impacto en el pie.
- No mezclar propósitos distintos en un commit.

```text
feat(module): add approved state transition
fix(sync): preserve pending change after retry
docs(guide): clarify review requirements
test(module): cover rejected input
refactor(core): remove duplicated mapping
```

## 6. Pull Request Workflow

### 6.1. Antes de abrir el PR

1. Confirmar que la tarea cumple Definition of Ready.
2. Mantener la rama enfocada y actualizada.
3. Revisar el diff completo, incluidos archivos generados.
4. Ejecutar los Quality Gates aplicables.
5. Completar pruebas y documentación.
6. Eliminar código temporal, secretos y logs de diagnóstico.

### 6.2. Contenido obligatorio

Todo PR debe incluir:

- problema y objetivo;
- fuente del requisito o incidencia;
- alcance incluido y excluido;
- archivos o módulos afectados;
- decisiones relevantes y alternativas descartadas cuando aplique;
- evidencia de pruebas y validación manual;
- riesgos, migraciones y forma de reversión;
- cambios documentales;
- capturas o registros solo si aportan evidencia y no contienen datos sensibles.

### 6.3. Revisión y cierre

- Solicitar revisión a responsables del área afectada.
- Clasificar observaciones como bloqueantes, recomendadas o preguntas.
- Resolver cada conversación con cambio, explicación verificable o acuerdo explícito.
- Reejecutar gates después de cambios relevantes.
- Obtener la aprobación requerida antes del merge.

### 6.4. Prohibiciones

- no autoaprobar cambios propios;
- no mezclar refactors no relacionados;
- no ocultar fallos mediante excepciones o desactivación de validaciones;
- no forzar el merge con gates fallidos;
- no introducir archivos, paquetes o cambios de alcance no declarados;
- no resolver observaciones sin evidencia cuando afectan seguridad o comportamiento.

## 7. Code Review Standards

La revisión evalúa el cambio, no a su autor.

### 7.1. Arquitectura

- propietario y capa correctos;
- dependencias permitidas y ausencia de ciclos;
- contratos mínimos y responsabilidades separadas;
- ausencia de decisiones técnicas no aprobadas.

### 7.2. Legibilidad

- nombres expresan intención;
- funciones y tipos tienen responsabilidad acotada;
- comentarios explican motivos, no repiten código;
- no existe duplicación evitable ni abstracción prematura.

### 7.3. Seguridad

- entradas y permisos se validan;
- no aparecen secretos ni datos sensibles;
- errores no exponen detalles internos;
- acciones destructivas y migraciones tienen protección y recuperación.

### 7.4. Rendimiento

- no se introduce trabajo repetido o no acotado sin justificación;
- operaciones costosas tienen ciclo de vida y cancelación adecuados;
- una optimización incluye medición antes y después.

### 7.5. Documentación

- fuentes afectadas están actualizadas;
- nombres, ejemplos y comandos siguen vigentes;
- decisiones y excepciones tienen trazabilidad.

### 7.6. Pruebas

- criterios de aceptación tienen evidencia;
- se cubren rutas principal, error y borde relevantes;
- las pruebas son deterministas, legibles y prueban comportamiento;
- no se reduce protección existente sin justificación aprobada.

## 8. Desarrollo de features

1. **Analizar:** identificar requisito, prioridad, criterios, exclusiones y personas afectadas.
2. **Delimitar:** definir feature propietaria, dependencias y módulos impactados.
3. **Confirmar readiness:** aplicar la sección 11 y escalar vacíos.
4. **Diseñar el cambio:** proponer contratos, estados, errores y datos sin ampliar alcance.
5. **Planificar pruebas:** mapear criterios a pruebas antes de implementar.
6. **Crear rama:** usar `feature/*` con un propósito único.
7. **Implementar verticalmente:** completar el recorrido mínimo por incrementos verificables.
8. **Validar continuamente:** ejecutar pruebas cercanas al cambio y revisar errores.
9. **Documentar:** actualizar README, feature docs, ADR o changelog cuando corresponda.
10. **Auto-revisar:** comprobar diff, seguridad, dependencias y Definition of Done.
11. **Abrir PR:** aportar contexto, evidencia, riesgos y reversión.
12. **Atender review:** resolver observaciones y repetir gates.
13. **Integrar:** realizar merge solo con aprobaciones y gates correctos.
14. **Verificar:** confirmar el comportamiento integrado y registrar incidencias nuevas.

## 9. Documentación obligatoria

| Artefacto | Cuándo actualizarlo |
| --- | --- |
| `README.md` de feature | Al crear la feature o cambiar propósito, contratos, dependencias, estados o estrategia de datos. |
| ADR | Cuando se proponga una decisión técnica relevante, alternativa con impacto o excepción aprobada. |
| Feature Docs | Cuando el comportamiento necesite detalle operativo adicional al requisito maestro. |
| Changelog | Cuando el cambio sea visible en una versión o afecte compatibilidad, operación o migración. |
| Documentos maestros | Cuando cambie una decisión que les pertenezca, después de obtener aprobación. |

Reglas:

- Documentación y código relacionado viajan en el mismo PR.
- Un ADR registra contexto, decisión, alternativas, consecuencias, estado y fecha.
- No usar un README o ADR para contradecir una fuente maestra.
- No crear documentos vacíos ni duplicar contenido; enlazar la fuente oficial.
- Las rutas o artefactos aún no definidos requieren aclaración antes de crearse.

## 10. Estrategia de testing

### 10.1. Unit Test

Valida una unidad de comportamiento aislada: reglas, transformaciones, estados y contratos. Debe ser rápido, determinista y no depender de red, reloj real o datos compartidos.

### 10.2. Widget Test

Valida comportamiento de componentes: estados visibles, interacción, accesibilidad y respuesta a dependencias controladas. Debe probar resultados observables, no detalles privados.

### 10.3. Integration Test

Valida recorridos que atraviesan componentes o límites reales. Se reserva para contratos, persistencia, sincronización, navegación y journeys cuyo riesgo no queda cubierto por pruebas aisladas.

### 10.4. Smoke Test

Confirma que el artefacto inicia y que sus recorridos críticos básicos están disponibles en el entorno objetivo. No sustituye pruebas funcionales detalladas.

### 10.5. Cobertura

- No se utiliza un porcentaje aislado como definición de calidad.
- Todo criterio de aceptación debe tener evidencia automatizada o una justificación documentada.
- Las reglas de negocio, errores, permisos, migraciones y conflictos requieren cobertura proporcional a su riesgo.
- Un defecto corregido debe incorporar una prueba que falle antes del arreglo cuando sea reproducible.
- La cobertura no debe disminuir en el código modificado sin justificación y aprobación.
- Se prioriza comportamiento significativo sobre líneas ejecutadas accidentalmente.

## 11. Definition of Ready

Una tarea está lista para comenzar cuando:

- [ ] problema, objetivo y valor están claros;
- [ ] alcance incluido y excluido están definidos;
- [ ] existe requisito o incidencia trazable;
- [ ] criterios de aceptación son verificables;
- [ ] prioridad y responsable están definidos;
- [ ] feature y capa propietarias están identificadas;
- [ ] dependencias, datos y permisos están conocidos;
- [ ] decisiones necesarias están aprobadas;
- [ ] riesgos y casos borde principales están identificados;
- [ ] estrategia de pruebas es viable;
- [ ] no existe un bloqueo externo sin plan de resolución.

Si falta un elemento que cambie alcance o solución, la tarea vuelve a análisis.

## 12. Definition of Done

Una tarea está terminada cuando:

- [ ] satisface todos los criterios de aceptación;
- [ ] respeta arquitectura y alcance aprobados;
- [ ] código y nombres son legibles;
- [ ] errores y casos borde relevantes están tratados;
- [ ] seguridad, privacidad y accesibilidad aplicables están validadas;
- [ ] pruebas requeridas existen y pasan;
- [ ] no quedan logs temporales, secretos ni código muerto;
- [ ] documentación y trazabilidad están actualizadas;
- [ ] Quality Gates pasan en local y automatización;
- [ ] review está aprobado y conversaciones resueltas;
- [ ] migración y reversión están verificadas cuando aplican;
- [ ] el cambio integrado fue comprobado en el entorno correspondiente.

## 13. Quality Gates

### 13.1. Validaciones mínimas

```powershell
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

Además:

- ejecutar pruebas de integración cuando el alcance cruce límites o journeys;
- validar que la documentación y enlaces modificados sean correctos;
- ejecutar escaneo de secretos y verificaciones de dependencias;
- revisar migraciones, permisos y seguridad cuando apliquen;
- confirmar que no existen cambios inesperados en archivos generados;
- obtener las aprobaciones requeridas.

### 13.2. Política de gates

- Un gate obligatorio fallido bloquea el merge.
- Un fallo intermitente se investiga; no se normaliza reejecutándolo hasta que pase.
- Una excepción requiere causa, riesgo, responsable, vencimiento y aprobación.
- La evidencia se adjunta o enlaza en el PR.

## 14. Manejo de deuda técnica

### 14.1. Registro

Toda deuda identificada se registra con:

- contexto y causa;
- ubicación y alcance;
- riesgo actual y futuro;
- impacto en seguridad, calidad o velocidad;
- solución propuesta y alternativas;
- esfuerzo estimado, dependencias y responsable;
- fecha o condición de revisión.

No ocultar deuda con comentarios vagos. Un `TODO` debe enlazar un registro trazable.

### 14.2. Priorización

Priorizar por riesgo y costo de demora: seguridad y pérdida de datos; bloqueos de release; defectos recurrentes; fricción significativa; mantenibilidad; optimización opcional.

### 14.3. Resolución

- incluir deuda relacionada dentro del cambio si es pequeña y reduce riesgo;
- planificar deuda amplia como tarea independiente;
- añadir pruebas antes de refactors de riesgo;
- resolver por incrementos reversibles;
- cerrar el registro solo con evidencia y documentación actualizada.

## 15. Manejo de incidencias

### 15.1. Bug

Reproducir, clasificar severidad, identificar alcance, crear prueba de regresión, corregir la causa mínima, validar impactos y procesar mediante `bugfix/*`.

### 15.2. Mejora

Registrar problema y valor, contrastar con alcance aprobado, definir criterios y prioridad. Si cambia comportamiento comprometido, pasar por requisitos antes de implementar.

### 15.3. Refactor

Definir objetivo interno y evidencia de comportamiento preservado. Usar `refactor/*`, limitar alcance y separar cualquier cambio funcional descubierto.

### 15.4. Hotfix

1. Confirmar impacto urgente en producción.
2. Crear `hotfix/*` desde `main`.
3. Aplicar la corrección mínima y prueba de regresión.
4. Ejecutar gates y revisión acelerada, nunca omitida.
5. Integrar en `main`, liberar y verificar.
6. Incorporar el cambio a `develop`.
7. Completar análisis de causa y acciones preventivas.

Toda incidencia grave conserva cronología, impacto, mitigación, causa, recuperación y aprendizaje sin buscar culpables.

## 16. Reglas para colaboración con IA

### 16.1. Lectura obligatoria

Antes de actuar, una IA lee los documentos maestros aplicables, `.ai/ARCHITECT_CONTEXT.md`, el README de la feature y las instrucciones locales del repositorio.

### 16.2. Forma de trabajo

1. Declarar objetivo, alcance y archivos previstos.
2. Identificar requisito, propietario y capa.
3. Inspeccionar el estado actual antes de editar.
4. Proponer el cambio mínimo.
5. Preservar cambios existentes ajenos.
6. Implementar y probar en proporción al riesgo.
7. Revisar el diff y comunicar resultados verificables.

### 16.3. Límites

Una IA no puede inventar requisitos, cambiar arquitectura, instalar dependencias, ampliar archivos, eliminar datos, aprobar sus propios cambios ni declarar pruebas que no ejecutó. Debe distinguir hechos, inferencias y asuntos pendientes.

### 16.4. Aclaraciones y propuestas

Solicitar aclaración cuando falten decisiones, exista contradicción, cambie el alcance o se requiera autoridad nueva. Una propuesta debe incluir problema, opciones, impacto, riesgo, reversibilidad y recomendación; no debe implementarse antes de aprobación cuando altera una decisión vigente.

## 17. Checklist antes del merge

- [ ] El PR tiene propósito único y trazabilidad.
- [ ] El diff fue revisado por el autor.
- [ ] Alcance y archivos coinciden con lo declarado.
- [ ] Definition of Ready y Definition of Done se cumplen.
- [ ] Arquitectura y dependencias fueron verificadas.
- [ ] Pruebas aplicables pasan y aportan evidencia.
- [ ] Formato y análisis pasan.
- [ ] Seguridad, privacidad, accesibilidad y rendimiento aplicables fueron revisados.
- [ ] No existen secretos, logs temporales o cambios generados inesperados.
- [ ] Documentación, ADR y changelog están actualizados cuando corresponde.
- [ ] Migración y reversión están preparadas cuando aplican.
- [ ] Conversaciones de review están resueltas.
- [ ] Aprobaciones requeridas están registradas.
- [ ] La rama está actualizada y sin conflictos.

## 18. Checklist antes del release

- [ ] Alcance de la versión está cerrado y aprobado.
- [ ] Todos los cambios están integrados desde ramas autorizadas.
- [ ] Pipeline completo y smoke tests pasan sobre el artefacto candidato.
- [ ] Defectos conocidos tienen severidad, decisión y responsable.
- [ ] Migraciones fueron probadas con datos representativos y recuperación.
- [ ] Configuración del entorno fue validada sin exponer secretos.
- [ ] Permisos, autenticación y controles de seguridad fueron comprobados.
- [ ] Rendimiento y estabilidad cumplen los gates vigentes.
- [ ] Notas de versión y changelog describen cambios relevantes.
- [ ] Monitoreo, alertas y responsables de respuesta están preparados.
- [ ] Plan de despliegue, verificación y rollback fue ensayado o revisado.
- [ ] Versión y etiqueta son coherentes y trazables al commit.
- [ ] La aprobación de release está registrada.
- [ ] La verificación posterior tiene criterios y ventana definidos.

## 19. Roadmap de desarrollo

### 19.1. Fundación

Establecer documentación, repositorio, convenciones, automatización y gates mínimos. El objetivo es que todo cambio posterior sea reproducible y revisable.

### 19.2. Construcción controlada

Desarrollar incrementos pequeños con trazabilidad, pruebas cercanas y revisión frecuente. Medir fricción del proceso y corregir causas, no solo síntomas.

### 19.3. Integración y estabilización

Fortalecer pruebas de límites, manejo de fallos, migraciones, seguridad y observabilidad. Reducir deuda que comprometa releases repetibles.

### 19.4. Entrega repetible

Automatizar validaciones y liberaciones con controles, rollback y evidencia. Mantener separación entre construir, aprobar y liberar.

### 19.5. Escalamiento del equipo

Distribuir propiedad, reducir conocimiento implícito y revisar estándares con evidencia. El crecimiento debe mejorar autonomía sin debilitar calidad ni gobernanza.

Las etapas describen madurez de ingeniería, no funcionalidades ni fechas.

## 20. Referencias

- [Estándar oficial de documentación](./00_DOCUMENTATION_STANDARD.md)
- [Visión del proyecto](./01_PROJECT_VISION.md)
- [Requisitos del producto](./02_PRODUCT_REQUIREMENTS.md)
- [Arquitectura del sistema](./03_SYSTEM_ARCHITECTURE.md)
- [Contexto arquitectónico operativo para IA](../../.ai/ARCHITECT_CONTEXT.md)

## 21. AI CONTEXT

- **Cómo utilizar este documento:** aplicar sus flujos, gates, definiciones y checklists al planificar o ejecutar cualquier cambio de ingeniería.
- **Qué puede inferir una IA:** pasos de trabajo, evidencias requeridas, tipo de rama, documentación aplicable y validaciones mínimas según el riesgo y alcance confirmados.
- **Qué no puede inferir:** requisitos, decisiones técnicas, permisos para ampliar alcance, excepciones, aprobaciones, resultados de pruebas no ejecutadas ni autoridad para hacer merge o release.
- **Qué consultar:** estándar documental, visión, PRD, arquitectura, `.ai/ARCHITECT_CONTEXT.md`, README de la feature e instrucciones locales aplicables.
- **Precedencia:** si esta guía entra en conflicto con una fuente maestra, detenerse y solicitar resolución; no modificar unilateralmente ninguna fuente.

## 22. Historial de cambios

| Versión | Fecha | Estado | Descripción | Autor |
| --- | --- | --- | --- | --- |
| 1.0.0 | 11 de julio de 2026 | Approved | Creación y aprobación inicial de la guía oficial de desarrollo de Focusly. | Equipo Focusly |
