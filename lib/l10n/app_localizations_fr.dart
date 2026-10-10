// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Echo';

  @override
  String get tabZone => 'Zone';

  @override
  String get tabMap => 'Carte';

  @override
  String get settings => 'Réglages';

  @override
  String get retry => 'Réessayer';

  @override
  String get write => 'Écrire';

  @override
  String get reply => 'Répondre';

  @override
  String get publish => 'Publier';

  @override
  String get cancel => 'Annuler';

  @override
  String get continueAction => 'Continuer';

  @override
  String get openThread => 'Ouvrir le fil';

  @override
  String get thread => 'Fil';

  @override
  String get map => 'Carte';

  @override
  String get refresh => 'Actualiser';

  @override
  String get zoneRadius => 'Rayon de zone';

  @override
  String zoneRadiusValue(int km) {
    return '$km km';
  }

  @override
  String distanceAt(String distance) {
    return 'À $distance';
  }

  @override
  String get distanceUnknown => 'À —';

  @override
  String get fromYourPosition => 'depuis votre position';

  @override
  String repliesCount(int count) {
    return '$count réponses';
  }

  @override
  String get boostPlusKm => '+1 km';

  @override
  String get boostPlusKmReach => '+1 km de portée';

  @override
  String get boosted => 'Élargi';

  @override
  String get alreadyBoosted => 'Déjà élargi';

  @override
  String get emptyZoneTitle => 'Zone silencieuse';

  @override
  String get emptyZoneBody =>
      'Personne n\'a encore écrit près d\'ici.\nSoyez le premier dans votre zone.';

  @override
  String get noRepliesYet => 'Pas encore de réponses.';

  @override
  String get repliesSection => 'Réponses';

  @override
  String get nearbyEcho => 'Écho proche';

  @override
  String mapOverlay(int count, int km) {
    return '$count échos dans $km km  ·  vous êtes l\'épingle teal';
  }

  @override
  String get newEcho => 'Nouvel écho';

  @override
  String get composerHint => 'Que se passe-t-il par ici ?';

  @override
  String get addImageNoFaces => 'Ajouter une image (sans visages)';

  @override
  String get writeSomething => 'Écrivez quelque chose.';

  @override
  String get imageRejectedFace => 'Image refusée : un visage a été détecté.';

  @override
  String get imageNoPeople =>
      'Les photos avec des personnes reconnaissables ne sont pas autorisées.';

  @override
  String get gateHeadline =>
      'Vous ne voyez que les messages à 15 km. Pas de comptes, pas de noms.';

  @override
  String get gateCardTitle => 'Localisation pour ouvrir votre zone';

  @override
  String get gateCardBody =>
      'Nous avons besoin du GPS (et vérifions la zone approximative de votre réseau) pour ouvrir le forum autour de vous.';

  @override
  String get enableLocation => 'Activer la localisation';

  @override
  String get connectionFailed => 'Connexion impossible.';

  @override
  String get avatarTitle => 'Avatar (sans visages)';

  @override
  String get avatarSubtitle =>
      'Facultatif. Refusé si ML Kit détecte un visage.';

  @override
  String get avatarRejected =>
      'Avatar refusé : images avec personnes reconnaissables interdites.';

  @override
  String get avatarUpdated => 'Avatar mis à jour.';

  @override
  String get newIdentityTitle => 'Nouvelle identité anonyme';

  @override
  String get newIdentitySubtitle =>
      'Efface la clé de cet appareil et recommence.';

  @override
  String get newIdentityDialogTitle => 'Nouvelle identité ?';

  @override
  String get newIdentityDialogBody =>
      'Vous perdrez le lien avec vos messages précédents sur cet appareil.';

  @override
  String get darkThemeTitle => 'Thème sombre';

  @override
  String get darkThemeSubtitle => 'Fond noir OLED pour économiser la batterie.';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsSubtitle =>
      '+1 sur vos échos et nouveaux messages dans votre zone.';

  @override
  String boostTooltip(String label) {
    return 'Extensions de portée : $label km';
  }

  @override
  String get settingsTitleStyle => 'Réglages';

  @override
  String get pushBoostTitle => 'Votre écho va plus loin';

  @override
  String get pushBoostBody => 'Quelqu\'un a élargi la portée de votre message.';

  @override
  String get pushNewPostTitle => 'Nouvel écho proche';

  @override
  String get pushNewPostBody => 'Quelqu\'un a écrit dans votre zone.';
}
