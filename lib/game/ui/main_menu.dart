import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../epic_game.dart';

class MainMenuOverlay extends StatelessWidget {
  final EpicGame game;
  const MainMenuOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A0E27), Color(0xFF1A1F3A), Color(0xFF0A0E27)],
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // العنوان
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EPIC',
                  style: GoogleFonts.cinzel(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFFD700),
                    letterSpacing: 12,
                    shadows: [
                      Shadow(
                        color: const Color(0xFFFFD700).withValues(alpha: 0.7),
                        blurRadius: 30,
                      ),
                    ],
                  ),
                ),
                Text(
                  'S T O R Y',
                  style: GoogleFonts.cinzel(
                    fontSize: 28,
                    color: const Color(0xB3FFFFFF),
                    letterSpacing: 20,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'An epic journey awaits...',
                  style: GoogleFonts.cinzel(
                    fontSize: 14,
                    color: const Color(0xFF8899BB),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            // الأزرار
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _MenuBtn(
                  label: 'ابدأ الرحلة',
                  icon: Icons.play_arrow_rounded,
                  onTap: game.startGame,
                ),
                const SizedBox(height: 14),
                _MenuBtn(
                  label: 'الإعدادات',
                  icon: Icons.settings_rounded,
                  onTap: () {},
                ),
                const SizedBox(height: 14),
                _MenuBtn(
                  label: 'خروج',
                  icon: Icons.exit_to_app_rounded,
                  onTap: () => SystemNavigator.pop(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _MenuBtn({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 22),
      label: Text(
        label,
        style: GoogleFonts.cinzel(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFD700).withValues(alpha: 0.12),
        foregroundColor: const Color(0xFFFFD700),
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xFFFFD700), width: 1.5),
        ),
        minimumSize: const Size(240, 56),
      ),
    );
  }
}
