import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../models/project_data.dart';

class ProjectDetailModal extends StatefulWidget {
  final ProjectData project;

  const ProjectDetailModal({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  State<ProjectDetailModal> createState() => _ProjectDetailModalState();
}

class _ProjectDetailModalState extends State<ProjectDetailModal>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late PageController _pageController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _pageController = PageController();

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Color _getCategoryColor() {
    switch (widget.project.category) {
      case ProjectCategory.mobileApps:
        return AppTheme.primaryPurple;
      case ProjectCategory.webApps:
        return AppTheme.primaryOrange;
      case ProjectCategory.uiUx:
        return AppTheme.primaryGreen;
      default:
        return AppTheme.primaryPurple;
    }
  }

  IconData _getCategoryIcon() {
    switch (widget.project.category) {
      case ProjectCategory.mobileApps:
        return Icons.smartphone;
      case ProjectCategory.webApps:
        return Icons.web;
      case ProjectCategory.uiUx:
        return Icons.design_services;
      default:
        return Icons.work;
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch URL: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(isDesktop ? 60 : (isTablet ? 40 : 20)),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 1000 : double.infinity,
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getCategoryColor(),
                          _getCategoryColor().withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getCategoryIcon(),
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.project.title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.project.category.displayName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Screenshots Section
                          if (widget.project.screenshots.isNotEmpty) ...[
                            _buildScreenshotsSection(),
                            const SizedBox(height: 32),
                          ],
                          
                          // Project Info Grid
                          if (isDesktop)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: _buildProjectDetails(),
                                ),
                                const SizedBox(width: 32),
                                Expanded(
                                  child: _buildProjectMeta(),
                                ),
                              ],
                            )
                          else
                            Column(
                              children: [
                                _buildProjectDetails(),
                                const SizedBox(height: 24),
                                _buildProjectMeta(),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Action Buttons
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        if (widget.project.githubUrl != null)
                          Expanded(
                            child: _buildActionButton(
                              label: 'View Code',
                              icon: Icons.code,
                              onPressed: () => _launchUrl(widget.project.githubUrl!),
                              color: AppTheme.darkText,
                            ),
                          ),
                        if (widget.project.githubUrl != null && widget.project.liveUrl != null)
                          const SizedBox(width: 16),
                        if (widget.project.liveUrl != null)
                          Expanded(
                            child: _buildActionButton(
                              label: 'Live Demo',
                              icon: Icons.launch,
                              onPressed: () => _launchUrl(widget.project.liveUrl!),
                              color: _getCategoryColor(),
                            ),
                          ),
                      ],
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

  Widget _buildScreenshotsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Screenshots',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkText,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemCount: widget.project.screenshots.length,
              itemBuilder: (context, index) {
                final screenshot = widget.project.screenshots[index];
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getCategoryColor(),
                        _getCategoryColor().withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: screenshot.isEmpty
                      ? Center(
                          child: Icon(
                            _getCategoryIcon(),
                            size: 100,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        )
                      : Image.network(
                          screenshot,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                _getCategoryIcon(),
                                size: 100,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            );
                          },
                        ),
                );
              },
            ),
          ),
        ),
        if (widget.project.screenshots.length > 1) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.project.screenshots.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == _currentImageIndex
                      ? _getCategoryColor()
                      : Colors.grey.withOpacity(0.3),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildProjectDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About This Project',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkText,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.project.fullDescription,
          style: const TextStyle(
            fontSize: 16,
            height: 1.6,
            color: AppTheme.lightText,
          ),
        ),
        const SizedBox(height: 24),
        
        // Features
        const Text(
          'Key Features',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkText,
          ),
        ),
        const SizedBox(height: 12),
        ...widget.project.features.map((feature) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(top: 8, right: 12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getCategoryColor(),
                ),
              ),
              Expanded(
                child: Text(
                  feature,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: AppTheme.lightText,
                  ),
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildProjectMeta() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Duration & Status
        _buildMetaCard(
          'Project Info',
          [
            _buildMetaItem('Duration', widget.project.duration),
            _buildMetaItem('Status', widget.project.status),
            _buildMetaItem('Category', widget.project.category.displayName),
          ],
        ),
        const SizedBox(height: 24),
        
        // Tech Stack
        _buildMetaCard(
          'Tech Stack',
          [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.project.techStack.map((tech) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getCategoryColor(),
                        _getCategoryColor().withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _getCategoryColor().withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    tech,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetaCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkText,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildMetaItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.lightText,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 4,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
