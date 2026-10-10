// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Echo';

  @override
  String get tabZone => 'Zone';

  @override
  String get tabMap => 'Map';

  @override
  String get settings => 'Settings';

  @override
  String get retry => 'Retry';

  @override
  String get write => 'Write';

  @override
  String get reply => 'Reply';

  @override
  String get publish => 'Post';

  @override
  String get cancel => 'Cancel';

  @override
  String get continueAction => 'Continue';

  @override
  String get openThread => 'Open thread';

  @override
  String get thread => 'Thread';

  @override
  String get map => 'Map';

  @override
  String get refresh => 'Refresh';

  @override
  String get zoneRadius => 'Zone radius';

  @override
  String zoneRadiusValue(int km) {
    return '$km km';
  }

  @override
  String distanceAt(String distance) {
    return 'At $distance';
  }

  @override
  String get distanceUnknown => 'At —';

  @override
  String get fromYourPosition => 'from your position';

  @override
  String repliesCount(int count) {
    return '$count replies';
  }

  @override
  String get boostPlusKm => '+1 km';

  @override
  String get boostPlusKmReach => '+1 km reach';

  @override
  String get boosted => 'Boosted';

  @override
  String get alreadyBoosted => 'Already boosted';

  @override
  String get emptyZoneTitle => 'Quiet zone';

  @override
  String get emptyZoneBody =>
      'Nobody has written nearby yet.\nBe the first in your area.';

  @override
  String get noRepliesYet => 'No replies yet.';

  @override
  String get repliesSection => 'Replies';

  @override
  String get nearbyEcho => 'Nearby echo';

  @override
  String mapOverlay(int count, int km) {
    return '$count echoes within $km km  ·  you are the teal pin';
  }

  @override
  String get newEcho => 'New echo';

  @override
  String get composerHint => 'What\'s happening around here?';

  @override
  String get addImageNoFaces => 'Add image (no faces)';

  @override
  String get writeSomething => 'Write something.';

  @override
  String get imageRejectedFace => 'Image rejected: a face was detected.';

  @override
  String get imageNoPeople =>
      'Photos with recognizable people are not allowed. Pick another image.';

  @override
  String get gateHeadline =>
      'You only see messages within 15 km. No accounts, no names.';

  @override
  String get gateCardTitle => 'Location to open your zone';

  @override
  String get gateCardBody =>
      'We need GPS (and check your network\'s approximate area) to open the forum around you.';

  @override
  String get enableLocation => 'Enable location';

  @override
  String get connectionFailed => 'Could not connect.';

  @override
  String get avatarTitle => 'Avatar (no faces)';

  @override
  String get avatarSubtitle => 'Optional. Rejected if ML Kit detects a face.';

  @override
  String get avatarRejected =>
      'Avatar rejected: images with recognizable people are not allowed.';

  @override
  String get avatarUpdated => 'Avatar updated.';

  @override
  String get newIdentityTitle => 'New anonymous identity';

  @override
  String get newIdentitySubtitle => 'Erase this device key and start over.';

  @override
  String get newIdentityDialogTitle => 'New identity?';

  @override
  String get newIdentityDialogBody =>
      'You will lose the link to your previous messages on this device.';

  @override
  String get darkThemeTitle => 'Dark theme';

  @override
  String get darkThemeSubtitle => 'OLED black background to save battery.';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsSubtitle =>
      '+1 on your echoes and new posts in your zone.';

  @override
  String boostTooltip(String label) {
    return 'Reach boosts: $label km';
  }

  @override
  String get settingsTitleStyle => 'Settings';

  @override
  String get pushBoostTitle => 'Your echo travels farther';

  @override
  String get pushBoostBody => 'Someone boosted your message\'s reach.';

  @override
  String get pushNewPostTitle => 'New echo nearby';

  @override
  String get pushNewPostBody => 'Someone posted in your zone.';
}
