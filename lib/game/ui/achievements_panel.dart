import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../systems/achievement_system.dart';

class AchievementsPanelOverlay extends StatelessWidget {
  final AchievementSystem system;
  final VoidCallback onClose;
  const AchievementsPanelOverlay({
    super.key,
    required this.system,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final unlocked = system.all.where((a) => a.unlocked).length;
    final total = system.all.length;

    return Container(
      color: const Color(0xEE000000),
      child: Center(
        child: Container(
          width: 600,
          height: 500,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0A0E27), Color(0xFF1A1F3A)],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFFFD700), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                blurRadius: 30,
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'الإنجازات',
                style: GoogleFonts.cinzel(
                  color: const Color(0xFFFFD700),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$unlocked / $total',
                style: GoogleFonts.cinzel(
                  color: const Color(0xFF8899BB),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: system.all.length,
                  itemBuilder: (context, i) {
                    final a = system.all[i];
                    return _AchievementTile(achievement: a);
                  },
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: onClose,
                icon: const Icon(Icons.arrow_back),
                label: Text('رجوع', style: GoogleFonts.cinzel(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700).withValues(alpha: 0.15),
                  foregroundColor: const Color(0xFFFFD700),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Color(0xFFFFD700), width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final Achievement achievement;
  const _AchievementTile({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final a = achievement;
    final ratio = (a.progress / a.target).clamp(0.0, 1.0);
    final color = a.unlocked ? const Color(0xFFFFD700) : const Color(0xFF546E7A);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: a.unlocked
            ? const Color(0x33FFD700)
            : const Color(0x22000000),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
      ),
      child: Row(
        children: [
          Icon(
            a.unlocked ? Icons.emoji_events : Icons.lock_outline,
            color: color,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.title,
                  style: GoogleFonts.cinzel(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  a.description,
                  style: GoogleFonts.cinzel(
                    color: const Color(0xFF8899BB),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 6,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0x33FFFFFF),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: ratio,
                        child: Container(
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${a.progress}/${a.target}',
            style: GoogleFonts.cinzel(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
