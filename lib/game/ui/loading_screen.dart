import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingScreenOverlay extends StatelessWidget {
  final String message;
  const LoadingScreenOverlay({super.key, this.message = 'جارٍ التحميل...'});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A0E27), Color(0xFF1A1F3A)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'EPIC',
              style: GoogleFonts.cinzel(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFFD700),
                letterSpacing: 10,
              ),
            ),
            Text(
              'S T O R Y',
              style: GoogleFonts.cinzel(
                fontSize: 20,
                color: Colors.white70,
                letterSpacing: 16,
              ),
            ),
            const SizedBox(height: 40),
            const SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                minHeight: 6,
                backgroundColor: Color(0x33FFFFFF),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: GoogleFonts.cinzel(
                color: const Color(0xFF8899BB),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
