# Modern Portfolio - Flutter Web

A stunning, responsive portfolio website built with Flutter for web. Features a modern design with a carefully crafted color scheme and beautiful typography.

## 🎨 Design Features

### Color Palette
- **Primary Purple**: `#6B46C1` - Used for headings, primary buttons, and accents
- **Primary Orange**: `#F97316` - Used for secondary elements and highlights
- **Primary Beige**: `#F5F5DC` - Used for section backgrounds and subtle accents
- **Primary Green**: `#10B981` - Used for success states and call-to-action elements

### Typography
- **Headings**: Poppins font family for all heading elements
- **Body Text**: Inter font family for all body text and labels
- **Responsive**: Font sizes automatically scale based on screen size

### Layout
- **Fully Responsive**: Adapts to mobile, tablet, and desktop screen sizes
- **Modern Grid System**: Responsive grid layout for projects and skills sections
- **Smooth Scrolling**: Enhanced user experience with smooth scroll behavior
- **Loading Screen**: Beautiful gradient loading screen while the app initializes

## 🚀 Features

### Sections
1. **Navigation Bar** - Responsive navigation with mobile hamburger menu
2. **Hero Section** - Eye-catching introduction with gradient profile image
3. **About Section** - Personal introduction with animated statistics cards
4. **Skills Section** - Technology skills organized in responsive cards
5. **Projects Section** - Portfolio projects showcase with links
6. **Contact Section** - Contact form and information display
7. **Footer** - Social links and copyright information

### Technical Features
- **Material Design 3**: Latest Material Design principles
- **Google Fonts Integration**: Beautiful typography with Poppins and Inter
- **Responsive Framework**: Handles different screen sizes gracefully
- **Web Optimized**: Optimized for web performance and SEO
- **PWA Ready**: Progressive Web App capabilities

## 🛠️ Project Structure

```
lib/
├── main.dart                 # App entry point with MaterialApp setup
├── pages/
│   └── portfolio_home_page.dart  # Main portfolio page with all sections
├── theme/
│   └── app_theme.dart           # Custom theme with colors and typography
├── utils/
│   └── responsive_layout.dart   # Responsive layout utilities
└── widgets/
    └── animated_widgets.dart    # Custom animated widgets and components
```

## 📱 Responsive Breakpoints

- **Mobile**: < 768px width
- **Tablet**: 768px - 1024px width  
- **Desktop**: > 1024px width

## 🔧 Setup & Installation

### Prerequisites
- Flutter SDK (>= 3.8.1)
- Chrome browser (for web development)

### Installation Steps

1. **Clone or use this project**:
   ```bash
   cd your-project-directory
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run for web development**:
   ```bash
   flutter run -d chrome
   ```

4. **Build for web production**:
   ```bash
   flutter build web --release
   ```

## 🎯 Customization Guide

### Updating Personal Information

1. **Edit Hero Section** in `lib/pages/portfolio_home_page.dart`:
   - Change name, title, and description in `_buildHeroContent()`

2. **Update About Section**:
   - Modify personal description in `_buildAboutContent()`
   - Update statistics in `_buildAboutStats()`

3. **Add Your Skills**:
   - Update skill categories and technologies in `_buildSkillsSection()`

4. **Showcase Your Projects**:
   - Replace project cards in `_buildProjectsSection()`
   - Add real project images and links

5. **Contact Information**:
   - Update contact details in `_buildContactInfo()`

### Color Customization

Edit colors in `lib/theme/app_theme.dart`:
```dart
static const Color primaryPurple = Color(0xFF6B46C1);  // Your primary color
static const Color primaryOrange = Color(0xFFF97316);  // Your secondary color
static const Color primaryBeige = Color(0xFFF5F5DC);   // Your background accent
static const Color primaryGreen = Color(0xFF10B981);   // Your success color
```

### Font Customization

In `lib/theme/app_theme.dart`, you can change fonts:
```dart
// For headings
headlineLarge: GoogleFonts.yourChosenFont(...)

// For body text  
bodyLarge: GoogleFonts.yourChosenFont(...)
```

## 📦 Dependencies

- **flutter**: Core Flutter framework
- **google_fonts**: ^6.2.1 - Typography with Google Fonts
- **responsive_framework**: ^1.4.0 - Responsive design utilities
- **cupertino_icons**: ^1.0.8 - iOS style icons

## 🌐 Web Deployment

### GitHub Pages
1. Build the web app: `flutter build web --release`
2. Deploy the `build/web` folder to GitHub Pages

### Netlify/Vercel
1. Build the web app: `flutter build web --release`
2. Upload the `build/web` folder to your hosting service

### Firebase Hosting
1. Install Firebase CLI: `npm install -g firebase-tools`
2. Build the web app: `flutter build web --release`
3. Deploy: `firebase deploy`

## 🎨 Design Inspiration

This portfolio design follows modern web design principles:
- **Minimalist Layout**: Clean, uncluttered design
- **Bold Typography**: Strong font hierarchy with Poppins and Inter
- **Vibrant Colors**: Carefully selected color palette for visual impact
- **Smooth Animations**: Subtle animations for better user experience
- **Mobile-First**: Responsive design starting from mobile screens

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 🤝 Contributing

Feel free to submit issues, feature requests, or pull requests to help improve this portfolio template.

---

**Built with ❤️ using Flutter Web**
