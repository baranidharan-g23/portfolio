import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ElegantFooter extends StatefulWidget {
  final VoidCallback? onBackToTop;
  
  const ElegantFooter({
    Key? key,
    this.onBackToTop,
  }) : super(key: key);

  @override
  State<ElegantFooter> createState() => _ElegantFooterState();
}

class _ElegantFooterState extends State<ElegantFooter>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _backToTopController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  
  final TextEditingController _emailController = TextEditingController();
  bool _isSubscribing = false;
  bool _subscriptionSuccess = false;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _backToTopController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));
    
    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
    ));
    
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    _backToTopController.dispose();
    _emailController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1024;
    final isTablet = size.width > 768 && size.width <= 1024;
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF1A1A2E).withOpacity(0.95),
                    const Color(0xFF16213E).withOpacity(0.98),
                    const Color(0xFF0F3460),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6B46C1).withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Background Pattern
                  _buildBackgroundPattern(),
                  
                  // Main Content
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 80 : (isTablet ? 40 : 20),
                      vertical: 60,
                    ),
                    child: Column(
                      children: [
                        // Newsletter Section
                        _buildNewsletterSection(isDesktop, isTablet),
                        
                        const SizedBox(height: 60),
                        
                        // Main Footer Content
                        _buildMainFooterContent(isDesktop, isTablet),
                        
                        const SizedBox(height: 40),
                        
                        // Divider
                        Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                const Color(0xFF6B46C1).withOpacity(0.5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Bottom Section
                        _buildBottomSection(isDesktop),
                      ],
                    ),
                  ),
                  
                  // Back to Top Button
                  _buildBackToTopButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildBackgroundPattern() {
    return Positioned.fill(
      child: CustomPaint(
        painter: FooterPatternPainter(),
      ),
    );
  }
  
  Widget _buildNewsletterSection(bool isDesktop, bool isTablet) {
    return Transform.scale(
      scale: _scaleAnimation.value,
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF6B46C1).withOpacity(0.1),
              const Color(0xFF10B981).withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF6B46C1).withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Text(
              'Stay Updated',
              style: GoogleFonts.poppins(
                fontSize: isDesktop ? 32 : (isTablet ? 28 : 24),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Subscribe to get notified about my latest projects and blog posts',
              style: GoogleFonts.inter(
                fontSize: isDesktop ? 16 : 14,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            _buildNewsletterForm(isDesktop, isTablet),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNewsletterForm(bool isDesktop, bool isTablet) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: isDesktop ? 400 : double.infinity,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              child: TextField(
                controller: _emailController,
                style: GoogleFonts.inter(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle: GoogleFonts.inter(color: Colors.white60),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _buildSubscribeButton(),
        ],
      ),
    );
  }
  
  Widget _buildSubscribeButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        gradient: _subscriptionSuccess
            ? const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF059669)],
              )
            : const LinearGradient(
                colors: [Color(0xFF6B46C1), Color(0xFF8B5CF6)],
              ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: (_subscriptionSuccess ? const Color(0xFF10B981) : const Color(0xFF6B46C1))
                .withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _subscriptionSuccess ? null : _handleSubscribe,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            child: _isSubscribing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Icon(
                    _subscriptionSuccess ? Icons.check : Icons.arrow_forward,
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildMainFooterContent(bool isDesktop, bool isTablet) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: _buildBrandSection()),
          const SizedBox(width: 60),
          Expanded(child: _buildQuickLinks()),
          const SizedBox(width: 60),
          Expanded(child: _buildSiteMap()),
          const SizedBox(width: 60),
          Expanded(child: _buildSocialSection()),
        ],
      );
    } else {
      return Column(
        children: [
          _buildBrandSection(),
          const SizedBox(height: 40),
          if (isTablet)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildQuickLinks()),
                const SizedBox(width: 40),
                Expanded(child: _buildSiteMap()),
              ],
            )
          else ...[
            _buildQuickLinks(),
            const SizedBox(height: 30),
            _buildSiteMap(),
          ],
          const SizedBox(height: 40),
          _buildSocialSection(),
        ],
      );
    }
  }
  
  Widget _buildBrandSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Naandhaan',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: [Color(0xFF6B46C1), Color(0xFF10B981)],
              ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Passionate Flutter developer creating beautiful and functional mobile experiences. Always learning, always building.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white70,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: const Color(0xFF6B46C1),
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              'Chennai, Tamil Nadu, India',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white60,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildQuickLinks() {
    final links = [
      {'title': 'Home', 'action': () => _scrollToSection('home')},
      {'title': 'About', 'action': () => _scrollToSection('about')},
      {'title': 'Skills', 'action': () => _scrollToSection('skills')},
      {'title': 'Projects', 'action': () => _scrollToSection('projects')},
      {'title': 'Contact', 'action': () => _scrollToSection('contact')},
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Links',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        ...links.map((link) => _buildFooterLink(
          link['title'] as String,
          link['action'] as VoidCallback,
        )),
      ],
    );
  }
  
  Widget _buildSiteMap() {
    final sections = [
      {'title': 'Portfolio', 'action': () => _scrollToSection('projects')},
      {'title': 'Resume', 'action': () => _launchURL('https://drive.google.com/your-resume-link')},
      {'title': 'Blog', 'action': () => _launchURL('https://your-blog-link.com')},
      {'title': 'Testimonials', 'action': () => _scrollToSection('testimonials')},
      {'title': 'Privacy Policy', 'action': () => _showPrivacyPolicy()},
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explore',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        ...sections.map((section) => _buildFooterLink(
          section['title'] as String,
          section['action'] as VoidCallback,
        )),
      ],
    );
  }
  
  Widget _buildSocialSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Connect',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _buildSocialIcon(
              Icons.code,
              'https://github.com/yourusername',
              const Color(0xFF333333),
            ),
            const SizedBox(width: 16),
            _buildSocialIcon(
              Icons.work,
              'https://www.linkedin.com/in/suvetha-chandru-abb95a2a9/',
              const Color(0xFF0077B5),
            ),
            const SizedBox(width: 16),
            _buildSocialIcon(
              Icons.code,
              'https://github.com/suvetha-chandru',
              const Color(0xFF333333),
            ),
            const SizedBox(width: 16),
            _buildSocialIcon(
              Icons.email,
              'mailto:suvethachandru07@gmail.com',
              const Color(0xFF6B46C1),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Available for remote opportunities and collaborations',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.white60,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
  
  Widget _buildFooterLink(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white70,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildSocialIcon(IconData icon, String url, Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _launchURL(url),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildBottomSection(bool isDesktop) {
    return isDesktop
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCopyright(),
              _buildMadeWithLove(),
            ],
          )
        : Column(
            children: [
              _buildCopyright(),
              const SizedBox(height: 12),
              _buildMadeWithLove(),
            ],
          );
  }
  
  Widget _buildCopyright() {
    return Text(
      '© ${DateTime.now().year} Naandhaan. All rights reserved.',
      style: GoogleFonts.inter(
        fontSize: 12,
        color: Colors.white60,
      ),
    );
  }
  
  Widget _buildMadeWithLove() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Made with ',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.white60,
          ),
        ),
        const Icon(
          Icons.favorite,
          color: Color(0xFFE91E63),
          size: 14,
        ),
        Text(
          ' using Flutter',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.white60,
          ),
        ),
      ],
    );
  }
  
  Widget _buildBackToTopButton() {
    return Positioned(
      right: 30,
      top: 30,
      child: AnimatedBuilder(
        animation: _backToTopController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (_backToTopController.value * 0.1),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6B46C1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6B46C1).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _backToTopController.forward().then((_) {
                      _backToTopController.reverse();
                    });
                    widget.onBackToTop?.call();
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: const Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  void _handleSubscribe() async {
    if (_emailController.text.isEmpty || !_isValidEmail(_emailController.text)) {
      _showMessage('Please enter a valid email address');
      return;
    }
    
    setState(() {
      _isSubscribing = true;
    });
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isSubscribing = false;
      _subscriptionSuccess = true;
    });
    
    _showMessage('Successfully subscribed to newsletter!');
    
    // Reset after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _subscriptionSuccess = false;
          _emailController.clear();
        });
      }
    });
  }
  
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  void _scrollToSection(String section) {
    // This would implement smooth scrolling to sections
    // You can integrate with your existing scroll controller
    widget.onBackToTop?.call(); // Placeholder for now
  }
  
  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
  
  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const Text(
          'This is a personal portfolio website. No personal data is collected or stored.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class FooterPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6B46C1).withOpacity(0.05)
      ..strokeWidth = 1;
    
    // Draw subtle geometric pattern
    for (int i = 0; i < size.width / 50; i++) {
      for (int j = 0; j < size.height / 50; j++) {
        final x = i * 50.0;
        final y = j * 50.0;
        
        if ((i + j) % 2 == 0) {
          canvas.drawCircle(
            Offset(x + 25, y + 25),
            2,
            paint,
          );
        }
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
