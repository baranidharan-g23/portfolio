import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_timeline.dart';
import '../widgets/interactive_elements.dart';

class AboutMeSection extends StatefulWidget {
  const AboutMeSection({super.key});

  @override
  State<AboutMeSection> createState() => _AboutMeSectionState();
}

class _AboutMeSectionState extends State<AboutMeSection>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isEducationVisible = false;
  bool _isStoryVisible = false;
  bool _isImageVisible = false;

  @override
  void initState() {
    super.initState();
    
    _scrollController = ScrollController();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Start initial animations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
      _slideController.forward();
      
      // Trigger story and image animations immediately
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isStoryVisible = true;
            _isImageVisible = true;
          });
        }
      });
      
      // Trigger other animations with delays
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() {
            _isEducationVisible = true;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  List<TimelineData> _getEducation() {
    return [
      TimelineData(
        title: 'M.Sc. Computer Science',
        subtitle: 'Bharathidasan University, Trichy',
        period: '2023 - 2025',
        description: 'Currently pursuing Master\'s degree in Computer Science with 75% aggregate. Focus on advanced software development, mobile app development, and modern programming paradigms.',
        icon: Icons.school_rounded,
        iconColor: AppTheme.primaryPurple,
      ),
      TimelineData(
        title: 'B.Sc. Computer Science',
        subtitle: 'Shrimati Indira Gandhi College, Trichy',
        period: '2020 - 2023',
        description: 'Graduated with 83% in Computer Science. Built strong foundation in programming, algorithms, data structures, and software engineering principles.',
        icon: Icons.code_rounded,
        iconColor: AppTheme.primaryGreen,
      ),
      TimelineData(
        title: 'HSC (PCM)',
        subtitle: 'Good Samaritan Public School, Sirkali',
        period: '2020',
        description: 'Completed Higher Secondary with 79.6% in Physics, Chemistry, and Mathematics. Developed analytical thinking and problem-solving skills.',
        icon: Icons.local_library_rounded,
        iconColor: AppTheme.primaryPurple,
      ),
    ];
  }

  List<TimelineData> _getCertifications() {
    return [
      TimelineData(
        title: 'Flutter & Dart – The Complete Guide',
        subtitle: 'Udemy Certification',
        period: 'Jun 2025 - Jul 2025',
        description: 'Completed comprehensive Flutter development course covering advanced UI/UX design, state management, Firebase integration, and professional app deployment techniques.',
        icon: Icons.verified_outlined,
        iconColor: AppTheme.primaryOrange,
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
            AppTheme.lightBeige,
            Color(0xFFFAF9F7),
            Colors.white,
          ],
        ),
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 80 : (isTablet ? 40 : 20),
              vertical: 80,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Header
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryPurple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'About Me',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryPurple,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Flutter Developer & CS Graduate',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkText,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: 100,
                          height: 4,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppTheme.primaryPurple,
                                AppTheme.primaryOrange,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 80),
                  
                  // Two-Column Layout: Story and Image
                  if (isDesktop)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildPersonalStory(),
                        ),
                        const SizedBox(width: 60),
                        Expanded(
                          flex: 2,
                          child: _buildProfileImage(),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _buildProfileImage(),
                        const SizedBox(height: 40),
                        _buildPersonalStory(),
                      ],
                    ),
                  
                  const SizedBox(height: 80),
                  
                  // Education Timeline - Centered for fresher profile
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isDesktop ? 800 : double.infinity,
                      ),
                      child: InteractiveCard(
                        child: AnimatedTimeline(
                          sectionTitle: 'Education',
                          items: _getEducation(),
                          isVisible: _isEducationVisible,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Certifications Section
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isDesktop ? 800 : double.infinity,
                      ),
                      child: InteractiveCard(
                        child: AnimatedTimeline(
                          sectionTitle: 'Certifications & Professional Development',
                          items: _getCertifications(),
                          isVisible: _isEducationVisible,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Download Resume Button
                  Center(
                    child: DownloadResumeButton(
                      resumeUrl: 'https://example.com/resume.pdf', // Replace with your actual resume URL
                      onPressed: () {
                        // Custom action if needed
                        print('Download Resume pressed');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalStory() {
    return AnimatedOpacity(
      opacity: _isStoryVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 1000),
      child: InteractiveCard(
        backgroundColor: Colors.white.withOpacity(0.8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Story',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryPurple,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Hello! I\'m Suvetha Chandru, an enthusiastic Flutter Developer with hands-on experience in building mobile applications using Flutter and Firebase. I am passionate about creating user-friendly and efficient solutions with a focus on frontend development and seamless user experiences.',
              style: TextStyle(
                fontSize: 18,
                height: 1.6,
                color: AppTheme.darkText,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'I am currently pursuing my M.Sc. Computer Science at Bharathidasan University, Trichy, and have a strong foundation backed by my B.Sc. Computer Science degree. My journey with Flutter development has been enriched through practical learning and the completion of specialized courses.',
              style: TextStyle(
                fontSize: 16,
                height: 1.7,
                color: AppTheme.lightText,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'I specialize in Flutter and Firebase development, with expertise in creating applications featuring real-time communication, collaborative features, and finance tracking. My projects showcase my ability to build comprehensive solutions like logistics apps, skill-sharing platforms, and custom finance trackers.',
              style: TextStyle(
                fontSize: 16,
                height: 1.7,
                color: AppTheme.lightText,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'I am eager to contribute my skills to innovative projects and continue learning in a professional environment. My goal is to create applications that make a positive impact on users\' lives through intuitive design and robust functionality.',
              style: TextStyle(
                fontSize: 16,
                height: 1.7,
                color: AppTheme.lightText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return InteractiveCard(
      child: Column(
        children: [
          Container(
            width: 300,
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryPurple,
                  AppTheme.primaryOrange,
                  AppTheme.primaryGreen,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryPurple.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/me.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print('Failed to load image: $error');
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Image not found', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Suvetha Chandru',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkText,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppTheme.primaryPurple,
                  AppTheme.primaryOrange,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'CS Student & Flutter Developer',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
