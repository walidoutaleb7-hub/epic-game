import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../systems/audio_system.dart';

class SettingsMenuOverlay extends StatefulWidget {
  final VoidCallback onClose;
  const SettingsMenuOverlay({super.key, required this.onClose});

  @override
  State<SettingsMenuOverlay> createState() => _SettingsMenuOverlayState();
}

class _SettingsMenuOverlayState extends State<SettingsMenuOverlay> {
  double _musicVolume = 0.7;
  double _sfxVolume = 0.8;
  bool _vibration = true;
  bool _showFps = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xEE000000),
      child: Center(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(28),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'الإعدادات',
                style: GoogleFonts.cinzel(
                  color: const Color(0xFFFFD700),
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 24),
              _SettingSlider(
                label: 'الموسيقى',
                icon: Icons.music_note,
                value: _musicVolume,
                onChange: (v) => setState(() => _musicVolume = v),
              ),
              _SettingSlider(
                label: 'المؤثرات',
                icon: Icons.volume_up,
                value: _sfxVolume,
                onChange: (v) => setState(() => _sfxVolume = v),
              ),
              _SettingToggle(
                label: 'الاهتزاز',
                icon: Icons.vibration,
                value: _vibration,
                onChange: (v) => setState(() => _vibration = v),
              ),
              _SettingToggle(
                label: 'إظهار FPS',
                icon: Icons.speed,
                value: _showFps,
                onChange: (v) => setState(() => _showFps = v),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: widget.onClose,
                icon: const Icon(Icons.arrow_back),
                label: Text(
                  'رجوع',
                  style: GoogleFonts.cinzel(fontSize: 16),
                ),
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

class _SettingSlider extends StatelessWidget {
  final String label;
  final IconData icon;
  final double value;
  final ValueChanged<double> onChange;

  const _SettingSlider({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFFD700), size: 24),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.cinzel(
                color: const Color(0xFFE0E0E0),
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: const Color(0xFFFFD700),
                inactiveTrackColor: const Color(0x33FFFFFF),
                thumbColor: const Color(0xFFFFD700),
                overlayColor: const Color(0x33FFD700),
              ),
              child: Slider(value: value, onChanged: onChange),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '${(value * 100).toInt()}%',
              style: GoogleFonts.cinzel(
                color: const Color(0xFFFFD700),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingToggle extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChange;

  const _SettingToggle({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFFD700), size: 24),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.cinzel(
                color: const Color(0xFFE0E0E0),
                fontSize: 15,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChange,
            activeThumbColor: const Color(0xFFFFD700),
            activeTrackColor: const Color(0x66FFD700),
          ),
        ],
      ),
    );
  }
}
