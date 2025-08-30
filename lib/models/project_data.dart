enum ProjectCategory {
  all,
  mobileApps,
  webApps,
  uiUx,
}

class ProjectData {
  final String id;
  final String title;
  final String description;
  final String fullDescription;
  final List<String> techStack;
  final ProjectCategory category;
  final String thumbnailUrl;
  final List<String> screenshots;
  final String? githubUrl;
  final String? liveUrl;
  final String duration;
  final List<String> features;
  final String status;

  ProjectData({
    required this.id,
    required this.title,
    required this.description,
    required this.fullDescription,
    required this.techStack,
    required this.category,
    required this.thumbnailUrl,
    required this.screenshots,
    this.githubUrl,
    this.liveUrl,
    required this.duration,
    required this.features,
    required this.status,
  });
}

extension ProjectCategoryExtension on ProjectCategory {
  String get displayName {
    switch (this) {
      case ProjectCategory.all:
        return 'All Projects';
      case ProjectCategory.mobileApps:
        return 'Mobile Apps';
      case ProjectCategory.webApps:
        return 'Web Apps';
      case ProjectCategory.uiUx:
        return 'UI/UX';
    }
  }

  String get filterName {
    switch (this) {
      case ProjectCategory.all:
        return 'All';
      case ProjectCategory.mobileApps:
        return 'Mobile Apps';
      case ProjectCategory.webApps:
        return 'Web Apps';
      case ProjectCategory.uiUx:
        return 'UI/UX';
    }
  }
}
