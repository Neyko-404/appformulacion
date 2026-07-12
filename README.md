# Focusly

Focusly es un compañero inteligente para aprender mejor.

## Estado

- **Sprint 0 — Foundation Engineering:** completado.
- **Sprint 1 — Firebase Authentication:** completado.
- **Sprint 1.5 — Firebase Foundation:** completado.
- **Sprint 2A — Onboarding:** en desarrollo con almacenamiento temporal en memoria.
- **Persistencia definitiva de Onboarding:** pendiente para Sprint 2B.
- **Firestore:** no configurado.
- **Datos académicos:** todavía no implementados.
- **Dashboard:** todavía no implementado.

La sesión productiva utiliza Firebase Authentication. Las pruebas conservan un repositorio en memoria aislado.

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
