import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;
import '../theme.dart';

class PerformanceRadar extends StatelessWidget {
  final double fun;
  final double tech;
  final double coord;
  final double pace;
  final double diff;

  const PerformanceRadar({
    super.key,
    required this.fun,
    required this.tech,
    required this.coord,
    required this.pace,
    required this.diff,
  });

  @override
  Widget build(BuildContext context) {
    // Normalization helper (same as models.dart)
    double normalize(double val) => 5.0 - (2.0 * (val - 3.0).abs());

    // Normalized values for PLOTTING
    final plotPace = normalize(pace);
    final plotDiff = normalize(diff);

    // Interpretation Helpers
    String getPaceDesc(double val) {
      if (val < 2.8) return '(Too Slow)';
      if (val > 3.2) return '(Too Fast)';
      return '(Perfect)';
    }

    String getDiffDesc(double val) {
       if (val < 2.8) return '(Too Easy)';
       if (val > 3.2) return '(Too Hard)';
       return '(Perfect)';
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate effective radius for the chart area
        // fl_chart leaves some padding for titles. We estimate the playing field is ~70% of the box.
        final double size = (constraints.maxWidth < constraints.maxHeight ? constraints.maxWidth : constraints.maxHeight);
        final double radius = (size / 2) * 0.7; // Estimated internal radius scaling factor
        final Offset center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);

        return Stack(
          children: [
            RadarChart(
              RadarChartData(
                radarShape: RadarShape.circle,
                radarTouchData: RadarTouchData(enabled: false),
                dataSets: [
                  // Min/Max Anchors
                  RadarDataSet(
                    fillColor: Colors.transparent,
                    borderColor: Colors.transparent,
                    entryRadius: 0,
                    dataEntries: List.generate(5, (i) => const RadarEntry(value: 0)),
                    borderWidth: 0,
                  ),
                  RadarDataSet(
                    fillColor: Colors.transparent,
                    borderColor: Colors.transparent,
                    entryRadius: 0,
                    dataEntries: List.generate(5, (i) => const RadarEntry(value: 5)),
                    borderWidth: 0,
                  ),


                  // Actual Data
                  RadarDataSet(
                    fillColor: PhoenixTheme.primary.withOpacity(0.3),
                    borderColor: PhoenixTheme.primary,
                    entryRadius: 3,
                    dataEntries: [
                      RadarEntry(value: fun),
                      RadarEntry(value: tech),
                      RadarEntry(value: coord),
                      RadarEntry(value: plotPace), // Use normalized
                      RadarEntry(value: plotDiff), // Use normalized
                    ],
                    borderWidth: 2,
                  ),
                ],
                radarBackgroundColor: Colors.black,
                borderData: FlBorderData(show: false),
                radarBorderData: const BorderSide(color: Colors.white24, width: 1),
                titlePositionPercentageOffset: 0.2, // Push text out a bit
                titleTextStyle: TextStyle(color: PhoenixTheme.textSecondary, fontSize: 10, fontWeight: FontWeight.bold),
                getTitle: (index, angle) {
                  switch (index) {
                    case 0: return const RadarChartTitle(text: 'FUN');
                    case 1: return const RadarChartTitle(text: 'TECH');
                    case 2: return const RadarChartTitle(text: 'COORD');
                    case 3: return RadarChartTitle(text: 'PACE\n${getPaceDesc(pace)}'); 
                    case 4: return RadarChartTitle(text: 'DIFF\n${getDiffDesc(diff)}'); 
                    default: return const RadarChartTitle(text: '');
                  }
                },
                tickCount: 5,
                ticksTextStyle: const TextStyle(color: Colors.transparent),
                gridBorderData: const BorderSide(color: Colors.white12, width: 1),
              ),
            ),
            
            // Overlays - Pass BOTH display value and plot value (normalized position)
            _buildValueBadge(fun, fun, -90, center, radius),   // Top
            _buildValueBadge(tech, tech, -18, center, radius),  // Top Right
            _buildValueBadge(coord, coord, 54, center, radius),  // Bottom Right
            // For Pace/Diff: Display NORMALIZED value (e.g. 5.0 instead of 3.0), and position at normalized '5.0' location
            _buildValueBadge(plotPace, plotPace, 126, center, radius), // Bottom Left
            _buildValueBadge(plotDiff, plotDiff, 198, center, radius), // Top Left
          ],
        );
      },
    );
  }

  Widget _buildValueBadge(double displayValue, double plotValue, double angleDeg, Offset center, double maxRadius) {
    if (displayValue == 0) return const SizedBox.shrink();

    final double angleRad = angleDeg * (math.pi / 180);
    // Use plotValue for positioning
    final double dist = (plotValue / 5.0) * maxRadius;
    
    final double x = center.dx + dist * math.cos(angleRad);
    final double y = center.dy + dist * math.sin(angleRad);

    return Positioned(
      left: x - 16, // Center badge (approx width 32)
      top: y - 10,  // Center badge height
      child: Transform.translate(
        offset: Offset(
             angleDeg == -90 ? 0 : (angleDeg < 90 && angleDeg > -90 ? 10 : -10),
             angleDeg == -90 ? -15 : (angleDeg > 90 ? 10 : -10)
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: PhoenixTheme.primary.withOpacity(0.5), width: 1),
          ),
          child: Text(
            displayValue.toStringAsFixed(1), // Show ACTUAL value
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
