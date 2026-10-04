import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreenOverlay extends StatelessWidget {
  const SplashScreenOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            Color(0xFF1A1F3A),
            Color(0xFF0A0E27),
            Color(0xFF000000),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة متوهجة
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.8),
                    blurRadius: 60,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 60,
                color: Colors.black,
              ),
            )
                .animate()
                .scale(duration: 800.ms, curve: Curves.elasticOut)
                .then()
                .shimmer(duration: 1500.ms),

            const SizedBox(height: 40),

            // EPIC
            Text(
              'EPIC',
              style: GoogleFonts.cinzel(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFFD700),
                letterSpacing: 16,
                shadows: [
                  Shadow(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.9),
                    blurRadius: 40,
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 800.ms)
                .slideY(begin: 0.5, end: 0, curve: Curves.easeOut),

            // STORY
            Text(
              'S T O R Y',
              style: GoogleFonts.cinzel(
                fontSize: 24,
                color: Colors.white70,
                letterSpacing: 24,
              ),
            ).animate().fadeIn(delay: 800.ms, duration: 800.ms),

            const SizedBox(height: 60),

            // شريط تحميل
            SizedBox(
              width: 300,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      minHeight: 4,
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                      valueColor: const AlwaysStoppedAnimation(Color(0xFFFFD700)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'جارٍ التحميل...',
                    style: GoogleFonts.cinzel(
                      color: const Color(0xFF8899BB),
                      fontSize: 12,
                    ),
                  ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1500.ms),
                ],
              ),
            ).animate().fadeIn(delay: 1200.ms, duration: 500.ms),
          ],
        ),
      ),
    );
  }
}
