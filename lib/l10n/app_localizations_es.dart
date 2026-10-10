// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Echo';

  @override
  String get tabZone => 'Zona';

  @override
  String get tabMap => 'Mapa';

  @override
  String get settings => 'Ajustes';

  @override
  String get retry => 'Reintentar';

  @override
  String get write => 'Escribir';

  @override
  String get reply => 'Responder';

  @override
  String get publish => 'Publicar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get continueAction => 'Continuar';

  @override
  String get openThread => 'Abrir hilo';

  @override
  String get thread => 'Hilo';

  @override
  String get map => 'Mapa';

  @override
  String get refresh => 'Actualizar';

  @override
  String get zoneRadius => 'Radio de zona';

  @override
  String zoneRadiusValue(int km) {
    return '$km km';
  }

  @override
  String distanceAt(String distance) {
    return 'A $distance';
  }

  @override
  String get distanceUnknown => 'A —';

  @override
  String get fromYourPosition => 'desde tu posición';

  @override
  String repliesCount(int count) {
    return '$count respuestas';
  }

  @override
  String get boostPlusKm => '+1 km';

  @override
  String get boostPlusKmReach => '+1 km de alcance';

  @override
  String get boosted => 'Ampliado';

  @override
  String get alreadyBoosted => 'Ya ampliaste';

  @override
  String get emptyZoneTitle => 'Zona en silencio';

  @override
  String get emptyZoneBody =>
      'Nadie ha escrito cerca todavía.\nSé el primero en tu zona.';

  @override
  String get noRepliesYet => 'Aún no hay respuestas.';

  @override
  String get repliesSection => 'Respuestas';

  @override
  String get nearbyEcho => 'Eco cercano';

  @override
  String mapOverlay(int count, int km) {
    return '$count ecos en $km km  ·  tú estás en el pin teal';
  }

  @override
  String get newEcho => 'Nuevo eco';

  @override
  String get composerHint => '¿Qué se oye por aquí?';

  @override
  String get addImageNoFaces => 'Añadir imagen (sin caras)';

  @override
  String get writeSomething => 'Escribe algo.';

  @override
  String get imageRejectedFace => 'Imagen rechazada: se detectó una cara.';

  @override
  String get imageNoPeople =>
      'No se permiten fotos donde se reconozca a personas. Elige otra imagen.';

  @override
  String get gateHeadline =>
      'Solo ves mensajes a 15 km de donde estás. Sin cuentas, sin nombres.';

  @override
  String get gateCardTitle => 'Ubicación para abrir tu zona';

  @override
  String get gateCardBody =>
      'Necesitamos GPS (y comprobamos la zona aproximada de tu red) para abrir el foro de tu alrededor.';

  @override
  String get enableLocation => 'Activar ubicación';

  @override
  String get connectionFailed => 'No se pudo conectar.';

  @override
  String get avatarTitle => 'Avatar (sin caras)';

  @override
  String get avatarSubtitle =>
      'Opcional. Se rechaza si ML Kit detecta una cara.';

  @override
  String get avatarRejected =>
      'Avatar rechazado: no se permiten imágenes con personas reconocibles.';

  @override
  String get avatarUpdated => 'Avatar actualizado.';

  @override
  String get newIdentityTitle => 'Nueva identidad anónima';

  @override
  String get newIdentitySubtitle =>
      'Borra la clave de este dispositivo y empieza de cero.';

  @override
  String get newIdentityDialogTitle => '¿Nueva identidad?';

  @override
  String get newIdentityDialogBody =>
      'Perderás el vínculo con tus mensajes anteriores en este dispositivo.';

  @override
  String get darkThemeTitle => 'Tema oscuro';

  @override
  String get darkThemeSubtitle => 'Fondo negro OLED para ahorrar batería.';

  @override
  String get notificationsTitle => 'Notificaciones';

  @override
  String get notificationsSubtitle =>
      '+1 a tus ecos y nuevos mensajes en tu zona.';

  @override
  String boostTooltip(String label) {
    return 'Ampliaciones de alcance: $label km';
  }

  @override
  String get settingsTitleStyle => 'Ajustes';

  @override
  String get pushBoostTitle => 'Tu eco llega más lejos';

  @override
  String get pushBoostBody => 'Alguien amplió el alcance de tu mensaje.';

  @override
  String get pushNewPostTitle => 'Nuevo eco cerca';

  @override
  String get pushNewPostBody => 'Alguien escribió en tu zona.';
}
