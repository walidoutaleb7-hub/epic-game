import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../systems/dialogue_system.dart';

class DialogueBoxOverlay extends StatefulWidget {
  final List<DialogueLine> lines;
  final VoidCallback onComplete;
  const DialogueBoxOverlay({
    super.key,
    required this.lines,
    required this.onComplete,
  });

  @override
  State<DialogueBoxOverlay> createState() => _DialogueBoxOverlayState();
}

class _DialogueBoxOverlayState extends State<DialogueBoxOverlay> {
  int _index = 0;
  String _displayedText = '';
  bool _isTyping = false;
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();
    _startLine();
  }

  void _startLine() {
    _displayedText = '';
    _charIndex = 0;
    _isTyping = true;
    _typeNext();
  }

  void _typeNext() {
    if (!mounted) return;
    final line = widget.lines[_index];
    if (_charIndex >= line.text.length) {
      setState(() => _isTyping = false);
      return;
    }
    setState(() {
      _displayedText += line.text[_charIndex];
      _charIndex++;
    });
    Future.delayed(const Duration(milliseconds: 30), _typeNext);
  }

  void _advance() {
    final line = widget.lines[_index];
    if (_isTyping) {
      setState(() {
        _displayedText = line.text;
        _charIndex = line.text.length;
        _isTyping = false;
      });
      return;
    }
    if (_index < widget.lines.length - 1) {
      setState(() {
        _index++;
        _startLine();
      });
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final line = widget.lines[_index];
    return GestureDetector(
      onTap: _advance,
      child: Container(
        color: Colors.black.withValues(alpha: 0.6),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF0A0E27).withValues(alpha: 0.98),
                  const Color(0xFF1A1F3A).withValues(alpha: 0.98),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFFFD700).withValues(alpha: 0.7),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                  blurRadius: 30,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFD700).withValues(alpha: 0.6),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.person, color: Colors.black, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          line.speaker,
                          style: GoogleFonts.cinzel(
                            color: const Color(0xFFFFD700),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 2,
                          color: const Color(0xFFFFD700).withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  _displayedText,
                  style: GoogleFonts.cinzel(
                    color: Colors.white,
                    fontSize: 17,
                    height: 1.7,
                  ),
                ),
                if (!_isTyping &&
                    line.choiceA != null &&
                    line.choiceB != null) ...[
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _ChoiceBtn(
                          label: line.choiceA!,
                          color: const Color(0xFF4CAF50),
                          onTap: _advance,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ChoiceBtn(
                          label: line.choiceB!,
                          color: const Color(0xFFE53935),
                          onTap: _advance,
                        ),
                      ),
                    ],
                  ),
                ],
                if (!_isTyping &&
                    (line.choiceA == null || line.choiceB == null)) ...[
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'اضغط للمتابعة',
                          style: GoogleFonts.cinzel(
                            color: const Color(0xFFFFD700),
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded,
                            color: Color(0xFFFFD700), size: 16)
                            .animate(onPlay: (c) => c.repeat())
                            .moveX(begin: 0, end: 8, duration: 800.ms),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChoiceBtn extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ChoiceBtn({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_ChoiceBtn> createState() => _ChoiceBtnState();
}

class _ChoiceBtnState extends State<_ChoiceBtn> {
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
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.color.withValues(alpha: 0.3),
                widget.color.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: widget.color, width: 2),
            boxShadow: [
              BoxShadow(color: widget.color.withValues(alpha: 0.4), blurRadius: 12),
            ],
          ),
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: GoogleFonts.cinzel(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
