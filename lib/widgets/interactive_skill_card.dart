import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';

class SkillData {
  final String name;
  final String category;
  final double percentage;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final String description;
  final String level;

  SkillData({
    required this.name,
    required this.category,
    required this.percentage,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
    required this.description,
    required this.level,
  });
}

class AnimatedCircularProgress extends StatefulWidget {
  final double percentage;
  final Color primaryColor;
  final Color secondaryColor;
  final double size;
  final bool isVisible;
  final Duration animationDuration;

  const AnimatedCircularProgress({
    Key? key,
    required this.percentage,
    required this.primaryColor,
    required this.secondaryColor,
    this.size = 80,
    this.isVisible = false,
    this.animationDuration = const Duration(milliseconds: 2000),
  }) : super(key: key);

  @override
  State<AnimatedCircularProgress> createState() => _AnimatedCircularProgressState();
}

class _AnimatedCircularProgressState extends State<AnimatedCircularProgress>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _scaleController;
  late Animation<double> _progressAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _progressController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.percentage / 100.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didUpdateWidget(AnimatedCircularProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _startAnimation();
    }
  }

  void _startAnimation() async {
    if (mounted) {
      await _scaleController.forward();
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        _progressController.forward();
      }
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            children: [
              // Background circle
              SizedBox(
                width: widget.size,
                height: widget.size,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 6,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.primaryColor.withOpacity(0.1),
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
              // Animated progress circle
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return SizedBox(
                    width: widget.size,
                    height: widget.size,
                    child: CircularProgressIndicator(
                      value: _progressAnimation.value,
                      strokeWidth: 6,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        widget.primaryColor,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  );
                },
              ),
              // Percentage text
              Center(
                child: AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return Text(
                      '${(_progressAnimation.value * 100).round()}%',
                      style: TextStyle(
                        fontSize: widget.size * 0.2,
                        fontWeight: FontWeight.bold,
                        color: widget.primaryColor,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InteractiveSkillCard extends StatefulWidget {
  final SkillData skill;
  final bool isVisible;
  final VoidCallback? onTap;

  const InteractiveSkillCard({
    Key? key,
    required this.skill,
    this.isVisible = false,
    this.onTap,
  }) : super(key: key);

  @override
  State<InteractiveSkillCard> createState() => _InteractiveSkillCardState();
}

class _InteractiveSkillCardState extends State<InteractiveSkillCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _entryController;
  late Animation<double> _elevationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _elevationAnimation = Tween<double>(
      begin: 4.0,
      end: 16.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.03,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
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
  }

  @override
  void didUpdateWidget(InteractiveSkillCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _entryController.forward();
    }
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  String _getLevelColor() {
    switch (widget.skill.level.toLowerCase()) {
      case 'expert':
        return 'Expert';
      case 'advanced':
        return 'Advanced';
      case 'intermediate':
        return 'Intermediate';
      default:
        return 'Beginner';
    }
  }

  Color _getLevelBadgeColor() {
    switch (widget.skill.level.toLowerCase()) {
      case 'expert':
        return AppTheme.primaryGreen;
      case 'advanced':
        return AppTheme.primaryOrange;
      case 'intermediate':
        return AppTheme.primaryPurple;
      default:
        return Colors.grey;
    }
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
              animation: Listenable.merge([_elevationAnimation, _scaleAnimation]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: widget.skill.primaryColor.withOpacity(0.2),
                          blurRadius: _elevationAnimation.value,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              widget.skill.primaryColor.withOpacity(0.02),
                            ],
                          ),
                          border: Border.all(
                            color: _isHovered 
                                ? widget.skill.primaryColor.withOpacity(0.3)
                                : Colors.grey.withOpacity(0.1),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Skill Icon and Progress
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        widget.skill.primaryColor,
                                        widget.skill.secondaryColor,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: widget.skill.primaryColor.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    widget.skill.icon,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                AnimatedCircularProgress(
                                  percentage: widget.skill.percentage,
                                  primaryColor: widget.skill.primaryColor,
                                  secondaryColor: widget.skill.secondaryColor,
                                  size: 60,
                                  isVisible: widget.isVisible,
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Skill Name
                            Text(
                              widget.skill.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkText,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            const SizedBox(height: 8),
                            
                            // Level Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getLevelBadgeColor().withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _getLevelBadgeColor().withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                _getLevelColor(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _getLevelBadgeColor(),
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Description
                            Text(
                              widget.skill.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.lightText,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Animated Progress Bar
                            Container(
                              height: 4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: widget.skill.primaryColor.withOpacity(0.1),
                              ),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 1500),
                                curve: Curves.easeOutCubic,
                                width: widget.isVisible 
                                    ? (MediaQuery.of(context).size.width * 0.2 * widget.skill.percentage / 100)
                                    : 0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  gradient: LinearGradient(
                                    colors: [
                                      widget.skill.primaryColor,
                                      widget.skill.secondaryColor,
                                    ],
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
              },
            ),
          ),
        ),
      ),
    );
  }
}
