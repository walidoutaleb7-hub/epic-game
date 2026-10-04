import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../epic_game.dart';

class PauseMenuOverlay extends StatelessWidget {
  final EpicGame game;
  const PauseMenuOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xCC000000),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'إيقاف مؤقت',
              style: GoogleFonts.cinzel(
                fontSize: 48,
                color: const Color(0xFFFFD700),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            _Btn(
              label: 'متابعة',
              icon: Icons.play_arrow_rounded,
              onTap: game.resumeGame,
            ),
            const SizedBox(height: 14),
            _Btn(
              label: 'القائمة الرئيسية',
              icon: Icons.home_rounded,
              onTap: game.returnToMenu,
            ),
          ],
        ),
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _Btn({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label, style: GoogleFonts.cinzel(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFD700).withValues(alpha: 0.12),
        foregroundColor: const Color(0xFFFFD700),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xFFFFD700), width: 1.5),
        ),
        minimumSize: const Size(260, 55),
      ),
    );
  }
}
