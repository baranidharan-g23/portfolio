import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_layout.dart';
import '../widgets/animated_particle_background.dart';
import '../widgets/typewriter_text.dart';
import '../widgets/floating_social_icons.dart';
import '../widgets/profile_photo.dart';

class ImpressiveHeroSection extends StatefulWidget {
  final ScrollController? scrollController;

  const ImpressiveHeroSection({
    super.key,
    this.scrollController,
  });

  @override
  State<ImpressiveHeroSection> createState() => _ImpressiveHeroSectionState();
}

class _ImpressiveHeroSectionState extends State<ImpressiveHeroSection>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  double _parallaxOffset = 0.0;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));
    
    // Start animations
    _fadeController.forward();
    _slideController.forward();
    
    // Listen to scroll for parallax effect
    widget.scrollController?.addListener(_updateParallax);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    widget.scrollController?.removeListener(_updateParallax);
    super.dispose();
  }

  void _updateParallax() {
    if (widget.scrollController != null) {
      setState(() {
        _parallaxOffset = widget.scrollController!.offset * 0.3;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Container(
      height: screenHeight,
      decoration: BoxDecoration(
        color: AppTheme.primaryPurple,
      ),
      child: AnimatedParticleBackground(
        particleCount: ResponsiveLayout.valueWhen(
          context: context,
          mobile: 15, // Reduced from 30
          tablet: 25, // Reduced from 40
          desktop: 35, // Reduced from 50
        ).round(),
        particleColor: Colors.white,
        child: Stack(
          children: [
            // Parallax background elements
            Transform.translate(
              offset: Offset(0, _parallaxOffset),
              child: _buildBackgroundElements(),
            ),
            
            // Main content
            ResponsiveContainer(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveLayout.responsivePadding(context).horizontal,
                vertical: 40.0,
              ),
              child: _buildHeroContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundElements() {
    return Stack(
      children: [
        // Floating geometric shapes
        Positioned(
          top: 100,
          right: 100,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ),
        Positioned(
          bottom: 150,
          left: 50,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(0.03),
            ),
          ),
        ),
        Positioned(
          top: 200,
          left: 200,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryGreen.withOpacity(0.1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroContent(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveLayout.getMaxWidth(context),
        ),
        child: ResponsiveLayout.isDesktop(context)
            ? _buildDesktopLayout()
            : _buildMobileLayout(),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left side - Text content
        Expanded(
          flex: 3,
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildTextContent(),
            ),
          ),
        ),
        
        const SizedBox(width: 80),
        
        // Right side - Profile photo
        Expanded(
          flex: 2,
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildProfileSection(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Profile photo
        FadeTransition(
          opacity: _fadeAnimation,
          child: _buildProfileSection(),
        ),
        
        const SizedBox(height: 40),
        
        // Text content
        SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: _buildTextContent(),
          ),
        ),
        
        const SizedBox(height: 30),
        
        // Social icons for mobile
        FadeTransition(
          opacity: _fadeAnimation,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _getSocialIcons().map((socialIcon) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: socialIcon.color,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: socialIcon.color.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: socialIcon.onTap,
                      child: Icon(
                        socialIcon.icon,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection() {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 1000),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: ProfilePhoto(
            size: ResponsiveLayout.valueWhen(
              context: context,
              mobile: 250.0,
              tablet: 300.0,
              desktop: 350.0,
            ),
            borderColors: [
              AppTheme.primaryOrange,
              AppTheme.primaryPurple,
              AppTheme.primaryGreen,
            ],
            // Add your profile image URL here
            imageUrl: 'assets/images/me.jpg', // Updated to match the actual image file
          ),
        );
      },
    );
  }

  Widget _buildTextContent() {
    return Column(
      crossAxisAlignment: ResponsiveLayout.isDesktop(context)
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        // Greeting
        TweenAnimationBuilder(
          duration: const Duration(milliseconds: 800),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double value, child) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: SolidText(
                  text: 'Hello, I\'m',
                  color: Colors.white,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: ResponsiveLayout.scaleFontSize(context, 28),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 16),
        
        // Name with gradient effect
        TweenAnimationBuilder(
          duration: const Duration(milliseconds: 1000),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double value, child) {
            return Transform.translate(
              offset: Offset(0, 40 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: Text(
                  'Suvetha Chandru',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: ResponsiveLayout.scaleFontSize(context, 56),
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 24),
        
        // Typewriter effect for title
        TweenAnimationBuilder(
          duration: const Duration(milliseconds: 1200),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double value, child) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: TypewriterText(
                  texts: [
                    'Flutter Developer',
                    'Mobile App Expert',
                    'Firebase Specialist',
                    'Frontend Developer',
                  ],
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: ResponsiveLayout.scaleFontSize(context, 32),
                    color: AppTheme.primaryBeige,
                    fontWeight: FontWeight.w600,
                  ),
                  typingSpeed: const Duration(milliseconds: 150),
                  pauseDuration: const Duration(seconds: 2),
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 32),
        
        // Description
        TweenAnimationBuilder(
          duration: const Duration(milliseconds: 1400),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: Text(
                  'Enthusiastic Flutter Developer with hands-on experience in building mobile applications '
                  'using Flutter and Firebase. Passionate about creating user-friendly and efficient solutions '
                  'with a focus on frontend development and seamless user experiences.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: ResponsiveLayout.scaleFontSize(context, 18),
                    color: Colors.white.withOpacity(0.9),
                    height: 1.6,
                  ),
                  textAlign: ResponsiveLayout.isDesktop(context)
                      ? TextAlign.left
                      : TextAlign.center,
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 48),
        
        // Call-to-action buttons
        TweenAnimationBuilder(
          duration: const Duration(milliseconds: 1600),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: _buildActionButtons(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Wrap(
      spacing: 20,
      runSpacing: 16,
      alignment: ResponsiveLayout.isDesktop(context)
          ? WrapAlignment.start
          : WrapAlignment.center,
      children: [
        AnimatedButton(
          text: 'View Projects',
          icon: Icons.work_outline,
          color: AppTheme.primaryOrange,
          onPressed: () {
            // TODO: Navigate to projects section
          },
        ),
        AnimatedButton(
          text: 'Download CV',
          icon: Icons.download_outlined,
          color: Colors.white,
          textColor: AppTheme.primaryOrange,
          isPrimary: true,
          onPressed: () {
            // TODO: Download CV functionality
          },
        ),
      ],
    );
  }

  List<SocialIcon> _getSocialIcons() {
    return [
      SocialIcon(
        icon: Icons.code,
        color: AppTheme.primaryPurple,
        onTap: () {
          // TODO: Open GitHub
        },
      ),
      SocialIcon(
        icon: Icons.work,
        color: AppTheme.primaryOrange,
        onTap: () {
          // TODO: Open LinkedIn
        },
      ),
      SocialIcon(
        icon: Icons.email,
        color: AppTheme.primaryGreen,
        onTap: () {
          // TODO: Open email
        },
      ),
      SocialIcon(
        icon: Icons.message,
        color: AppTheme.primaryBeige,
        onTap: () {
          // TODO: Open Twitter
        },
      ),
    ];
  }
}
