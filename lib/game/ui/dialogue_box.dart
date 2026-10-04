import 'package:flutter/material.dart';
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
    Future.delayed(const Duration(milliseconds: 25), _typeNext);
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
        color: const Color(0x88000000),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xF00A0E27), Color(0xF01A1F3A)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFFD700), width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                  blurRadius: 25,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // اسم المتحدث
                Text(
                  line.speaker,
                  style: GoogleFonts.cinzel(
                    color: const Color(0xFFFFD700),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                // النص
                Text(
                  _displayedText,
                  style: GoogleFonts.cinzel(
                    color: const Color(0xFFE0E0E0),
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
                // أزرار الاختيار
                if (!_isTyping && line.choiceA != null && line.choiceB != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _ChoiceButton(
                          label: line.choiceA!,
                          color: const Color(0xFF4CAF50),
                          onTap: _advance,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ChoiceButton(
                          label: line.choiceB!,
                          color: const Color(0xFFE53935),
                          onTap: _advance,
                        ),
                      ),
                    ],
                  ),
                ],
                if (!_isTyping && (line.choiceA == null || line.choiceB == null))
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'اضغط للمتابعة ▶',
                        style: GoogleFonts.cinzel(
                          color: const Color(0xFFFFD700),
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ChoiceButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.2),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: color, width: 2),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.cinzel(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
