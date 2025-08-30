import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedParticleBackground extends StatefulWidget {
  final Widget child;
  final int particleCount;
  final Color particleColor;
  final double particleSize;
  final double speed;

  const AnimatedParticleBackground({
    super.key,
    required this.child,
    this.particleCount = 50,
    this.particleColor = Colors.white,
    this.particleSize = 2.0,
    this.speed = 1.0,
  });

  @override
  State<AnimatedParticleBackground> createState() => _AnimatedParticleBackgroundState();
}

class _AnimatedParticleBackgroundState extends State<AnimatedParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30), // Slower animation for better performance
      vsync: this,
    )..repeat();
    
    particles = List.generate(widget.particleCount, (index) => Particle());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Particle animation layer
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(
                  particles: particles,
                  animation: _controller.value,
                  particleColor: widget.particleColor,
                  particleSize: widget.particleSize,
                ),
              );
            },
          ),
        ),
        // Content layer
        widget.child,
      ],
    );
  }
}

class Particle {
  double x;
  double y;
  double vx;
  double vy;
  double size;
  double opacity;

  Particle()
      : x = math.Random().nextDouble(),
        y = math.Random().nextDouble(),
        vx = (math.Random().nextDouble() - 0.5) * 0.002,
        vy = (math.Random().nextDouble() - 0.5) * 0.002,
        size = math.Random().nextDouble() * 3 + 1,
        opacity = math.Random().nextDouble() * 0.5 + 0.2;

  void update() {
    x += vx;
    y += vy;

    // Wrap around screen
    if (x < 0) x = 1;
    if (x > 1) x = 0;
    if (y < 0) y = 1;
    if (y > 1) y = 0;
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animation;
  final Color particleColor;
  final double particleSize;

  ParticlePainter({
    required this.particles,
    required this.animation,
    required this.particleColor,
    required this.particleSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = particleColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (final particle in particles) {
      particle.update();
      
      final x = particle.x * size.width;
      final y = particle.y * size.height;
      
      paint.color = particleColor.withOpacity(particle.opacity * 0.6);
      canvas.drawCircle(
        Offset(x, y),
        particle.size * particleSize,
        paint,
      );
    }

    // Draw connections between nearby particles
    _drawConnections(canvas, size);
  }

  void _drawConnections(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = particleColor.withOpacity(0.1)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final p1 = particles[i];
        final p2 = particles[j];
        
        final dx = (p1.x - p2.x) * size.width;
        final dy = (p1.y - p2.y) * size.height;
        final distance = math.sqrt(dx * dx + dy * dy);
        
        if (distance < 100) {
          final opacity = (100 - distance) / 100 * 0.3;
          paint.color = particleColor.withOpacity(opacity);
          
          canvas.drawLine(
            Offset(p1.x * size.width, p1.y * size.height),
            Offset(p2.x * size.width, p2.y * size.height),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
