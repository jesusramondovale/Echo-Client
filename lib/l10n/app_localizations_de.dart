// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Echo';

  @override
  String get tabZone => 'Zone';

  @override
  String get tabMap => 'Karte';

  @override
  String get settings => 'Einstellungen';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get write => 'Schreiben';

  @override
  String get reply => 'Antworten';

  @override
  String get publish => 'Posten';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get continueAction => 'Weiter';

  @override
  String get openThread => 'Thread öffnen';

  @override
  String get thread => 'Thread';

  @override
  String get map => 'Karte';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get zoneRadius => 'Zonenradius';

  @override
  String zoneRadiusValue(int km) {
    return '$km km';
  }

  @override
  String distanceAt(String distance) {
    return 'In $distance';
  }

  @override
  String get distanceUnknown => 'In —';

  @override
  String get fromYourPosition => 'von deinem Standort';

  @override
  String repliesCount(int count) {
    return '$count Antworten';
  }

  @override
  String get boostPlusKm => '+1 km';

  @override
  String get boostPlusKmReach => '+1 km Reichweite';

  @override
  String get boosted => 'Erweitert';

  @override
  String get alreadyBoosted => 'Bereits erweitert';

  @override
  String get emptyZoneTitle => 'Stille Zone';

  @override
  String get emptyZoneBody =>
      'Noch niemand in der Nähe geschrieben.\nSei der Erste in deiner Zone.';

  @override
  String get noRepliesYet => 'Noch keine Antworten.';

  @override
  String get repliesSection => 'Antworten';

  @override
  String get nearbyEcho => 'Nahes Echo';

  @override
  String mapOverlay(int count, int km) {
    return '$count Echos in $km km  ·  du bist der Teal-Pin';
  }

  @override
  String get newEcho => 'Neues Echo';

  @override
  String get composerHint => 'Was ist hier los?';

  @override
  String get addImageNoFaces => 'Bild hinzufügen (keine Gesichter)';

  @override
  String get writeSomething => 'Schreib etwas.';

  @override
  String get imageRejectedFace => 'Bild abgelehnt: ein Gesicht wurde erkannt.';

  @override
  String get imageNoPeople =>
      'Fotos mit erkennbaren Personen sind nicht erlaubt. Wähle ein anderes Bild.';

  @override
  String get gateHeadline =>
      'Du siehst nur Nachrichten im Umkreis von 15 km. Keine Konten, keine Namen.';

  @override
  String get gateCardTitle => 'Standort zum Öffnen deiner Zone';

  @override
  String get gateCardBody =>
      'Wir brauchen GPS (und prüfen den ungefähren Netzbereich), um das Forum um dich zu öffnen.';

  @override
  String get enableLocation => 'Standort aktivieren';

  @override
  String get connectionFailed => 'Verbindung fehlgeschlagen.';

  @override
  String get avatarTitle => 'Avatar (keine Gesichter)';

  @override
  String get avatarSubtitle =>
      'Optional. Wird abgelehnt, wenn ML Kit ein Gesicht erkennt.';

  @override
  String get avatarRejected =>
      'Avatar abgelehnt: Bilder mit erkennbaren Personen sind nicht erlaubt.';

  @override
  String get avatarUpdated => 'Avatar aktualisiert.';

  @override
  String get newIdentityTitle => 'Neue anonyme Identität';

  @override
  String get newIdentitySubtitle =>
      'Löscht den Geräteschlüssel und startet neu.';

  @override
  String get newIdentityDialogTitle => 'Neue Identität?';

  @override
  String get newIdentityDialogBody =>
      'Du verlierst die Verbindung zu früheren Nachrichten auf diesem Gerät.';

  @override
  String get darkThemeTitle => 'Dunkles Design';

  @override
  String get darkThemeSubtitle => 'OLED-schwarzer Hintergrund zum Stromsparen.';

  @override
  String get notificationsTitle => 'Benachrichtigungen';

  @override
  String get notificationsSubtitle =>
      '+1 auf deine Echos und neue Beiträge in deiner Zone.';

  @override
  String boostTooltip(String label) {
    return 'Reichweiten-Boosts: $label km';
  }

  @override
  String get settingsTitleStyle => 'Einstellungen';

  @override
  String get pushBoostTitle => 'Dein Echo reicht weiter';

  @override
  String get pushBoostBody =>
      'Jemand hat die Reichweite deiner Nachricht erweitert.';

  @override
  String get pushNewPostTitle => 'Neues Echo in der Nähe';

  @override
  String get pushNewPostBody => 'Jemand hat in deiner Zone geschrieben.';
}
