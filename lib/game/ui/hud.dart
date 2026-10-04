import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../emberfall_game.dart';

class HudOverlay extends StatelessWidget {
  final EmberfallGame game;
  const HudOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // صحة اللاعب
        Positioned(
          top: 20,
          left: 20,
          child: _GlassPanel(
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [Color(0xFFFF5252), Color(0xFFB71C1C)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF5252).withValues(alpha: 0.6),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.favorite, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الصحة',
                      style: GoogleFonts.cinzel(
                        color: const Color(0xFF8899BB),
                        fontSize: 10,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 160,
                      height: 12,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: (game.health / game.maxHealth).clamp(0.0, 1.0),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFF5252), Color(0xFFFF8A80)],
                                ),
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF5252).withValues(alpha: 0.7),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${game.health} / ${game.maxHealth}',
                      style: GoogleFonts.cinzel(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // زر الإيقاف
        Positioned(
          top: 20,
          right: 180,
          child: _IconButton(
            icon: Icons.pause_rounded,
            color: const Color(0xFFFFD700),
            onTap: game.pauseGame,
          ),
        ),

        // النقاط
        Positioned(
          top: 20,
          right: 20,
          child: _GlassPanel(
            child: Row(
              children: [
                const Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 26),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'النقاط',
                      style: GoogleFonts.cinzel(
                        color: const Color(0xFF8899BB),
                        fontSize: 10,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      '${game.score}',
                      style: GoogleFonts.cinzel(
                        color: const Color(0xFFFFD700),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Joystick
        Positioned(
          left: 40,
          bottom: 40,
          child: VirtualJoystick(onMove: game.movePlayer),
        ),

        // أزرار الأكشن
        Positioned(
          right: 40,
          bottom: 40,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  _ActionButton(
                    label: 'خطاف',
                    icon: Icons.anchor_rounded,
                    color: const Color(0xFF00BCD4),
                    onTap: game.hookPlayer,
                  ),
                  const SizedBox(height: 12),
                  _ActionButton(
                    label: 'قذيفة',
                    icon: Icons.bolt_rounded,
                    color: const Color(0xFFFFC107),
                    onTap: game.fireProjectile,
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Column(
                children: [
                  _ActionButton(
                    label: 'اندفاع',
                    icon: Icons.flash_on_rounded,
                    color: const Color(0xFF9C27B0),
                    onTap: game.dashPlayer,
                  ),
                  const SizedBox(height: 12),
                  _ActionButton(
                    label: 'هجوم',
                    icon: Icons.sports_martial_arts,
                    color: const Color(0xFFFF5252),
                    onTap: game.attackPlayer,
                  ),
                ],
              ),
              const SizedBox(width: 14),
              _ActionButton(
                label: 'قفز',
                icon: Icons.arrow_upward_rounded,
                color: const Color(0xFF4CAF50),
                onTap: game.jumpPlayer,
                large: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// ==================== لوحة زجاجية ====================
class _GlassPanel extends StatelessWidget {
  final Widget child;
  const _GlassPanel({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withValues(alpha: 0.7),
            Colors.black.withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFFFD700).withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 12,
          ),
          BoxShadow(
            color: const Color(0xFFFFD700).withValues(alpha: 0.15),
            blurRadius: 20,
          ),
        ],
      ),
      child: child,
    );
  }
}

/// ==================== زر أيقونة ====================
class _IconButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _IconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_IconButton> createState() => _IconButtonState();
}

class _IconButtonState extends State<_IconButton> {
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
        scale: _pressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withValues(alpha: 0.6),
            border: Border.all(color: widget.color, width: 2),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.5),
                blurRadius: 12,
              ),
            ],
          ),
          child: Icon(widget.icon, color: widget.color, size: 26),
        ),
      ),
    );
  }
}

/// ==================== Joystick ====================
class VirtualJoystick extends StatefulWidget {
  final Function(double) onMove;
  const VirtualJoystick({super.key, required this.onMove});

  @override
  State<VirtualJoystick> createState() => _VirtualJoystickState();
}

class _VirtualJoystickState extends State<VirtualJoystick> {
  double _kx = 0;
  double _ky = 0;
  static const double _maxRadius = 45;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (d) {
        setState(() {
          _kx += d.delta.dx;
          _ky += d.delta.dy;
          final dist = math.sqrt(_kx * _kx + _ky * _ky);
          if (dist > _maxRadius) {
            _kx = _kx / dist * _maxRadius;
            _ky = _ky / dist * _maxRadius;
          }
        });
        widget.onMove((_kx / _maxRadius).clamp(-1.0, 1.0));
      },
      onPanEnd: (_) {
        setState(() {
          _kx = 0;
          _ky = 0;
        });
        widget.onMove(0);
      },
      child: SizedBox(
        width: 150,
        height: 150,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.white.withValues(alpha: 0.03),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: Offset(_kx, _ky),
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                  ),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withValues(alpha: 0.9),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.gamepad, color: Colors.black, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ==================== زر أكشن ====================
class _ActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool large;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.large = false,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final size = widget.large ? 95.0 : 68.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTapDown: (_) {
            setState(() => _pressed = true);
            widget.onTap();
          },
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedScale(
            scale: _pressed ? 0.85 : 1.0,
            duration: const Duration(milliseconds: 80),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    widget.color.withValues(alpha: _pressed ? 0.5 : 0.3),
                    widget.color.withValues(alpha: _pressed ? 0.3 : 0.15),
                  ],
                ),
                border: Border.all(color: widget.color, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: _pressed ? 0.9 : 0.5),
                    blurRadius: _pressed ? 25 : 15,
                    spreadRadius: _pressed ? 2 : 0,
                  ),
                ],
              ),
              child: Icon(
                widget.icon,
                color: Colors.white,
                size: widget.large ? 42 : 30,
                shadows: [
                  Shadow(color: widget.color, blurRadius: 8),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          widget.label,
          style: GoogleFonts.cinzel(
            color: widget.color,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: Colors.black, blurRadius: 4)],
          ),
        ),
      ],
    );
  }
}
