# 05_DOMAIN_MODEL_GUIDE.md

> Master Project Guide — Focusly
> Version: 1.0
> Status: Official Domain Reference
> Last Updated: July 2026

---

# 1. Purpose

Este documento define el modelo de dominio oficial de Focusly.

Su objetivo es establecer un lenguaje común entre:

- Desarrollo
- Arquitectura
- Producto
- Inteligencia Artificial
- Documentación
- Testing

Toda nueva funcionalidad deberá construirse utilizando este modelo como referencia principal.

Este documento no describe pantallas ni detalles técnicos de Flutter.

Describe el negocio.

---

# 2. Domain Philosophy

Focusly no es una aplicación de tareas.

No es una aplicación de Pomodoro.

No es una agenda.

No es un calendario.

Focusly es un sistema cuyo objetivo es ayudar al estudiante universitario a desarrollar hábitos de estudio sostenibles mediante planificación, acompañamiento, motivación y análisis del progreso.

Toda funcionalidad futura deberá responder a una pregunta:

> ¿Ayuda realmente al estudiante a estudiar mejor?

Si la respuesta es negativa, la funcionalidad no pertenece al dominio principal.

---

# 3. Ubiquitous Language

El proyecto utiliza un lenguaje único.

No deben existir sinónimos para las entidades principales.

Ejemplos:

Correcto:

- Course
- StudySession
- StudentProfile
- FocusGoal
- StudyCompanion
- AcademicTerm

Incorrecto:

- Subject
- Lesson
- ClassItem
- Pet
- Animal
- UserData
- GoalItem

Todo el código, documentación y prompts deberán utilizar el mismo vocabulario.

---

# 4. Domain Layers

El dominio permanece completamente independiente de:

- Flutter
- Firebase
- Riverpod
- Isar
- GoRouter
- HTTP
- Widgets
- Providers

El dominio únicamente conoce reglas de negocio.

---

# 5. Core Principles

Todas las entidades deben ser:

- Inmutables
- Deterministas
- Testeables
- Independientes de Frameworks

Nunca deben contener:

- BuildContext
- Widgets
- Firebase
- Isar
- Controllers
- Navegación

---

# 6. Core Entities

Actualmente el dominio oficial está compuesto por las siguientes entidades.

---

## 6.1 AuthUser

Representa la identidad mínima del usuario autenticado.

Responsabilidades:

- Identificador único
- Correo electrónico

No contiene:

- Contraseña
- Perfil académico
- Preferencias
- Configuración

---

## 6.2 AuthSession

Representa el estado de autenticación.

Responsabilidades:

- Usuario autenticado
- Estado de autenticación
- Verificación del correo

No representa:

- Perfil
- Configuración
- Datos académicos

---

## 6.3 StudentProfile

Representa la información académica inicial del estudiante.

Contiene:

- Universidad
- Carrera
- Ciclo académico
- Objetivo principal
- Preferencia inicial de estudio

No contiene:

- Horario
- Cursos
- Calificaciones
- Historial

---

## 6.4 StudyCompanion

Representa el compañero virtual del estudiante.

Contiene:

- Nombre
- Apariencia
- Propietario

No contiene:

- Inventario
- Economía
- Accesorios
- Evolución avanzada

---

## 6.5 Course

Representa una asignatura oficial.

Contiene:

- Identificador
- Nombre
- Código
- Créditos
- Color
- Estado

No contiene:

- Tareas
- Horarios
- Sesiones

---

## 6.6 AcademicTerm

Representa un periodo académico.

Contiene:

- Año
- Ciclo
- Fecha inicio
- Fecha fin

Relaciona múltiples cursos.

---

## 6.7 StudySession

Representa una sesión real de estudio.

Contiene:

- Inicio
- Fin
- Duración
- Curso
- Resultado

Nunca representa:

- Pomodoro
- Descansos
- Estadísticas

---

## 6.8 FocusGoal

Representa un objetivo de estudio.

Ejemplos:

- Estudiar 120 minutos diarios.
- Completar un curso.
- Preparar un examen.

No representa hábitos permanentes.

---

## 6.9 FocusStreak

Representa continuidad.

Contiene:

- Racha actual
- Mejor racha
- Última fecha válida

No calcula estadísticas.

---

## 6.10 UserPreferences

Representa preferencias personales.

Ejemplos:

- Tema
- Idioma
- Sonido
- Duración inicial

Nunca almacena datos académicos.

---

# 7. Aggregate Boundaries

Cada agregado protege sus propias reglas.

StudentProfile

↓

StudyCompanion

↓

Course

↓

StudySession

↓

FocusGoal

↓

FocusStreak

Las entidades no modifican directamente otras entidades.

La coordinación pertenece a los casos de uso.

---

# 8. Identity

Cada entidad posee identidad propia.

Ejemplos:

Course.id

StudySession.id

FocusGoal.id

StudentProfile.userId

StudyCompanion.id

Nunca utilizar IDs internos de bases de datos como identidad del dominio.

---

# 9. Value Objects

Los siguientes conceptos evolucionarán hacia Value Objects:

Email

CourseCode

StudyDuration

GoalPriority

AcademicCycle

UniversityName

CompanionName

StudyMinutes

Language

ThemeMode

Un Value Object:

- no posee identidad;
- es inmutable;
- se compara por valor.

---

# 10. Invariants

Las reglas del dominio nunca deben romperse.

Ejemplos:

Un StudyCompanion siempre pertenece exactamente a un usuario.

Un StudentProfile pertenece exactamente a un usuario.

Una StudySession no puede tener duración negativa.

Un CourseCode nunca puede estar vacío.

Un AcademicTerm debe tener fecha fin posterior a fecha inicio.

Un FocusGoal debe poseer un objetivo medible.

---

# 11. Domain Events (Future)

Versiones futuras podrán utilizar eventos como:

CourseCreated

StudySessionCompleted

GoalCompleted

CompanionLevelUp

PomodoroFinished

ExamScheduled

Todavía no se implementan.

---

# 12. Persistence Rules

El dominio desconoce completamente:

- Firebase
- Isar
- SQLite
- API REST
- JSON

Toda persistencia pertenece exclusivamente a Data.

---

# 13. Evolution Strategy

El dominio debe crecer mediante expansión.

Nunca mediante modificación destructiva.

Nuevas entidades deberán:

- documentarse aquí;
- justificarse;
- mantener compatibilidad.

---

# 14. AI Guidelines

Toda IA utilizada durante el desarrollo deberá respetar las siguientes reglas:

- Nunca introducir entidades duplicadas.
- Nunca cambiar el significado de una entidad existente.
- Nunca mover lógica de negocio fuera del dominio.
- Nunca crear dependencias del dominio hacia frameworks.
- Mantener el lenguaje ubicuo.

---

# 15. Future Roadmap

Las siguientes entidades están planificadas:

- Task
- StudyPlan
- Exam
- Flashcard
- ReviewSession
- Achievement
- CompanionEmotion
- CompanionInventory
- Notification
- AIRecommendation

Su implementación deberá respetar este documento.

---

# 16. Version History

## Version 1.0

- Definición del lenguaje ubicuo.
- Definición de entidades principales.
- Definición de agregados.
- Definición de invariantes.
- Definición de estrategia de evolución.
- Base oficial para el desarrollo futuro.