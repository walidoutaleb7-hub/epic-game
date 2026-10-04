import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameOverOverlay extends StatelessWidget {
  final VoidCallback onRetry;
  final VoidCallback onMenu;
  final int score;
  final int kills;

  const GameOverOverlay({
    super.key,
    required this.onRetry,
    required this.onMenu,
    required this.score,
    required this.kills,
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
              'سقطت',
              style: GoogleFonts.cinzel(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFE53935),
                letterSpacing: 8,
                shadows: const [
                  Shadow(color: Color(0xFFFF5252), blurRadius: 30),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'لكن الرحلة لم تنتهِ بعد...',
              style: GoogleFonts.cinzel(
                color: const Color(0xFF8899BB),
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 32),
            _StatsRow(label: 'النقاط', value: '$score', icon: Icons.star_rounded),
            const SizedBox(height: 8),
            _StatsRow(label: 'القتلات', value: '$kills', icon: Icons.dangerous),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Btn(
                  label: 'أعد المحاولة',
                  icon: Icons.refresh_rounded,
                  color: const Color(0xFF4CAF50),
                  onTap: onRetry,
                ),
                const SizedBox(width: 20),
                _Btn(
                  label: 'القائمة',
                  icon: Icons.home_rounded,
                  color: const Color(0xFFFFD700),
                  onTap: onMenu,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatsRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: const Color(0xFFFFD700), size: 24),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: GoogleFonts.cinzel(
            color: const Color(0xFFE0E0E0),
            fontSize: 18,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.cinzel(
            color: const Color(0xFFFFD700),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _Btn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _Btn({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 22),
      label: Text(label, style: GoogleFonts.cinzel(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.15),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color, width: 2),
        ),
        minimumSize: const Size(200, 60),
      ),
    );
  }
}
