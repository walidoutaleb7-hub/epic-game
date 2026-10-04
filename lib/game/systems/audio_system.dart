import 'package:flame_audio/flame_audio.dart';

class AudioSystem {
  static bool _muted = false;

  static Future<void> playMusic(String fileName) async {
    if (_muted) return;
    try {
      await FlameAudio.bgm.play('music/$fileName');
    } catch (_) {}
  }

  static Future<void> stopMusic() async {
    try {
      await FlameAudio.bgm.stop();
    } catch (_) {}
  }

  static Future<void> playSfx(String fileName) async {
    if (_muted) return;
    try {
      await FlameAudio.play('sfx/$fileName');
    } catch (_) {}
  }

  static void toggleMute() {
    _muted = !_muted;
    if (_muted) stopMusic();
  }

  static bool get isMuted => _muted;
}
