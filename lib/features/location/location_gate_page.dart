import 'package:echo/features/session/session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationGatePage extends ConsumerWidget {
  const LocationGatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 48, 28, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Echo',
                style: GoogleFonts.fraunces(
                  fontSize: 48,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Solo ves mensajes a 15 km de donde estás. Sin cuentas, sin nombres.',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      height: 1.4,
                      color: Colors.black87,
                    ),
              ),
              const SizedBox(height: 28),
              Text(
                'Necesitamos GPS (y comprobamos la zona aproximada de tu red) para abrir el foro de tu alrededor.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.45,
                      color: Colors.black54,
                    ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () =>
                      ref.read(appBootstrapProvider.notifier).requestLocationAgain(),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text('Activar ubicación'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
