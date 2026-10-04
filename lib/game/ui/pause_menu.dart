import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../epic_game.dart';

class PauseMenuOverlay extends StatelessWidget {
  final EpicGame game;
  const PauseMenuOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.85),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF0A0E27).withValues(alpha: 0.95),
                const Color(0xFF1A1F3A).withValues(alpha: 0.95),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFFFD700).withValues(alpha: 0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                blurRadius: 40,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.pause_circle_filled,
                      color: Color(0xFFFFD700), size: 72)
                  .animate()
                  .scale(curve: Curves.elasticOut, duration: 600.ms)
                  .shimmer(delay: 300.ms),
              const SizedBox(height: 12),
              Text(
                'إيقاف مؤقت',
                style: GoogleFonts.cinzel(
                  fontSize: 42,
                  color: const Color(0xFFFFD700),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 6,
                  shadows: [
                    Shadow(
                      color: const Color(0xFFFFD700).withValues(alpha: 0.7),
                      blurRadius: 20,
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
              Text(
                'PAUSED',
                style: GoogleFonts.cinzel(
                  fontSize: 12,
                  color: const Color(0xFF8899BB),
                  letterSpacing: 8,
                ),
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 40),
              _PauseBtn(
                label: 'متابعة',
                icon: Icons.play_arrow_rounded,
                color: const Color(0xFF4CAF50),
                onTap: game.resumeGame,
                delay: 400,
              ),
              const SizedBox(height: 14),
              _PauseBtn(
                label: 'الإعدادات',
                icon: Icons.settings_rounded,
                color: const Color(0xFF4FC3F7),
                onTap: game.openSettings,
                delay: 500,
              ),
              const SizedBox(height: 14),
              _PauseBtn(
                label: 'القائمة الرئيسية',
                icon: Icons.home_rounded,
                color: const Color(0xFFFFD700),
                onTap: game.returnToMenu,
                delay: 600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PauseBtn extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final int delay;

  const _PauseBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.delay,
  });

  @override
  State<_PauseBtn> createState() => _PauseBtnState();
}

class _PauseBtnState extends State<_PauseBtn> {
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
          width: 280,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                widget.color.withValues(alpha: 0.25),
                widget.color.withValues(alpha: 0.1),
              ],
            ),
            border: Border.all(color: widget.color, width: 2),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.4),
                blurRadius: 15,
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 20),
              Icon(widget.icon, color: widget.color, size: 26),
              const SizedBox(width: 16),
              Text(
                widget.label,
                style: GoogleFonts.cinzel(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: widget.delay.ms, duration: 400.ms)
        .slideX(begin: 0.3, end: 0);
  }
}
