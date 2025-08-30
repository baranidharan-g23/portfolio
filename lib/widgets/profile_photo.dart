import 'package:flutter/material.dart';

class ParallaxWidget extends StatefulWidget {
  final Widget child;
  final double intensity;
  final ScrollController? scrollController;

  const ParallaxWidget({
    super.key,
    required this.child,
    this.intensity = 0.5,
    this.scrollController,
  });

  @override
  State<ParallaxWidget> createState() => _ParallaxWidgetState();
}

class _ParallaxWidgetState extends State<ParallaxWidget> {
  double _offset = 0.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_updateOffset);
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_updateOffset);
    super.dispose();
  }

  void _updateOffset() {
    if (widget.scrollController != null) {
      setState(() {
        _offset = widget.scrollController!.offset * widget.intensity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, _offset),
      child: widget.child,
    );
  }
}

class ProfilePhoto extends StatefulWidget {
  final String? imageUrl;
  final double size;
  final List<Color> borderColors;
  final double borderWidth;

  const ProfilePhoto({
    super.key,
    this.imageUrl,
    this.size = 300.0,
    required this.borderColors,
    this.borderWidth = 4.0,
  });

  @override
  State<ProfilePhoto> createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.2, curve: Curves.elasticOut),
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Animated rotating border
              Transform.rotate(
                angle: _rotationAnimation.value * 2 * 3.14159,
                child: Container(
                  width: widget.size + 20,
                  height: widget.size + 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: widget.borderColors,
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
              
              // Inner shadow circle
              Container(
                width: widget.size + 10,
                height: widget.size + 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
              ),
              
              // Profile image
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: widget.imageUrl != null
                      ? (widget.imageUrl!.startsWith('assets/')
                          ? Image.asset(
                              widget.imageUrl!,
                              width: widget.size,
                              height: widget.size,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                print('Asset image error: $error');
                                return _buildPlaceholder();
                              },
                            )
                          : Image.network(
                              widget.imageUrl!,
                              width: widget.size,
                              height: widget.size,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                print('Network image error: $error');
                                return _buildPlaceholder();
                              },
                            ))
                      : _buildPlaceholder(),
                ),
              ),
              
              // Shine effect
              Positioned.fill(
                child: ClipOval(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.transparent,
                          Colors.transparent,
                          Colors.white.withOpacity(0.1),
                        ],
                        stops: const [0.0, 0.3, 0.7, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.borderColors,
        ),
      ),
      child: Icon(
        Icons.person,
        size: widget.size * 0.5,
        color: Colors.white.withOpacity(0.8),
      ),
    );
  }
}
