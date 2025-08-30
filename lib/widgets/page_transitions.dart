import 'package:flutter/material.dart';

class PageTransitions {
  // Slide Transition
  static PageRouteBuilder slideTransition({
    required Widget page,
    AxisDirection direction = AxisDirection.right,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Offset begin;
        switch (direction) {
          case AxisDirection.up:
            begin = const Offset(0.0, 1.0);
            break;
          case AxisDirection.down:
            begin = const Offset(0.0, -1.0);
            break;
          case AxisDirection.right:
            begin = const Offset(-1.0, 0.0);
            break;
          case AxisDirection.left:
            begin = const Offset(1.0, 0.0);
            break;
        }
        
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;
        
        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  // Fade Transition
  static PageRouteBuilder fadeTransition({
    required Widget page,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  // Scale Transition
  static PageRouteBuilder scaleTransition({
    required Widget page,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.8;
        const end = 1.0;
        const curve = Curves.elasticOut;
        
        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        
        return ScaleTransition(
          scale: animation.drive(tween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  // Rotation Transition
  static PageRouteBuilder rotationTransition({
    required Widget page,
    Duration duration = const Duration(milliseconds: 600),
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.elasticOut;
        
        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        
        return RotationTransition(
          turns: animation.drive(tween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  // Custom Hero Transition
  static PageRouteBuilder heroTransition({
    required Widget page,
    required String heroTag,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return Hero(
          tag: heroTag,
          child: FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(
                begin: 0.8,
                end: 1.0,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutBack,
              )),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class MicroInteractions {
  // Bounce Button
  static Widget bounceButton({
    required Widget child,
    required VoidCallback onTap,
    double scaleFactor = 0.95,
    Duration duration = const Duration(milliseconds: 100),
  }) {
    return BounceWidget(
      onTap: onTap,
      scaleFactor: scaleFactor,
      duration: duration,
      child: child,
    );
  }

  // Hover Scale Effect
  static Widget hoverScale({
    required Widget child,
    double scale = 1.05,
    Duration duration = const Duration(milliseconds: 200),
  }) {
    return HoverScaleWidget(
      scale: scale,
      duration: duration,
      child: child,
    );
  }

  // Shimmer Button
  static Widget shimmerButton({
    required Widget child,
    required VoidCallback onTap,
    Color shimmerColor = Colors.white,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return ShimmerButton(
      onTap: onTap,
      shimmerColor: shimmerColor,
      duration: duration,
      child: child,
    );
  }

  // Ripple Effect
  static Widget rippleEffect({
    required Widget child,
    required VoidCallback onTap,
    Color rippleColor = Colors.white,
    BorderRadius? borderRadius,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: rippleColor.withOpacity(0.3),
        highlightColor: rippleColor.withOpacity(0.1),
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }

  // Floating Action Button with Animation
  static Widget animatedFAB({
    required IconData icon,
    required VoidCallback onPressed,
    Color backgroundColor = const Color(0xFF6B46C1),
    Color foregroundColor = Colors.white,
    String? tooltip,
  }) {
    return AnimatedFloatingActionButton(
      icon: icon,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      tooltip: tooltip,
    );
  }
}

class BounceWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double scaleFactor;
  final Duration duration;

  const BounceWidget({
    Key? key,
    required this.child,
    required this.onTap,
    this.scaleFactor = 0.95,
    this.duration = const Duration(milliseconds: 100),
  }) : super(key: key);

  @override
  State<BounceWidget> createState() => _BounceWidgetState();
}

class _BounceWidgetState extends State<BounceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleFactor,
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
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

class HoverScaleWidget extends StatefulWidget {
  final Widget child;
  final double scale;
  final Duration duration;

  const HoverScaleWidget({
    Key? key,
    required this.child,
    this.scale = 1.05,
    this.duration = const Duration(milliseconds: 200),
  }) : super(key: key);

  @override
  State<HoverScaleWidget> createState() => _HoverScaleWidgetState();
}

class _HoverScaleWidgetState extends State<HoverScaleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scale,
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
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

class ShimmerButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color shimmerColor;
  final Duration duration;

  const ShimmerButton({
    Key? key,
    required this.child,
    required this.onTap,
    this.shimmerColor = Colors.white,
    this.duration = const Duration(milliseconds: 1500),
  }) : super(key: key);

  @override
  State<ShimmerButton> createState() => _ShimmerButtonState();
}

class _ShimmerButtonState extends State<ShimmerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -2,
      end: 2,
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

  void _startShimmer() {
    _controller.forward().then((_) {
      _controller.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _startShimmer();
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment(_animation.value - 1, 0),
                end: Alignment(_animation.value + 1, 0),
                colors: [
                  Colors.transparent,
                  widget.shimmerColor.withOpacity(0.5),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ).createShader(bounds);
            },
            child: widget.child,
          );
        },
      ),
    );
  }
}

class AnimatedFloatingActionButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final String? tooltip;

  const AnimatedFloatingActionButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor = const Color(0xFF6B46C1),
    this.foregroundColor = Colors.white,
    this.tooltip,
  }) : super(key: key);

  @override
  State<AnimatedFloatingActionButton> createState() =>
      _AnimatedFloatingActionButtonState();
}

class _AnimatedFloatingActionButtonState
    extends State<AnimatedFloatingActionButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.25,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });
    
    _rotationController.forward().then((_) {
      _rotationController.reverse();
    });
    
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _rotationAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value * 2 * 3.14159,
            child: FloatingActionButton(
              onPressed: _handleTap,
              backgroundColor: widget.backgroundColor,
              foregroundColor: widget.foregroundColor,
              tooltip: widget.tooltip,
              elevation: 8,
              child: Icon(widget.icon),
            ),
          ),
        );
      },
    );
  }
}

// Parallax Scroll Effect
class ParallaxWidget extends StatelessWidget {
  final Widget child;
  final double speed;
  final ScrollController scrollController;

  const ParallaxWidget({
    Key? key,
    required this.child,
    required this.scrollController,
    this.speed = 0.5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, child) {
        final offset = scrollController.hasClients 
            ? scrollController.offset * speed 
            : 0.0;
        
        return Transform.translate(
          offset: Offset(0, offset),
          child: this.child,
        );
      },
    );
  }
}

// Scroll-triggered animations
class ScrollTriggeredAnimation extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;
  final double triggerOffset;
  final Duration duration;

  const ScrollTriggeredAnimation({
    Key? key,
    required this.child,
    required this.scrollController,
    this.triggerOffset = 100,
    this.duration = const Duration(milliseconds: 600),
  }) : super(key: key);

  @override
  State<ScrollTriggeredAnimation> createState() =>
      _ScrollTriggeredAnimationState();
}

class _ScrollTriggeredAnimationState extends State<ScrollTriggeredAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  bool _hasTriggered = false;

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
      curve: Curves.easeOut,
    ));
    
    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    
    widget.scrollController.addListener(_checkScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_checkScroll);
    _controller.dispose();
    super.dispose();
  }

  void _checkScroll() {
    if (!_hasTriggered && 
        widget.scrollController.offset >= widget.triggerOffset) {
      _hasTriggered = true;
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}
