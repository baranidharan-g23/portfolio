import 'package:flutter/material.dart';

class AnimatedSection extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final bool animateOnce;

  const AnimatedSection({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeOut,
    this.animateOnce = true,
  });

  @override
  State<AnimatedSection> createState() => _AnimatedSectionState();
}

class _AnimatedSectionState extends State<AnimatedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    if (!widget.animateOnce || !_hasAnimated) {
      _controller.forward();
      _hasAnimated = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('animated_section_${widget.hashCode}'),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.1) {
          _startAnimation();
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}

// Simple visibility detector (basic implementation)
class VisibilityDetector extends StatefulWidget {
  final Widget child;
  final Key key;
  final Function(VisibilityInfo) onVisibilityChanged;

  const VisibilityDetector({
    required this.key,
    required this.child,
    required this.onVisibilityChanged,
  }) : super(key: key);

  @override
  State<VisibilityDetector> createState() => _VisibilityDetectorState();
}

class _VisibilityDetectorState extends State<VisibilityDetector> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onVisibilityChanged(VisibilityInfo(visibleFraction: 1.0));
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class VisibilityInfo {
  final double visibleFraction;
  VisibilityInfo({required this.visibleFraction});
}

// Solid color button widget
class SolidButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final IconData? icon;

  const SolidButton({
    super.key,
    required this.text,
    this.onPressed,
    required this.color,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius,
          child: Padding(
            padding: padding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
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

// Floating action button for scroll to top
class ScrollToTopButton extends StatelessWidget {
  final ScrollController scrollController;

  const ScrollToTopButton({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _ScrollVisibilityNotifier(scrollController),
      builder: (context, isVisible, child) {
        return AnimatedScale(
          scale: isVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: FloatingActionButton(
            mini: true,
            onPressed: () {
              scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOut,
              );
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
          ),
        );
      },
    );
  }
}

class _ScrollVisibilityNotifier extends ValueNotifier<bool> {
  final ScrollController _scrollController;

  _ScrollVisibilityNotifier(this._scrollController) : super(false) {
    _scrollController.addListener(_updateVisibility);
  }

  void _updateVisibility() {
    value = _scrollController.offset > 200;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateVisibility);
    super.dispose();
  }
}
