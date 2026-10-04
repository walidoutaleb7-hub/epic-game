import 'dart:ui';

class GameConstants {
  static const double gravity = 55.0;
  static const double playerSpeed = 220.0;
  static const double jumpVelocity = -520.0;
  static const double dashSpeed = 700.0;
  static const double dashDuration = 0.15;
  static const double dashCooldown = 0.7;
  static const double cameraZoom = 2.5;

  static const Color goldColor = Color(0xFFFFD700);
  static const Color darkBg = Color(0xFF0A0E27);
  static const Color playerBlue = Color(0xFF4FC3F7);
  static const Color enemyRed = Color(0xFFE53935);
  static const int maxHealth = 100;
}
