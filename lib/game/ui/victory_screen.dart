import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VictoryOverlay extends StatelessWidget {
  final VoidCallback onNextLevel;
  final VoidCallback onMenu;
  final int score;
  final bool isLastLevel;

  const VictoryOverlay({
    super.key,
    required this.onNextLevel,
    required this.onMenu,
    required this.score,
    required this.isLastLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xEE000000),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLastLevel ? 'انتصرت!' : 'أحسنت!',
              style: GoogleFonts.cinzel(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFFD700),
                letterSpacing: 8,
                shadows: const [
                  Shadow(color: Color(0xFFFFD700), blurRadius: 40),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isLastLevel
                  ? 'أنقذت المملكة من الظلام!'
                  : 'المستوى القادم ينتظرك...',
              style: GoogleFonts.cinzel(
                color: const Color(0xFFE0E0E0),
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 32),
                const SizedBox(width: 10),
                Text(
                  'النقاط: $score',
                  style: GoogleFonts.cinzel(
                    color: const Color(0xFFFFD700),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isLastLevel)
                  ElevatedButton.icon(
                    onPressed: onNextLevel,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: Text(
                      'المستوى التالي',
                      style: GoogleFonts.cinzel(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50).withValues(alpha: 0.2),
                      foregroundColor: const Color(0xFF4CAF50),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Color(0xFF4CAF50), width: 2),
                      ),
                      minimumSize: const Size(220, 60),
                    ),
                  ),
                if (!isLastLevel) const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: onMenu,
                  icon: const Icon(Icons.home_rounded),
                  label: Text(
                    'القائمة الرئيسية',
                    style: GoogleFonts.cinzel(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700).withValues(alpha: 0.15),
                    foregroundColor: const Color(0xFFFFD700),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFFFFD700), width: 2),
                    ),
                    minimumSize: const Size(220, 60),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
