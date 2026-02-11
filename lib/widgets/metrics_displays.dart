import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class MissionMetrics extends StatelessWidget {
  final double fun;
  final double tech;
  final double coord;
  final double pace;
  final double diff;

  const MissionMetrics({
    super.key,
    required this.fun,
    required this.tech,
    required this.coord,
    required this.pace,
    required this.diff,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildLinearMeter('FUN', fun),
        const SizedBox(height: 16),
        _buildLinearMeter('TECH', tech),
        const SizedBox(height: 16),
        _buildLinearMeter('COORD', coord),
        const SizedBox(height: 16), // Replaces larger gap and divider
        _buildCenteredMeter('PACE', pace, 'SLOW', 'FAST'),
        const SizedBox(height: 16),
        _buildCenteredMeter('DIFF', diff, 'EASY', 'HARD'),
      ],
    );
  }

  Widget _buildBarBackground(List<Widget> zones) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(3),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Stack(children: zones),
      ),
    );
  }

  Widget _buildZone(double start, double end, Color color) {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(
                left: constraints.maxWidth * start,
              ),
              width: constraints.maxWidth * (end - start),
              color: color.withOpacity(0.15),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLinearMeter(String label, double value) {
    final t = (value / 5.0).clamp(0.0, 1.0);
    final color = Color.lerp(Colors.redAccent, Colors.greenAccent, Curves.easeIn.transform(t))!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: _labelStyle),
            Text(value.toStringAsFixed(1), style: _scoreStyle(color)),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            _buildBarBackground([
              _buildZone(0.0, 0.15, Colors.redAccent),  // Warning zone (tighter: 0-15)
              _buildZone(0.85, 1.0, Colors.greenAccent), // Optimal zone (tighter: 85-100)
            ]),
            AnimatedAlign(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutBack,
              alignment: Alignment((t * 2.0 - 1.0).clamp(-1.0, 1.0), 0),
              child: _Indicator(color: color),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCenteredMeter(String label, double value, String minLabel, String maxLabel) {
    final normalizedScore = 5.0 - (2.0 * (value - 3.0).abs());
    final distance = (value - 3.0).abs();
    final t = (distance / 2.0).clamp(0.0, 1.0);
    final color = Color.lerp(Colors.greenAccent, Colors.redAccent, Curves.easeIn.transform(t))!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: _labelStyle),
            Text(normalizedScore.toStringAsFixed(1), style: _scoreStyle(color)),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          alignment: Alignment.center,
          children: [
            _buildBarBackground([
              _buildZone(0.0, 0.15, Colors.redAccent),  // Way too slow/easy
              _buildZone(0.4, 0.6, Colors.greenAccent),  // Optimal zone (tighter: 40-60)
              _buildZone(0.85, 1.0, Colors.redAccent), // Way too fast/hard
            ]),
            AnimatedAlign(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutBack,
              alignment: Alignment(((value - 3.0) / 2.0).clamp(-1.0, 1.0), 0),
              child: _Indicator(color: color),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(minLabel, style: _subLabelStyle),
            Text('OPTIMAL', style: _subLabelStyle.copyWith(color: Colors.greenAccent.withOpacity(0.3))),
            Text(maxLabel, style: _subLabelStyle),
          ],
        ),
      ],
    );
  }

  TextStyle get _labelStyle => const TextStyle(
        color: PhoenixTheme.primary,
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      );

  TextStyle _scoreStyle(Color color) => GoogleFonts.orbitron(
        color: color,
        fontSize: 14,
        fontWeight: FontWeight.w900,
      );

  TextStyle get _subLabelStyle => const TextStyle(
        color: Colors.white24,
        fontSize: 8,
        fontWeight: FontWeight.bold,
      );
}

class _Indicator extends StatelessWidget {
  final Color color;
  const _Indicator({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.5), blurRadius: 6),
        ],
      ),
    );
  }
}
