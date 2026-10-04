import 'dart:ui';

class GameConstants {
  // الفيزياء
  static const double gravity = 25.0;
  static const double playerSpeed = 14.0;
  static const double jumpForce = 42.0;
  static const double dashSpeed = 36.0;
  static const double dashDuration = 0.18;
  static const double dashCooldown = 0.7;

  // الألوان
  static const Color goldColor = Color(0xFFFFD700);
  static const Color darkBg = Color(0xFF0A0E27);
  static const Color midBg = Color(0xFF1A1F3A);
  static const Color playerBlue = Color(0xFF4FC3F7);
  static const Color playerBlueDark = Color(0xFF1565C0);
  static const Color groundGreen = Color(0xFF2E7D32);
  static const Color groundGreenLight = Color(0xFF66BB6A);
  static const Color enemyRed = Color(0xFFE53935);
  static const Color enemyRedDark = Color(0xFF8B0000);

  // اللعبة
  static const int maxHealth = 100;
  static const double cameraZoom = 50.0;
}
