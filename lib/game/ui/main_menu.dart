import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../emberfall_game.dart';
import 'particle_background.dart';

class MainMenuOverlay extends StatelessWidget {
  final EmberfallGame game;
  const MainMenuOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.5,
          colors: [
            Color(0xFF1A1F3A),
            Color(0xFF0A0E27),
            Color(0xFF000000),
          ],
        ),
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: ParticleBackground()),

          // توهجات جانبية
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFD700).withValues(alpha: 0.05),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.1),
                    blurRadius: 200,
                    spreadRadius: 100,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF4FC3F7).withValues(alpha: 0.05),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4FC3F7).withValues(alpha: 0.1),
                    blurRadius: 200,
                    spreadRadius: 100,
                  ),
                ],
              ),
            ),
          ),

          // المحتوى
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // العنوان
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // شعار
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const RadialGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFD700).withValues(alpha: 0.7),
                              blurRadius: 40,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.auto_awesome,
                            size: 36, color: Colors.black),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .scale(curve: Curves.elasticOut),

                      const SizedBox(height: 20),

                      Text(
                        'EMBER',
                        style: GoogleFonts.cinzel(
                          fontSize: 96,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFD700),
                          letterSpacing: 12,
                          height: 1,
                          shadows: [
                            Shadow(
                              color: const Color(0xFFFFD700).withValues(alpha: 0.9),
                              blurRadius: 50,
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 800.ms)
                          .slideX(begin: -0.3, end: 0),

                      Text(
                        'F A L L',
                        style: GoogleFonts.cinzel(
                          fontSize: 32,
                          color: Colors.white70,
                          letterSpacing: 20,
                          height: 1,
                        ),
                      ).animate().fadeIn(delay: 400.ms, duration: 800.ms),

                      const SizedBox(height: 16),

                      Text(
                        'An ember burns in the dark...',
                        style: GoogleFonts.cinzel(
                          fontSize: 14,
                          color: const Color(0xFF8899BB),
                          fontStyle: FontStyle.italic,
                        ),
                      ).animate().fadeIn(delay: 600.ms, duration: 800.ms),

                      const SizedBox(height: 32),

                      // شريط سفلي
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 2,
                            color: const Color(0xFFFFD700),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'v1.0',
                            style: GoogleFonts.cinzel(
                              fontSize: 12,
                              color: const Color(0xFF546E7A),
                              letterSpacing: 4,
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 800.ms, duration: 800.ms),
                    ],
                  ),

                  // الأزرار
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _MenuBtn(
                        label: 'ابدأ الرحلة',
                        subtitle: 'Start Adventure',
                        icon: Icons.play_arrow_rounded,
                        gradient: const [Color(0xFFFFD700), Color(0xFFFFA000)],
                        onTap: game.startGame,
                        delay: 400,
                      ),
                      const SizedBox(height: 18),
                      _MenuBtn(
                        label: 'الإنجازات',
                        subtitle: 'Achievements',
                        icon: Icons.emoji_events_rounded,
                        gradient: const [Color(0xFF9C27B0), Color(0xFF6A1B9A)],
                        onTap: game.openAchievements,
                        delay: 600,
                      ),
                      const SizedBox(height: 18),
                      _MenuBtn(
                        label: 'الإعدادات',
                        subtitle: 'Settings',
                        icon: Icons.settings_rounded,
                        gradient: const [Color(0xFF4FC3F7), Color(0xFF1565C0)],
                        onTap: game.openSettings,
                        delay: 800,
                      ),
                      const SizedBox(height: 18),
                      _MenuBtn(
                        label: 'خروج',
                        subtitle: 'Exit',
                        icon: Icons.exit_to_app_rounded,
                        gradient: const [Color(0xFFE53935), Color(0xFFB71C1C)],
                        onTap: () => SystemNavigator.pop(),
                        delay: 1000,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuBtn extends StatefulWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;
  final int delay;

  const _MenuBtn({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
    required this.delay,
  });

  @override
  State<_MenuBtn> createState() => _MenuBtnState();
}

class _MenuBtnState extends State<_MenuBtn> {
  bool _pressed = false;
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.95 : (_hovered ? 1.05 : 1.0),
          duration: const Duration(milliseconds: 150),
          child: Container(
            width: 300,
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.gradient
                    .map((c) => c.withValues(alpha: _pressed ? 0.9 : 0.7))
                    .toList(),
              ),
              border: Border.all(
                color: widget.gradient.first.withValues(alpha: 0.9),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.gradient.first.withValues(alpha: _hovered ? 0.8 : 0.4),
                  blurRadius: _hovered ? 30 : 20,
                  spreadRadius: _hovered ? 2 : 0,
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 20),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.3),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(widget.icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.label,
                        style: GoogleFonts.cinzel(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.subtitle,
                        style: GoogleFonts.cinzel(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.7),
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.white, size: 16),
                const SizedBox(width: 20),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: widget.delay.ms, duration: 600.ms)
        .slideX(begin: 0.4, end: 0, curve: Curves.easeOutCubic);
  }
}
