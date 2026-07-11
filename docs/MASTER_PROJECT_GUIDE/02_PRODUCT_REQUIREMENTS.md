# Requisitos del producto Focusly

| Campo | Valor |
| --- | --- |
| Documento | `02_PRODUCT_REQUIREMENTS.md` |
| Proyecto | Focusly |
| Versión | 1.0.0 |
| Estado | Approved |
| Última actualización | 11 de julio de 2026 |
| Autor | Equipo Focusly |
| Responsable técnico | Gary Nivin Quispe |

## Índice

1. [Objetivo del documento](#1-objetivo-del-documento)
2. [Alcance del producto](#2-alcance-del-producto)
3. [Objetivos del producto](#3-objetivos-del-producto)
4. [Product Pillars](#4-product-pillars)
5. [Personas](#5-personas)
6. [User Journey](#6-user-journey)
7. [Requisitos funcionales](#7-requisitos-funcionales)
8. [Requisitos no funcionales](#8-requisitos-no-funcionales)
9. [Restricciones](#9-restricciones)
10. [Fuera de alcance](#10-fuera-de-alcance)
11. [Dependencias del producto](#11-dependencias-del-producto)
12. [Riesgos del producto](#12-riesgos-del-producto)
13. [Métricas de éxito](#13-métricas-de-éxito)
14. [Criterios de aceptación generales](#14-criterios-de-aceptación-generales)
15. [Roadmap funcional](#15-roadmap-funcional)
16. [Glosario](#16-glosario)
17. [Referencias](#17-referencias)
18. [AI CONTEXT](#18-ai-context)
19. [Historial de cambios](#19-historial-de-cambios)

## 1. Objetivo del documento

Este Product Requirements Document (PRD) define qué debe hacer Focusly, qué resultados debe ofrecer y bajo qué condiciones funcionales se considerará aceptable. Constituye el contrato funcional entre Producto y Desarrollo para delimitar alcance, prioridades, dependencias y criterios de validación.

El documento describe comportamientos observables y necesidades del usuario. No determina cómo deben construirse ni asigna soluciones internas. Un elemento no incluido como requisito aprobado no forma parte automáticamente del compromiso del producto.

## 2. Alcance del producto

Focusly cubre el acompañamiento personal del estudio desde la organización inicial hasta la revisión del progreso. El producto permite al estudiante:

- crear y administrar su acceso personal;
- configurar un perfil inicial y sus preferencias de estudio;
- consultar un resumen de prioridades y progreso;
- organizar cursos, horarios, tareas, evaluaciones y calificaciones;
- realizar sesiones de concentración y registrar sus resultados;
- recibir acompañamiento motivacional no punitivo;
- solicitar apoyo para comprender y practicar contenidos;
- crear, organizar y repasar flashcards;
- consultar indicadores sobre actividad y avance;
- controlar preferencias, privacidad y continuidad de uso.

El alcance se orienta al uso individual. Focusly apoya las decisiones del estudiante, pero no sustituye su razonamiento, su responsabilidad académica ni la enseñanza formal.

## 3. Objetivos del producto

### 3.1. Objetivos funcionales

- Centralizar la información académica personal necesaria para planificar el estudio.
- Convertir prioridades académicas en actividades de concentración realizables.
- Facilitar prácticas de aprendizaje activo y refuerzo de memoria.
- Mostrar el progreso de manera comprensible y vinculada con objetivos del estudiante.
- Mantener preferencias y datos esenciales disponibles ante interrupciones de conectividad.
- Permitir que el estudiante controle su información y personalice su experiencia.

### 3.2. Objetivos de experiencia

- Reducir la carga mental necesaria para decidir qué estudiar.
- Permitir que las acciones principales se comprendan sin instrucciones externas.
- Comunicar estados, errores y resultados con lenguaje claro y no punitivo.
- Favorecer la continuidad después de una pausa o una sesión incompleta.
- Mantener coherencia entre organización, concentración, aprendizaje y progreso.
- Ofrecer control visible sobre preferencias, datos y recomendaciones.

### 3.3. Objetivos estratégicos

- Validar que Focusly aporta valor recurrente al público principal definido en la visión.
- Priorizar profundidad y coherencia del ciclo de estudio sobre cantidad de funciones.
- Aprender de métricas y retroalimentación sin comprometer privacidad ni autonomía.
- Ampliar el producto solo cuando el valor de la etapa anterior haya sido evaluado.
- Conservar los Product Pillars como criterio para aceptar o rechazar nuevas iniciativas.

## 4. Product Pillars

Los pilares oficiales son invariables dentro de este PRD y proceden de la visión del proyecto.

| Pilar oficial | Objetivo | Descripción | Valor para el usuario |
| --- | --- | --- | --- |
| Academic Organization | Dar claridad sobre responsabilidades, prioridades y progreso académico. | Conecta compromisos y metas de estudio dentro de una visión ordenada y manejable. | Reduce la carga de recordar y decidir constantemente qué atender. |
| Deep Focus | Favorecer periodos de atención intencional y protegida. | Ayuda a transformar una prioridad en una actividad concreta de estudio con menos distracciones. | Facilita comenzar, mantener el esfuerzo y cerrar sesiones con propósito. |
| AI Learning | Ofrecer apoyo educativo contextual sin sustituir el razonamiento del estudiante. | Orienta la comprensión, la práctica y la reflexión de forma subordinada a los objetivos de aprendizaje. | Brinda acompañamiento oportuno y promueve autonomía para aprender. |
| Memory Reinforcement | Ayudar a conservar y recuperar conocimientos relevantes. | Promueve el repaso activo y oportuno como parte continua del proceso de estudio. | Mejora la continuidad del aprendizaje y reduce el olvido evitable. |
| Gamification | Hacer visible y motivador el progreso sin recurrir al castigo. | Utiliza reconocimiento, metas y evolución para reforzar conductas positivas. | Aumenta la sensación de avance y favorece la constancia. |
| Wellbeing | Proteger una relación saludable y sostenible con el estudio. | Considera descanso, carga percibida, autonomía y tono emocional en la experiencia. | Ayuda a progresar sin convertir la productividad en presión permanente. |

## 5. Personas

Las personas representan patrones de necesidades y no perfiles demográficos exhaustivos. No deben utilizarse para inferir atributos personales no declarados.

### 5.1. Persona 1 — Estudiante universitario

- **Contexto:** cursa varias asignaturas con horarios, entregas, evaluaciones y cargas de trabajo diferentes. Alterna clases, estudio independiente y otras responsabilidades.
- **Necesidades:** reunir compromisos académicos, reconocer prioridades, planificar sesiones de estudio, seguir calificaciones y reforzar contenidos relevantes.
- **Frustraciones:** información dispersa, cambios frecuentes, dificultad para iniciar tareas amplias y sensación de no saber si avanza lo suficiente.
- **Objetivos:** mantener control del semestre, reducir olvidos, estudiar con mayor constancia y llegar mejor preparado a las evaluaciones.

### 5.2. Persona 2 — Estudiante técnico

- **Contexto:** sigue una formación orientada a competencias prácticas, con actividades secuenciales, entregas y evaluaciones de aplicación.
- **Necesidades:** organizar prácticas y teoría, disponer de sesiones breves y enfocadas, repasar procedimientos y visualizar avances por materia.
- **Frustraciones:** tiempo limitado, prioridades simultáneas, dificultad para retomar contenidos después de una pausa y herramientas que no reflejan su ritmo.
- **Objetivos:** aprovechar periodos disponibles, completar prácticas a tiempo, consolidar conocimientos y sostener una rutina compatible con otras obligaciones.

### 5.3. Persona 3 — Usuario autodidacta

- **Contexto:** estudia por iniciativa propia para alcanzar una meta definida, sin una estructura institucional que organice fechas o contenidos.
- **Necesidades:** convertir una meta amplia en un plan, mantener dirección, practicar lo aprendido y revisar su continuidad.
- **Frustraciones:** falta de estructura externa, exceso de materiales, cambios de prioridad y dificultad para medir progreso significativo.
- **Objetivos:** mantener un camino de aprendizaje claro, desarrollar disciplina flexible, recordar conceptos y completar su meta con autonomía.

## 6. User Journey

### 6.1. Primer uso

1. El usuario conoce el propósito de Focusly y las condiciones esenciales de uso.
2. Crea o recupera su acceso personal.
3. Completa la configuración inicial con la información mínima necesaria.
4. Define preferencias y un objetivo académico inicial.
5. Registra o selecciona su primera prioridad.
6. Llega a un resumen inicial que propone una siguiente acción comprensible.

**Resultado esperado:** el usuario entiende para qué sirve Focusly, conserva control sobre sus decisiones y puede obtener valor inicial sin completar información innecesaria.

### 6.2. Uso diario

1. El usuario consulta sus prioridades y compromisos próximos.
2. Elige o ajusta una actividad relevante.
3. Inicia una sesión de concentración o una actividad de aprendizaje.
4. Registra el resultado y decide el siguiente paso.
5. Observa una actualización de progreso y recibe reconocimiento no punitivo.

**Resultado esperado:** el usuario pasa de la revisión a la acción con poca fricción y termina con claridad sobre su avance.

### 6.3. Uso semanal

1. El usuario revisa actividades realizadas, pendientes y próximas.
2. Consulta patrones de dedicación y continuidad.
3. Ajusta prioridades, horarios o metas de estudio.
4. Identifica contenidos que requieren refuerzo.
5. Define una orientación para la siguiente semana.

**Resultado esperado:** el usuario comprende su situación y adapta su plan sin recibir juicios ni penalizaciones.

### 6.4. Uso antes de exámenes

1. El usuario registra o confirma la evaluación y su fecha.
2. Identifica contenidos y pendientes relacionados.
3. Distribuye actividades de estudio y repaso según el tiempo disponible.
4. Alterna concentración, práctica y refuerzo de memoria.
5. Consulta el progreso para decidir qué necesita atención adicional.

**Resultado esperado:** el usuario llega a la evaluación con un plan visible y evidencia de qué ha practicado, sin que Focusly garantice resultados académicos.

## 7. Requisitos funcionales

Las prioridades usan las categorías `Must`, `Should` y `Could`. El estado `Approved` indica que el requisito forma parte de este contrato funcional; su prioridad determina la etapa comprometida.

### 7.1. RF-001 — Authentication

| Campo | Definición |
| --- | --- |
| ID | RF-001 |
| Nombre | Authentication |
| Descripción | Permitir al usuario crear, validar, utilizar, recuperar y cerrar su acceso personal, además de solicitar la eliminación de su cuenta. |
| Prioridad | Must |
| Dependencias | Ninguna dependencia funcional previa. |
| Estado | Approved |

**Criterios de aceptación**

1. Dado un usuario sin cuenta, cuando proporciona datos válidos y acepta las condiciones obligatorias, entonces puede completar el registro y recibe confirmación del resultado.
2. Dado un usuario registrado, cuando presenta credenciales válidas, entonces accede a su información personal.
3. Cuando los datos de acceso son inválidos, el producto rechaza el intento sin revelar si una cuenta específica existe y explica cómo continuar.
4. Dado un usuario que no recuerda su acceso, cuando solicita recuperación, entonces recibe instrucciones y confirmación del proceso.
5. Dado un usuario con sesión activa, cuando cierra sesión, entonces el contenido personal deja de estar accesible desde esa sesión.
6. Dado un usuario autenticado, cuando solicita eliminar su cuenta, entonces conoce las consecuencias, confirma la decisión y recibe constancia de la solicitud.

### 7.2. RF-002 — Onboarding

| Campo | Definición |
| --- | --- |
| ID | RF-002 |
| Nombre | Onboarding |
| Descripción | Presentar el propósito de Focusly y recopilar la información mínima para establecer una experiencia inicial relevante. |
| Prioridad | Must |
| Dependencias | RF-001 Authentication. |
| Estado | Approved |

**Criterios de aceptación**

1. En el primer acceso, el usuario conoce el propósito del producto antes de proporcionar información personal opcional.
2. El usuario puede identificar su contexto de estudio, objetivo inicial y preferencias esenciales.
3. Cada dato opcional se distingue claramente de los datos obligatorios.
4. El usuario puede revisar y corregir la información antes de finalizar.
5. Al completar el onboarding, el producto conserva las elecciones y presenta una siguiente acción concreta.
6. Si el usuario interrumpe el proceso, puede retomarlo sin repetir pasos ya confirmados.

### 7.3. RF-003 — Dashboard

| Campo | Definición |
| --- | --- |
| ID | RF-003 |
| Nombre | Dashboard |
| Descripción | Mostrar un resumen priorizado del estado académico, las acciones próximas y el progreso relevante del usuario. |
| Prioridad | Must |
| Dependencias | RF-001 Authentication; RF-002 Onboarding; datos disponibles de RF-004 Academic Tracker, RF-005 Focus Mode y RF-009 Analytics. |
| Estado | Approved |

**Criterios de aceptación**

1. Al ingresar, el usuario puede identificar su prioridad actual y los compromisos próximos disponibles.
2. El resumen distingue información pendiente, completada y vencida sin utilizar lenguaje punitivo.
3. El usuario puede iniciar una acción relacionada directamente desde cada elemento accionable del resumen.
4. Los cambios confirmados en módulos dependientes se reflejan en el resumen al actualizarse la información.
5. Cuando no existen datos suficientes, el producto explica el estado vacío y ofrece una acción pertinente.
6. La información mostrada respeta las preferencias y el contexto del usuario activo.

### 7.4. RF-004 — Academic Tracker

| Campo | Definición |
| --- | --- |
| ID | RF-004 |
| Nombre | Academic Tracker |
| Descripción | Permitir al usuario registrar, consultar, modificar y cerrar cursos, horarios, tareas, evaluaciones y calificaciones personales. |
| Prioridad | Must |
| Dependencias | RF-001 Authentication; RF-002 Onboarding. |
| Estado | Approved |

**Criterios de aceptación**

1. El usuario puede crear, consultar, editar y archivar un curso sin afectar cursos no relacionados.
2. El usuario puede asociar horarios, tareas y evaluaciones a un curso existente.
3. Cada tarea o evaluación admite un estado, una fecha pertinente y una descripción identificable.
4. El producto valida campos obligatorios y explica los datos inválidos antes de confirmar un cambio.
5. El usuario puede registrar calificaciones y consultar el estado resultante sin que el producto garantice una nota final.
6. Antes de eliminar información con relaciones activas, el producto explica el impacto y solicita confirmación.
7. Los elementos próximos, completados y vencidos pueden distinguirse de forma verificable.

### 7.5. RF-005 — Focus Mode

| Campo | Definición |
| --- | --- |
| ID | RF-005 |
| Nombre | Focus Mode |
| Descripción | Permitir al usuario definir, iniciar, pausar, reanudar, cancelar y completar una sesión de concentración vinculada opcionalmente con una actividad. |
| Prioridad | Must |
| Dependencias | RF-001 Authentication; integración funcional opcional con RF-004 Academic Tracker. |
| Estado | Approved |

**Criterios de aceptación**

1. El usuario puede definir la duración prevista y el propósito de una sesión antes de iniciarla.
2. Durante una sesión, el producto muestra su estado y el tiempo restante de manera comprensible.
3. El usuario puede pausar, reanudar o cancelar la sesión y conoce el efecto de cada acción.
4. Al completar o cancelar una sesión, el usuario puede registrar un resultado y una observación opcional.
5. Una sesión completada actualiza el progreso relacionado sin conceder penalizaciones por sesiones incompletas.
6. Si ocurre una interrupción, el producto conserva un estado suficiente para que el usuario pueda decidir cómo continuar.

### 7.6. RF-006 — Virtual Companion

| Campo | Definición |
| --- | --- |
| ID | RF-006 |
| Nombre | Virtual Companion |
| Descripción | Representar el progreso y ofrecer acompañamiento motivacional positivo mediante un compañero personalizable. |
| Prioridad | Should |
| Dependencias | RF-002 Onboarding; actividad confirmada de RF-004 Academic Tracker, RF-005 Focus Mode o RF-008 Flashcards. |
| Estado | Approved |

**Criterios de aceptación**

1. El usuario puede elegir y personalizar su compañero entre las opciones disponibles.
2. El compañero reconoce actividades confirmadas mediante mensajes comprensibles y positivos.
3. La ausencia, una sesión cancelada o una racha interrumpida no genera castigos, pérdida irreversible ni mensajes de culpa.
4. El producto explica qué acciones contribuyen al progreso del compañero.
5. El usuario puede desactivar las intervenciones motivacionales sin perder acceso a funciones esenciales.
6. Los cambios del compañero reflejan únicamente actividad atribuible al usuario activo.

### 7.7. RF-007 — AI Learning

| Campo | Definición |
| --- | --- |
| ID | RF-007 |
| Nombre | AI Learning |
| Descripción | Proporcionar apoyo contextual para comprender, resumir, practicar y reflexionar sobre contenido educativo aportado o seleccionado por el usuario. |
| Prioridad | Must |
| Dependencias | RF-001 Authentication; contenido o instrucciones proporcionados por el usuario; relación opcional con RF-004 Academic Tracker. |
| Estado | Approved |

**Criterios de aceptación**

1. Antes de solicitar apoyo, el usuario puede identificar el contenido y el objetivo de aprendizaje relevante.
2. El producto distingue el contenido proporcionado por el usuario de la respuesta generada.
3. Cada resultado identifica su carácter orientativo y no se presenta como garantía de exactitud o desempeño académico.
4. El usuario puede solicitar una explicación, resumen o actividad de práctica y recibe un resultado relacionado con su solicitud.
5. Cuando no puede producirse un resultado útil, el producto informa la limitación y permite reformular o cancelar.
6. El usuario puede valorar, descartar o volver a solicitar el resultado sin que este sustituya automáticamente su contenido original.
7. El producto rechaza solicitudes que pretendan suplantar al estudiante en evaluaciones o vulnerar la integridad académica.

### 7.8. RF-008 — Flashcards

| Campo | Definición |
| --- | --- |
| ID | RF-008 |
| Nombre | Flashcards |
| Descripción | Permitir crear, organizar, editar, repasar y archivar tarjetas de estudio, de forma manual o a partir de contenido aprobado por el usuario. |
| Prioridad | Must |
| Dependencias | RF-001 Authentication; asociación opcional con RF-004 Academic Tracker y RF-007 AI Learning. |
| Estado | Approved |

**Criterios de aceptación**

1. El usuario puede crear una flashcard con una indicación y una respuesta identificables.
2. El usuario puede consultar, editar, agrupar y archivar sus flashcards.
3. Antes de guardar tarjetas propuestas a partir de contenido, el usuario puede revisarlas y modificarlas.
4. Durante un repaso, la respuesta permanece oculta hasta que el usuario decide revelarla.
5. El usuario puede registrar su nivel de recuerdo después de cada tarjeta revisada.
6. El producto utiliza el resultado de repasos anteriores para ordenar futuras revisiones de manera explicable para el usuario.
7. El historial distingue tarjetas nuevas, revisadas y pendientes.

### 7.9. RF-009 — Analytics

| Campo | Definición |
| --- | --- |
| ID | RF-009 |
| Nombre | Analytics |
| Descripción | Presentar indicadores comprensibles sobre organización, concentración, práctica y continuidad a partir de actividad confirmada del usuario. |
| Prioridad | Must |
| Dependencias | Datos disponibles de RF-004 Academic Tracker, RF-005 Focus Mode y RF-008 Flashcards. |
| Estado | Approved |

**Criterios de aceptación**

1. El usuario puede consultar indicadores por un periodo claramente identificado.
2. Cada indicador muestra su significado y la actividad utilizada para calcularlo.
3. Los totales coinciden con la actividad confirmada incluida en el periodo seleccionado.
4. Cuando no existen datos suficientes, el producto informa la ausencia sin presentar conclusiones engañosas.
5. El usuario puede diferenciar actividad planificada, iniciada y completada cuando el indicador lo requiera.
6. Los mensajes derivados de indicadores son descriptivos y no realizan diagnósticos ni juicios sobre la capacidad del usuario.

### 7.10. RF-010 — Settings

| Campo | Definición |
| --- | --- |
| ID | RF-010 |
| Nombre | Settings |
| Descripción | Permitir al usuario consultar y modificar preferencias generales, recordatorios, accesibilidad, privacidad, datos personales y opciones de cuenta. |
| Prioridad | Must |
| Dependencias | RF-001 Authentication; preferencias relacionadas con los módulos correspondientes. |
| Estado | Approved |

**Criterios de aceptación**

1. El usuario puede consultar el valor actual de cada preferencia antes de modificarla.
2. Un cambio confirmado se conserva y se refleja en las funciones relacionadas.
3. El usuario puede activar o desactivar recordatorios y acompañamiento motivacional de forma independiente.
4. El usuario puede consultar qué categorías de información personal mantiene Focusly y para qué se utilizan.
5. El usuario puede solicitar una copia o eliminación de su información mediante una acción identificable y confirmada.
6. Las acciones con consecuencias irreversibles explican su impacto y requieren confirmación explícita.
7. El usuario puede cerrar sesión desde la configuración.

## 8. Requisitos no funcionales

Cada requisito no funcional describe una condición observable del producto sin prescribir su solución interna.

### 8.1. Usabilidad

- **RNF-USA-001:** una persona del público objetivo debe poder completar las acciones principales del MVP siguiendo únicamente las indicaciones disponibles en el producto.
- **RNF-USA-002:** toda acción confirmada debe producir una señal clara de éxito, error o estado en curso.
- **RNF-USA-003:** los errores deben explicar qué ocurrió, qué información se conserva y qué puede hacer el usuario.
- **RNF-USA-004:** la terminología debe ser consistente entre módulos y concordar con el glosario funcional.

### 8.2. Rendimiento

- **RNF-REN-001:** las acciones locales principales deben responder sin una espera que impida continuar el flujo previsto.
- **RNF-REN-002:** cuando una operación requiera espera, el producto debe mostrar su estado y evitar envíos duplicados involuntarios.
- **RNF-REN-003:** una operación prolongada debe permitir al usuario conocer si sigue activa, finalizó o falló.
- **RNF-REN-004:** los criterios cuantitativos de rendimiento se establecerán mediante medición sobre escenarios y dispositivos representativos antes de la liberación.

### 8.3. Disponibilidad

- **RNF-DIS-001:** la organización académica, las sesiones registradas, las flashcards guardadas y las preferencias esenciales deben poder consultarse ante una interrupción de conectividad.
- **RNF-DIS-002:** si una función no está disponible, el producto debe identificarla antes de que el usuario pierda trabajo.
- **RNF-DIS-003:** una interrupción inesperada no debe eliminar datos que el producto haya confirmado como guardados.
- **RNF-DIS-004:** al recuperar disponibilidad, el usuario debe poder reintentar las acciones pendientes de forma controlada.

### 8.4. Seguridad

- **RNF-SEG-001:** el contenido personal solo debe ser accesible después de validar el acceso correspondiente.
- **RNF-SEG-002:** la información de una cuenta no debe mostrarse ni atribuirse a otra cuenta.
- **RNF-SEG-003:** las operaciones sensibles deben requerir confirmación y comunicar sus consecuencias.
- **RNF-SEG-004:** los mensajes de acceso no deben revelar información que facilite identificar cuentas ajenas.
- **RNF-SEG-005:** toda incidencia que pueda comprometer datos personales debe quedar sujeta al proceso de respuesta y comunicación definido por el producto.

### 8.5. Accesibilidad

- **RNF-ACC-001:** la información no debe depender únicamente del color, sonido, movimiento o posición.
- **RNF-ACC-002:** los elementos interactivos deben tener nombres y estados comprensibles mediante ayudas de acceso.
- **RNF-ACC-003:** el contenido debe conservar legibilidad al aumentar el tamaño del texto dentro de los niveles soportados por el producto.
- **RNF-ACC-004:** las acciones esenciales deben poder completarse sin depender de gestos complejos o de tiempo de reacción breve.
- **RNF-ACC-005:** el movimiento no esencial debe poder reducirse cuando el usuario así lo prefiera.

### 8.6. Escalabilidad

- **RNF-ESC-001:** el aumento de usuarios o datos no debe alterar las reglas funcionales ni mezclar información entre cuentas.
- **RNF-ESC-002:** los límites operativos que afecten al usuario deben ser visibles antes de que bloquee una acción.
- **RNF-ESC-003:** el producto debe permitir incorporar nuevos cursos, periodos y conjuntos de flashcards sin cambiar el significado de los datos existentes.
- **RNF-ESC-004:** cualquier degradación por crecimiento debe poder detectarse mediante las métricas operativas aprobadas antes de afectar de forma generalizada a los usuarios.

### 8.7. Mantenibilidad

- **RNF-MAN-001:** cada requisito liberado debe conservar trazabilidad con sus criterios de aceptación y evidencia de validación.
- **RNF-MAN-002:** un cambio funcional debe identificar los módulos, journeys, métricas y documentos afectados antes de aprobarse.
- **RNF-MAN-003:** los términos y reglas compartidos deben tener una fuente oficial única.
- **RNF-MAN-004:** las funciones retiradas deben conservar un tratamiento definido para los datos existentes y comunicar el cambio al usuario afectado.

### 8.8. Privacidad

- **RNF-PRI-001:** Focusly debe solicitar solo información necesaria para una finalidad declarada.
- **RNF-PRI-002:** el usuario debe poder distinguir datos obligatorios de datos opcionales antes de proporcionarlos.
- **RNF-PRI-003:** las finalidades de uso deben expresarse en lenguaje comprensible y estar disponibles para consulta.
- **RNF-PRI-004:** el usuario debe disponer de acciones para consultar, corregir, solicitar copia y solicitar eliminación de su información personal.
- **RNF-PRI-005:** una nueva finalidad de uso requiere información y consentimiento cuando corresponda antes de aplicarse.

### 8.9. Offline First

- **RNF-OFF-001:** el usuario debe poder consultar y actualizar información académica previamente disponible sin conectividad.
- **RNF-OFF-002:** el usuario debe poder iniciar y finalizar sesiones de concentración sin conectividad.
- **RNF-OFF-003:** el usuario debe poder revisar y calificar flashcards previamente disponibles sin conectividad.
- **RNF-OFF-004:** una función que requiera conectividad debe indicarlo antes de iniciar la operación y ofrecer una alternativa cuando exista.
- **RNF-OFF-005:** los cambios pendientes deben conservar su estado y comunicar si están guardados, pendientes o requieren intervención.
- **RNF-OFF-006:** ante cambios incompatibles realizados en contextos diferentes, el producto no debe descartar información silenciosamente y debe solicitar una resolución comprensible.

## 9. Restricciones

- El MVP se limita al uso personal del estudiante.
- Las prioridades `Must` definen el compromiso funcional del MVP; las prioridades restantes no deben bloquear su validación.
- El onboarding debe solicitar únicamente la información necesaria para entregar valor inicial.
- El acompañamiento y la gamificación no pueden utilizar castigos, pérdida irreversible ni culpa como mecanismos de retorno.
- AI Learning debe apoyar el aprendizaje y no realizar evaluaciones o trabajos en nombre del usuario.
- El producto no puede prometer resultados académicos, exactitud absoluta ni mejora garantizada.
- Las funciones esenciales definidas como Offline First deben conservar los comportamientos indicados en la sección 8.9.
- Las métricas del producto no deben presentarse como diagnósticos de salud, capacidad o rendimiento futuro.
- Toda ampliación del MVP requiere evaluación de alcance y trazabilidad con al menos un Product Pillar.

## 10. Fuera de alcance

Focusly no hará dentro del MVP:

- gestión de instituciones, docentes, clases o grupos;
- comunicación social abierta entre usuarios;
- publicación o comercialización de contenido educativo;
- realización automática de tareas, exámenes o entregas;
- calificación oficial o certificación de aprendizaje;
- diagnóstico, tratamiento o asesoramiento clínico;
- vigilancia de actividad ajena o control disciplinario;
- colaboración simultánea sobre información académica compartida;
- integraciones con sistemas institucionales;
- sincronización con servicios externos no necesaria para validar el ciclo principal;
- cobertura funcional específica para todos los niveles educativos;
- personalización avanzada del compañero que no aporte a la validación del MVP.

La exclusión del MVP no constituye compromiso para una etapa posterior.

## 11. Dependencias del producto

### 11.1. Relaciones entre módulos

| Módulo | Depende de | Proporciona valor a |
| --- | --- | --- |
| RF-001 Authentication | Ningún módulo previo. | Onboarding, acceso a información personal y Settings. |
| RF-002 Onboarding | Authentication. | Dashboard, preferencias iniciales y Virtual Companion. |
| RF-003 Dashboard | Onboarding y datos disponibles de Academic Tracker, Focus Mode y Analytics. | Orientación diaria y acceso contextual a acciones. |
| RF-004 Academic Tracker | Authentication y contexto inicial. | Dashboard, Focus Mode, AI Learning y Analytics. |
| RF-005 Focus Mode | Authentication; Academic Tracker cuando se vincula una actividad. | Dashboard, Virtual Companion y Analytics. |
| RF-006 Virtual Companion | Onboarding y actividad confirmada. | Motivación y reconocimiento del progreso. |
| RF-007 AI Learning | Authentication y contenido seleccionado por el usuario. | Actividades de aprendizaje y propuestas revisables de flashcards. |
| RF-008 Flashcards | Authentication; opcionalmente Academic Tracker y AI Learning. | Memory Reinforcement y Analytics. |
| RF-009 Analytics | Actividad confirmada de Academic Tracker, Focus Mode y Flashcards. | Dashboard, revisión semanal y decisiones del usuario. |
| RF-010 Settings | Authentication y preferencias de los módulos afectados. | Control transversal de experiencia, privacidad y cuenta. |

### 11.2. Reglas de dependencia

- Un módulo consumidor debe funcionar con estados vacíos cuando la dependencia opcional no tenga datos.
- La ausencia de Virtual Companion no debe bloquear organización, concentración o aprendizaje.
- AI Learning no debe modificar automáticamente Academic Tracker o Flashcards sin confirmación del usuario.
- Analytics solo debe utilizar actividad confirmada y debe explicar periodos y significados.
- Settings debe reflejar el efecto de una preferencia en los módulos relacionados.

## 12. Riesgos del producto

### 12.1. Producto

| Riesgo | Efecto | Respuesta funcional |
| --- | --- | --- |
| Alcance excesivo | Retrasa la validación y reduce coherencia. | Aplicar prioridades y exigir trazabilidad con pilares y métricas. |
| Integración superficial | El producto se percibe como funciones desconectadas. | Validar journeys completos y dependencias entre módulos. |
| Complejidad creciente | Aumenta la carga mental del usuario. | Evaluar comprensión y utilidad antes de ampliar capacidades. |

### 12.2. Usuarios

| Riesgo | Efecto | Respuesta funcional |
| --- | --- | --- |
| Valor inicial poco claro | Abandono durante el primer uso. | Entregar una siguiente acción relevante con información mínima. |
| Uso irregular | El usuario no consolida una rutina. | Facilitar el retorno sin castigo y conservar contexto. |
| Diferencias de contexto | Una experiencia única no responde a distintos ritmos. | Permitir preferencias y ajustes sin asumir atributos personales. |

### 12.3. Contenido

| Riesgo | Efecto | Respuesta funcional |
| --- | --- | --- |
| Información académica incorrecta | Decisiones basadas en datos inválidos. | Permitir revisión, edición y confirmación del usuario. |
| Contenido insuficiente | Resultados de aprendizaje poco útiles. | Informar limitaciones y solicitar contexto adicional. |
| Sobrecarga de materiales | Dificultad para priorizar. | Relacionar contenido con cursos, metas y actividades concretas. |

### 12.4. Crecimiento

| Riesgo | Efecto | Respuesta funcional |
| --- | --- | --- |
| Pérdida de foco | La propuesta deja de ser comprensible. | Evaluar nuevas iniciativas contra visión, alcance y pilares. |
| Datos acumulados difíciles de gestionar | Menor claridad y confianza. | Proporcionar archivo, filtros y control sobre información personal. |
| Expectativas no sostenibles | Desconfianza ante funciones futuras implícitas. | Comunicar el roadmap como orientación, no como promesa. |

### 12.5. IA

| Riesgo | Efecto | Respuesta funcional |
| --- | --- | --- |
| Resultado incorrecto o engañoso | Aprendizaje equivocado o pérdida de confianza. | Comunicar carácter orientativo y permitir valoración, descarte y revisión. |
| Dependencia excesiva | Sustitución del razonamiento del estudiante. | Priorizar explicación, práctica y reflexión sobre entrega de respuestas finales. |
| Uso contrario a integridad académica | Suplantación del trabajo del estudiante. | Rechazar solicitudes destinadas a completar evaluaciones en su nombre. |
| Exposición innecesaria de contenido | Riesgo para privacidad y confianza. | Explicar qué contenido se usa y permitir control antes de procesarlo. |

## 13. Métricas de éxito

Las métricas se interpretarán por tendencia, contexto y etapa del producto. Este PRD no fija umbrales sin una línea base validada.

### 13.1. Adopción y activación

- usuarios que completan el onboarding;
- usuarios que registran una primera prioridad académica;
- usuarios que completan una primera actividad de valor;
- tiempo y abandonos observados hasta alcanzar valor inicial;
- motivos declarados de abandono durante el primer uso.

### 13.2. Uso recurrente

- usuarios que regresan para consultar o actualizar prioridades;
- frecuencia de jornadas con una actividad significativa;
- continuidad después de una pausa;
- uso de revisión semanal;
- módulos utilizados dentro de un mismo journey.

### 13.3. Organización y concentración

- compromisos académicos registrados y completados;
- sesiones de concentración iniciadas, completadas y canceladas;
- actividades vinculadas con una prioridad;
- ajustes de planificación después de una revisión;
- claridad percibida sobre la siguiente acción.

### 13.4. Aprendizaje y memoria

- actividades de aprendizaje iniciadas y valoradas como útiles;
- flashcards creadas, revisadas y archivadas;
- continuidad de repasos;
- resultados descartados o reformulados;
- percepción del usuario sobre comprensión y preparación.

### 13.5. Experiencia, bienestar y confianza

- satisfacción declarada con claridad y facilidad de uso;
- reportes de presión, confusión o mensajes inadecuados;
- uso de controles de privacidad y preferencias;
- solicitudes de ayuda, corrección o eliminación de datos;
- retroalimentación sobre motivación y capacidad de retomar el estudio.

## 14. Criterios de aceptación generales

Toda feature debe cumplir, además de sus criterios específicos, las siguientes reglas:

1. Está vinculada con un requisito aprobado, una persona y al menos un Product Pillar.
2. Su comportamiento observable y límites están documentados antes de validarse.
3. Los recorridos principal, alternativos, vacíos y de error tienen resultados definidos.
4. Los datos obligatorios, opcionales y derivados pueden distinguirse.
5. Las validaciones se ejecutan antes de confirmar datos inválidos o incompletos.
6. Cada acción informa éxito, error, cancelación o estado pendiente.
7. Una operación repetida involuntariamente no debe producir resultados duplicados sin advertencia.
8. Las acciones destructivas explican consecuencias y requieren confirmación.
9. Las interrupciones no eliminan información confirmada ni ocultan el estado de trabajo pendiente.
10. La feature respeta las preferencias, permisos y datos del usuario activo.
11. La experiencia cumple los requisitos aplicables de accesibilidad, privacidad, seguridad y Offline First.
12. El lenguaje es claro, consistente, no punitivo y no promete resultados garantizados.
13. La actividad que alimenta Analytics es trazable y utiliza estados confirmados.
14. Existen evidencias de validación para cada criterio de aceptación específico y general aplicable.
15. Los documentos relacionados se actualizan cuando cambia el contrato funcional.

## 15. Roadmap funcional

### 15.1. MVP

Objetivo: validar el ciclo principal de organización, acción y progreso.

- RF-001 Authentication;
- RF-002 Onboarding;
- RF-003 Dashboard con resumen esencial;
- RF-004 Academic Tracker;
- RF-005 Focus Mode;
- RF-007 AI Learning con apoyo acotado y revisable;
- RF-008 Flashcards con creación y repaso esencial;
- RF-009 Analytics con indicadores básicos;
- RF-010 Settings con preferencias y controles esenciales;
- requisitos no funcionales aplicables al alcance anterior.

### 15.2. Versión 1

Objetivo: consolidar el ciclo de estudio y la motivación positiva.

- RF-006 Virtual Companion;
- mayor relación entre prioridades, sesiones, aprendizaje y repaso;
- revisión semanal guiada;
- indicadores más explicativos y controles ampliados;
- mejoras basadas en evidencia obtenida durante el MVP.

### 15.3. Versión 2

Objetivo: profundizar la adaptación a distintos hábitos y contextos.

- orientación más personalizada sobre continuidad y refuerzo;
- planificación de objetivos de mayor duración;
- mayor variedad de actividades de aprendizaje activo;
- evolución del compañero vinculada con progreso significativo;
- capacidades adicionales aprobadas tras validar utilidad y simplicidad.

### 15.4. Visión futura

Objetivo: acompañar trayectorias de aprendizaje más diversas y prolongadas.

- expansión a contextos educativos confirmados;
- continuidad del aprendizaje entre etapas y metas;
- nuevas formas de reflexión sobre hábitos y progreso;
- colaboración o integraciones únicamente si respetan autonomía, privacidad y enfoque personal.

El roadmap expresa una secuencia funcional conceptual. No establece fechas ni convierte elementos futuros en compromisos aprobados.

## 16. Glosario

| Término | Definición funcional |
| --- | --- |
| Academic Tracker | Conjunto de funciones para registrar y seguir información académica personal. |
| AI Learning | Pilar y módulo de apoyo contextual para comprensión, práctica y reflexión, sin sustituir el razonamiento del estudiante. |
| Analytics | Indicadores que describen actividad y progreso a partir de datos confirmados. |
| Authentication | Funciones para crear, validar, recuperar, utilizar y cerrar el acceso personal. |
| Dashboard | Resumen priorizado del estado académico, acciones próximas y progreso relevante. |
| Feature | Capacidad funcional delimitada que aporta un resultado verificable al usuario. |
| Flashcard | Tarjeta de estudio compuesta por una indicación y una respuesta que se revela durante el repaso. |
| Focus Mode | Función para realizar y registrar una sesión de concentración con propósito definido. |
| MVP | Alcance mínimo destinado a validar el ciclo principal y su valor para el público objetivo. |
| Offline First | Criterio funcional que conserva disponibles las actividades esenciales definidas ante interrupciones de conectividad. |
| Onboarding | Recorrido inicial que presenta el producto y establece contexto y preferencias esenciales. |
| Product Pillar | Principio temático oficial que agrupa y orienta el valor del producto. |
| Prioridad Must | Requisito necesario para cumplir el compromiso funcional del MVP. |
| Prioridad Should | Requisito importante previsto después de asegurar el alcance Must. |
| Prioridad Could | Requisito opcional sujeto a evidencia, capacidad y aprobación posterior. |
| Virtual Companion | Representación personalizable que reconoce progreso y ofrece motivación positiva. |

## 17. Referencias

- [Estándar oficial de documentación](./00_DOCUMENTATION_STANDARD.md)
- [Visión del proyecto](./01_PROJECT_VISION.md)
- [Arquitectura del sistema](./03_SYSTEM_ARCHITECTURE.md)

## 18. AI CONTEXT

- **Qué representa este documento:** es el contrato funcional oficial que define qué debe hacer Focusly, sus límites, prioridades, dependencias de producto y condiciones de aceptación.
- **Qué puede inferir una IA:** puede derivar escenarios de validación, casos borde y propuestas compatibles con requisitos aprobados, siempre que identifique el requisito de origen y no amplíe su alcance.
- **Qué no puede inferir una IA:** no puede inventar funciones, prioridades, fechas, umbrales, datos obligatorios, soluciones internas ni compromisos futuros. Tampoco puede interpretar una métrica conceptual como un objetivo cuantitativo aprobado.
- **Documentos que debe consultar antes de generar una feature:** `00_DOCUMENTATION_STANDARD.md` para reglas documentales, `01_PROJECT_VISION.md` para identidad y principios, este PRD para el contrato funcional y `03_SYSTEM_ARCHITECTURE.md` para las decisiones que correspondan fuera del alcance del PRD.
- **Regla de precedencia:** una propuesta que contradiga la visión, el alcance, un requisito aprobado o un criterio general debe detenerse y solicitar aclaración.

## 19. Historial de cambios

| Versión | Fecha | Estado | Descripción | Autor |
| --- | --- | --- | --- | --- |
| 1.0.0 | 11 de julio de 2026 | Approved | Creación y aprobación inicial del Product Requirements Document oficial de Focusly. | Equipo Focusly |
