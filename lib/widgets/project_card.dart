import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/project_data.dart';

class ProjectCard extends StatefulWidget {
  final ProjectData project;
  final VoidCallback onTap;
  final bool isVisible;

  const ProjectCard({
    Key? key,
    required this.project,
    required this.onTap,
    this.isVisible = false,
  }) : super(key: key);

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _entryController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<double> _overlayAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: 4.0,
      end: 20.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));

    _overlayAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didUpdateWidget(ProjectCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _entryController.forward();
    }
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _entryController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: MouseRegion(
          onEnter: (_) {
            setState(() {
              _isHovered = true;
            });
            _hoverController.forward();
          },
          onExit: (_) {
            setState(() {
              _isHovered = false;
            });
            _hoverController.reverse();
          },
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _scaleAnimation,
                _elevationAnimation,
                _overlayAnimation,
              ]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: _getCategoryColor().withOpacity(0.2),
                          blurRadius: _elevationAnimation.value,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Project Thumbnail with Overlay
                            Expanded(
                              flex: 3,
                              child: Stack(
                                children: [
                                  // Thumbnail Image
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          _getCategoryColor(),
                                          _getCategoryColor().withOpacity(0.7),
                                        ],
                                      ),
                                    ),
                                    child: widget.project.thumbnailUrl.isEmpty
                                        ? Center(
                                            child: Icon(
                                              _getCategoryIcon(),
                                              size: 80,
                                              color: Colors.white.withOpacity(0.8),
                                            ),
                                          )
                                        : Image.network(
                                            widget.project.thumbnailUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Center(
                                                child: Icon(
                                                  _getCategoryIcon(),
                                                  size: 80,
                                                  color: Colors.white.withOpacity(0.8),
                                                ),
                                              );
                                            },
                                          ),
                                  ),
                                  
                                  // Hover Overlay
                                  AnimatedOpacity(
                                    opacity: _overlayAnimation.value,
                                    duration: const Duration(milliseconds: 300),
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.4),
                                            Colors.black.withOpacity(0.8),
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.visibility,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                              'View Details',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  // Category Badge
                                  Positioned(
                                    top: 12,
                                    left: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getCategoryColor(),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            _getCategoryIcon(),
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            widget.project.category.filterName,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  
                                  // Status Badge
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: widget.project.status == 'Completed'
                                            ? AppTheme.primaryGreen
                                            : AppTheme.primaryOrange,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        widget.project.status,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Project Info
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Project Title
                                    Text(
                                      widget.project.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.darkText,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    
                                    const SizedBox(height: 8),
                                    
                                    // Project Description
                                    Text(
                                      widget.project.description,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppTheme.lightText,
                                        height: 1.4,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    
                                    const Spacer(),
                                    
                                    // Tech Stack Preview
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 6,
                                      children: widget.project.techStack.take(3).map((tech) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getCategoryColor().withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: _getCategoryColor().withOpacity(0.3),
                                            ),
                                          ),
                                          child: Text(
                                            tech,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              color: _getCategoryColor(),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    
                                    if (widget.project.techStack.length > 3)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          '+${widget.project.techStack.length - 3} more',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: _getCategoryColor(),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
