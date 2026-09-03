import 'package:echo/core/config.dart';
import 'package:echo/features/session/session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          _message =
              'Avatar rechazado: no se permiten imágenes con personas reconocibles.';
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
        _message = 'Avatar actualizado.';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Radio de zona'),
            subtitle: Text('${AppConfig.feedRadiusKm} km'),
          ),
          ListTile(
            title: const Text('Avatar (sin caras)'),
            subtitle: const Text('Opcional. Se rechaza si ML Kit detecta una cara.'),
            trailing: _busy
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.person_outline),
            onTap: _busy ? null : _pickAvatar,
          ),
          ListTile(
            title: const Text('Nueva identidad anónima'),
            subtitle: const Text(
              'Borra la clave de este dispositivo y empieza de cero.',
            ),
            onTap: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('¿Nueva identidad?'),
                  content: const Text(
                    'Perderás el vínculo con tus mensajes anteriores en este dispositivo.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancelar'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Continuar'),
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
          if (_message != null)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(_message!),
            ),
        ],
      ),
    );
  }
}
