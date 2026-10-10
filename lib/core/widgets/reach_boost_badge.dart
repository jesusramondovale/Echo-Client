import 'package:echo/core/theme.dart';
import 'package:echo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Shows how many +1 km boosts a post has beyond the base 15 km (`+0`, `+1`…).
class ReachBoostBadge extends StatelessWidget {
  const ReachBoostBadge({
    super.key,
    required this.reachBoost,
    this.size = 36,
  });

  final int reachBoost;
  final double size;

  @override
  Widget build(BuildContext context) {
    final value = reachBoost < 0 ? 0 : reachBoost;
    final label = '+$value';
    final l10n = AppLocalizations.of(context);
    return Tooltip(
      message: l10n.boostTooltip(label),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: EchoColors.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(size * 0.33),
          border: Border.all(color: EchoColors.primary.withValues(alpha: 0.28)),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: size * (value >= 10 ? 0.30 : 0.34),
            fontWeight: FontWeight.w800,
            color: EchoColors.primary,
            height: 1,
          ),
        ),
      ),
    );
  }
}
