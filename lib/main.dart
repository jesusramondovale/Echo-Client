import 'package:echo/core/app_settings.dart';
import 'package:echo/core/theme.dart';
import 'package:echo/features/home/home_shell.dart';
import 'package:echo/features/location/location_gate_page.dart';
import 'package:echo/features/notifications/push_service.dart';
import 'package:echo/features/session/session_providers.dart';
import 'package:echo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: EchoApp()));
}

class EchoApp extends ConsumerStatefulWidget {
  const EchoApp({super.key});

  @override
  ConsumerState<EchoApp> createState() => _EchoAppState();
}

class _EchoAppState extends ConsumerState<EchoApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(pushServiceProvider).init());
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsProvider);

    ref.listen(appBootstrapProvider, (prev, next) {
      next.whenData((state) {
        if (state.phase == AppPhase.ready) {
          ref.read(pushServiceProvider).syncToken();
        }
      });
    });

    ref.listen(appSettingsProvider, (prev, next) {
      if (next.notificationsEnabled) {
        ref.read(pushServiceProvider).syncToken();
      }
    });

    return MaterialApp(
      title: 'Echo',
      debugShowCheckedModeBanner: false,
      theme: EchoTheme.light(),
      darkTheme: EchoTheme.darkOled(),
      themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.light,
      localeResolutionCallback: (locale, supported) {
        if (locale == null) return supported.first;
        for (final l in supported) {
          if (l.languageCode == locale.languageCode) return l;
        }
        return const Locale('en');
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const _Root(),
    );
  }
}

class _Root extends ConsumerWidget {
  const _Root();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boot = ref.watch(appBootstrapProvider);
    final l10n = AppLocalizations.of(context);
    final surface = EchoColors.surfaceOf(context);
    final ink = EchoColors.inkOf(context);
    final muted = EchoColors.mutedOf(context);

    return boot.when(
      loading: () => Scaffold(
        backgroundColor: surface,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.appName,
                style: GoogleFonts.syne(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: ink,
                ),
              ),
              const SizedBox(height: 24),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ],
          ),
        ),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: surface,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.appName,
                  style: GoogleFonts.syne(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: ink,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  e.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: muted, height: 1.4),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () =>
                      ref.read(appBootstrapProvider.notifier).retry(),
                  child: Text(l10n.retry),
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
              backgroundColor: surface,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.appName,
                        style: GoogleFonts.syne(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: ink,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.errorMessage ?? l10n.connectionFailed,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: muted, height: 1.4),
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: () =>
                            ref.read(appBootstrapProvider.notifier).retry(),
                        child: Text(l10n.retry),
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
