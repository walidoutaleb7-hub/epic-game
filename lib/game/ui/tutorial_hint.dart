import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TutorialHintOverlay extends StatelessWidget {
  final String hint;
  final IconData icon;
  const TutorialHintOverlay({
    super.key,
    required this.hint,
    this.icon = Icons.lightbulb_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.only(top: 80),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xF00A0E27), Color(0xF01A1F3A)],
          ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFFFD700), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD700).withValues(alpha: 0.4),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFFFFD700), size: 26),
            const SizedBox(width: 12),
            Text(
              hint,
              style: GoogleFonts.cinzel(
                color: const Color(0xFFFFD700),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
