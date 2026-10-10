import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pt'),
  ];

  /// No description provided for @appName.
  ///
  /// In es, this message translates to:
  /// **'Echo'**
  String get appName;

  /// No description provided for @tabZone.
  ///
  /// In es, this message translates to:
  /// **'Zona'**
  String get tabZone;

  /// No description provided for @tabMap.
  ///
  /// In es, this message translates to:
  /// **'Mapa'**
  String get tabMap;

  /// No description provided for @settings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settings;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @write.
  ///
  /// In es, this message translates to:
  /// **'Escribir'**
  String get write;

  /// No description provided for @reply.
  ///
  /// In es, this message translates to:
  /// **'Responder'**
  String get reply;

  /// No description provided for @publish.
  ///
  /// In es, this message translates to:
  /// **'Publicar'**
  String get publish;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @continueAction.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get continueAction;

  /// No description provided for @openThread.
  ///
  /// In es, this message translates to:
  /// **'Abrir hilo'**
  String get openThread;

  /// No description provided for @thread.
  ///
  /// In es, this message translates to:
  /// **'Hilo'**
  String get thread;

  /// No description provided for @map.
  ///
  /// In es, this message translates to:
  /// **'Mapa'**
  String get map;

  /// No description provided for @refresh.
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get refresh;

  /// No description provided for @zoneRadius.
  ///
  /// In es, this message translates to:
  /// **'Radio de zona'**
  String get zoneRadius;

  /// No description provided for @zoneRadiusValue.
  ///
  /// In es, this message translates to:
  /// **'{km} km'**
  String zoneRadiusValue(int km);

  /// No description provided for @distanceAt.
  ///
  /// In es, this message translates to:
  /// **'A {distance}'**
  String distanceAt(String distance);

  /// No description provided for @distanceUnknown.
  ///
  /// In es, this message translates to:
  /// **'A —'**
  String get distanceUnknown;

  /// No description provided for @fromYourPosition.
  ///
  /// In es, this message translates to:
  /// **'desde tu posición'**
  String get fromYourPosition;

  /// No description provided for @repliesCount.
  ///
  /// In es, this message translates to:
  /// **'{count} respuestas'**
  String repliesCount(int count);

  /// No description provided for @boostPlusKm.
  ///
  /// In es, this message translates to:
  /// **'+1 km'**
  String get boostPlusKm;

  /// No description provided for @boostPlusKmReach.
  ///
  /// In es, this message translates to:
  /// **'+1 km de alcance'**
  String get boostPlusKmReach;

  /// No description provided for @boosted.
  ///
  /// In es, this message translates to:
  /// **'Ampliado'**
  String get boosted;

  /// No description provided for @alreadyBoosted.
  ///
  /// In es, this message translates to:
  /// **'Ya ampliaste'**
  String get alreadyBoosted;

  /// No description provided for @emptyZoneTitle.
  ///
  /// In es, this message translates to:
  /// **'Zona en silencio'**
  String get emptyZoneTitle;

  /// No description provided for @emptyZoneBody.
  ///
  /// In es, this message translates to:
  /// **'Nadie ha escrito cerca todavía.\nSé el primero en tu zona.'**
  String get emptyZoneBody;

  /// No description provided for @noRepliesYet.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay respuestas.'**
  String get noRepliesYet;

  /// No description provided for @repliesSection.
  ///
  /// In es, this message translates to:
  /// **'Respuestas'**
  String get repliesSection;

  /// No description provided for @nearbyEcho.
  ///
  /// In es, this message translates to:
  /// **'Eco cercano'**
  String get nearbyEcho;

  /// No description provided for @mapOverlay.
  ///
  /// In es, this message translates to:
  /// **'{count} ecos en {km} km  ·  tú estás en el pin teal'**
  String mapOverlay(int count, int km);

  /// No description provided for @newEcho.
  ///
  /// In es, this message translates to:
  /// **'Nuevo eco'**
  String get newEcho;

  /// No description provided for @composerHint.
  ///
  /// In es, this message translates to:
  /// **'¿Qué se oye por aquí?'**
  String get composerHint;

  /// No description provided for @addImageNoFaces.
  ///
  /// In es, this message translates to:
  /// **'Añadir imagen (sin caras)'**
  String get addImageNoFaces;

  /// No description provided for @writeSomething.
  ///
  /// In es, this message translates to:
  /// **'Escribe algo.'**
  String get writeSomething;

  /// No description provided for @imageRejectedFace.
  ///
  /// In es, this message translates to:
  /// **'Imagen rechazada: se detectó una cara.'**
  String get imageRejectedFace;

  /// No description provided for @imageNoPeople.
  ///
  /// In es, this message translates to:
  /// **'No se permiten fotos donde se reconozca a personas. Elige otra imagen.'**
  String get imageNoPeople;

  /// No description provided for @gateHeadline.
  ///
  /// In es, this message translates to:
  /// **'Solo ves mensajes a 15 km de donde estás. Sin cuentas, sin nombres.'**
  String get gateHeadline;

  /// No description provided for @gateCardTitle.
  ///
  /// In es, this message translates to:
  /// **'Ubicación para abrir tu zona'**
  String get gateCardTitle;

  /// No description provided for @gateCardBody.
  ///
  /// In es, this message translates to:
  /// **'Necesitamos GPS (y comprobamos la zona aproximada de tu red) para abrir el foro de tu alrededor.'**
  String get gateCardBody;

  /// No description provided for @enableLocation.
  ///
  /// In es, this message translates to:
  /// **'Activar ubicación'**
  String get enableLocation;

  /// No description provided for @connectionFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo conectar.'**
  String get connectionFailed;

  /// No description provided for @avatarTitle.
  ///
  /// In es, this message translates to:
  /// **'Avatar (sin caras)'**
  String get avatarTitle;

  /// No description provided for @avatarSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Opcional. Se rechaza si ML Kit detecta una cara.'**
  String get avatarSubtitle;

  /// No description provided for @avatarRejected.
  ///
  /// In es, this message translates to:
  /// **'Avatar rechazado: no se permiten imágenes con personas reconocibles.'**
  String get avatarRejected;

  /// No description provided for @avatarUpdated.
  ///
  /// In es, this message translates to:
  /// **'Avatar actualizado.'**
  String get avatarUpdated;

  /// No description provided for @newIdentityTitle.
  ///
  /// In es, this message translates to:
  /// **'Nueva identidad anónima'**
  String get newIdentityTitle;

  /// No description provided for @newIdentitySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Borra la clave de este dispositivo y empieza de cero.'**
  String get newIdentitySubtitle;

  /// No description provided for @newIdentityDialogTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Nueva identidad?'**
  String get newIdentityDialogTitle;

  /// No description provided for @newIdentityDialogBody.
  ///
  /// In es, this message translates to:
  /// **'Perderás el vínculo con tus mensajes anteriores en este dispositivo.'**
  String get newIdentityDialogBody;

  /// No description provided for @darkThemeTitle.
  ///
  /// In es, this message translates to:
  /// **'Tema oscuro'**
  String get darkThemeTitle;

  /// No description provided for @darkThemeSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Fondo negro OLED para ahorrar batería.'**
  String get darkThemeSubtitle;

  /// No description provided for @notificationsTitle.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get notificationsTitle;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'+1 a tus ecos y nuevos mensajes en tu zona.'**
  String get notificationsSubtitle;

  /// No description provided for @boostTooltip.
  ///
  /// In es, this message translates to:
  /// **'Ampliaciones de alcance: {label} km'**
  String boostTooltip(String label);

  /// No description provided for @settingsTitleStyle.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settingsTitleStyle;

  /// No description provided for @pushBoostTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu eco llega más lejos'**
  String get pushBoostTitle;

  /// No description provided for @pushBoostBody.
  ///
  /// In es, this message translates to:
  /// **'Alguien amplió el alcance de tu mensaje.'**
  String get pushBoostBody;

  /// No description provided for @pushNewPostTitle.
  ///
  /// In es, this message translates to:
  /// **'Nuevo eco cerca'**
  String get pushNewPostTitle;

  /// No description provided for @pushNewPostBody.
  ///
  /// In es, this message translates to:
  /// **'Alguien escribió en tu zona.'**
  String get pushNewPostBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'pt',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
