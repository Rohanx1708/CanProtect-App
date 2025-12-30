import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final double topTintOpacity;
  final double bottomTintOpacity;
  final Alignment alignment;

  const AppBackground({
    super.key,
    required this.child,
    this.topTintOpacity = 0.3,
    this.bottomTintOpacity = 0.3,
    this.alignment = Alignment.center, // default
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_light.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
