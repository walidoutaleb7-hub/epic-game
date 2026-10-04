import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
      color: Colors.black.withValues(alpha: 0.9),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [Color(0xFFE53935), Color(0xFF8B0000)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE53935).withValues(alpha: 0.8),
                    blurRadius: 40,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(Icons.close_rounded, color: Colors.white, size: 60),
            )
                .animate()
                .scale(curve: Curves.elasticOut, duration: 700.ms)
                .shimmer(delay: 500.ms),

            const SizedBox(height: 20),

            Text(
              'سقطت',
              style: GoogleFonts.cinzel(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFE53935),
                letterSpacing: 10,
                shadows: [
                  Shadow(
                    color: const Color(0xFFE53935).withValues(alpha: 0.9),
                    blurRadius: 40,
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideY(begin: -0.3, end: 0),

            Text(
              'YOU DIED',
              style: GoogleFonts.cinzel(
                fontSize: 14,
                color: const Color(0xFF8899BB),
                letterSpacing: 8,
              ),
            ).animate().fadeIn(delay: 400.ms),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _StatCard(
                  icon: Icons.star_rounded,
                  label: 'النقاط',
                  value: '$score',
                  color: const Color(0xFFFFD700),
                ),
                const SizedBox(width: 16),
                _StatCard(
                  icon: Icons.dangerous,
                  label: 'القتلات',
                  value: '$kills',
                  color: const Color(0xFFFF5252),
                ),
              ],
            ).animate().fadeIn(delay: 600.ms, duration: 500.ms),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ActionBtn(
                  label: 'إعادة',
                  icon: Icons.refresh_rounded,
                  color: const Color(0xFF4CAF50),
                  onTap: onRetry,
                  delay: 800,
                ),
                const SizedBox(width: 20),
                _ActionBtn(
                  label: 'القائمة',
                  icon: Icons.home_rounded,
                  color: const Color(0xFFFFD700),
                  onTap: onMenu,
                  delay: 900,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 20),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.cinzel(color: const Color(0xFF8899BB), fontSize: 11),
          ),
          Text(
            value,
            style: GoogleFonts.cinzel(
              color: color,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final int delay;

  const _ActionBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.delay,
  });

  @override
  State<_ActionBtn> createState() => _ActionBtnState();
}

class _ActionBtnState extends State<_ActionBtn> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 200,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.color.withValues(alpha: 0.3),
                widget.color.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: widget.color, width: 2),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.5),
                blurRadius: 20,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: widget.color, size: 24),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: GoogleFonts.cinzel(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: widget.delay.ms).slideY(begin: 0.3, end: 0);
  }
}
