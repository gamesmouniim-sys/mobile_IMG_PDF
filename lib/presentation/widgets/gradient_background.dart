import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final gradient = Theme.of(context).extension<GradientPalette>()!.primary;
    return Container(
      decoration: BoxDecoration(gradient: gradient),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
        ),
        child: SafeArea(child: child),
      ),
    );
  }
}
