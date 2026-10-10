# Echo (Flutter)

Cliente Android/iOS del foro anónimo localizado **Echo**.

## Requisitos

- Flutter 3.38+
- API [Echo-Server](../Echo-Server) en marcha

## Configurar API

Por defecto conecta a **`http://83.58.254.192:8080`** (API pública).

En LAN local:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.33:8080
```

## Funciones MVP

- Identidad anónima (`deviceKey` en secure storage + JWT)
- Gate de GPS obligatorio
- Feed y hilos en radio 15 km
- Composer con texto + imagen
- Filtro de caras on-device (`google_mlkit_face_detection`) antes de subir
- Avatar opcional con la misma regla
- Ajuste para regenerar identidad

## Arranque

```bash
cd Echo
flutter pub get
flutter run
```
