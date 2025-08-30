import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TimelineData {
  final String title;
  final String subtitle;
  final String period;
  final String description;
  final IconData icon;
  final Color iconColor;

  TimelineData({
    required this.title,
    required this.subtitle,
    required this.period,
    required this.description,
    required this.icon,
    this.iconColor = AppTheme.primaryPurple,
  });
}

class AnimatedTimeline extends StatefulWidget {
  final List<TimelineData> items;
  final String sectionTitle;
  final bool isVisible;

  const AnimatedTimeline({
    Key? key,
    required this.items,
    required this.sectionTitle,
    this.isVisible = false,
  }) : super(key: key);

  @override
  State<AnimatedTimeline> createState() => _AnimatedTimelineState();
}

class _AnimatedTimelineState extends State<AnimatedTimeline>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    
    _controllers = List.generate(
      widget.items.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 600 + (index * 200)),
        vsync: this,
      ),
    );

    _fadeAnimations = _controllers.map((controller) =>
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: controller, curve: Curves.easeOut),
        )).toList();

    _slideAnimations = _controllers.map((controller) =>
        Tween<Offset>(begin: const Offset(0.5, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
        )).toList();
  }

  @override
  void didUpdateWidget(AnimatedTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _startAnimations();
    }
  }

  void _startAnimations() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(Duration(milliseconds: i * 150));
      if (mounted) {
        _controllers[i].forward();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.sectionTitle,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryPurple,
          ),
        ),
        const SizedBox(height: 24),
        ...widget.items.asMap().entries.map((entry) {
          int index = entry.key;
          TimelineData item = entry.value;
          bool isLast = index == widget.items.length - 1;

          return SlideTransition(
            position: _slideAnimations[index],
            child: FadeTransition(
              opacity: _fadeAnimations[index],
              child: TimelineItem(
                data: item,
                isLast: isLast,
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}

class TimelineItem extends StatelessWidget {
  final TimelineData data;
  final bool isLast;

  const TimelineItem({
    Key? key,
    required this.data,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline Icon and Line
        Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    data.iconColor,
                    data.iconColor.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: data.iconColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                data.icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 80,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      data.iconColor.withOpacity(0.5),
                      data.iconColor.withOpacity(0.1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 20),
        // Content
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 32),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryPurple.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        data.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkText,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        data.period,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryPurple,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  data.subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryOrange,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  data.description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppTheme.lightText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
