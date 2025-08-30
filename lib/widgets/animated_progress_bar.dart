import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnimatedProgressBar extends StatefulWidget {
  final String title;
  final double percentage;
  final Color backgroundColor;
  final Color progressColor;
  final Duration animationDuration;
  final bool isVisible;

  const AnimatedProgressBar({
    Key? key,
    required this.title,
    required this.percentage,
    this.backgroundColor = Colors.grey,
    this.progressColor = AppTheme.primaryPurple,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.isVisible = false,
  }) : super(key: key);

  @override
  State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.percentage / 100.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didUpdateWidget(AnimatedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _startAnimation();
    }
  }

  void _startAnimation() async {
    await _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkText,
                  ),
                ),
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return Text(
                      '${(_progressAnimation.value * 100).round()}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryPurple,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: widget.backgroundColor.withOpacity(0.3),
              ),
              child: AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: widget.backgroundColor.withOpacity(0.1),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: _progressAnimation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: LinearGradient(
                              colors: [
                                widget.progressColor,
                                widget.progressColor.withOpacity(0.7),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: widget.progressColor.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SkillsSection extends StatefulWidget {
  final List<SkillData> skills;
  final bool isVisible;

  const SkillsSection({
    Key? key,
    required this.skills,
    this.isVisible = false,
  }) : super(key: key);

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Technical Skills',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryPurple,
          ),
        ),
        const SizedBox(height: 24),
        ...widget.skills.map((skill) => AnimatedProgressBar(
              title: skill.name,
              percentage: skill.percentage,
              progressColor: skill.color,
              isVisible: widget.isVisible,
            )).toList(),
      ],
    );
  }
}

class SkillData {
  final String name;
  final double percentage;
  final Color color;

  SkillData({
    required this.name,
    required this.percentage,
    this.color = AppTheme.primaryPurple,
  });
}
