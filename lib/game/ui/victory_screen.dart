import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            const Color(0xFFFFD700).withValues(alpha: 0.15),
            Colors.black.withValues(alpha: 0.95),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.9),
                    blurRadius: 50,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: const Icon(Icons.emoji_events, color: Colors.black, size: 70),
            )
                .animate()
                .scale(curve: Curves.elasticOut, duration: 800.ms)
                .then()
                .shimmer(duration: 1500.ms, delay: 500.ms),

            const SizedBox(height: 24),

            Text(
              isLastLevel ? 'انتصرت!' : 'أحسنت!',
              style: GoogleFonts.cinzel(
                fontSize: 76,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFFD700),
                letterSpacing: 8,
                shadows: [
                  Shadow(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.9),
                    blurRadius: 40,
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 300.ms, duration: 700.ms).slideY(begin: -0.3, end: 0),

            Text(
              isLastLevel ? 'أنقذت المملكة من الظلام!' : 'LEVEL COMPLETE',
              style: GoogleFonts.cinzel(
                fontSize: 14,
                color: const Color(0xFF8899BB),
                letterSpacing: 8,
                fontStyle: FontStyle.italic,
              ),
            ).animate().fadeIn(delay: 500.ms),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFFD700).withValues(alpha: 0.6), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.4),
                    blurRadius: 25,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 40),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'النقاط',
                        style: GoogleFonts.cinzel(
                          color: const Color(0xFF8899BB),
                          fontSize: 11,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        '$score',
                        style: GoogleFonts.cinzel(
                          color: const Color(0xFFFFD700),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 700.ms, duration: 500.ms).scale(),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isLastLevel) ...[
                  _VBtn(
                    label: 'المستوى التالي',
                    icon: Icons.arrow_forward_rounded,
                    color: const Color(0xFF4CAF50),
                    onTap: onNextLevel,
                    delay: 900,
                  ),
                  const SizedBox(width: 20),
                ],
                _VBtn(
                  label: 'القائمة',
                  icon: Icons.home_rounded,
                  color: const Color(0xFFFFD700),
                  onTap: onMenu,
                  delay: 1000,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _VBtn extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final int delay;

  const _VBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.delay,
  });

  @override
  State<_VBtn> createState() => _VBtnState();
}

class _VBtnState extends State<_VBtn> {
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
          width: 240,
          height: 64,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.color.withValues(alpha: 0.4),
                widget.color.withValues(alpha: 0.15),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: widget.color, width: 2),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.6),
                blurRadius: 25,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: widget.color, size: 26),
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
    ).animate().fadeIn(delay: widget.delay.ms).scale(curve: Curves.easeOutBack);
  }
}
