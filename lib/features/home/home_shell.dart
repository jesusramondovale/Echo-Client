import 'package:echo/core/theme.dart';
import 'package:echo/features/feed/feed_page.dart';
import 'package:echo/features/map/map_page.dart';
import 'package:echo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          FeedPage(),
          MapPage(),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: EchoColors.cardOf(context),
          border: Border(
            top: BorderSide(color: EchoColors.outlineOf(context)),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.forum_outlined),
              selectedIcon: const Icon(Icons.forum_rounded),
              label: l10n.tabZone,
            ),
            NavigationDestination(
              icon: const Icon(Icons.map_outlined),
              selectedIcon: const Icon(Icons.map_rounded),
              label: l10n.tabMap,
            ),
          ],
        ),
      ),
    );
  }
}
