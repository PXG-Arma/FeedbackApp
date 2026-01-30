import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme.dart';

class MeshBackground extends StatelessWidget {
  const MeshBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        // Finalized 3-color Flecktarn Palette
        const fleckGreen = Color(0xFF2D361E);  // Moss Green
        const fleckBrown = Color(0xFF4A3728);  // Earth Brown
        const fleckTan = Color(0xFF8B7355);    // Sandy Tan

        // Simplified pattern (20 patches total)
        final patches = [
          // Moss Green
          _PatchData(fleckGreen, const Offset(0.1, 0.1), 0.45, 0.6),
          _PatchData(fleckGreen, const Offset(0.5, 0.2), 0.4, 0.5),
          _PatchData(fleckGreen, const Offset(0.8, 0.7), 0.45, 0.6),
          _PatchData(fleckGreen, const Offset(0.2, 0.8), 0.4, 0.5),
          _PatchData(fleckGreen, const Offset(0.6, 0.45), 0.35, 0.6),
          _PatchData(fleckGreen, const Offset(0.9, 0.1), 0.3, 0.5),
          _PatchData(fleckGreen, const Offset(0.4, 0.9), 0.35, 0.5),
          
          // Earth Brown
          _PatchData(fleckBrown, const Offset(0.3, 0.2), 0.35, 0.6),
          _PatchData(fleckBrown, const Offset(0.7, 0.35), 0.3, 0.5),
          _PatchData(fleckBrown, const Offset(0.1, 0.6), 0.35, 0.6),
          _PatchData(fleckBrown, const Offset(0.85, 0.9), 0.3, 0.5),
          _PatchData(fleckBrown, const Offset(0.5, 0.7), 0.25, 0.6),
          _PatchData(fleckBrown, const Offset(0.4, 0.05), 0.3, 0.5),
          
          // Sandy Tan Highlights
          _PatchData(fleckTan, const Offset(0.15, 0.4), 0.15, 0.7),
          _PatchData(fleckTan, const Offset(0.65, 0.15), 0.18, 0.6),
          _PatchData(fleckTan, const Offset(0.8, 0.45), 0.15, 0.7),
          _PatchData(fleckTan, const Offset(0.35, 0.85), 0.2, 0.6),
          _PatchData(fleckTan, const Offset(0.95, 0.6), 0.15, 0.7),
          _PatchData(fleckTan, const Offset(0.05, 0.95), 0.12, 0.6),
          _PatchData(fleckTan, const Offset(0.55, 0.55), 0.15, 0.7),
        ];

        return Stack(
          children: [
            // Dark forest base
            Container(color: const Color(0xFF1B2014)),

            // Camouflage Patches
            ...patches.map((p) => _PositionedBlob(
              color: p.color.withOpacity(p.opacity),
              size: w * p.sizeFactor,
              baseOffset: p.offset,
              screenSize: Size(w, h),
            )),

            // High Diffusion Blur for a premium look
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Container(color: Colors.transparent),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PatchData {
  final Color color;
  final Offset offset;
  final double sizeFactor;
  final double opacity;

  const _PatchData(this.color, this.offset, this.sizeFactor, this.opacity);
}

class _PositionedBlob extends StatelessWidget {
  final Color color;
  final double size;
  final Offset baseOffset;
  final Size screenSize;

  const _PositionedBlob({
    required this.color,
    required this.size,
    required this.baseOffset,
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    final dx = (baseOffset.dx * screenSize.width) - (size / 2);
    final dy = (baseOffset.dy * screenSize.height) - (size / 2);

    return Positioned(
      left: dx,
      top: dy,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withOpacity(0)],
          ),
        ),
      ),
    );
  }
}
