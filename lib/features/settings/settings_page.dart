import 'package:echo/core/app_settings.dart';
import 'package:echo/core/config.dart';
import 'package:echo/core/theme.dart';
import 'package:echo/features/notifications/push_service.dart';
import 'package:echo/features/session/session_providers.dart';
import 'package:echo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  String? _message;
  bool _busy = false;

  Future<void> _pickAvatar() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        imageQuality: 85,
      );
      if (file == null) {
        setState(() => _busy = false);
        return;
      }

      final allowed = await ref.read(faceGateProvider).allowsImage(file.path);
      if (!allowed) {
        setState(() {
          _busy = false;
          _message = l10n.avatarRejected;
        });
        return;
      }

      final api = ref.read(echoApiProvider);
      final media = await api.uploadMedia(
        filePath: file.path,
        fileName: file.name,
      );
      await api.setAvatar(media.id);
      setState(() {
        _busy = false;
        _message = l10n.avatarUpdated;
      });
    } catch (e) {
      setState(() {
        _busy = false;
        _message = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(appSettingsProvider);
    final ink = EchoColors.inkOf(context);
    final muted = EchoColors.mutedOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: GoogleFonts.syne(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: ink,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          _SettingsCard(
            children: [
              ListTile(
                leading: const Icon(Icons.radar_rounded),
                title: Text(l10n.zoneRadius),
                subtitle: Text(l10n.zoneRadiusValue(AppConfig.feedRadiusKm)),
              ),
              const Divider(height: 1, indent: 20, endIndent: 20),
              SwitchListTile(
                secondary: const Icon(Icons.dark_mode_outlined),
                title: Text(l10n.darkThemeTitle),
                subtitle: Text(l10n.darkThemeSubtitle),
                value: settings.darkMode,
                onChanged: (v) =>
                    ref.read(appSettingsProvider.notifier).setDarkMode(v),
              ),
              const Divider(height: 1, indent: 20, endIndent: 20),
              SwitchListTile(
                secondary: const Icon(Icons.notifications_outlined),
                title: Text(l10n.notificationsTitle),
                subtitle: Text(l10n.notificationsSubtitle),
                value: settings.notificationsEnabled,
                onChanged: (v) async {
                  await ref
                      .read(appSettingsProvider.notifier)
                      .setNotificationsEnabled(v);
                  if (v) {
                    await ref.read(pushServiceProvider).syncToken();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SettingsCard(
            children: [
              ListTile(
                leading: const Icon(Icons.person_outline_rounded),
                title: Text(l10n.avatarTitle),
                subtitle: Text(l10n.avatarSubtitle),
                trailing: _busy
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.chevron_right_rounded),
                onTap: _busy ? null : _pickAvatar,
              ),
              const Divider(height: 1, indent: 20, endIndent: 20),
              ListTile(
                leading: const Icon(
                  Icons.refresh_rounded,
                  color: EchoColors.secondary,
                ),
                title: Text(l10n.newIdentityTitle),
                subtitle: Text(l10n.newIdentitySubtitle),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(l10n.newIdentityDialogTitle),
                      content: Text(l10n.newIdentityDialogBody),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text(l10n.cancel),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text(l10n.continueAction),
                        ),
                      ],
                    ),
                  );
                  if (ok == true) {
                    await ref.read(appBootstrapProvider.notifier).resetIdentity();
                    if (context.mounted) Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
          if (_message != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
              child: Text(
                _message!,
                style: GoogleFonts.plusJakartaSans(
                  color: muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: EchoColors.cardOf(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: EchoColors.outlineOf(context)),
      ),
      child: Column(children: children),
    );
  }
}
