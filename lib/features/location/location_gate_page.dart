import 'package:echo/core/theme.dart';
import 'package:echo/features/location/location_service.dart';
import 'package:echo/features/session/session_providers.dart';
import 'package:echo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationGatePage extends ConsumerStatefulWidget {
  const LocationGatePage({super.key});

  @override
  ConsumerState<LocationGatePage> createState() => _LocationGatePageState();
}

class _LocationGatePageState extends ConsumerState<LocationGatePage>
    with WidgetsBindingObserver {
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _tryEnableLocation(openSettings: false);
    }
  }

  Future<void> _tryEnableLocation({required bool openSettings}) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final location = ref.read(locationServiceProvider);
      final result = await location.requestAccess(
        openSettingsIfNeeded: openSettings,
      );
      if (!mounted) return;
      if (result == LocationAccessResult.granted) {
        // Refresh bootstrap without reopening settings.
        await ref.read(appBootstrapProvider.notifier).retry();
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0B1220),
              Color(0xFF12353A),
              Color(0xFFF4F6F8),
            ],
            stops: [0.0, 0.42, 0.78],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 40, 28, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.appName,
                  style: GoogleFonts.syne(
                    fontSize: 56,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  l10n.gateHeadline,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.88),
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: EchoColors.cardOf(context),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: EchoColors.outlineOf(context)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.radar_rounded,
                        color: EchoColors.primary,
                        size: 28,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.gateCardTitle,
                        style: GoogleFonts.syne(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: EchoColors.inkOf(context),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.gateCardBody,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          height: 1.45,
                          color: EchoColors.mutedOf(context),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _busy
                              ? null
                              : () => _tryEnableLocation(openSettings: true),
                          child: _busy
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(l10n.enableLocation),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
