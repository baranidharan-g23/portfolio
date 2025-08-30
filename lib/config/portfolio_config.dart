class PortfolioConfig {
  // Personal Information
  static const String name = "Your Name";
  static const String title = "Full Stack Developer & UI/UX Designer";
  static const String description = 
      "I create beautiful, responsive web applications and mobile apps with modern technologies. "
      "Passionate about clean code and exceptional user experiences.";

  // Contact Information
  static const String email = "your.email@example.com";
  static const String phone = "+1 (555) 123-4567";
  static const String location = "Your City, Country";

  // Social Links
  static const String githubUrl = "https://github.com/yourusername";
  static const String linkedinUrl = "https://linkedin.com/in/yourusername";
  static const String twitterUrl = "https://twitter.com/yourusername";

  // About Section
  static const String aboutTitle = "Passionate Developer";
  static const String aboutDescription = 
      "I'm a dedicated full-stack developer with over 5 years of experience creating digital "
      "solutions that make a difference. I specialize in modern web technologies and have a keen eye for design.";
  
  static const String aboutSecondaryDescription = 
      "When I'm not coding, you can find me exploring new technologies, contributing to open-source "
      "projects, or sharing knowledge with the developer community.";

  // Statistics
  static const String projectsCompleted = "50+";
  static const String yearsExperience = "5+";
  static const String clientSatisfaction = "100%";

  // Skills
  static const List<SkillCategory> skills = [
    SkillCategory(
      title: "Frontend",
      skills: ["Flutter", "React", "Vue.js", "HTML/CSS"],
    ),
    SkillCategory(
      title: "Backend", 
      skills: ["Node.js", "Python", "PHP", "MongoDB"],
    ),
    SkillCategory(
      title: "Tools",
      skills: ["Git", "Docker", "AWS", "Figma"],
    ),
  ];

  // Projects
  static const List<Project> projects = [
    Project(
      title: "E-Commerce App",
      description: "Flutter mobile application with modern UI",
      technologies: ["Flutter", "Firebase", "Stripe"],
      demoUrl: "https://your-demo-url.com",
      codeUrl: "https://github.com/yourusername/project1",
    ),
    Project(
      title: "Portfolio Website",
      description: "Responsive web portfolio with animations",
      technologies: ["Flutter Web", "Google Fonts", "Responsive Design"],
      demoUrl: "https://your-portfolio-url.com",
      codeUrl: "https://github.com/yourusername/portfolio",
    ),
    Project(
      title: "Task Manager",
      description: "Productivity app with team collaboration",
      technologies: ["Flutter", "Node.js", "MongoDB"],
      demoUrl: "https://your-task-app-url.com",
      codeUrl: "https://github.com/yourusername/task-manager",
    ),
  ];
}

class SkillCategory {
  final String title;
  final List<String> skills;

  const SkillCategory({
    required this.title,
    required this.skills,
  });
}

class Project {
  final String title;
  final String description;
  final List<String> technologies;
  final String demoUrl;
  final String codeUrl;

  const Project({
    required this.title,
    required this.description,
    required this.technologies,
    required this.demoUrl,
    required this.codeUrl,
  });
}
