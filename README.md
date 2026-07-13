# Focusly

Focusly es un compañero inteligente para aprender mejor.

## Estado

- **Sprint 0 — Foundation Engineering:** completado.
- **Sprint 1 — Firebase Authentication:** completado.
- **Sprint 1.5 — Firebase Foundation:** completado.
- **Sprint 2 — Onboarding:** completado con persistencia local.
- **Firestore:** no configurado.
- **Datos académicos:** todavía no implementados.
- **Sprint 3A — Dashboard Foundation:** completado.
- **Sprint 3B — Academic Courses:** implementado con persistencia local.
- **Sprint 4A — Study Engine Core:** completado con temporizador persistente basado en timestamps e historial básico.
- **Sprint 4B — Focus Experience:** implementado con preparación, progreso accesible, navegación segura y resultados de sesión.
- **Sprint 4C — Companion Integration:** completado con mensajes deterministas y apoyo visual discreto.
- **Sprint 4D — Anti-Distraction Foundation:** implementado con detección de visibilidad, interrupciones locales y retorno neutral.
- **Sprint 5A — Analytics Foundation:** implementado con resumen diario, semanal, mensual y por curso.
- **Sprint 5B — Dashboard Intelligence:** implementado con jerarquía accionable, resumen diario e insights deterministas basados en datos locales.
- **Sprint 5C — Trends & Progress:** implementado con comparaciones locales semanales, mensuales y por curso.
- **Sprint 5D — Personalized Insights Engine:** implementado con reglas deterministas, locales y no persistentes.
- **Sprint 6A — Companion State & Progression:** implementado como estado académico derivado, neutral y no persistente.
- **Sprint 6B — Companion Personalization:** implementado con identidad visual y personalización local explícita.
- **Sprint 6C — Companion Expressions:** implementado con presencia contextual determinista y microtransiciones nativas accesibles.
- **Sprint 7A — Animated Companion Framework:** implementado con gato vectorial nativo, movimiento determinista y reduce motion.
- **Horarios y calificaciones:** pendientes.
- **Pomodoro:** pendiente.
- **Mascota interactiva:** pendiente.
- **Detección de aplicaciones específicas:** no implementada.
- **Notificaciones:** pendientes.
- **Assets avanzados, sonidos, Rive/Lottie, gráficos, predicciones e IA:** pendientes.
- **Sincronización remota:** pendiente.

La sesión productiva utiliza Firebase Authentication y el onboarding utiliza persistencia local. Las pruebas pueden sustituir ambos repositorios por implementaciones aisladas en memoria.

## Sprint 1.5 — Firebase Foundation

- Firebase Core integrado.
- Proyecto Firebase configurado.
- Aplicación Android registrada.
- Firebase Authentication integrado.
- Firestore pendiente.
- Storage pendiente.

Para regenerar la configuración oficial después de un cambio aprobado en plataformas o proyecto:

```powershell
flutterfire configure
```

No edites manualmente los archivos generados ni compartas su contenido fuera de los canales autorizados.

## Requisitos

- Flutter estable.
- Una versión de Dart compatible con `pubspec.yaml`.
- Entorno Android configurado.

## Uso local

```powershell
flutter pub get
flutter run
flutter analyze
flutter test
```

## Documentación

Las decisiones oficiales del proyecto se encuentran en [Master Project Guide](docs/MASTER_PROJECT_GUIDE/). Antes de realizar cambios, consulta también el contexto operativo disponible en `.ai/`.

## Seguridad

No compartas ni agregues al repositorio secretos, credenciales, tokens, claves privadas o archivos de entorno reales.
