import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ResponsiveDesignTester {
  static const List<Size> testSizes = [
    // Mobile Portrait
    Size(375, 667),   // iPhone SE
    Size(390, 844),   // iPhone 12
    Size(393, 851),   // Pixel 5
    Size(412, 915),   // Samsung Galaxy S21
    
    // Mobile Landscape
    Size(667, 375),   // iPhone SE Landscape
    Size(844, 390),   // iPhone 12 Landscape
    
    // Tablet Portrait
    Size(768, 1024),  // iPad
    Size(820, 1180),  // iPad Air
    Size(834, 1194),  // iPad Pro 11"
    
    // Tablet Landscape
    Size(1024, 768),  // iPad Landscape
    Size(1180, 820),  // iPad Air Landscape
    Size(1194, 834),  // iPad Pro 11" Landscape
    
    // Desktop
    Size(1280, 720),  // Small Desktop
    Size(1366, 768),  // Common Laptop
    Size(1440, 900),  // MacBook Pro 15"
    Size(1920, 1080), // Full HD
    Size(2560, 1440), // QHD
    Size(3840, 2160), // 4K
  ];
  
  static void testResponsiveBreakpoints() {
    if (kDebugMode) {
      print('=== Responsive Design Breakpoints ===');
      
      for (final size in testSizes) {
        final deviceType = _getDeviceType(size);
        final orientation = size.width > size.height ? 'Landscape' : 'Portrait';
        
        print('Size: ${size.width.toInt()}x${size.height.toInt()} - '
              'Type: $deviceType - Orientation: $orientation');
        
        // Test breakpoint logic
        final isMobile = size.width < 768;
        final isTablet = size.width >= 768 && size.width <= 1024;
        final isDesktop = size.width > 1024;
        
        print('  Breakpoints: Mobile: $isMobile, Tablet: $isTablet, Desktop: $isDesktop');
        print('  Recommended padding: ${_getRecommendedPadding(size)}');
        print('  Grid columns: ${_getGridColumns(size)}');
        print('  Typography scale: ${_getTypographyScale(size)}');
        print('---');
      }
    }
  }
  
  static String _getDeviceType(Size size) {
    if (size.width < 600) return 'Mobile';
    if (size.width < 1024) return 'Tablet';
    if (size.width < 1440) return 'Desktop';
    return 'Large Desktop';
  }
  
  static EdgeInsets _getRecommendedPadding(Size size) {
    if (size.width < 768) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 24);
    } else if (size.width <= 1024) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 32);
    } else {
      return const EdgeInsets.symmetric(horizontal: 64, vertical: 48);
    }
  }
  
  static int _getGridColumns(Size size) {
    if (size.width < 600) return 1;
    if (size.width < 900) return 2;
    if (size.width < 1200) return 3;
    return 4;
  }
  
  static double _getTypographyScale(Size size) {
    if (size.width < 768) return 0.9;
    if (size.width <= 1024) return 1.0;
    return 1.1;
  }
}

class ResponsiveTestWidget extends StatefulWidget {
  final Widget child;
  
  const ResponsiveTestWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<ResponsiveTestWidget> createState() => _ResponsiveTestWidgetState();
}

class _ResponsiveTestWidgetState extends State<ResponsiveTestWidget> {
  Size? _selectedSize;
  bool _showTestFrame = false;
  
  @override
  Widget build(BuildContext context) {
    if (!kDebugMode || !_showTestFrame) {
      return widget.child;
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Design Tester'),
        backgroundColor: const Color(0xFF6B46C1),
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<Size>(
            icon: const Icon(Icons.phone_android),
            onSelected: (size) {
              setState(() {
                _selectedSize = size;
              });
            },
            itemBuilder: (context) => ResponsiveDesignTester.testSizes.map((size) {
              final deviceType = ResponsiveDesignTester._getDeviceType(size);
              return PopupMenuItem(
                value: size,
                child: Text('${size.width.toInt()}x${size.height.toInt()} ($deviceType)'),
              );
            }).toList(),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedSize = null;
              });
            },
            icon: const Icon(Icons.fullscreen),
            tooltip: 'Reset to full size',
          ),
        ],
      ),
      body: _selectedSize != null 
          ? Center(
              child: Container(
                width: _selectedSize!.width,
                height: _selectedSize!.height,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF6B46C1), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRect(
                  child: OverflowBox(
                    minWidth: _selectedSize!.width,
                    maxWidth: _selectedSize!.width,
                    minHeight: _selectedSize!.height,
                    maxHeight: _selectedSize!.height,
                    child: SizedBox(
                      width: _selectedSize!.width,
                      height: _selectedSize!.height,
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            )
          : widget.child,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showTestFrame = !_showTestFrame;
          });
        },
        backgroundColor: const Color(0xFF6B46C1),
        child: Icon(_showTestFrame ? Icons.close : Icons.settings),
      ),
    );
  }
}

// Performance testing utilities
class PerformanceTester {
  static void testScrollPerformance(ScrollController controller) {
    if (kDebugMode) {
      int frameCount = 0;
      DateTime startTime = DateTime.now();
      
      void frameCallback(Duration timestamp) {
        frameCount++;
        
        if (frameCount % 60 == 0) { // Check every 60 frames (~1 second)
          final elapsed = DateTime.now().difference(startTime);
          final fps = frameCount / elapsed.inSeconds;
          print('Scroll FPS: ${fps.toStringAsFixed(1)}');
        }
        
        WidgetsBinding.instance.addPostFrameCallback(frameCallback);
      }
      
      WidgetsBinding.instance.addPostFrameCallback(frameCallback);
    }
  }
  
  static void testAnimationPerformance(AnimationController controller) {
    if (kDebugMode) {
      controller.addListener(() {
        // Monitor animation performance
        final value = controller.value;
        if (value == 0.0 || value == 1.0) {
          print('Animation ${controller.debugLabel ?? 'Unknown'} completed: $value');
        }
      });
    }
  }
  
  static void measureWidgetBuildTime(String widgetName, VoidCallback buildFunction) {
    if (kDebugMode) {
      final stopwatch = Stopwatch()..start();
      buildFunction();
      stopwatch.stop();
      
      if (stopwatch.elapsedMilliseconds > 16) { // More than one frame (60fps)
        print('WARNING: $widgetName took ${stopwatch.elapsedMilliseconds}ms to build');
      }
    }
  }
}

// Layout debugging utilities
class LayoutDebugger {
  static Widget debugLayout({
    required Widget child,
    Color borderColor = Colors.red,
    bool showDimensions = false,
  }) {
    if (!kDebugMode) return child;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 1),
              ),
              child: child,
            ),
            if (showDimensions)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  color: borderColor,
                  child: Text(
                    '${constraints.maxWidth.toInt()}x${constraints.maxHeight.toInt()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
  
  static Widget debugOverflow({
    required Widget child,
    Color overflowColor = Colors.yellow,
  }) {
    if (!kDebugMode) return child;
    
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: overflowColor, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  static void printWidgetTree(BuildContext context, {int maxDepth = 5}) {
    if (kDebugMode) {
      void printElement(Element element, int depth) {
        if (depth > maxDepth) return;
        
        final indent = '  ' * depth;
        print('$indent${element.runtimeType}');
        
        element.visitChildElements((child) {
          printElement(child, depth + 1);
        });
      }
      
      printElement(context as Element, 0);
    }
  }
}

// Accessibility testing
class AccessibilityTester {
  static void testSemantics(BuildContext context) {
    if (kDebugMode) {
      final renderObject = context.findRenderObject();
      if (renderObject != null) {
        // Semantic testing would be implemented here
        // Note: semanticsOwner API has changed in newer Flutter versions
        print('Semantics testing placeholder');
      }
    }
  }
  
  static void _printSemanticsTree(dynamic node, int depth) {
    final indent = '  ' * depth;
    print('$indent${node.runtimeType}: ${node.label ?? 'No label'}');
    
    // Note: This is a simplified version. Actual implementation would need
    // proper casting and null checking based on the semantics API
  }
  
  static List<String> validateAccessibility(BuildContext context) {
    final issues = <String>[];
    
    // Check for missing semantic labels
    final renderObject = context.findRenderObject();
    if (renderObject != null) {
      // Add accessibility validation logic here
      // This is a placeholder for actual accessibility testing
    }
    
    return issues;
  }
}

// Memory usage monitoring
class MemoryMonitor {
  static void startMonitoring() {
    if (kDebugMode) {
      // This would integrate with Flutter's memory profiling tools
      print('Memory monitoring started (placeholder)');
      
      // In a real implementation, you'd use:
      // - WidgetsBinding.instance.addPersistentFrameCallback
      // - Memory profiling APIs
      // - Custom memory tracking
    }
  }
  
  static void logMemoryUsage(String label) {
    if (kDebugMode) {
      // Log current memory usage
      print('Memory usage at $label: (placeholder for actual measurement)');
    }
  }
}
