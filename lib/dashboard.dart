import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models.dart';
import '../theme.dart';
import 'widgets/pxg_divider.dart';
import 'widgets/metrics_displays.dart';
import 'widgets/glass_card.dart';
import 'widgets/mesh_background.dart';
import 'widgets/pxg_avatar.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardData data;
  final VoidCallback onRefresh;
  final bool enableAnimations;

  const DashboardScreen({
    super.key,
    required this.data,
    required this.onRefresh,
    this.enableAnimations = true,
  });

  @override
  Widget build(BuildContext context) {
    if (data.missionSummaries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No intelligence collected.'),
            const SizedBox(height: 16),
            IconButton(
              icon: const Icon(Icons.refresh, color: PhoenixTheme.primary),
              onPressed: onRefresh,
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return _buildDashboard(context, constraints);
      },
    );
  }

  Widget _buildDashboard(BuildContext context, BoxConstraints constraints) {
    final latest = data.missionSummaries.first;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            padding: const EdgeInsets.symmetric(
              horizontal: 48.0,
              vertical: 32.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Hero Section: Horizontal Layout (Logo + OpName - Personnel - Rating)
                Expanded(
                  flex: 2,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // A. Logo + Operation Name (Left)
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding: const EdgeInsets.only(right: 24),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Transform.rotate(
                                angle: 0.0001,
                                child: Image.asset(
                                  'assets/logo.png',
                                  height: 120,
                                  cacheHeight: 120,
                                  filterQuality: FilterQuality.medium,
                                  isAntiAlias: true,
                                ),
                              ),
                              const SizedBox(width: 32),
                               Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'OPERATION',
                                            style: GoogleFonts.orbitron(
                                              fontSize: 32,
                                              fontWeight: FontWeight.w900,
                                              color: PhoenixTheme.primary,
                                              letterSpacing: 4,
                                            ),
                                          ),
                                          Text(
                                            latest.opName
                                                .toUpperCase()
                                                .replaceFirst('OPERATION ', '')
                                                .trim(),
                                            style: GoogleFonts.orbitron(
                                              fontSize: 64,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                              height: 0.9,
                                              letterSpacing: -1.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        const Icon(
                                          FontAwesomeIcons.calendar,
                                          color: PhoenixTheme.textSecondary,
                                          size: 12,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          latest.date,
                                          style: const TextStyle(
                                            color: PhoenixTheme.textSecondary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 24),
                                        const Icon(
                                          FontAwesomeIcons.users,
                                          color: PhoenixTheme.textSecondary,
                                          size: 12,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${latest.totalFeedback} RESPONSES',
                                          style: const TextStyle(
                                            color: PhoenixTheme.textSecondary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn().slideX(begin: -0.05),

                      const PXGVerticalDivider(height: 100),

                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              _buildPersonnelCard(
                              'ZEUS',
                              latest.zeus,
                              id: latest.zeusId,
                              icon: FontAwesomeIcons.bolt,
                              color: PhoenixTheme.primary,
                            ),
                            const SizedBox(height: 12),
                            _buildPersonnelCard(
                              'PLATOON LEADER',
                              latest.pl,
                              id: latest.plId,
                              icon: FontAwesomeIcons.shieldHalved,
                              color: PhoenixTheme.secondary,
                            ),
                          ],
                        ).animate().fadeIn(delay: 100.ms),
                      ),

                      const PXGVerticalDivider(height: 100),

                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                latest.overallScore.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 108,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  height: 1,
                                ),
                              ),
                            ),
                            const Text(
                              'MISSION RATING',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: PhoenixTheme.primary,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.05),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 3. Console Section (Remains mostly same)
                Expanded(
                  flex: 6,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Metrics
                      Expanded(
                        flex: 3,
                        child: GlassCard(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'PERFORMANCE METRICS',
                                style: TextStyle(
                                  color: PhoenixTheme.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: MissionMetrics(
                                  fun: latest.avgFun,
                                  tech: latest.avgTech,
                                  coord: latest.avgCoord,
                                  pace: latest.avgPace,
                                  diff: latest.avgDiff,
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.05),
                      ),
                      const SizedBox(width: 24),

                      // Troop Comms
                      Expanded(
                        flex: 4,
                        child: GlassCard(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'TROOP TRANSMISSIONS',
                                style: TextStyle(
                                  color: PhoenixTheme.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: ListView.separated(
                                  itemCount: latest.comments.length,
                                  separatorBuilder: (context, i) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, i) =>
                                      _buildCommentItem(latest.comments[i]),
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.05),
                      ),
                      const SizedBox(width: 24),

                      // Leaderboard Component
                      Expanded(
                        flex: 3,
                        child: GlassCard(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'LEADERBOARD',
                                style: TextStyle(
                                  color: PhoenixTheme.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'TOP ZEUS',
                                      style: TextStyle(
                                        color: PhoenixTheme.primary,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    ...data.topZeuses
                                        .take(5)
                                        .map(
                                          (e) => _buildLeaderboardItem(
                                            e.name,
                                            e.avgScore,
                                            data.topZeuses.indexOf(e) + 1,
                                            subtitle: '${e.count} MISSIONS',
                                            userId: e.userId,
                                          ),
                                        ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'TOP PLs',
                                      style: TextStyle(
                                        color: PhoenixTheme.primary,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    ...data.topLeaders
                                        .take(5)
                                        .map(
                                          (e) => _buildLeaderboardItem(
                                            e.name,
                                            e.avgScore,
                                            data.topLeaders.indexOf(e) + 1,
                                            subtitle: '${e.count} MISSIONS',
                                            userId: e.userId,
                                          ),
                                        ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'TOP OPERATIONS',
                                      style: TextStyle(
                                        color: PhoenixTheme.primary,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    ...data.topOps.take(5).map(
                                      (e) => _buildLeaderboardItem(
                                        e.opName,
                                        e.overallScore,
                                        data.topOps.indexOf(e) + 1,
                                        subtitle: 'By ${e.zeus}',
                                        showAvatar: false,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonnelCard(
    String title,
    String name, {
    String? id,
    IconData? icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
      child: Row(
        children: [
          PXGAvatar(
            id: id,
            icon: icon,
            size: 60,
            color: color,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(String comment) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Text(
        '"$comment"',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          height: 1.4,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildLeaderboardItem(String name, double score, int rank,
      {required String subtitle, String? userId, bool showAvatar = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '#$rank',
              style: const TextStyle(
                color: PhoenixTheme.textSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
          if (showAvatar) ...[
            const SizedBox(width: 8),
            PXGAvatar(
              id: userId,
              icon: FontAwesomeIcons.solidUser,
              size: 24,
              color: PhoenixTheme.primary,
            ),
            const SizedBox(width: 16),
          ] else
            const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle.toUpperCase(),
                  style: const TextStyle(
                    color: PhoenixTheme.textSecondary,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Text(
            score.toStringAsFixed(1),
            style: const TextStyle(
              color: PhoenixTheme.primary,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
