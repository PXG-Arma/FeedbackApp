import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models.dart';
import '../theme.dart';
import 'widgets/radar_chart.dart';
import 'widgets/glass_card.dart';

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
            IconButton(icon: const Icon(Icons.refresh, color: PhoenixTheme.primary), onPressed: onRefresh),
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

    return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 1. Top Header (Logo + Title LEFT, Refresh RIGHT)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Branding
                  Row(
                    children: [
                      Transform.rotate(
                        angle: 0.0001, // Micro-rotation to force anti-aliasing
                        child: Image.asset(
                          'assets/logo.png',
                          height: 96,
                          cacheHeight: 96,
                          filterQuality: FilterQuality.medium,
                          isAntiAlias: true,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text('PXG INTELLIGENCE', style: TextStyle(color: Colors.white, fontSize: 12, letterSpacing: 4, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  
                  // Actions
                  IconButton(
                    icon: const Icon(Icons.refresh, color: PhoenixTheme.primary), // Using Primary Orange color
                    onPressed: onRefresh,
                    tooltip: 'Refresh Intelligence',
                  ),
                ],
              ),
              
              const SizedBox(height: 16),

              // 2. Hero Section: Horizontal Layout (OpName - Personnel - Rating)
              Expanded(
                flex: 3, // Slightly reduced flex to give console more room if needed
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // A. Operation Name (Left)
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.only(right: 24),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                latest.opName.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 80,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  height: 0.9,
                                  letterSpacing: -2.0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(FontAwesomeIcons.calendar, color: PhoenixTheme.textSecondary, size: 12),
                                const SizedBox(width: 8),
                                Text(latest.date, style: const TextStyle(color: PhoenixTheme.textSecondary, fontSize: 14, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 24),
                                const Icon(FontAwesomeIcons.users, color: PhoenixTheme.textSecondary, size: 12),
                                const SizedBox(width: 8),
                                Text('${latest.totalFeedback} RESPONSES', style: const TextStyle(color: PhoenixTheme.textSecondary, fontSize: 14, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ).animate().fadeIn().slideX(begin: -0.05),
                    ),
                    
                    // B. Personnel (Center)
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Expanded(child: _buildPersonnelCard('ZEUS', latest.zeus, FontAwesomeIcons.bolt, PhoenixTheme.primary)),
                          const SizedBox(height: 12),
                          Expanded(child: _buildPersonnelCard('PLATOON LEADER', latest.pl, FontAwesomeIcons.rankingStar, PhoenixTheme.secondary)),
                        ],
                      ).animate().fadeIn(delay: 100.ms),
                    ),
                    
                    const SizedBox(width: 24),

                    // C. Rating (Right)
                    Expanded(
                      flex: 2,
                      child: GlassCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                latest.overallScore.toStringAsFixed(1),
                                style: const TextStyle(fontSize: 96, fontWeight: FontWeight.w900, color: Colors.white, height: 1),
                              ),
                            ),
                            const Text('MISSION RATING', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: PhoenixTheme.primary, letterSpacing: 2)),
                          ],
                        ),
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
                    // Radar Chart
                    Expanded(
                      flex: 3,
                      child: GlassCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             const Text('PERFORMANCE METRICS', style: TextStyle(color: PhoenixTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                             Expanded(
                               child: PerformanceRadar(
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
                            const Text('TROOP TRANSMISSIONS', style: TextStyle(color: PhoenixTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                            const SizedBox(height: 16),
                            Expanded(
                              child: ListView.separated(
                                itemCount: latest.comments.length,
                                separatorBuilder: (context, i) => const SizedBox(height: 12),
                                itemBuilder: (context, i) => _buildCommentItem(latest.comments[i]),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.05),
                    ),
                    const SizedBox(width: 24),

                    // History Column (Split vertically)
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          // Top Zeuses
                          Expanded(
                            child: GlassCard(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('TOP ZEUS (OVERALL)', style: TextStyle(color: PhoenixTheme.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                                  const SizedBox(height: 12),
                                  Expanded(
                                    child: ListView.separated(
                                      itemCount: data.topZeuses.take(3).length,
                                      separatorBuilder: (context, i) => const Divider(color: Colors.white10, height: 8),
                                      itemBuilder: (context, i) => _buildLeaderboardItem(data.topZeuses[i], i + 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Top PLs
                          Expanded(
                            child: GlassCard(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('TOP PLs (COORD)', style: TextStyle(color: PhoenixTheme.accent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                                  const SizedBox(height: 12),
                                  Expanded(
                                    child: ListView.separated(
                                      itemCount: data.topLeaders.take(3).length,
                                      separatorBuilder: (context, i) => const Divider(color: Colors.white10, height: 8),
                                      itemBuilder: (context, i) => _buildLeaderboardItem(data.topLeaders[i], i + 1, isPl: true),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.05),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
  }


  Widget _buildPersonnelCard(String title, String name, IconData icon, Color color) {
    return GlassCard(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(name.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Text(
        '"$comment"',
        style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4, fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget _buildLeaderboardItem(LeaderboardEntry entry, int rank, {bool isPl = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text('#$rank', style: const TextStyle(color: PhoenixTheme.textSecondary, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis),
                Text('${entry.count} MISSIONS', 
                  style: const TextStyle(color: PhoenixTheme.textSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Text(
            entry.avgScore.toStringAsFixed(1), 
            style: TextStyle(
              color: isPl ? PhoenixTheme.accent : PhoenixTheme.primary, 
              fontWeight: FontWeight.w900, 
              fontSize: 18
            ),
          ),
        ],
      ),
    );
  }
}
