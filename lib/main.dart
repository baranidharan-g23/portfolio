import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'pages/portfolio_home_page.dart';
import 'utils/responsive_testing.dart';
import 'utils/seo_helper.dart';
import 'widgets/page_transitions.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize performance monitoring
  PerformanceMonitor.measurePageLoadTime();
  MemoryMonitor.startMonitoring();
  
  // Test responsive design breakpoints in debug mode
  ResponsiveDesignTester.testResponsiveBreakpoints();
  
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Suvetha Chandru - Flutter Developer Portfolio',
      debugShowCheckedModeBanner: false,
      
      // Custom theme with our color scheme and typography
      theme: AppTheme.lightTheme,
      
      // SEO and meta information
      onGenerateTitle: (context) => 'Suvetha Chandru - Flutter Developer | Portfolio',
      
      // Set portfolio home page as the main page
      home: const ResponsiveTestWidget(
        child: PortfolioHomePage(),
      ),
      
      // Custom page transitions
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return PageTransitions.fadeTransition(
              page: const PortfolioHomePage(),
              duration: const Duration(milliseconds: 500),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const PortfolioHomePage(),
            );
        }
      },
      
      // Performance optimization
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.4),
          ),
          child: child!,
        );
      },
    );
  }
}
