import 'package:flutter/material.dart';

class ResponsiveLayout {
  // Breakpoints
  static const double mobileMaxWidth = 768;
  static const double tabletMaxWidth = 1024;
  static const double desktopMaxWidth = 1440;

  // Device type detection
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileMaxWidth;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileMaxWidth &&
      MediaQuery.of(context).size.width < tabletMaxWidth;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletMaxWidth;

  // Responsive values
  static T valueWhen<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    } else if (isTablet(context)) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }

  // Responsive padding
  static EdgeInsets responsivePadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: valueWhen(
        context: context,
        mobile: 16.0,
        tablet: 32.0,
        desktop: 64.0,
      ),
      vertical: 16.0,
    );
  }

  // Container max width
  static double getMaxWidth(BuildContext context) {
    return valueWhen(
      context: context,
      mobile: double.infinity,
      tablet: 768.0,
      desktop: 1200.0,
    );
  }

  // Grid columns
  static int getGridColumns(BuildContext context) {
    return valueWhen(
      context: context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
    );
  }

  // Font size scaling
  static double scaleFontSize(BuildContext context, double baseSize) {
    return valueWhen(
      context: context,
      mobile: baseSize * 0.9,
      tablet: baseSize,
      desktop: baseSize * 1.1,
    );
  }
}

// Responsive container widget
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? maxWidth;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin,
      padding: padding ?? ResponsiveLayout.responsivePadding(context),
      color: color,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? ResponsiveLayout.getMaxWidth(context),
          ),
          child: child,
        ),
      ),
    );
  }
}

// Responsive grid widget
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int? forceColumns;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.forceColumns,
  });

  @override
  Widget build(BuildContext context) {
    final columns = forceColumns ?? ResponsiveLayout.getGridColumns(context);
    
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: children.map((child) {
        return SizedBox(
          width: (MediaQuery.of(context).size.width - 
                 (ResponsiveLayout.responsivePadding(context).horizontal) - 
                 (spacing * (columns - 1))) / columns,
          child: child,
        );
      }).toList(),
    );
  }
}
