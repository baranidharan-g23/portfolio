import 'package:flutter/material.dart';

class ScrollService {
  static final ScrollService _instance = ScrollService._internal();
  factory ScrollService() => _instance;
  ScrollService._internal();

  final Map<String, GlobalKey> _sectionKeys = {};
  ScrollController? _scrollController;

  void initialize(ScrollController controller) {
    _scrollController = controller;
  }

  void registerSection(String sectionName, GlobalKey key) {
    _sectionKeys[sectionName] = key;
  }

  Future<void> scrollToSection(String sectionName) async {
    if (_scrollController == null) return;

    final key = _sectionKeys[sectionName];
    if (key?.currentContext == null) return;

    final RenderBox renderBox = key!.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    
    // Calculate the target scroll position
    // Subtract header height to account for sticky navigation
    const headerHeight = 90.0;
    final targetPosition = position.dy + _scrollController!.offset - headerHeight;

    await _scrollController!.animateTo(
      targetPosition.clamp(0.0, _scrollController!.position.maxScrollExtent),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  double getCurrentScrollPosition() {
    return _scrollController?.offset ?? 0.0;
  }

  Map<String, double> getSectionPositions() {
    final positions = <String, double>{};
    
    for (final entry in _sectionKeys.entries) {
      final key = entry.value;
      if (key.currentContext != null) {
        final RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        positions[entry.key] = position.dy + (getCurrentScrollPosition());
      }
    }
    
    return positions;
  }

  String getActiveSection() {
    final currentPosition = getCurrentScrollPosition();
    final positions = getSectionPositions();
    
    String activeSection = 'Home';
    double minDistance = double.infinity;
    
    for (final entry in positions.entries) {
      final distance = (currentPosition - entry.value + 100).abs();
      if (distance < minDistance && currentPosition >= entry.value - 200) {
        minDistance = distance;
        activeSection = entry.key;
      }
    }
    
    return activeSection;
  }
}

// Widget to mark sections for navigation
class NavigationSection extends StatelessWidget {
  final String sectionName;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const NavigationSection({
    super.key,
    required this.sectionName,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey();
    
    // Register this section with the scroll service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScrollService().registerSection(sectionName, key);
    });

    return Container(
      key: key,
      padding: padding,
      child: child,
    );
  }
}
