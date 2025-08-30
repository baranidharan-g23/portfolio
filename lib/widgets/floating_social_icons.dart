import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FloatingSocialIcons extends StatefulWidget {
  final List<SocialIcon> socialIcons;
  final double iconSize;
  final double spacing;

  const FloatingSocialIcons({
    super.key,
    required this.socialIcons,
    this.iconSize = 50.0,
    this.spacing = 20.0,
  });

  @override
  State<FloatingSocialIcons> createState() => _FloatingSocialIconsState();
}

class _FloatingSocialIconsState extends State<FloatingSocialIcons>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    
    _controllers = List.generate(
      widget.socialIcons.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 2000 + (index * 200)),
        vsync: this,
      )..repeat(reverse: true),
    );
    
    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: -10.0,
        end: 10.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));
    }).toList();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.socialIcons.asMap().entries.map((entry) {
        final index = entry.key;
        final socialIcon = entry.value;
        
        return Padding(
          padding: EdgeInsets.only(bottom: widget.spacing),
          child: AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _animations[index].value),
                child: _buildSocialIcon(socialIcon, index),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSocialIcon(SocialIcon socialIcon, int index) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: widget.iconSize,
            height: widget.iconSize,
            decoration: BoxDecoration(
              color: socialIcon.color,
              borderRadius: BorderRadius.circular(widget.iconSize / 2),
              boxShadow: [
                BoxShadow(
                  color: socialIcon.color.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(widget.iconSize / 2),
                onTap: socialIcon.onTap,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.iconSize / 2),
                  ),
                  child: Icon(
                    socialIcon.icon,
                    color: Colors.white,
                    size: widget.iconSize * 0.5,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SocialIcon {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  SocialIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final IconData? icon;
  final bool isPrimary;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? textColor;

  const AnimatedButton({
    super.key,
    required this.text,
    this.onPressed,
    required this.color,
    this.icon,
    this.isPrimary = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    this.borderRadius = 25.0,
    this.textColor,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 0.0,
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
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(
                    0.3 + (_glowAnimation.value * 0.3),
                  ),
                  blurRadius: 15 + (_glowAnimation.value * 10),
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: widget.isPrimary
                ? _buildSolidButton()
                : _buildOutlinedButton(),
          ),
        );
      },
    );
  }

  Widget _buildSolidButton() {
    return Container(
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          onTap: widget.onPressed,
          onTapDown: (_) => _controller.forward(),
          onTapUp: (_) => _controller.reverse(),
          onTapCancel: () => _controller.reverse(),
          child: Padding(
            padding: widget.padding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    color: widget.textColor ?? Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.textColor ?? Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutlinedButton() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: widget.color,
        ),
        borderRadius: BorderRadius.circular(widget.borderRadius),
        color: Colors.transparent,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          onTap: widget.onPressed,
          onTapDown: (_) => _controller.forward(),
          onTapUp: (_) => _controller.reverse(),
          onTapCancel: () => _controller.reverse(),
          child: Padding(
            padding: widget.padding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    color: widget.color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.color,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
