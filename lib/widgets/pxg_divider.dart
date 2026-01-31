import 'package:flutter/material.dart';

class PXGVerticalDivider extends StatelessWidget {
  final double height;
  final double opacity;

  const PXGVerticalDivider({super.key, this.height = 60, this.opacity = 0.15});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0),
            Colors.white.withOpacity(opacity),
            Colors.white.withOpacity(0),
          ],
        ),
      ),
    );
  }
}
