import 'package:echo/core/theme.dart';
import 'package:echo/features/home/home_shell.dart';
import 'package:echo/features/location/location_gate_page.dart';
import 'package:echo/features/session/session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: EchoApp()));
}

class EchoApp extends StatelessWidget {
  const EchoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Echo',
      debugShowCheckedModeBanner: false,
      theme: EchoTheme.light(),
      home: const _Root(),
    );
  }
}

class _Root extends ConsumerWidget {
  const _Root();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boot = ref.watch(appBootstrapProvider);

    return boot.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(e.toString(), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () =>
                      ref.read(appBootstrapProvider.notifier).retry(),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (state) {
        switch (state.phase) {
          case AppPhase.needsLocation:
            return const LocationGatePage();
          case AppPhase.error:
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Echo',
                        style: GoogleFonts.fraunces(fontSize: 36),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.errorMessage ?? 'No se pudo conectar.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () =>
                            ref.read(appBootstrapProvider.notifier).retry(),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          case AppPhase.ready:
          case AppPhase.bootstrapping:
            return const HomeShell();
        }
      },
    );
  }
}
