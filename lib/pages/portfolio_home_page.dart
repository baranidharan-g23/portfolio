import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_layout.dart';
import '../widgets/modern_nav_header.dart';
import '../widgets/impressive_hero_section.dart';
import '../widgets/about_me_section.dart';
import '../widgets/interactive_skills_showcase.dart';
import '../widgets/stunning_projects_gallery.dart';
import '../widgets/comprehensive_contact_section.dart';
import '../widgets/elegant_footer.dart';
import '../widgets/loading_animations.dart';
import '../widgets/page_transitions.dart';
import '../utils/seo_helper.dart';
import '../services/scroll_service.dart';

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  late ScrollController _scrollController;
  bool _showMobileMenu = false;
  bool _isLoading = true;
  late AnimationController _mobileMenuController;
  
  // Scroll throttling variables
  bool _isScrolling = false;
  
  void _onScroll() {
    // Remove setState that was causing constant rebuilds
    // Only update if we need to show/hide specific scroll-dependent UI elements
    if (!_isScrolling && mounted) {
      _isScrolling = true;
      Future.delayed(const Duration(milliseconds: 16), () {
        if (mounted) {
          _isScrolling = false;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    
    // Initialize SEO and performance monitoring
    _initializeSEO();
    
    // Initialize scroll service
    ScrollService().initialize(_scrollController);
    
    // Listen for scroll changes to update navigation (throttled)
    _scrollController.addListener(_onScroll);
    
    // Simulate initial loading
    _initializeApp();
  }
  
  void _initializeSEO() {
    // Setup SEO meta tags
    SEOHelper.setupMetaTags();
    SEOHelper.setupFavicons();
    SEOHelper.preloadCriticalResources();
    
    // Setup accessibility
    AccessibilityHelper.setupA11y();
    
    // Start performance monitoring
    PerformanceMonitor.measurePageLoadTime();
    PerformanceMonitor.measureFirstContentfulPaint();
    
    // Track page view
    SEOHelper.trackPageView('Portfolio Home');
  }
  
  void _initializeApp() async {
    // Simulate app initialization
    await Future.delayed(const Duration(milliseconds: 2000));
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onNavigate(String section) {
    ScrollService().scrollToSection(section);
    
    // Track navigation events
    SEOHelper.trackEvent('navigation', parameters: {
      'section': section,
      'method': 'header_click',
    });
    
    // Close mobile menu if open
    if (_showMobileMenu) {
      setState(() {
        _showMobileMenu = false;
      });
    }
  }
  
  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
    );
    
    // Track scroll to top events
    SEOHelper.trackEvent('scroll_to_top', parameters: {
      'method': 'footer_button',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: LoadingAnimations.pageLoader(
        isLoading: _isLoading,
        loadingText: 'Crafting beautiful experiences...',
        child: Stack(
          children: [
            // Main content with scroll (optimized for performance)
            SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              clipBehavior: Clip.none, // Reduces clipping overhead
              child: RepaintBoundary( // Isolate repaints for better performance
                child: Column(
                children: [
                  // Add top padding to account for sticky header
                  SizedBox(height: ResponsiveLayout.valueWhen(
                    context: context,
                    mobile: 70.0,
                    tablet: 80.0,
                    desktop: 90.0,
                  )),
                  
                  // Hero Section with fade in animation
                  FadeInAnimation(
                    key: const ValueKey('hero_section'),
                    delay: const Duration(milliseconds: 300),
                    child: NavigationSection(
                      sectionName: 'Home',
                      child: ImpressiveHeroSection(
                        scrollController: _scrollController,
                      ),
                    ),
                  ),
                  
                  // About Section
                  FadeInAnimation(
                    key: const ValueKey('about_section'),
                    delay: const Duration(milliseconds: 600),
                    child: NavigationSection(
                      sectionName: 'About',
                      child: const AboutMeSection(),
                    ),
                  ),
                  
                  // Skills Section with scale animation
                  ScaleInAnimation(
                    key: const ValueKey('skills_section'),
                    delay: const Duration(milliseconds: 900),
                    child: NavigationSection(
                      sectionName: 'Skills',
                      child: const InteractiveSkillsShowcase(),
                    ),
                  ),
                  
                  // Projects Section with staggered animation
                  FadeInAnimation(
                    key: const ValueKey('projects_section'),
                    delay: const Duration(milliseconds: 1200),
                    child: NavigationSection(
                      sectionName: 'Projects',
                      child: const StunningProjectsGallery(),
                    ),
                  ),
                  
                  // Contact Section with slide animation
                  FadeInAnimation(
                    key: const ValueKey('contact_section'),
                    delay: const Duration(milliseconds: 1500),
                    child: NavigationSection(
                      sectionName: 'Contact',
                      child: const ComprehensiveContactSection(),
                    ),
                  ),
                  
                  // Footer with elegant design
                  FadeInAnimation(
                    key: const ValueKey('footer_section'),
                    delay: const Duration(milliseconds: 1800),
                    child: ElegantFooter(
                      onBackToTop: _scrollToTop,
                    ),
                  ),
                ],
                ),
              ),
            ),
            
            // Sticky Navigation Header
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ModernNavHeader(
                scrollController: _scrollController,
                onNavigate: _onNavigate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollToTopButton() {
    return AnimatedBuilder(
      animation: _scrollController,
      builder: (context, child) {
        final showButton = _scrollController.hasClients && _scrollController.offset > 500;
        
        return AnimatedScale(
          scale: showButton ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: MicroInteractions.animatedFAB(
            icon: Icons.keyboard_arrow_up,
            onPressed: _scrollToTop,
            tooltip: 'Back to top',
          ),
        );
      },
    );
  }
}
