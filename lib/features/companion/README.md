# Companion

| Campo | Valor |
| --- | --- |
| Feature | Companion |
| Sprint | 7A |
| Estado | Animated Companion Framework implementado |

## Objetivo

Derivar un estado académico cercano para el compañero sin convertirlo en una mascota de necesidades, recompensas o castigos.

## Dominio

`StudyCompanion`, `CompanionMood`, `CompanionExpression`, `CompanionProgress` y `CompanionSnapshot` son inmutables. Los moods son relaxed, focused, encouraging, celebrating y resting; nunca existen estados negativos. El progreso contiene únicamente minutos de enfoque del día, sesiones completadas del día, días activos de la semana y tendencia semanal.

## Motor y reglas

`CompanionStateEngine` es puro y determinista. Sin actividad deriva resting/sleeping; una sesión deriva encouraging/thinking; varias sesiones derivan focused/normal; una tendencia positiva deriva celebrating con happy o cheering; varias interrupciones priorizan encouraging/thinking. El copy nunca juzga.

## API pública y persistencia

`companion_public_providers.dart` consume exclusivamente proyecciones públicas read-only de Analytics y expone `companionSnapshotProvider`. El snapshot se recalcula y no se persiste. No hay repositorios, Isar, Firebase, IA, Random, assets ni animaciones.

`companion_customization_public.dart` es el único punto de consumo para Dashboard. Expone la personalización local y el modelo de presentación combinado. Solo `CompanionCustomization` se guarda por usuario en Isar; mood, expression, progress y snapshot continúan siendo derivados y nunca se persisten.

Onboarding proporciona el nombre inicial mediante una API pública mínima y read-only. Después del primer guardado, `CompanionCustomization.displayName` es la fuente oficial para Presentation. Companion no escribe cambios de vuelta en Onboarding ni mantiene dos escrituras sincronizadas; cuando no existe personalización, utiliza el nombre de Onboarding como fallback.

## Identidad visual

La identidad permite editar explícitamente el nombre, elegir uno de cinco temas (classic, forest, ocean, sunset y night) y uno de cinco avatares Material. Domain conserva únicamente enums y texto; el mapeo a `IconData` y colores temáticos vive en Presentation. La vista previa no escribe datos y Guardar es la única acción persistente.

## Presencia contextual Sprint 6C

`CompanionContext` representa Dashboard, preparación, fases running, pausa, retorno, resultado, progreso y ausencia de actividad sin duplicar `StudySessionStatus`. `CompanionExpressionEngine` es puro, determinista y aplica prioridad: completed, retorno, cancelled, paused, final, steady, start, ready, progreso, sin actividad y Dashboard neutral. Los umbrales running son 50 %, 20 % y 5 %; no cambian por segundo dentro de una fase.

`CompanionExpressionState` contiene mood, expression, copy, semántica y emphasis no negativo. `CompanionPresentationMapper` lo combina con la identidad visual sin persistir estados derivados. `CompanionPresenceCard` ofrece variantes compact, standard y focus, usa un único mapper visual, Semantics y microtransiciones nativas de hasta 250 ms que respetan animaciones reducidas.

Dashboard y Focus consumen la API pública de Companion y no calculan mood o expression. Si faltan Analytics o Study Engine se usa contexto neutral; si falta personalización se conserva el fallback inicial de Onboarding. Animaciones avanzadas, assets, sonidos, IA, Random, chat y gamificación permanecen fuera de alcance.

## Animated Companion Framework Sprint 7A

`AnimatedCompanionAvatar` reemplaza el placeholder principal por un gato vectorial nativo dibujado con `CustomPainter`. Cabeza, orejas, ojos, boca, cuerpo, patas y cola se adaptan mediante `CatPose` y `CatMouthStyle`. `CompanionCatPoseMapper` convierte expression, personalización y variante de card en una pose determinista; no modifica el engine ni persiste valores visuales.

`CompanionCatPalette` deriva todos los colores desde `CompanionTheme`, `ThemeData` y `ColorScheme`. `CompanionMotionProfile` y `CompanionMotionPolicy` limitan respiración, parpadeo y cola; Focus reduce amplitudes, compact minimiza movimiento, sleeping permanece quieto y completed permite una celebración breve al entrar en el contexto. Reduce motion detiene controladores y muestra la pose final.

El painter está dentro de `RepaintBoundary`, implementa `shouldRepaint` por pose/paleta/fase y no anuncia movimientos mediante Semantics. Tamaños inválidos usan `Icons.pets` como fallback. Dashboard y Focus reciben el widget mediante la API pública; ninguno conoce `CatPose` ni administra controllers. Assets avanzados, sonidos, Rive, Lottie, sprites y animaciones complejas quedan pendientes de evaluación.

## Fuera de alcance

Hambre, sueño como necesidad, vida, muerte, monedas, inventario, logros, niveles, batallas, microtransacciones, IA, predicciones, notificaciones y persistencia remota.

## AI CONTEXT

Companion Sprint 6A refleja exclusivamente contexto académico local. Una IA no debe añadir estados negativos, necesidades virtuales, recompensas, persistencia ni comportamiento aleatorio.

## Historial de cambios

| Versión | Fecha | Estado | Descripción | Autor |
| --- | --- | --- | --- | --- |
| 0.2.0 | 12 de julio de 2026 | Implementado | Companion Personalization Sprint 6B. | Equipo Focusly |
| 0.1.0 | 12 de julio de 2026 | Implementado | Companion State & Progression Sprint 6A. | Equipo Focusly |
| 0.3.0 | 12 de julio de 2026 | Implementado | Companion Expressions & Contextual Presence Sprint 6C. | Equipo Focusly |
| 0.4.0 | 13 de julio de 2026 | Implementado | Animated Companion Framework Sprint 7A. | Equipo Focusly |
