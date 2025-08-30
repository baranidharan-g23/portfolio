import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_layout.dart';

class ModernNavHeader extends StatefulWidget {
  final ScrollController scrollController;
  final Function(String) onNavigate;

  const ModernNavHeader({
    super.key,
    required this.scrollController,
    required this.onNavigate,
  });

  @override
  State<ModernNavHeader> createState() => _ModernNavHeaderState();
}

class _ModernNavHeaderState extends State<ModernNavHeader>
    with TickerProviderStateMixin {
  late AnimationController _menuController;
  late AnimationController _logoController;
  late Animation<double> _menuAnimation;
  late Animation<double> _logoAnimation;
  
  bool _isMenuOpen = false;
  String _activeSection = 'Home';
  bool _isScrolled = false;
  
  // Scroll throttling
  bool _isScrolling = false;

  final List<NavItem> _navItems = [
    NavItem('Home', Icons.home_outlined),
    NavItem('About', Icons.person_outline),
    NavItem('Skills', Icons.code_outlined),
    NavItem('Projects', Icons.work_outline),
    NavItem('Contact', Icons.email_outlined),
  ];

  @override
  void initState() {
    super.initState();
    
    _menuController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _menuAnimation = CurvedAnimation(
      parent: _menuController,
      curve: Curves.easeInOut,
    );

    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );

    // Start logo animation
    _logoController.forward();

    // Listen to scroll changes
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _menuController.dispose();
    _logoController.dispose();
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!_isScrolling && mounted) {
      _isScrolling = true;
      
      final scrollPosition = widget.scrollController.offset;
      final newIsScrolled = scrollPosition > 50;
      
      if (newIsScrolled != _isScrolled) {
        setState(() {
          _isScrolled = newIsScrolled;
        });
      }

      // Update active section based on scroll position
      _updateActiveSection(scrollPosition);
      
      // Throttle to 60fps
      Future.delayed(const Duration(milliseconds: 16), () {
        _isScrolling = false;
      });
    }
  }

  void _updateActiveSection(double scrollPosition) {
    // These would be the actual positions of your sections
    // Updated to include Home section and match the actual navigation items
    final sectionPositions = {
      'Home': 0.0,        // Hero section at the top
      'About': 800.0,     // About section 
      'Skills': 1600.0,   // Skills section 
      'Projects': 2400.0, // Projects section
      'Contact': 3200.0,  // Contact section
    };

    String newActiveSection = 'Home'; // Default to Home
    for (final entry in sectionPositions.entries) {
      if (scrollPosition >= entry.value - 200) { // Increased threshold for better detection
        newActiveSection = entry.key;
      }
    }

    if (newActiveSection != _activeSection) {
      setState(() {
        _activeSection = newActiveSection;
      });
    }
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
    
    if (_isMenuOpen) {
      _menuController.forward();
    } else {
      _menuController.reverse();
    }
  }

  void _navigateToSection(String section) {
    // Close mobile menu if open
    if (_isMenuOpen) {
      _toggleMenu();
    }

    // Update active section immediately when clicked
    setState(() {
      _activeSection = section;
    });

    // Call the navigation callback
    widget.onNavigate(section);
    
    // Prevent automatic scroll-based section detection for a brief moment
    // to avoid conflicting with the manual selection
    Future.delayed(const Duration(milliseconds: 1000), () {
      // Re-enable automatic section detection after navigation settles
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main navigation bar
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: ResponsiveLayout.valueWhen(
            context: context,
            mobile: 70.0,
            tablet: 80.0,
            desktop: 90.0,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFF4500).withOpacity(_isScrolled ? 0.95 : 0.9),
            boxShadow: _isScrolled
                ? [
                    BoxShadow(
                      color: const Color(0xFFFF4500).withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 2),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: const Color(0xFFFF4500).withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 1),
                    ),
                  ],
          ),
          child: ResponsiveContainer(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveLayout.valueWhen(
                context: context,
                mobile: 16.0,
                tablet: 24.0,
                desktop: 32.0,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLogo(),
                if (ResponsiveLayout.isDesktop(context)) ...[
                  _buildDesktopMenu(),
                ] else ...[
                  _buildMobileMenuButton(),
                ],
              ],
            ),
          ),
        ),
        
        // Mobile menu overlay
        if (!ResponsiveLayout.isDesktop(context) && _isMenuOpen)
          Positioned(
            top: ResponsiveLayout.valueWhen(
              context: context,
              mobile: 70.0,
              tablet: 80.0,
              desktop: 90.0,
            ),
            left: 0,
            right: 0,
            child: MobileMenuOverlay(
              animation: _menuAnimation,
              navItems: _navItems,
              activeSection: _activeSection,
              onNavigate: _navigateToSection,
            ),
          ),
      ],
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _logoAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoAnimation.value,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.web,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Portfolio',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveLayout.valueWhen(
                    context: context,
                    mobile: 20.0,
                    tablet: 22.0,
                    desktop: 24.0,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktopMenu() {
    return Row(
      children: _navItems.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        
        return TweenAnimationBuilder(
          duration: Duration(milliseconds: 600 + (index * 100)),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: _buildNavItem(item, false),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildNavItem(NavItem item, bool isMobile) {
    final isActive = _activeSection == item.title;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 0 : 8,
        vertical: isMobile ? 8 : 0,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _navigateToSection(item.title),
          onHover: isMobile ? null : (isHovered) {
            // Add subtle hover effect for desktop
            if (mounted) {
              setState(() {
                // You can add hover state tracking here if needed
              });
            }
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 16,
                vertical: isMobile ? 16 : 12,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white.withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: isActive
                    ? Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      )
                    : null,
              ),
              child: Row(
                mainAxisSize: isMobile ? MainAxisSize.max : MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      item.icon,
                      color: Colors.white,
                      size: isMobile ? 24 : 20,
                    ),
                  ),
                  SizedBox(width: isMobile ? 16 : 8),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      fontSize: isMobile ? 16 : 14,
                    ) ?? const TextStyle(),
                    child: Text(item.title),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileMenuButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: _toggleMenu,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: AnimatedBuilder(
            animation: _menuAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _menuAnimation.value * 0.5,
                child: Icon(
                  _isMenuOpen ? Icons.close : Icons.menu,
                  color: Colors.white,
                  size: 24,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Mobile menu overlay
class MobileMenuOverlay extends StatelessWidget {
  final Animation<double> animation;
  final List<NavItem> navItems;
  final String activeSection;
  final Function(String) onNavigate;

  const MobileMenuOverlay({
    super.key,
    required this.animation,
    required this.navItems,
    required this.activeSection,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -50 * (1 - animation.value)),
          child: Opacity(
            opacity: animation.value,
            child: Container(
              margin: const EdgeInsets.only(top: 70),
              decoration: BoxDecoration(
                color: const Color(0xFFFF4500).withOpacity(0.95),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF4500).withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: navItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  
                  return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 200 + (index * 50)),
                    tween: Tween<double>(begin: 0, end: animation.value),
                    builder: (context, double value, child) {
                      return Transform.translate(
                        offset: Offset(20 * (1 - value), 0),
                        child: Opacity(
                          opacity: value,
                          child: _buildMobileNavItem(item, context),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileNavItem(NavItem item, BuildContext context) {
    final isActive = activeSection == item.title;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onNavigate(item.title),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: isActive ? Colors.white.withOpacity(0.2) : null,
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                item.icon,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 16),
              Text(
                item.title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              const Spacer(),
              if (isActive)
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavItem {
  final String title;
  final IconData icon;

  NavItem(this.title, this.icon);
}
