import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../epic_game.dart';

class HudOverlay extends StatelessWidget {
  final EpicGame game;
  const HudOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 20,
          left: 20,
          child: _HealthBar(current: game.health, max: game.maxHealth),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: _ScoreDisplay(score: game.score),
        ),
        Positioned(
          left: 30,
          bottom: 30,
          child: VirtualJoystick(onMove: game.movePlayer),
        ),
        Positioned(
          right: 30,
          bottom: 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // صف أول: قذيفة + خطاف
              Row(
                children: [
                  _ActionButton(
                    label: 'قذيفة',
                    icon: Icons.bolt_rounded,
                    color: const Color(0xFFFFC107),
                    onTap: game.fireProjectile,
                  ),
                  const SizedBox(width: 12),
                  _ActionButton(
                    label: 'خطاف',
                    icon: Icons.anchor_rounded,
                    color: const Color(0xFF00BCD4),
                    onTap: game.hookPlayer,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // صف ثاني: هجوم + اندفاع + قفز
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _ActionButton(
                    label: 'هجوم',
                    icon: Icons.sports_martial_arts,
                    color: const Color(0xFFFF5252),
                    onTap: game.attackPlayer,
                  ),
                  const SizedBox(width: 12),
                  _ActionButton(
                    label: 'اندفاع',
                    icon: Icons.flash_on_rounded,
                    color: const Color(0xFF9C27B0),
                    onTap: game.dashPlayer,
                  ),
                  const SizedBox(width: 12),
                  _ActionButton(
                    label: 'قفز',
                    icon: Icons.arrow_upward_rounded,
                    color: const Color(0xFF4CAF50),
                    onTap: game.jumpPlayer,
                    large: true,
                  ),
                ],
              ),
            ],
          ),
        ),
        // زر إيقاف مؤقت
        Positioned(
          top: 20,
          left: 300,
          child: GestureDetector(
            onTap: game.pauseGame,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0x99000000),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFFD700), width: 1.5),
              ),
              child: const Icon(Icons.pause, color: Color(0xFFFFD700), size: 24),
            ),
          ),
        ),
      ],
    );
  }
}

class _HealthBar extends StatelessWidget {
  final int current;
  final int max;
  const _HealthBar({required this.current, required this.max});

  @override
  Widget build(BuildContext context) {
    final ratio = (current / max).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0x99000000),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFD700), width: 1.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.favorite, color: Color(0xFFFF5252), size: 24),
          const SizedBox(width: 8),
          SizedBox(
            width: 140,
            height: 18,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0x33FFFFFF),
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: ratio,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF5252), Color(0xFFFF8A80)],
                      ),
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$current/$max',
            style: GoogleFonts.cinzel(
              color: const Color(0xFFFFD700),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreDisplay extends StatelessWidget {
  final int score;
  const _ScoreDisplay({required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x99000000),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFD700), width: 1.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 24),
          const SizedBox(width: 8),
          Text(
            '$score',
            style: GoogleFonts.cinzel(
              color: const Color(0xFFFFD700),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

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
        width: 140,
        height: 140,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0x14FFFFFF),
                border: Border.all(color: const Color(0x33FFFFFF), width: 2),
              ),
            ),
            Transform.translate(
              offset: Offset(_kx, _ky),
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withValues(alpha: 0.7),
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
    final size = widget.large ? 85.0 : 62.0;
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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: _pressed ? size * 0.92 : size,
            height: _pressed ? size * 0.92 : size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color.withValues(alpha: _pressed ? 0.4 : 0.2),
              border: Border.all(color: widget.color, width: 3),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: _pressed ? 0.8 : 0.4),
                  blurRadius: _pressed ? 25 : 15,
                ),
              ],
            ),
            child: Icon(
              widget.icon,
              color: widget.color,
              size: widget.large ? 38 : 26,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.label,
          style: GoogleFonts.cinzel(
            color: widget.color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
