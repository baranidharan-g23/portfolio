import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:html' as html;

class SEOHelper {
  static void setupMetaTags() {
    if (kIsWeb) {
      _setMetaTag('description', 
        'Naandhaan - Passionate Flutter Developer creating beautiful and functional mobile experiences. Explore my portfolio of innovative Flutter apps and mobile solutions.');
      
      _setMetaTag('keywords', 
        'Flutter Developer, Mobile App Developer, Dart Programming, Cross-platform Development, UI/UX Design, Mobile Applications, Flutter Apps, Portfolio, Naandhaan');
      
      _setMetaTag('author', 'Naandhaan');
      
      _setMetaTag('robots', 'index, follow');
      
      _setMetaTag('language', 'English');
      
      _setMetaTag('revisit-after', '7 days');
      
      // Open Graph Meta Tags
      _setMetaProperty('og:title', 'Naandhaan - Flutter Developer Portfolio');
      _setMetaProperty('og:description', 
        'Passionate Flutter Developer creating beautiful and functional mobile experiences. Explore my portfolio of innovative Flutter apps.');
      _setMetaProperty('og:type', 'website');
      _setMetaProperty('og:url', 'https://naandhaan-portfolio.web.app');
      _setMetaProperty('og:image', 'https://naandhaan-portfolio.web.app/icons/og-image.png');
      _setMetaProperty('og:image:width', '1200');
      _setMetaProperty('og:image:height', '630');
      _setMetaProperty('og:site_name', 'Naandhaan Portfolio');
      _setMetaProperty('og:locale', 'en_US');
      
      // Twitter Card Meta Tags
      _setMetaName('twitter:card', 'summary_large_image');
      _setMetaName('twitter:site', '@yourtwitterhandle');
      _setMetaName('twitter:creator', '@yourtwitterhandle');
      _setMetaName('twitter:title', 'Naandhaan - Flutter Developer Portfolio');
      _setMetaName('twitter:description', 
        'Passionate Flutter Developer creating beautiful and functional mobile experiences.');
      _setMetaName('twitter:image', 'https://naandhaan-portfolio.web.app/icons/twitter-image.png');
      
      // Additional SEO Meta Tags
      _setMetaName('theme-color', '#6B46C1');
      _setMetaName('msapplication-TileColor', '#6B46C1');
      _setMetaName('apple-mobile-web-app-capable', 'yes');
      _setMetaName('apple-mobile-web-app-status-bar-style', 'black-translucent');
      _setMetaName('apple-mobile-web-app-title', 'Naandhaan Portfolio');
      
      // Canonical URL
      _setCanonicalURL('https://naandhaan-portfolio.web.app');
      
      // JSON-LD Structured Data
      _addStructuredData();
    }
  }
  
  static void _setMetaTag(String name, String content) {
    final meta = html.document.querySelector('meta[name="$name"]') as html.MetaElement?;
    if (meta != null) {
      meta.content = content;
    } else {
      final newMeta = html.MetaElement()
        ..name = name
        ..content = content;
      html.document.head!.append(newMeta);
    }
  }
  
  static void _setMetaProperty(String property, String content) {
    final meta = html.document.querySelector('meta[property="$property"]') as html.MetaElement?;
    if (meta != null) {
      meta.content = content;
    } else {
      final newMeta = html.MetaElement()
        ..setAttribute('property', property)
        ..content = content;
      html.document.head!.append(newMeta);
    }
  }
  
  static void _setMetaName(String name, String content) {
    final meta = html.document.querySelector('meta[name="$name"]') as html.MetaElement?;
    if (meta != null) {
      meta.content = content;
    } else {
      final newMeta = html.MetaElement()
        ..name = name
        ..content = content;
      html.document.head!.append(newMeta);
    }
  }
  
  static void _setCanonicalURL(String url) {
    final existing = html.document.querySelector('link[rel="canonical"]');
    existing?.remove();
    
    final canonical = html.LinkElement()
      ..rel = 'canonical'
      ..href = url;
    html.document.head!.append(canonical);
  }
  
  static void _addStructuredData() {
    final structuredData = '''
    {
      "@context": "https://schema.org",
      "@type": "Person",
      "name": "Naandhaan",
      "jobTitle": "Flutter Developer",
      "description": "Passionate Flutter Developer creating beautiful and functional mobile experiences",
      "url": "https://naandhaan-portfolio.web.app",
      "image": "https://naandhaan-portfolio.web.app/icons/profile-image.jpg",
      "sameAs": [
        "https://github.com/yourusername",
        "https://linkedin.com/in/yourusername",
        "https://twitter.com/yourusername"
      ],
      "address": {
        "@type": "PostalAddress",
        "addressLocality": "Chennai",
        "addressRegion": "Tamil Nadu",
        "addressCountry": "India"
      },
      "knowsAbout": [
        "Flutter Development",
        "Dart Programming",
        "Mobile App Development",
        "Cross-platform Development",
        "UI/UX Design"
      ],
      "alumniOf": {
        "@type": "CollegeOrUniversity",
        "name": "Your University Name"
      }
    }
    ''';
    
    final script = html.ScriptElement()
      ..type = 'application/ld+json'
      ..text = structuredData;
    html.document.head!.append(script);
  }
  
  static void updatePageTitle(String title) {
    if (kIsWeb) {
      html.document.title = '$title | Naandhaan - Flutter Developer';
    }
  }
  
  static void updatePageDescription(String description) {
    if (kIsWeb) {
      _setMetaTag('description', description);
      _setMetaProperty('og:description', description);
      _setMetaName('twitter:description', description);
    }
  }
  
  static void setupFavicons() {
    if (kIsWeb) {
      // Standard favicon
      _addFavicon('favicon.ico', sizes: null);
      
      // PNG favicons
      _addFavicon('icons/Icon-192.png', sizes: '192x192', type: 'image/png');
      _addFavicon('icons/Icon-512.png', sizes: '512x512', type: 'image/png');
      
      // Apple touch icons
      _addAppleTouchIcon('icons/Icon-192.png', sizes: '180x180');
      
      // Manifest
      _addManifestLink();
    }
  }
  
  static void _addFavicon(String href, {String? sizes, String? type}) {
    final link = html.LinkElement()
      ..rel = 'icon'
      ..href = href;
    
    if (sizes != null) link.setAttribute('sizes', sizes);
    if (type != null) link.type = type;
    
    html.document.head!.append(link);
  }
  
  static void _addAppleTouchIcon(String href, {String? sizes}) {
    final link = html.LinkElement()
      ..rel = 'apple-touch-icon'
      ..href = href;
    
    if (sizes != null) link.setAttribute('sizes', sizes);
    
    html.document.head!.append(link);
  }
  
  static void _addManifestLink() {
    final link = html.LinkElement()
      ..rel = 'manifest'
      ..href = 'manifest.json';
    html.document.head!.append(link);
  }
  
  // Analytics tracking
  static void trackPageView(String pageName) {
    if (kIsWeb) {
      // Google Analytics 4 tracking
      _gtag('config', 'GA_MEASUREMENT_ID', {
        'page_title': pageName,
        'page_location': html.window.location.href,
      });
    }
  }
  
  static void trackEvent(String eventName, {Map<String, dynamic>? parameters}) {
    if (kIsWeb) {
      _gtag('event', eventName, parameters ?? {});
    }
  }
  
  static void _gtag(String command, String targetId, [Map<String, dynamic>? config]) {
    // This would integrate with Google Analytics
    // Implementation depends on your analytics setup
    if (kDebugMode) {
      print('Analytics: $command $targetId ${config?.toString() ?? ''}');
    }
  }
  
  // Performance optimization
  static void preloadCriticalResources() {
    if (kIsWeb) {
      // Preload critical fonts
      _preloadResource('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap', 'style');
      _preloadResource('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&display=swap', 'style');
      
      // Preload critical images
      _preloadResource('icons/Icon-512.png', 'image');
    }
  }
  
  static void _preloadResource(String href, String as) {
    final link = html.LinkElement()
      ..rel = 'preload'
      ..href = href
      ..setAttribute('as', as);
    
    if (as == 'style') {
      link.setAttribute('crossorigin', 'anonymous');
    }
    
    html.document.head!.append(link);
  }
  
  // Security headers (for production)
  static void setupSecurityHeaders() {
    if (kIsWeb) {
      // Content Security Policy
      _setMetaHttpEquiv('Content-Security-Policy', 
        "default-src 'self'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com; img-src 'self' data: https:; script-src 'self' 'unsafe-inline' 'unsafe-eval';");
      
      // Other security headers
      _setMetaHttpEquiv('X-Content-Type-Options', 'nosniff');
      _setMetaHttpEquiv('X-Frame-Options', 'DENY');
      _setMetaHttpEquiv('X-XSS-Protection', '1; mode=block');
      _setMetaHttpEquiv('Referrer-Policy', 'strict-origin-when-cross-origin');
    }
  }
  
  static void _setMetaHttpEquiv(String httpEquiv, String content) {
    final meta = html.MetaElement()
      ..httpEquiv = httpEquiv
      ..content = content;
    html.document.head!.append(meta);
  }
  
  // Sitemap generation helper
  static List<Map<String, String>> getSitemapUrls() {
    return [
      {
        'url': 'https://naandhaan-portfolio.web.app/',
        'priority': '1.0',
        'changefreq': 'weekly',
      },
      {
        'url': 'https://naandhaan-portfolio.web.app/#about',
        'priority': '0.8',
        'changefreq': 'monthly',
      },
      {
        'url': 'https://naandhaan-portfolio.web.app/#skills',
        'priority': '0.8',
        'changefreq': 'monthly',
      },
      {
        'url': 'https://naandhaan-portfolio.web.app/#projects',
        'priority': '0.9',
        'changefreq': 'weekly',
      },
      {
        'url': 'https://naandhaan-portfolio.web.app/#contact',
        'priority': '0.7',
        'changefreq': 'monthly',
      },
    ];
  }
}

// Performance monitoring
class PerformanceMonitor {
  static void measurePageLoadTime() {
    if (kIsWeb) {
      html.window.addEventListener('load', (event) {
        final navigationTiming = html.window.performance.timing;
        final pageLoadTime = navigationTiming.loadEventEnd - navigationTiming.navigationStart;
        
        if (kDebugMode) {
          print('Page Load Time: ${pageLoadTime}ms');
        }
        
        // Track with analytics
        SEOHelper.trackEvent('page_load_time', parameters: {
          'value': pageLoadTime,
          'custom_parameter': 'portfolio_page',
        });
      });
    }
  }
  
  static void measureFirstContentfulPaint() {
    if (kIsWeb) {
      try {
        final observer = html.PerformanceObserver((list, observer) {
          for (final entry in list.getEntries()) {
            if (entry.name == 'first-contentful-paint') {
              if (kDebugMode) {
                print('First Contentful Paint: ${entry.startTime}ms');
              }
              
              SEOHelper.trackEvent('first_contentful_paint', parameters: {
                'value': entry.startTime,
              });
            }
          }
        });
        
        observer.observe({'entryTypes': ['paint']});
      } catch (e) {
        if (kDebugMode) {
          print('Performance API not supported: $e');
        }
      }
    }
  }
}

// Accessibility helpers
class AccessibilityHelper {
  static void setupA11y() {
    if (kIsWeb) {
      // Skip links for keyboard navigation
      _addSkipLinks();
      
      // Focus management
      _setupFocusManagement();
      
      // Screen reader announcements
      _setupAriaLiveRegion();
    }
  }
  
  static void _addSkipLinks() {
    final skipLink = html.AnchorElement()
      ..href = '#main-content'
      ..text = 'Skip to main content'
      ..className = 'skip-link'
      ..style.position = 'absolute'
      ..style.top = '-40px'
      ..style.left = '6px'
      ..style.background = '#000'
      ..style.color = '#fff'
      ..style.padding = '8px'
      ..style.textDecoration = 'none'
      ..style.zIndex = '1000';
    
    skipLink.addEventListener('focus', (event) {
      skipLink.style.top = '6px';
    });
    
    skipLink.addEventListener('blur', (event) {
      skipLink.style.top = '-40px';
    });
    
    html.document.body!.insertBefore(skipLink, html.document.body!.firstChild);
  }
  
  static void _setupFocusManagement() {
    html.document.addEventListener('keydown', (event) {
      final keyboardEvent = event as html.KeyboardEvent;
      
      // Escape key handling
      if (keyboardEvent.key == 'Escape') {
        final modals = html.document.querySelectorAll('.modal, .dialog');
        for (final modal in modals) {
          if (modal.style.display != 'none') {
            (modal as html.Element).style.display = 'none';
            break;
          }
        }
      }
    });
  }
  
  static void _setupAriaLiveRegion() {
    final liveRegion = html.DivElement()
      ..id = 'aria-live-region'
      ..setAttribute('aria-live', 'polite')
      ..setAttribute('aria-atomic', 'true')
      ..style.position = 'absolute'
      ..style.left = '-10000px'
      ..style.width = '1px'
      ..style.height = '1px'
      ..style.overflow = 'hidden';
    
    html.document.body!.append(liveRegion);
  }
  
  static void announceToScreenReader(String message) {
    if (kIsWeb) {
      final liveRegion = html.document.getElementById('aria-live-region');
      if (liveRegion != null) {
        liveRegion.text = message;
        
        // Clear after announcement
        Future.delayed(const Duration(milliseconds: 1000), () {
          liveRegion.text = '';
        });
      }
    }
  }
}
