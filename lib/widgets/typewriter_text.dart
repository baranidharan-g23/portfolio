import 'package:flutter/material.dart';
import 'dart:async';

class TypewriterText extends StatefulWidget {
  final List<String> texts;
  final TextStyle? style;
  final Duration typingSpeed;
  final Duration pauseDuration;
  final bool loop;

  const TypewriterText({
    super.key,
    required this.texts,
    this.style,
    this.typingSpeed = const Duration(milliseconds: 100),
    this.pauseDuration = const Duration(seconds: 2),
    this.loop = true,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;
  
  String _currentText = '';
  int _currentIndex = 0;
  int _charIndex = 0;
  bool _isDeleting = false;
  Timer? _typingTimer;
  Timer? _pauseTimer;

  @override
  void initState() {
    super.initState();
    
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    
    _blinkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_blinkController);
    
    _startTyping();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _pauseTimer?.cancel();
    _blinkController.dispose();
    super.dispose();
  }

  void _startTyping() {
    _typingTimer = Timer.periodic(widget.typingSpeed, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      setState(() {
        final fullText = widget.texts[_currentIndex];
        
        if (!_isDeleting) {
          // Typing forward
          if (_charIndex < fullText.length) {
            _currentText = fullText.substring(0, _charIndex + 1);
            _charIndex++;
          } else {
            // Finished typing current text
            _isDeleting = true;
            timer.cancel();
            _pauseTimer = Timer(widget.pauseDuration, () {
              if (mounted) _startTyping();
            });
            return;
          }
        } else {
          // Deleting backward
          if (_charIndex > 0) {
            _currentText = fullText.substring(0, _charIndex - 1);
            _charIndex--;
          } else {
            // Finished deleting
            _isDeleting = false;
            _currentIndex = (_currentIndex + 1) % widget.texts.length;
            if (!widget.loop && _currentIndex == 0) {
              timer.cancel();
              return;
            }
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _currentText,
          style: widget.style,
        ),
        AnimatedBuilder(
          animation: _blinkAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _blinkAnimation.value,
              child: Text(
                '|',
                style: widget.style?.copyWith(
                  color: widget.style?.color ?? Colors.black,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class SolidText extends StatelessWidget {
  final String text;
  final Color color;
  final TextStyle? style;

  const SolidText({
    super.key,
    required this.text,
    required this.color,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style?.copyWith(
        color: color,
      ) ?? TextStyle(color: color),
    );
  }
}

class AnimatedSolidText extends StatefulWidget {
  final String text;
  final Color color;
  final TextStyle? style;
  final Duration duration;

  const AnimatedSolidText({
    super.key,
    required this.text,
    required this.color,
    this.style,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<AnimatedSolidText> createState() => _AnimatedSolidTextState();
}

class _AnimatedSolidTextState extends State<AnimatedSolidText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Text(
            widget.text,
            style: widget.style?.copyWith(
              color: widget.color,
            ) ?? TextStyle(color: widget.color),
          ),
        );
      },
    );
  }
}
