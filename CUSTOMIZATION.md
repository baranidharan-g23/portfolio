# Quick Customization Guide

This guide will help you quickly customize your portfolio with your own information.

## Step 1: Update Portfolio Configuration

Edit `lib/config/portfolio_config.dart` and update your personal information:

```dart
// Replace with your actual information
static const String name = "John Doe";
static const String title = "Flutter Developer & Mobile App Specialist";
static const String email = "john.doe@example.com";
// ... etc
```

## Step 2: Update Your Skills

In the same file, modify the skills array:

```dart
static const List<SkillCategory> skills = [
  SkillCategory(
    title: "Mobile Development",
    skills: ["Flutter", "React Native", "Swift", "Kotlin"],
  ),
  // Add your own skill categories
];
```

## Step 3: Add Your Projects

Replace the sample projects with your real work:

```dart
static const List<Project> projects = [
  Project(
    title: "Your Amazing App",
    description: "Description of what your app does",
    technologies: ["Flutter", "Firebase", "etc"],
    demoUrl: "https://your-actual-demo.com",
    codeUrl: "https://github.com/yourusername/your-repo",
  ),
  // Add more projects
];
```

## Step 4: Customize Colors (Optional)

If you want different colors, edit `lib/theme/app_theme.dart`:

```dart
// Replace these hex colors with your preferred palette
static const Color primaryPurple = Color(0xFF6B46C1);  // Your main color
static const Color primaryOrange = Color(0xFFF97316);  // Your accent color
static const Color primaryBeige = Color(0xFFF5F5DC);   // Your background
static const Color primaryGreen = Color(0xFF10B981);   // Your success color
```

## Step 5: Add Your Photo

1. Add your profile photo to `assets/images/` folder
2. Update `pubspec.yaml` to include assets:
   ```yaml
   flutter:
     assets:
       - assets/images/
   ```
3. Replace the placeholder in the hero section with your actual image

## Step 6: Update Social Links

In the footer section of `portfolio_home_page.dart`, update the social links:

```dart
IconButton(
  onPressed: () {
    // Add your actual social media links
    launch("https://github.com/yourusername");
  },
  icon: const Icon(Icons.code),
),
```

## Step 7: Deploy Your Portfolio

### For GitHub Pages:
1. Run: `flutter build web --release`
2. Copy contents of `build/web` to your GitHub Pages repository

### For Netlify:
1. Run: `flutter build web --release`
2. Drag and drop the `build/web` folder to Netlify

### For Firebase:
1. Install Firebase CLI: `npm install -g firebase-tools`
2. Run: `firebase init hosting`
3. Run: `flutter build web --release`
4. Run: `firebase deploy`

## Colors Used in This Portfolio

- **Purple (#6B46C1)**: Primary brand color for headings and buttons
- **Orange (#F97316)**: Secondary color for highlights and CTAs
- **Beige (#F5F5DC)**: Subtle background sections
- **Green (#10B981)**: Success states and positive actions

## Typography

- **Poppins**: Used for all headings (modern, geometric)
- **Inter**: Used for body text (highly readable)

Both fonts are loaded via Google Fonts for optimal web performance.

## Responsive Design

The portfolio automatically adapts to:
- **Mobile**: < 768px (single column layout)
- **Tablet**: 768px - 1024px (two column layout)  
- **Desktop**: > 1024px (three column layout)

## Next Steps

1. Replace all placeholder content with your actual information
2. Add real project screenshots to `assets/images/projects/`
3. Test on different screen sizes
4. Deploy to your preferred hosting platform
5. Share your beautiful new portfolio!

## Need Help?

If you encounter any issues:
1. Check the Flutter documentation: https://flutter.dev/docs
2. Review the code comments in each file
3. Test changes incrementally
4. Use `flutter run -d chrome` to see changes in real-time

Remember: This portfolio template is designed to be easily customizable while maintaining professional design standards.
