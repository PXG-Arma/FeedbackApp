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
          // We will fill these later from metadata if available
          'opId': entry.opid, // Capture OpID from feedback if possible to link
        };
      }

      var m = missionMap[entry.opName]!;

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
      final opName = e.key;
      final opId = val['opId'] as String;

      final count = val['count'] as int;
      final safeCount = count == 0 ? 1 : count;

      // Find metadata for this mission
      // Try linking by OpID first, fallback to Name could be tricky if names vary slightly
      // But assuming OpID is consistent in both lists.
      MissionMetadata? meta;
      try {
        meta = metadata.firstWhere((m) => m.opId == opId);
      } catch (_) {
        // Fallback: try by OpName? Or just leave N/A
      }

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

    // Debug: Print the avatar URLs for the latest mission
    if (missionSummaries.isNotEmpty) {
      final latest = missionSummaries.first;
      print('--- DEBUG AVATARS (AFTER SORT) ---');
      print('Mission: ${latest.opName} (${latest.date})');
      print('Zeus: ${latest.zeus} | Avatar: ${latest.zeusAvatar}');
      print('PL: ${latest.pl} | Avatar: ${latest.plAvatar}');
      print('----------------------');
    }

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
            'bytes': mission.zeusAvatarBytes,
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
          if (mission.zeusAvatarBytes != null) {
            zeusMap[mission.zeus]!['bytes'] = mission.zeusAvatarBytes;
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
            'bytes': mission.plAvatarBytes,
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
          if (mission.plAvatarBytes != null) {
            leaderMap[mission.pl]!['bytes'] = mission.plAvatarBytes;
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
        avatarBytes: val['bytes'],
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
        avatarBytes: val['bytes'],
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
