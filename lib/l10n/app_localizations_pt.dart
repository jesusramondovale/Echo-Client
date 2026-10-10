// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Echo';

  @override
  String get tabZone => 'Zona';

  @override
  String get tabMap => 'Mapa';

  @override
  String get settings => 'Definições';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get write => 'Escrever';

  @override
  String get reply => 'Responder';

  @override
  String get publish => 'Publicar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get continueAction => 'Continuar';

  @override
  String get openThread => 'Abrir tópico';

  @override
  String get thread => 'Tópico';

  @override
  String get map => 'Mapa';

  @override
  String get refresh => 'Atualizar';

  @override
  String get zoneRadius => 'Raio da zona';

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
  String get fromYourPosition => 'da tua posição';

  @override
  String repliesCount(int count) {
    return '$count respostas';
  }

  @override
  String get boostPlusKm => '+1 km';

  @override
  String get boostPlusKmReach => '+1 km de alcance';

  @override
  String get boosted => 'Alargado';

  @override
  String get alreadyBoosted => 'Já alargaste';

  @override
  String get emptyZoneTitle => 'Zona em silêncio';

  @override
  String get emptyZoneBody =>
      'Ninguém escreveu perto ainda.\nSê o primeiro na tua zona.';

  @override
  String get noRepliesYet => 'Ainda não há respostas.';

  @override
  String get repliesSection => 'Respostas';

  @override
  String get nearbyEcho => 'Eco próximo';

  @override
  String mapOverlay(int count, int km) {
    return '$count ecos em $km km  ·  estás no pin teal';
  }

  @override
  String get newEcho => 'Novo eco';

  @override
  String get composerHint => 'O que se ouve por aqui?';

  @override
  String get addImageNoFaces => 'Adicionar imagem (sem rostos)';

  @override
  String get writeSomething => 'Escreve algo.';

  @override
  String get imageRejectedFace => 'Imagem rejeitada: foi detetado um rosto.';

  @override
  String get imageNoPeople =>
      'Não são permitidas fotos com pessoas reconhecíveis. Escolhe outra imagem.';

  @override
  String get gateHeadline => 'Só vês mensagens a 15 km. Sem contas, sem nomes.';

  @override
  String get gateCardTitle => 'Localização para abrir a tua zona';

  @override
  String get gateCardBody =>
      'Precisamos de GPS (e verificamos a zona aproximada da tua rede) para abrir o fórum à tua volta.';

  @override
  String get enableLocation => 'Ativar localização';

  @override
  String get connectionFailed => 'Não foi possível ligar.';

  @override
  String get avatarTitle => 'Avatar (sem rostos)';

  @override
  String get avatarSubtitle =>
      'Opcional. Rejeitado se o ML Kit detetar um rosto.';

  @override
  String get avatarRejected =>
      'Avatar rejeitado: imagens com pessoas reconhecíveis não são permitidas.';

  @override
  String get avatarUpdated => 'Avatar atualizado.';

  @override
  String get newIdentityTitle => 'Nova identidade anónima';

  @override
  String get newIdentitySubtitle =>
      'Apaga a chave deste dispositivo e começa de novo.';

  @override
  String get newIdentityDialogTitle => 'Nova identidade?';

  @override
  String get newIdentityDialogBody =>
      'Perderás a ligação às tuas mensagens anteriores neste dispositivo.';

  @override
  String get darkThemeTitle => 'Tema escuro';

  @override
  String get darkThemeSubtitle => 'Fundo preto OLED para poupar bateria.';

  @override
  String get notificationsTitle => 'Notificações';

  @override
  String get notificationsSubtitle =>
      '+1 nos teus ecos e novas mensagens na tua zona.';

  @override
  String boostTooltip(String label) {
    return 'Ampliações de alcance: $label km';
  }

  @override
  String get settingsTitleStyle => 'Definições';

  @override
  String get pushBoostTitle => 'O teu eco chega mais longe';

  @override
  String get pushBoostBody => 'Alguém ampliou o alcance da tua mensagem.';

  @override
  String get pushNewPostTitle => 'Novo eco perto';

  @override
  String get pushNewPostBody => 'Alguém escreveu na tua zona.';
}
