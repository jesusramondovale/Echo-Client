// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'Echo';

  @override
  String get tabZone => 'Zona';

  @override
  String get tabMap => 'Mappa';

  @override
  String get settings => 'Impostazioni';

  @override
  String get retry => 'Riprova';

  @override
  String get write => 'Scrivi';

  @override
  String get reply => 'Rispondi';

  @override
  String get publish => 'Pubblica';

  @override
  String get cancel => 'Annulla';

  @override
  String get continueAction => 'Continua';

  @override
  String get openThread => 'Apri thread';

  @override
  String get thread => 'Thread';

  @override
  String get map => 'Mappa';

  @override
  String get refresh => 'Aggiorna';

  @override
  String get zoneRadius => 'Raggio della zona';

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
  String get fromYourPosition => 'dalla tua posizione';

  @override
  String repliesCount(int count) {
    return '$count risposte';
  }

  @override
  String get boostPlusKm => '+1 km';

  @override
  String get boostPlusKmReach => '+1 km di portata';

  @override
  String get boosted => 'Ampliato';

  @override
  String get alreadyBoosted => 'Già ampliato';

  @override
  String get emptyZoneTitle => 'Zona silenziosa';

  @override
  String get emptyZoneBody =>
      'Nessuno ha ancora scritto qui vicino.\nSii il primo nella tua zona.';

  @override
  String get noRepliesYet => 'Ancora nessuna risposta.';

  @override
  String get repliesSection => 'Risposte';

  @override
  String get nearbyEcho => 'Eco vicino';

  @override
  String mapOverlay(int count, int km) {
    return '$count echi entro $km km  ·  sei il pin teal';
  }

  @override
  String get newEcho => 'Nuovo eco';

  @override
  String get composerHint => 'Cosa si sente da queste parti?';

  @override
  String get addImageNoFaces => 'Aggiungi immagine (senza volti)';

  @override
  String get writeSomething => 'Scrivi qualcosa.';

  @override
  String get imageRejectedFace =>
      'Immagine rifiutata: è stato rilevato un volto.';

  @override
  String get imageNoPeople =>
      'Non sono consentite foto con persone riconoscibili. Scegline un\'altra.';

  @override
  String get gateHeadline =>
      'Vedi solo i messaggi entro 15 km. Niente account, niente nomi.';

  @override
  String get gateCardTitle => 'Posizione per aprire la tua zona';

  @override
  String get gateCardBody =>
      'Serve il GPS (e controlliamo la zona approssimativa della tua rete) per aprire il forum intorno a te.';

  @override
  String get enableLocation => 'Attiva posizione';

  @override
  String get connectionFailed => 'Connessione non riuscita.';

  @override
  String get avatarTitle => 'Avatar (senza volti)';

  @override
  String get avatarSubtitle =>
      'Facoltativo. Rifiutato se ML Kit rileva un volto.';

  @override
  String get avatarRejected =>
      'Avatar rifiutato: immagini con persone riconoscibili non consentite.';

  @override
  String get avatarUpdated => 'Avatar aggiornato.';

  @override
  String get newIdentityTitle => 'Nuova identità anonima';

  @override
  String get newIdentitySubtitle =>
      'Cancella la chiave di questo dispositivo e ricomincia.';

  @override
  String get newIdentityDialogTitle => 'Nuova identità?';

  @override
  String get newIdentityDialogBody =>
      'Perderai il collegamento con i messaggi precedenti su questo dispositivo.';

  @override
  String get darkThemeTitle => 'Tema scuro';

  @override
  String get darkThemeSubtitle => 'Sfondo nero OLED per risparmiare batteria.';

  @override
  String get notificationsTitle => 'Notifiche';

  @override
  String get notificationsSubtitle =>
      '+1 ai tuoi echi e nuovi messaggi nella tua zona.';

  @override
  String boostTooltip(String label) {
    return 'Ampliamenti di portata: $label km';
  }

  @override
  String get settingsTitleStyle => 'Impostazioni';

  @override
  String get pushBoostTitle => 'Il tuo eco arriva più lontano';

  @override
  String get pushBoostBody =>
      'Qualcuno ha ampliato la portata del tuo messaggio.';

  @override
  String get pushNewPostTitle => 'Nuovo eco vicino';

  @override
  String get pushNewPostBody => 'Qualcuno ha scritto nella tua zona.';
}
