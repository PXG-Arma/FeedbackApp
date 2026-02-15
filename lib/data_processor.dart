import 'models.dart';

class DataProcessor {
  static DashboardData process(
    List<FeedbackEntry> data,
    List<MissionMetadata> metadata,
  ) {
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

    // --- PASS 1: Mission Aggregation ---
    for (var entry in data) {
      final key = entry.opid;
      if (!missionMap.containsKey(key)) {
        missionMap[key] = {
          'totalFun': 0.0,
          'totalTech': 0.0,
          'totalCoord': 0.0,
          'totalPace': 0.0,
          'totalDiff': 0.0,
          'count': 0,
          'date': entry.date,
          'comments': <String>[],
          'opName': entry.opName,
          'opId': entry.opid,
        };
      }

      var m = missionMap[key]!;

      // Metadata Detection: If Fun & Tech are 0, it's a metadata row (or invalid feedback)
      // Do NOT add to averages
      bool isMetadata = (entry.fun == 0 && entry.tech == 0);

      if (!isMetadata) {
        m['totalFun'] += entry.fun;
        m['totalTech'] += entry.tech;
        m['totalCoord'] += entry.coord;
        m['totalPace'] += entry.pace;
        m['totalDiff'] += entry.diff;
        m['count'] += 1;

        if (entry.comments.trim().isNotEmpty) {
          m['comments'].add(entry.comments);
        }

        // Capture Role-based Candidates (Fallback logic)
        final role = entry.role.toLowerCase();
        if (role.contains('zeus')) {
          m['zeusCandidate'] = entry.player;
        } else if (role.contains('platoon') || role == 'pl') {
          m['plCandidate'] = entry.player;
        } else if (role.contains('squad lead') || role.contains('sl')) {
          // Track Squad Lead as a potential fallback for PL
          m['slCandidate'] = entry.player;
        }
      }
    }

    // Create Mission Summaries
    final missionSummaries = missionMap.entries.map((e) {
      final val = e.value;
      final opId = e.key;
      final rawOpName = val['opName'] as String;

      final count = val['count'] as int;
      final safeCount = count == 0 ? 1 : count;

      // Find metadata for this mission
      MissionMetadata? meta;
      try {
        meta = metadata.firstWhere((m) => m.opId == opId);
      } catch (_) {
        // No metadata found for this OPID
      }

      final opName = meta?.missionName ?? rawOpName;
      String zeusName = meta?.zeus ?? '';
      String plName = meta?.pl ?? '';

      // Fallback to candidates found in feedback if metadata is missing/empty
      if ((zeusName.isEmpty || zeusName == 'N/A') &&
          val.containsKey('zeusCandidate')) {
        zeusName = val['zeusCandidate'];
      }

      if (plName.isEmpty || plName == 'N/A') {
        if (val.containsKey('plCandidate')) {
          plName = val['plCandidate'];
        } else if (val.containsKey('slCandidate')) {
          plName = val['slCandidate'];
        }
      }

      if (zeusName.isEmpty) zeusName = 'N/A';
      if (plName.isEmpty) plName = 'N/A';

      return MissionSummary(
        opName: opName,
        date: val['date'],
        avgFun: val['totalFun'] / safeCount,
        avgTech: val['totalTech'] / safeCount,
        avgCoord: val['totalCoord'] / safeCount,
        avgPace: val['totalPace'] / safeCount,
        avgDiff: val['totalDiff'] / safeCount,
        totalFeedback: count,
        comments: List<String>.from(val['comments']),
        zeus: zeusName,
        pl: plName,
        zeusAvatar: meta?.zeusAvatar,
        plAvatar: meta?.plAvatar,
        zeusId: meta?.zeusId,
        plId: meta?.plId,
      );
    }).toList();

    // Sort: Latest date first
    missionSummaries.sort((a, b) => b.date.compareTo(a.date));


    // --- PASS 2: Leaderboard Construction ---
    final zeusMap = <String, Map<String, dynamic>>{};
    final leaderMap = <String, Map<String, dynamic>>{};

    for (var mission in missionSummaries) {
      // 1. Zeus Leaderboard
      if (mission.zeus != 'N/A') {
        if (!zeusMap.containsKey(mission.zeus)) {
          zeusMap[mission.zeus] = {
            'totalScore': 0.0,
            'count': 0,
            'avatar': mission.zeusAvatar,
            'id': mission.zeusId,
          };
        }
        if (mission.totalFeedback > 0) {
          zeusMap[mission.zeus]!['totalScore'] += mission.overallScore;
          zeusMap[mission.zeus]!['count'] += 1;
          if (mission.zeusAvatar != null) {
            zeusMap[mission.zeus]!['avatar'] = mission.zeusAvatar;
          }
          if (mission.zeusId != null) {
            zeusMap[mission.zeus]!['id'] = mission.zeusId;
          }
        }
      }

      // 2. PL Leaderboard
      if (mission.pl != 'N/A') {
        if (!leaderMap.containsKey(mission.pl)) {
          leaderMap[mission.pl] = {
            'totalScore': 0.0,
            'count': 0,
            'avatar': mission.plAvatar,
            'id': mission.plId,
          };
        }
        if (mission.totalFeedback > 0) {
          leaderMap[mission.pl]!['totalScore'] += mission.avgCoord;
          leaderMap[mission.pl]!['count'] += 1;
          if (mission.plAvatar != null) {
            leaderMap[mission.pl]!['avatar'] = mission.plAvatar;
          }
          if (mission.plId != null) {
            leaderMap[mission.pl]!['id'] = mission.plId;
          }
        }
      }
    }

    final topZeuses = zeusMap.entries.map((e) {
      final val = e.value;
      return LeaderboardEntry(
        name: e.key,
        avgScore: val['totalScore'] / val['count'],
        count: val['count'],
        avatarUrl: val['avatar'],
        userId: val['id'],
      );
    }).toList()..sort((a, b) => b.avgScore.compareTo(a.avgScore));

    final topLeaders = leaderMap.entries.map((e) {
      final val = e.value;
      return LeaderboardEntry(
        name: e.key,
        avgScore: val['totalScore'] / val['count'],
        count: val['count'],
        avatarUrl: val['avatar'],
        userId: val['id'],
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
