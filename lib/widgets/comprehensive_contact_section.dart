import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_contact_form.dart';
import '../widgets/contact_info_cards.dart';

class ComprehensiveContactSection extends StatefulWidget {
  const ComprehensiveContactSection({Key? key}) : super(key: key);

  @override
  State<ComprehensiveContactSection> createState() => _ComprehensiveContactSectionState();
}

class _ComprehensiveContactSectionState extends State<ComprehensiveContactSection>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  
  bool _isFormVisible = false;
  bool _isContactInfoVisible = false;
  bool _isSocialVisible = false;
  bool _isLocationVisible = false;
  
  bool _isSubmitting = false;
  bool _isSuccess = false;
  bool _isError = false;

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
      
      // Trigger section animations with delays
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() {
            _isContactInfoVisible = true;
          });
        }
      });
      
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _isFormVisible = true;
          });
        }
      });
      
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() {
            _isSocialVisible = true;
          });
        }
      });
      
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) {
          setState(() {
            _isLocationVisible = true;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validateMessage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your message';
    }
    if (value.length < 10) {
      return 'Message must be at least 10 characters long';
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _isSuccess = false;
      _isError = false;
    });

    try {
      // Simulate form submission
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Implement actual email sending logic here
      // For now, we'll simulate success
      print('Form submitted:');
      print('Name: ${_nameController.text}');
      print('Email: ${_emailController.text}');
      print('Message: ${_messageController.text}');
      
      setState(() {
        _isSubmitting = false;
        _isSuccess = true;
      });
      
      // Show success message
      _showSuccessSnackBar();
      
      // Clear form after success
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _nameController.clear();
          _emailController.clear();
          _messageController.clear();
          setState(() {
            _isSuccess = false;
          });
        }
      });
      
    } catch (e) {
      setState(() {
        _isSubmitting = false;
        _isError = true;
      });
      
      // Show error message
      _showErrorSnackBar();
      
      // Reset error state after delay
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isError = false;
          });
        }
      });
    }
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Message sent successfully! I\'ll get back to you soon.'),
          ],
        ),
        backgroundColor: AppTheme.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 12),
            Text('Failed to send message. Please try again.'),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch $url');
    }
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'suvethachandru07@gmail.com',
      query: 'subject=Hello from Portfolio&body=Hi there!',
    );
    
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      print('Could not launch email');
    }
  }

  Future<void> _launchPhone() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: '+1234567890',
    );
    
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      print('Could not launch phone');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768 && screenWidth <= 1024;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
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
                          color: AppTheme.primaryPurple,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Get In Touch',
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
                        'Let\'s Work Together',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkText,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Have a project in mind? I\'d love to hear about it. Send me a message and let\'s discuss how we can bring your ideas to life.',
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
                          color: AppTheme.primaryPurple,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 80),
              
              // Main Content
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column - Contact Info
                    Expanded(
                      flex: 2,
                      child: _buildContactInfoColumn(),
                    ),
                    const SizedBox(width: 60),
                    // Right Column - Contact Form
                    Expanded(
                      flex: 3,
                      child: _buildContactForm(),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    _buildContactInfoColumn(),
                    const SizedBox(height: 40),
                    _buildContactForm(),
                  ],
                ),
              
              const SizedBox(height: 60),
              
              // Social Media Links
              _buildSocialMediaSection(),
              
              const SizedBox(height: 40),
              
              // Location Display
              LocationDisplay(
                city: 'Trichy',
                country: 'India',
                description: 'Available for remote opportunities and collaborations',
                isVisible: _isLocationVisible,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfoColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Information',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryPurple,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Feel free to reach out through any of these channels. I typically respond within 24 hours.',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.lightText,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        
        ContactInfoCard(
          icon: Icons.email_rounded,
          title: 'Email',
          value: 'suvethachandru07@gmail.com',
          subtitle: 'Send me an email anytime',
          primaryColor: AppTheme.primaryPurple,
          secondaryColor: AppTheme.primaryGreen,
          isVisible: _isContactInfoVisible,
          onTap: _launchEmail,
        ),
        
        ContactInfoCard(
          icon: Icons.school_rounded,
          title: 'Education',
          value: 'M.Sc. Computer Science',
          subtitle: 'Bharathidasan University',
          primaryColor: AppTheme.primaryGreen,
          secondaryColor: AppTheme.primaryPurple,
          isVisible: _isContactInfoVisible,
        ),
        
        ContactInfoCard(
          icon: Icons.schedule_rounded,
          title: 'Response Time',
          value: 'Within 24 hours',
          subtitle: 'I\'ll get back to you quickly',
          primaryColor: AppTheme.primaryOrange,
          secondaryColor: AppTheme.primaryPurple,
          isVisible: _isContactInfoVisible,
        ),
      ],
    );
  }

  Widget _buildContactForm() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPurple.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Send Message',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkText,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fill out the form below and I\'ll get back to you as soon as possible.',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.lightText,
              ),
            ),
            const SizedBox(height: 32),
            
            AnimatedFormField(
              label: 'Full Name',
              hint: 'Enter your full name',
              icon: Icons.person_rounded,
              controller: _nameController,
              validator: _validateName,
              isVisible: _isFormVisible,
            ),
            
            AnimatedFormField(
              label: 'Email Address',
              hint: 'Enter your email address',
              icon: Icons.email_rounded,
              controller: _emailController,
              validator: _validateEmail,
              keyboardType: TextInputType.emailAddress,
              isVisible: _isFormVisible,
            ),
            
            AnimatedFormField(
              label: 'Message',
              hint: 'Tell me about your project or inquiry...',
              icon: Icons.message_rounded,
              controller: _messageController,
              validator: _validateMessage,
              maxLines: 5,
              isVisible: _isFormVisible,
            ),
            
            const SizedBox(height: 32),
            
            SubmitButton(
              onPressed: _submitForm,
              isLoading: _isSubmitting,
              isSuccess: _isSuccess,
              isError: _isError,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaSection() {
    return Column(
      children: [
        const Text(
          'Connect With Me',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkText,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Follow me on social media for updates and insights',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.lightText,
          ),
        ),
        const SizedBox(height: 24),
        
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            SocialMediaLink(
              icon: Icons.code,
              platform: 'GitHub',
              url: 'https://github.com/suvetha-chandru',
              primaryColor: AppTheme.primaryPurple,
              secondaryColor: AppTheme.primaryGreen,
              isVisible: _isSocialVisible,
            ),
            SocialMediaLink(
              icon: Icons.work,
              platform: 'LinkedIn',
              url: 'https://www.linkedin.com/in/suvetha-chandru-abb95a2a9/',
              primaryColor: AppTheme.primaryGreen,
              secondaryColor: AppTheme.primaryPurple,
              isVisible: _isSocialVisible,
            ),
          ],
        ),
      ],
    );
  }
}
