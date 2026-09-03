import 'dart:io';

import 'package:echo/core/echo_api.dart';
import 'package:echo/features/session/session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ComposerPage extends ConsumerStatefulWidget {
  const ComposerPage({super.key, this.postId});

  /// When set, creates a reply instead of a root post.
  final String? postId;

  @override
  ConsumerState<ComposerPage> createState() => _ComposerPageState();
}

class _ComposerPageState extends ConsumerState<ComposerPage> {
  final _controller = TextEditingController();
  final _picker = ImagePicker();
  XFile? _image;
  bool _submitting = false;
  String? _error;

  bool get _isReply => widget.postId != null;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    setState(() => _error = null);
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (file == null) return;

    final allowed = await ref.read(faceGateProvider).allowsImage(file.path);
    if (!allowed) {
      setState(() {
        _image = null;
        _error =
            'No se permiten fotos donde se reconozca a personas. Elige otra imagen.';
      });
      return;
    }

    setState(() => _image = file);
  }

  Future<void> _submit() async {
    final body = _controller.text.trim();
    if (body.isEmpty) {
      setState(() => _error = 'Escribe algo.');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      final api = ref.read(echoApiProvider);
      final fix = await ref.read(locationServiceProvider).currentFix();
      String? mediaId;

      if (_image != null) {
        final allowed =
            await ref.read(faceGateProvider).allowsImage(_image!.path);
        if (!allowed) {
          setState(() {
            _submitting = false;
            _error = 'Imagen rechazada: se detectó una cara.';
          });
          return;
        }
        final media = await api.uploadMedia(
          filePath: _image!.path,
          fileName: _image!.name,
        );
        mediaId = media.id;
      }

      if (_isReply) {
        await api.createReply(
          postId: widget.postId!,
          body: body,
          lat: fix.latitude,
          lon: fix.longitude,
          mediaId: mediaId,
        );
      } else {
        await api.createPost(
          body: body,
          lat: fix.latitude,
          lon: fix.longitude,
          mediaId: mediaId,
        );
      }

      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      final api = asApiException(e);
      setState(() {
        _submitting = false;
        _error = api?.message ?? e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isReply ? 'Responder' : 'Nuevo eco'),
        actions: [
          TextButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Publicar'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _controller,
            maxLines: 8,
            maxLength: 2000,
            decoration: const InputDecoration(
              hintText: '¿Qué se oye por aquí?',
            ),
          ),
          const SizedBox(height: 12),
          if (_image != null)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(_image!.path),
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton.filled(
                    onPressed: () => setState(() => _image = null),
                    icon: const Icon(Icons.close),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _submitting ? null : _pickImage,
            icon: const Icon(Icons.image_outlined),
            label: const Text('Añadir imagen (sin caras)'),
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ],
      ),
    );
  }
}
