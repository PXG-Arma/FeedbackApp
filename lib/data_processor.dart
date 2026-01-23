import 'models.dart';

class DataProcessor {
  static DashboardData process(List<FeedbackEntry> data) {
    if (data.isEmpty) {
      return DashboardData(
        missionSummaries: [],
        topZeuses: [],
        topLeaders: [],
        topOps: [],
        topCoordOps: [],
      );
    }

    final missionMap = <String, Map<String, dynamic>>{};
    final zeusMap = <String, Map<String, dynamic>>{};
    final leaderMap = <String, Map<String, dynamic>>{};

    for (var entry in data) {
      // Mission Summary logic
      if (!missionMap.containsKey(entry.opName)) {
        missionMap[entry.opName] = {
          'totalFun': 0.0,
          'totalTech': 0.0,
          'totalCoord': 0.0,
          'totalPace': 0.0,
          'totalDiff': 0.0,
          'count': 0,
          'date': entry.date,
          'comments': <String>[],
          'zeusNames': <String>{},
          'plNames': <String>{},
        };
      }
      
      var m = missionMap[entry.opName]!;
      m['totalFun'] += entry.fun;
      m['totalTech'] += entry.tech;
      m['totalCoord'] += entry.coord;
      m['totalPace'] += entry.pace;
      m['totalDiff'] += entry.diff;
      m['count'] += 1;
      
      if (entry.comments.trim().isNotEmpty) {
        m['comments'].add(entry.comments);
      }

      String roleLower = entry.role.toLowerCase();
      if (roleLower.contains('zeus')) {
        m['zeusNames'].add(entry.player);
      }
      if (roleLower.contains('platoon lead')) {
        m['plNames'].add(entry.player);
      }

      // Global Leaderboards
      double avgEntryScore = (entry.fun + entry.tech) / 2;

      if (roleLower.contains('zeus')) {
        if (!zeusMap.containsKey(entry.player)) {
          zeusMap[entry.player] = {'totalScore': 0.0, 'count': 0};
        }
        zeusMap[entry.player]!['totalScore'] += avgEntryScore;
        zeusMap[entry.player]!['count'] += 1;
      }

      if (roleLower.contains('platoon lead')) {
        if (!leaderMap.containsKey(entry.player)) {
          leaderMap[entry.player] = {'totalScore': 0.0, 'count': 0};
        }
        // User requested PL ranking based on Coordination
        leaderMap[entry.player]!['totalScore'] += entry.coord;
        leaderMap[entry.player]!['count'] += 1;
      }
    }

    final missionSummaries = missionMap.entries.map((e) {
      final val = e.value;
      final count = val['count'] as int;
      return MissionSummary(
        opName: e.key,
        date: val['date'],
        avgFun: val['totalFun'] / count,
        avgTech: val['totalTech'] / count,
        avgCoord: val['totalCoord'] / count,
        avgPace: val['totalPace'] / count,
        avgDiff: val['totalDiff'] / count,
        totalFeedback: count,
        comments: List<String>.from(val['comments']),
        zeus: (val['zeusNames'] as Set<String>).join(', ').isEmpty ? 'N/A' : (val['zeusNames'] as Set<String>).join(', '),
        pl: (val['plNames'] as Set<String>).join(', ').isEmpty ? 'N/A' : (val['plNames'] as Set<String>).join(', '),
      );
    }).toList();

    // Sort missions by date descending (latest first)
    // Assuming date format allows alphabetical sort or we should parse it
    // For now assuming the input order is somewhat relevant or we just take the first one after processing
    // Let's sort by opid if available or just leave as is since we want the "latest"
    
    final topZeuses = zeusMap.entries.map((e) {
      final val = e.value;
      return LeaderboardEntry(
        name: e.key,
        avgScore: val['totalScore'] / val['count'],
        count: val['count'],
      );
    }).toList()..sort((a, b) => b.avgScore.compareTo(a.avgScore));

    final topLeaders = leaderMap.entries.map((e) {
      final val = e.value;
      return LeaderboardEntry(
        name: e.key,
        avgScore: val['totalScore'] / val['count'],
        count: val['count'],
      );
    }).toList()..sort((a, b) => b.avgScore.compareTo(a.avgScore));

    final topOps = List<MissionSummary>.from(missionSummaries)
      ..sort((a, b) => b.overallScore.compareTo(a.overallScore))
      ..take(5);

    final topCoordOps = List<MissionSummary>.from(missionSummaries)
      ..sort((a, b) => b.avgCoord.compareTo(a.avgCoord))
      ..take(5);

    return DashboardData(
      missionSummaries: missionSummaries,
      topZeuses: topZeuses,
      topLeaders: topLeaders,
      topOps: topOps.take(5).toList(),
      topCoordOps: topCoordOps.take(5).toList(),
    );
  }
}
