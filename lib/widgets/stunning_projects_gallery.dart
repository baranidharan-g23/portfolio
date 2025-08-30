import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';
import '../models/project_data.dart';
import '../widgets/project_card.dart';
import '../widgets/project_detail_modal.dart';

class StunningProjectsGallery extends StatefulWidget {
  const StunningProjectsGallery({Key? key}) : super(key: key);

  @override
  State<StunningProjectsGallery> createState() => _StunningProjectsGalleryState();
}

class _StunningProjectsGalleryState extends State<StunningProjectsGallery>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _filterController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _filterFadeAnimation;

  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  List<ProjectData> _filteredProjects = [];
  List<ProjectData> _allProjects = [];
  bool _showCards = false;

  @override
  void initState() {
    super.initState();
    
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _filterController = AnimationController(
      duration: const Duration(milliseconds: 600),
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

    _filterFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _filterController,
      curve: Curves.easeOut,
    ));

    // Initialize projects
    _allProjects = _getSampleProjects();
    _filteredProjects = _allProjects;

    // Start animations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _headerController.forward();
      
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          _filterController.forward();
        }
      });
      
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _showCards = true;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _filterController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<ProjectData> _getSampleProjects() {
    return [
      ProjectData(
        id: '1',
        title: 'Trans_bee – The Shifting Partner',
        description: 'Logistics application enabling on-demand goods transportation',
        fullDescription: 'A comprehensive logistics application that revolutionizes goods transportation through a unique space-sharing model. The app optimizes unused cargo space, reduces costs, and increases vehicle efficiency by connecting users who need transportation with providers who have available space.',
        techStack: ['Flutter', 'Firebase', 'Dart', 'Real-time Database'],
        category: ProjectCategory.mobileApps,
        thumbnailUrl: '',
        screenshots: ['', ''],
        githubUrl: 'https://github.com/suvetha-chandru',
        duration: '4 months',
        features: [
          'On-demand booking system for goods transportation',
          'Real-time tracking of shipments and vehicles',
          'Space-sharing optimization algorithm',
          'Coordination between users and service providers',
          'Cost-effective transportation solutions',
          'Vehicle efficiency optimization',
          'User-friendly booking interface',
        ],
        status: 'Completed',
      ),
      ProjectData(
        id: '2',
        title: 'Skill Swap – Your Skill Library',
        description: 'Community-driven platform enabling peer-to-peer skill exchange',
        fullDescription: 'An innovative platform that connects people for skill sharing and learning. Users can teach their expertise in various domains like coding, cooking, music, and more while learning from others in the community. Features real-time communication and comprehensive session management.',
        techStack: ['Flutter', 'Firebase', 'Video Calling', 'Real-time Chat'],
        category: ProjectCategory.mobileApps,
        thumbnailUrl: '',
        screenshots: ['', '', ''],
        githubUrl: 'https://github.com/suvetha-chandru',
        duration: '5 months',
        features: [
          'Peer-to-peer skill exchange platform',
          'Real-time chat and messaging system',
          'Video calling for remote sessions',
          'Session booking and scheduling',
          'Rating and feedback system',
          'Profile-based portfolios for users',
          'Multi-domain skill categories',
        ],
        status: 'In Progress',
      ),
      ProjectData(
        id: '3',
        title: 'FinTrail – Custom Finance Tracker',
        description: 'Personalized finance tracker built for client-specific needs',
        fullDescription: 'A comprehensive finance tracking application designed to meet specific client requirements. The app provides detailed monitoring of income, expenses, savings, and budgets with intuitive visualizations and reporting features for personal financial management.',
        techStack: ['Flutter', 'Firebase', 'Data Visualization', 'Charts'],
        category: ProjectCategory.mobileApps,
        thumbnailUrl: '',
        screenshots: ['', ''],
        githubUrl: 'https://github.com/suvetha-chandru',
        duration: '3 months',
        features: [
          'Detailed income and expense tracking',
          'Savings and budget monitoring',
          'Custom financial categories',
          'Visual data representation with charts',
          'Monthly and yearly financial reports',
          'Goal setting and progress tracking',
          'Client-specific customizations',
        ],
        status: 'Completed',
      ),
    ];
  }

  void _filterProjects() {
    setState(() {
      _filteredProjects = _allProjects.where((project) {
        final matchesSearch = _searchQuery.isEmpty ||
                            project.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                            project.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                            project.techStack.any((tech) => 
                              tech.toLowerCase().contains(_searchQuery.toLowerCase()));
        return matchesSearch;
      }).toList();
      
      // Reset card visibility for animation
      _showCards = false;
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _showCards = true;
          });
        }
      });
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _filterProjects();
  }

  void _showProjectDetails(ProjectData project) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProjectDetailModal(project: project),
    );
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
            Color(0xFFFAFAFA),
            Colors.white,
            Color(0xFFF8F9FA),
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 80 : (isTablet ? 40 : 20),
          vertical: 80,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
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
                              AppTheme.primaryPurple,
                              AppTheme.primaryOrange,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Featured Projects',
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
                        'Stunning Projects Gallery',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkText,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Explore my latest work and creative solutions across mobile apps, web applications, and UI/UX design projects',
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
              ),
              
              const SizedBox(height: 60),
              
              // Filter and Search Section
              FadeTransition(
                opacity: _filterFadeAnimation,
                child: Column(
                  children: [
                    // Search Bar
                    Container(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          hintText: 'Search projects by name, description, or technology...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    _onSearchChanged('');
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Projects Count
              Text(
                '${_filteredProjects.length} Mobile App ${_filteredProjects.length == 1 ? 'Project' : 'Projects'}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightText,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Projects Grid
              _buildProjectsGrid(isDesktop, isTablet),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectsGrid(bool isDesktop, bool isTablet) {
    if (_filteredProjects.isEmpty) {
      return Container(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: Colors.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              const Text(
                'No projects found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightText,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Try adjusting your search or filter criteria',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.lightText,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Calculate staggered grid layout
    return _StaggeredProjectGrid(
      projects: _filteredProjects,
      isDesktop: isDesktop,
      isTablet: isTablet,
      showCards: _showCards,
      onProjectTap: _showProjectDetails,
    );
  }
}

class _StaggeredProjectGrid extends StatelessWidget {
  final List<ProjectData> projects;
  final bool isDesktop;
  final bool isTablet;
  final bool showCards;
  final Function(ProjectData) onProjectTap;

  const _StaggeredProjectGrid({
    required this.projects,
    required this.isDesktop,
    required this.isTablet,
    required this.showCards,
    required this.onProjectTap,
  });

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: isDesktop ? 0.75 : (isTablet ? 0.8 : 0.85),
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return AnimatedOpacity(
          opacity: showCards ? 1.0 : 0.0,
          duration: Duration(milliseconds: 600 + (index * 100)),
          child: ProjectCard(
            project: project,
            onTap: () => onProjectTap(project),
            isVisible: showCards,
          ),
        );
      },
    );
  }
}
