# Companion

| Campo | Valor |
| --- | --- |
| Feature | Companion |
| Sprint | 6A |
| Estado | Companion State & Progression implementado |

## Objetivo

Derivar un estado académico cercano para el compañero sin convertirlo en una mascota de necesidades, recompensas o castigos.

## Dominio

`StudyCompanion`, `CompanionMood`, `CompanionExpression`, `CompanionProgress` y `CompanionSnapshot` son inmutables. Los moods son relaxed, focused, encouraging, celebrating y resting; nunca existen estados negativos. El progreso contiene únicamente minutos de enfoque del día, sesiones completadas del día, días activos de la semana y tendencia semanal.

## Motor y reglas

`CompanionStateEngine` es puro y determinista. Sin actividad deriva resting/sleeping; una sesión deriva encouraging/thinking; varias sesiones derivan focused/normal; una tendencia positiva deriva celebrating con happy o cheering; varias interrupciones priorizan encouraging/thinking. El copy nunca juzga.

## API pública y persistencia

`companion_public_providers.dart` consume exclusivamente proyecciones públicas read-only de Analytics y expone `companionSnapshotProvider`. El snapshot se recalcula y no se persiste. No hay repositorios, Isar, Firebase, IA, Random, assets ni animaciones.

## Fuera de alcance

Hambre, sueño como necesidad, vida, muerte, monedas, inventario, logros, niveles, batallas, microtransacciones, IA, predicciones, notificaciones y persistencia remota.

## AI CONTEXT

Companion Sprint 6A refleja exclusivamente contexto académico local. Una IA no debe añadir estados negativos, necesidades virtuales, recompensas, persistencia ni comportamiento aleatorio.

## Historial de cambios

| Versión | Fecha | Estado | Descripción | Autor |
| --- | --- | --- | --- | --- |
| 0.1.0 | 12 de julio de 2026 | Implementado | Companion State & Progression Sprint 6A. | Equipo Focusly |
