import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/interactive_skill_card.dart';

class InteractiveSkillsShowcase extends StatefulWidget {
  const InteractiveSkillsShowcase({Key? key}) : super(key: key);

  @override
  State<InteractiveSkillsShowcase> createState() => _InteractiveSkillsShowcaseState();
}

class _InteractiveSkillsShowcaseState extends State<InteractiveSkillsShowcase>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  
  Map<String, bool> _categoryVisibility = {
    'Mobile Development': false,
    'Backend': false,
    'Tools': false,
  };

  @override
  void initState() {
    super.initState();
    
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOut,
    ));

    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _headerController.forward();
      
      // Trigger category animations with delays
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() {
            _categoryVisibility['Mobile Development'] = true;
          });
        }
      });
      
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() {
            _categoryVisibility['Backend'] = true;
          });
        }
      });
      
      Future.delayed(const Duration(milliseconds: 1400), () {
        if (mounted) {
          setState(() {
            _categoryVisibility['Tools'] = true;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  List<SkillData> _getMobileSkills() {
    return [
      SkillData(
        name: 'Flutter',
        category: 'Mobile Development',
        percentage: 90,
        icon: Icons.smartphone,
        primaryColor: AppTheme.primaryPurple,
        secondaryColor: AppTheme.primaryOrange,
        description: 'Cross-platform mobile app development with beautiful UIs',
        level: 'Expert',
      ),
      SkillData(
        name: 'Dart',
        category: 'Mobile Development',
        percentage: 88,
        icon: Icons.code,
        primaryColor: AppTheme.primaryOrange,
        secondaryColor: AppTheme.primaryGreen,
        description: 'Modern programming language for Flutter development',
        level: 'Advanced',
      ),
      SkillData(
        name: 'Python',
        category: 'Mobile Development',
        percentage: 75,
        icon: Icons.psychology,
        primaryColor: AppTheme.primaryGreen,
        secondaryColor: AppTheme.primaryPurple,
        description: 'Backend scripting and data analysis capabilities',
        level: 'Intermediate',
      ),
    ];
  }

  List<SkillData> _getBackendSkills() {
    return [
      SkillData(
        name: 'Firebase',
        category: 'Backend',
        percentage: 85,
        icon: Icons.cloud,
        primaryColor: AppTheme.primaryOrange,
        secondaryColor: AppTheme.primaryGreen,
        description: 'Real-time database, authentication, and cloud storage',
        level: 'Advanced',
      ),
      SkillData(
        name: 'Real-time Communication',
        category: 'Backend',
        percentage: 80,
        icon: Icons.chat,
        primaryColor: AppTheme.primaryGreen,
        secondaryColor: AppTheme.primaryPurple,
        description: 'Chat systems, video calling, and live data sync',
        level: 'Advanced',
      ),
      SkillData(
        name: 'Database Management',
        category: 'Backend',
        percentage: 75,
        icon: Icons.storage,
        primaryColor: AppTheme.primaryPurple,
        secondaryColor: AppTheme.primaryOrange,
        description: 'Firestore, data modeling, and optimization',
        level: 'Intermediate',
      ),
    ];
  }

  List<SkillData> _getToolsSkills() {
    return [
      SkillData(
        name: 'Git/GitHub',
        category: 'Tools',
        percentage: 85,
        icon: Icons.source,
        primaryColor: AppTheme.primaryGreen,
        secondaryColor: AppTheme.primaryPurple,
        description: 'Version control and collaborative development',
        level: 'Advanced',
      ),
      SkillData(
        name: 'VS Code',
        category: 'Tools',
        percentage: 90,
        icon: Icons.code_outlined,
        primaryColor: AppTheme.primaryPurple,
        secondaryColor: AppTheme.primaryOrange,
        description: 'Efficient development environment for Flutter',
        level: 'Expert',
      ),
      SkillData(
        name: 'Collaborative Development',
        category: 'Tools',
        percentage: 80,
        icon: Icons.group_work,
        primaryColor: AppTheme.primaryOrange,
        secondaryColor: AppTheme.primaryGreen,
        description: 'Team collaboration and project coordination',
        level: 'Advanced',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768 && screenWidth <= 1024;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Color(0xFFF8FAF9),
            Colors.white,
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 80 : (isTablet ? 40 : 20),
          vertical: 80,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Section Header
              SlideTransition(
                position: _headerSlideAnimation,
                child: FadeTransition(
                  opacity: _headerFadeAnimation,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppTheme.primaryGreen,
                              AppTheme.primaryOrange,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Skills & Expertise',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Interactive Skills Showcase',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkText,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Hover over each card to explore my technical expertise and proficiency levels',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppTheme.lightText,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: 100,
                        height: 4,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppTheme.primaryGreen,
                              AppTheme.primaryOrange,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 80),
              
              // Mobile Development Category
              _buildSkillCategory(
                'Mobile Development',
                'Building beautiful cross-platform applications',
                Icons.smartphone,
                _getMobileSkills(),
                AppTheme.primaryPurple,
                _categoryVisibility['Mobile Development']!,
                isDesktop,
                isTablet,
              ),
              
              const SizedBox(height: 60),
              
              // Backend Category
              _buildSkillCategory(
                'Backend Development',
                'Server-side solutions and API integrations',
                Icons.dns,
                _getBackendSkills(),
                AppTheme.primaryOrange,
                _categoryVisibility['Backend']!,
                isDesktop,
                isTablet,
              ),
              
              const SizedBox(height: 60),
              
              // Tools Category
              _buildSkillCategory(
                'Development Tools',
                'Efficient workflows and productivity tools',
                Icons.build,
                _getToolsSkills(),
                AppTheme.primaryGreen,
                _categoryVisibility['Tools']!,
                isDesktop,
                isTablet,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillCategory(
    String title,
    String description,
    IconData icon,
    List<SkillData> skills,
    Color primaryColor,
    bool isVisible,
    bool isDesktop,
    bool isTablet,
  ) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 800),
      child: Column(
        children: [
          // Category Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryColor,
                      primaryColor.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppTheme.lightText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Skills Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 4 : (isTablet ? 3 : 2),
              childAspectRatio: isDesktop ? 0.85 : (isTablet ? 0.8 : 0.75),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: skills.length,
            itemBuilder: (context, index) {
              final skill = skills[index];
              return InteractiveSkillCard(
                skill: skill,
                isVisible: isVisible,
                onTap: () {
                  _showSkillDetails(skill);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _showSkillDetails(SkillData skill) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    skill.primaryColor,
                    skill.secondaryColor,
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                skill.icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              skill.name,
              style: TextStyle(
                color: skill.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Proficiency: ${skill.percentage.round()}%',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Level: ${skill.level}',
              style: TextStyle(
                fontSize: 14,
                color: skill.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              skill.description,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(color: skill.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
