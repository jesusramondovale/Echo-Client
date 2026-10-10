import 'dart:io';

import 'package:echo/core/echo_api.dart';
import 'package:echo/core/theme.dart';
import 'package:echo/features/session/session_providers.dart';
import 'package:echo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
        _error = AppLocalizations.of(context).imageNoPeople;
      });
      return;
    }

    setState(() => _image = file);
  }

  Future<void> _submit() async {
    final body = _controller.text.trim();
    if (body.isEmpty) {
      setState(() => _error = AppLocalizations.of(context).writeSomething);
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
            _error = AppLocalizations.of(context).imageRejectedFace;
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
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          _isReply ? l10n.reply : l10n.newEcho,
          style: GoogleFonts.syne(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: EchoColors.inkOf(context),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton(
              onPressed: _submitting ? null : _submit,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                minimumSize: Size.zero,
              ),
              child: _submitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(l10n.publish),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          TextField(
            controller: _controller,
            maxLines: 10,
            maxLength: 2000,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 17,
              height: 1.45,
            ),
            decoration: InputDecoration(
              hintText: l10n.composerHint,
            ),
          ),
          const SizedBox(height: 16),
          if (_image != null)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.file(
                    File(_image!.path),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: EchoColors.ink.withValues(alpha: 0.72),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => setState(() => _image = null),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _submitting ? null : _pickImage,
            icon: const Icon(Icons.image_outlined, size: 20),
            label: Text(l10n.addImageNoFaces),
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                _error!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
