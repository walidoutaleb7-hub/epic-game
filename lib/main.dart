import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const EpicGameApp());
}

class EpicGameApp extends StatelessWidget {
  const EpicGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Epic Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0E27),
        textTheme: GoogleFonts.cinzelTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      home: const MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0E27),
              Color(0xFF1A1F3A),
              Color(0xFF0A0E27),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'EPIC',
                style: GoogleFonts.cinzel(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFFD700),
                  letterSpacing: 8,
                  shadows: [
                    Shadow(
                      color: const Color(0xFFFFD700).withOpacity(0.6),
                      blurRadius: 20,
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .slideY(begin: -0.5, end: 0),
              Text(
                'S T O R Y',
                style: GoogleFonts.cinzel(
                  fontSize: 28,
                  color: Colors.white70,
                  letterSpacing: 12,
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 800.ms),

              const SizedBox(height: 80),

              _MenuButton(
                label: 'ابدأ القصة',
                icon: Icons.play_arrow_rounded,
                onTap: () {},
                delay: 800,
              ),
              const SizedBox(height: 20),
              _MenuButton(
                label: 'الإعدادات',
                icon: Icons.settings_rounded,
                onTap: () {},
                delay: 1000,
              ),
              const SizedBox(height: 20),
              _MenuButton(
                label: 'خروج',
                icon: Icons.exit_to_app_rounded,
                onTap: () {},
                delay: 1200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final int delay;

  const _MenuButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 24),
      label: Text(
        label,
        style: GoogleFonts.cinzel(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFD700).withOpacity(0.15),
        foregroundColor: const Color(0xFFFFD700),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFFFD700), width: 1.5),
        ),
        minimumSize: const Size(260, 60),
      ),
    )
        .animate()
        .fadeIn(delay: delay.ms, duration: 600.ms)
        .slideX(begin: 0.3, end: 0);
  }
}