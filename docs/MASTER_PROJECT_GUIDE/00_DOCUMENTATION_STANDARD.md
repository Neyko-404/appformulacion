# Estándar oficial de documentación

| Campo | Valor |
| --- | --- |
| Documento | `00_DOCUMENTATION_STANDARD.md` |
| Proyecto | Focusly |
| Versión | 1.0.0 |
| Estado | Approved |
| Última actualización | 11 de julio de 2026 |
| Autor | Equipo Focusly |
| Responsable técnico | Por definir |

## Índice

1. [Objetivo](#1-objetivo)
2. [Alcance](#2-alcance)
3. [Filosofía de documentación](#3-filosofía-de-documentación)
4. [Convenciones de nombres de archivos](#4-convenciones-de-nombres-de-archivos)
5. [Convenciones de escritura y Markdown](#5-convenciones-de-escritura-y-markdown)
6. [Versionado semántico de documentos](#6-versionado-semántico-de-documentos)
7. [Estados de los documentos](#7-estados-de-los-documentos)
8. [Referencias cruzadas](#8-referencias-cruzadas)
9. [Reglas para AI CONTEXT](#9-reglas-para-ai-context)
10. [Plantilla oficial reutilizable](#10-plantilla-oficial-reutilizable)
11. [Checklist de calidad](#11-checklist-de-calidad)
12. [Proceso de revisión](#12-proceso-de-revisión)
13. [Referencias](#13-referencias)
14. [AI CONTEXT](#14-ai-context)
15. [Historial de cambios](#15-historial-de-cambios)

## 1. Objetivo

Establecer el estándar oficial para crear, revisar, aprobar, mantener y retirar la documentación de Focusly. Su aplicación busca que cada documento sea comprensible, consistente, trazable y útil como fuente de trabajo para personas y sistemas de inteligencia artificial.

## 2. Alcance

Este estándar se aplica a todos los documentos Markdown mantenidos como documentación oficial de Focusly, incluidos los documentos del directorio `docs/MASTER_PROJECT_GUIDE/` y los que se incorporen posteriormente al repositorio.

El estándar regula:

- la identificación y estructura de los documentos;
- los nombres de archivo;
- la escritura y el formato Markdown;
- el versionado y los estados;
- las referencias cruzadas;
- el contexto destinado a inteligencia artificial;
- la revisión, aprobación y trazabilidad de cambios.

Los archivos generados automáticamente y la documentación externa enlazada desde el repositorio quedan fuera de este alcance, salvo que se adopten expresamente como documentación oficial.

## 3. Filosofía de documentación

### 3.1. Claridad

Cada documento debe expresar su propósito, alcance, decisiones y restricciones con lenguaje directo. Los términos especializados deben definirse cuando aparezcan por primera vez y no deben utilizarse expresiones ambiguas como «según corresponda» sin explicar el criterio aplicable.

### 3.2. Consistencia

Los documentos deben aplicar las mismas convenciones de estructura, terminología, estado, versión, fechas y referencias. Un mismo concepto debe conservar el mismo nombre en todo el conjunto documental.

### 3.3. Mantenibilidad

La información debe organizarse en secciones con responsabilidades claras, evitando duplicar contenido que ya tenga una fuente oficial. Los cambios deben quedar registrados y las decisiones obsoletas deben marcarse, no ocultarse.

### 3.4. Utilidad para humanos e IA

La documentación debe poder leerse de forma autónoma por integrantes del equipo y utilizarse como contexto fiable por sistemas de inteligencia artificial. Para ello debe distinguir hechos confirmados, decisiones, restricciones, supuestos y asuntos pendientes.

## 4. Convenciones de nombres de archivos

Los documentos oficiales deben cumplir estas reglas:

- usar la extensión `.md` en minúsculas;
- usar nombres descriptivos en inglés, escritos en mayúsculas y separados por guion bajo;
- evitar espacios, tildes, caracteres especiales y nombres genéricos;
- usar un prefijo numérico de dos dígitos cuando exista un orden de lectura;
- mantener estable el nombre una vez publicado; si debe cambiar, actualizar todas sus referencias.

Formato recomendado:

```text
NN_DOCUMENT_NAME.md
```

Ejemplos válidos:

- `00_DOCUMENTATION_STANDARD.md`
- `01_PROJECT_VISION.md`
- `02_PRODUCT_REQUIREMENTS.md`

Los anexos pueden añadir un sufijo descriptivo, siempre que conserven la relación con el documento principal.

## 5. Convenciones de escritura y Markdown

### 5.1. Idioma y estilo

- Escribir en español profesional, claro y conciso.
- Utilizar voz activa cuando facilite la comprensión.
- Evitar redundancias, lenguaje promocional y afirmaciones no verificadas.
- Definir siglas y términos técnicos en su primera aparición.
- Expresar obligaciones con «debe», recomendaciones con «debería» y opciones con «puede».
- Marcar explícitamente los asuntos pendientes con `PENDIENTE:` y una descripción concreta.

### 5.2. Encabezados y numeración

- Usar un único encabezado de nivel 1 (`#`) para el título del documento.
- Usar nivel 2 (`##`) para el índice y para las secciones principales.
- Numerar consecutivamente las secciones de contenido; el índice no se numera.
- Usar nivel 3 (`###`) para subsecciones, con numeración jerárquica cuando aporte claridad.
- No omitir niveles de encabezado.
- Evitar encabezados duplicados dentro del mismo documento.

### 5.3. Elementos Markdown

- Dejar una línea en blanco antes y después de encabezados, listas, tablas y bloques de código.
- Usar listas con guion para elementos sin orden y listas numeradas para secuencias.
- Incluir lenguaje en los bloques de código cuando sea aplicable.
- Usar tablas solo cuando faciliten una comparación o una estructura repetitiva.
- Usar texto de enlace descriptivo; evitar «aquí» o direcciones sin contexto.
- Escribir rutas, nombres de archivo, comandos y símbolos técnicos entre comillas invertidas.
- Evitar HTML si Markdown ofrece una alternativa suficiente.

### 5.4. Fechas y metadatos

- Escribir fechas completas con el formato `DD de mes de AAAA`.
- Mantener la versión sin prefijos, por ejemplo `1.2.0`.
- Usar exactamente uno de los estados definidos en la sección 7.
- Identificar funciones institucionales cuando el nombre de una persona no esté confirmado.

## 6. Versionado semántico de documentos

Cada documento oficial debe utilizar el formato `MAJOR.MINOR.PATCH`:

- `MAJOR`: cambia el propósito, alcance, estructura normativa o una decisión fundamental de forma incompatible con la versión anterior.
- `MINOR`: añade contenido, decisiones o secciones compatibles con lo ya aprobado.
- `PATCH`: corrige redacción, formato, referencias o errores sin alterar el significado aprobado.

Reglas adicionales:

- la primera versión aprobada es `1.0.0`;
- una versión en Draft o Review puede comenzar en `0.x.y`;
- todo incremento debe registrarse en el historial de cambios;
- no se reutiliza una versión publicada para contenido diferente;
- un cambio de estado sin cambio de contenido no exige incrementar la versión, pero debe registrarse si afecta la trazabilidad.

## 7. Estados de los documentos

| Estado | Significado | Uso permitido |
| --- | --- | --- |
| Draft | Documento en elaboración; puede contener vacíos o decisiones pendientes. | Consulta y edición de trabajo. |
| Review | Contenido completo propuesto para revisión formal. | Validación y comentarios; no es aún norma definitiva. |
| Approved | Documento revisado y aceptado como fuente oficial vigente. | Uso normativo y operativo. |
| Deprecated | Documento retirado o sustituido que se conserva por trazabilidad. | Consulta histórica; no debe guiar trabajo nuevo. |

Un documento Deprecated debe indicar al inicio cuál es su reemplazo, cuando exista. Solo una versión Approved y no Deprecated debe considerarse la fuente vigente de una misma materia.

## 8. Referencias cruzadas

Las referencias deben apuntar a una fuente concreta y verificable:

- utilizar enlaces Markdown relativos para archivos del repositorio;
- enlazar preferentemente al documento oficial que sea fuente del contenido;
- usar anclas de sección cuando la referencia dependa de un apartado específico;
- comprobar el destino y el ancla antes de aprobar el documento;
- actualizar enlaces cuando se renombre o retire un documento;
- no duplicar una regla: resumirla solo si es necesario y enlazar su fuente oficial;
- identificar las referencias aún inexistentes como `PENDIENTE:` en lugar de crear enlaces rotos.

Ejemplo:

```markdown
Consulta [Visión del proyecto](./01_PROJECT_VISION.md).
```

## 9. Reglas para AI CONTEXT

Todo documento oficial debe incluir una única sección principal titulada `AI CONTEXT`, ubicada inmediatamente antes del historial de cambios.

La sección debe:

- resumir el propósito del documento;
- indicar qué información constituye una decisión o restricción vigente;
- declarar dependencias documentales necesarias para interpretar el contenido;
- enumerar los asuntos pendientes o ambigüedades conocidas;
- definir qué puede proponer o modificar una IA;
- definir qué requiere autorización humana explícita;
- prohibir que se presenten inferencias como decisiones confirmadas;
- evitar secretos, datos personales e instrucciones ajenas al propósito documental.

El contexto debe ser breve, operativo y coherente con el cuerpo del documento. No reemplaza las secciones normativas ni puede introducir decisiones nuevas.

## 10. Plantilla oficial reutilizable

La siguiente plantilla define el orden mínimo. Los marcadores entre llaves deben sustituirse por contenido real y eliminarse antes de pasar el documento a Review.

```markdown
# {{TÍTULO}}

| Campo | Valor |
| --- | --- |
| Documento | `{{NOMBRE_ARCHIVO}}` |
| Proyecto | Focusly |
| Versión | {{VERSIÓN}} |
| Estado | {{ESTADO}} |
| Última actualización | {{FECHA}} |
| Autor | {{AUTOR}} |
| Responsable técnico | {{RESPONSABLE_TÉCNICO}} |

{{ÍNDICE}}

{{SECCIONES_NUMERADAS}}

{{REFERENCIAS}}

{{SECCIÓN_AI_CONTEXT}}

{{HISTORIAL_DE_CAMBIOS}}
```

Un documento puede añadir secciones necesarias para su materia, pero debe conservar los metadatos, el índice, las referencias, el contexto para IA y el historial de cambios.

## 11. Checklist de calidad

Antes de cambiar un documento a Review o Approved, se debe comprobar:

- [ ] El título y el nombre de archivo describen el contenido.
- [ ] Los siete metadatos obligatorios están completos.
- [ ] El índice coincide con las secciones y sus enlaces funcionan.
- [ ] La numeración es continua y jerárquicamente correcta.
- [ ] Existe un solo encabezado de nivel 1.
- [ ] No existen secciones principales duplicadas.
- [ ] El lenguaje es profesional, claro y consistente.
- [ ] Los términos, siglas y estados están definidos.
- [ ] Las decisiones se distinguen de supuestos y pendientes.
- [ ] No se afirman tecnologías o compromisos no confirmados.
- [ ] No existe contenido duplicado o contradictorio.
- [ ] Las referencias relativas y sus anclas son válidas.
- [ ] Existe una única sección AI CONTEXT antes del historial.
- [ ] Existe un único historial de cambios y contiene la versión actual.
- [ ] No hay secretos, credenciales ni datos personales innecesarios.
- [ ] El Markdown es válido y legible como texto sin renderizar.

## 12. Proceso de revisión

1. **Redacción:** el autor crea o actualiza el documento en estado Draft y completa sus metadatos.
2. **Autoevaluación:** el autor aplica el checklist de calidad y corrige los hallazgos.
3. **Solicitud de revisión:** el documento pasa a Review con una versión propuesta y un resumen de cambios.
4. **Revisión funcional:** una persona conocedora del propósito valida alcance, exactitud y coherencia con las necesidades confirmadas.
5. **Revisión técnica:** el responsable técnico valida decisiones, restricciones, referencias e impacto sobre otros documentos.
6. **Resolución:** el autor atiende observaciones y vuelve a ejecutar el checklist.
7. **Aprobación:** la autoridad responsable cambia el estado a Approved y registra la aprobación en el historial.
8. **Mantenimiento:** cualquier cambio posterior repite el proceso en proporción a su impacto.
9. **Retiro:** si el documento deja de ser vigente, cambia a Deprecated e identifica su reemplazo cuando corresponda.

Una misma persona puede cubrir más de una función cuando el equipo así lo determine, pero la responsabilidad de aprobación debe quedar explícita.

## 13. Referencias

- [Visión del proyecto](./01_PROJECT_VISION.md)
- [Requisitos del producto](./02_PRODUCT_REQUIREMENTS.md)
- [Arquitectura del sistema](./03_SYSTEM_ARCHITECTURE.md)
- [CommonMark Specification](https://spec.commonmark.org/)
- [Semantic Versioning 2.0.0](https://semver.org/)

Las referencias externas se incluyen únicamente como base de las convenciones de Markdown y versionado. Las decisiones específicas de Focusly se rigen por este documento y por los documentos oficiales relacionados.

## 14. AI CONTEXT

- **Propósito:** definir las reglas oficiales para crear y mantener documentación de Focusly.
- **Fuente vigente:** esta versión `1.0.0`, en estado Approved, es normativa para los documentos oficiales mientras no sea reemplazada o marcada como Deprecated.
- **Uso requerido:** una IA debe aplicar estas convenciones antes de proponer o modificar documentación del proyecto.
- **Permitido:** detectar inconsistencias, enlaces rotos, duplicaciones, omisiones y proponer mejoras compatibles con este estándar.
- **Requiere autorización:** cambiar reglas normativas, estados aprobados, decisiones del proyecto o responsabilidades identificadas.
- **Restricción:** no inventar tecnologías, requisitos, responsables, aprobaciones ni fechas. Toda inferencia debe marcarse como tal o como pendiente.
- **Dependencias documentales:** para interpretar el contenido específico del producto, consultar los documentos relacionados de la sección 13.
- **Pendiente conocido:** el nombre de la persona responsable técnica no está confirmado.

## 15. Historial de cambios

| Versión | Fecha | Estado | Descripción | Autor |
| --- | --- | --- | --- | --- |
| 1.0.0 | 11 de julio de 2026 | Approved | Creación y aprobación inicial del estándar oficial de documentación de Focusly. | Equipo Focusly |