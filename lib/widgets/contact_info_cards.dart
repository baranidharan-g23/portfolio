import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ContactInfoCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color primaryColor;
  final Color secondaryColor;
  final VoidCallback? onTap;
  final bool isVisible;

  const ContactInfoCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.primaryColor,
    required this.secondaryColor,
    this.onTap,
    this.isVisible = false,
  }) : super(key: key);

  @override
  State<ContactInfoCard> createState() => _ContactInfoCardState();
}

class _ContactInfoCardState extends State<ContactInfoCard>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _hoverController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.03,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: 4.0,
      end: 12.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didUpdateWidget(ContactInfoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _entryController.forward();
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: MouseRegion(
          onEnter: (_) {
            setState(() {
              _isHovered = true;
            });
            _hoverController.forward();
          },
          onExit: (_) {
            setState(() {
              _isHovered = false;
            });
            _hoverController.reverse();
          },
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedBuilder(
              animation: Listenable.merge([_scaleAnimation, _elevationAnimation]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: widget.primaryColor.withOpacity(0.2),
                          blurRadius: _elevationAnimation.value,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _isHovered 
                              ? widget.primaryColor.withOpacity(0.3)
                              : Colors.grey.withOpacity(0.1),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Icon Container
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6366F1),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF6366F1).withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              widget.icon,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          
                          const SizedBox(width: 20),
                          
                          // Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.darkText,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.value,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: widget.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.subtitle,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.lightText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Arrow Icon
                          if (widget.onTap != null)
                            AnimatedRotation(
                              turns: _isHovered ? 0.125 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: widget.primaryColor,
                                size: 16,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class SocialMediaLink extends StatefulWidget {
  final IconData icon;
  final String platform;
  final String url;
  final Color primaryColor;
  final Color secondaryColor;
  final bool isVisible;

  const SocialMediaLink({
    Key? key,
    required this.icon,
    required this.platform,
    required this.url,
    required this.primaryColor,
    required this.secondaryColor,
    this.isVisible = false,
  }) : super(key: key);

  @override
  State<SocialMediaLink> createState() => _SocialMediaLinkState();
}

class _SocialMediaLinkState extends State<SocialMediaLink>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didUpdateWidget(SocialMediaLink oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _entryController.forward();
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: MouseRegion(
          onEnter: (_) {
            setState(() {
              _isHovered = true;
            });
            _hoverController.forward();
          },
          onExit: (_) {
            setState(() {
              _isHovered = false;
            });
            _hoverController.reverse();
          },
          child: GestureDetector(
            onTap: () {
              // TODO: Launch URL
              print('Opening ${widget.platform}: ${widget.url}');
            },
            child: AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: _isHovered
                            ? const Color(0xFF10B981)
                            : const Color(0xFF6B7280),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: _isHovered 
                              ? const Color(0xFF10B981).withOpacity(0.3)
                              : Colors.black.withOpacity(0.1),
                          blurRadius: _isHovered ? 12 : 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.icon,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class LocationDisplay extends StatefulWidget {
  final String city;
  final String country;
  final String description;
  final bool isVisible;

  const LocationDisplay({
    Key? key,
    required this.city,
    required this.country,
    required this.description,
    this.isVisible = false,
  }) : super(key: key);

  @override
  State<LocationDisplay> createState() => _LocationDisplayState();
}

class _LocationDisplayState extends State<LocationDisplay>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void didUpdateWidget(LocationDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _entryController.forward();
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E293B).withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.white,
                size: 40,
              ),
              const SizedBox(height: 16),
              Text(
                '${widget.city}, ${widget.country}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                widget.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
