class FeedbackEntry {
  final String opName;
  final String date;
  final String time;
  final String opid;
  final String player;
  final String role;
  final String key;
  final double fun;
  final double tech;
  final String comments;
  final double coord;
  final double pace;
  final double diff;

  FeedbackEntry({
    required this.opName,
    required this.date,
    required this.time,
    required this.opid,
    required this.player,
    required this.role,
    required this.key,
    required this.fun,
    required this.tech,
    required this.comments,
    this.coord = 3.0,
    this.pace = 3.0,
    this.diff = 3.0,
  });


  factory FeedbackEntry.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value, double defaultValue) {
      if (value == null) return defaultValue;
      if (value is num) return value.toDouble();
      if (value is String) {
        if (value.trim().isEmpty) return defaultValue;
        return double.tryParse(value) ?? defaultValue;
      }
      return defaultValue;
    }

    return FeedbackEntry(
      opName: json['OpName']?.toString() ?? json['Operation']?.toString() ?? '',
      date: json['Date']?.toString() ?? '',
      time: json['Time']?.toString() ?? '',
      opid: json['opid']?.toString() ?? json['OPID']?.toString() ?? '',
      player: json['player']?.toString() ?? json['Zeus']?.toString() ?? '',
      role: json['Role']?.toString() ?? (json['Zeus'] != null ? 'Zeus' : ''),
      key: json['Key']?.toString() ?? '',
      fun: parseDouble(json['Fun (1-5)'], 0.0),
      tech: parseDouble(json['Tech (1-5)'], 0.0),
      comments: json['Comments']?.toString() ?? '',
      coord: parseDouble(json['Coordination (1-5)'] ?? json['Coordination'] ?? json['Coord'], 3.0),
      pace: parseDouble(json['Pace (1-5)'] ?? json['Pace'], 3.0),
      diff: parseDouble(json['Difficulty (1-5)'] ?? json['Difficulty'] ?? json['Dificulty'] ?? json['Diff'], 3.0),
    );
  }
}

class MissionMetadata {
  final String opId;
  final String zeus;
  final String pl;

  MissionMetadata({
    required this.opId,
    required this.zeus,
    required this.pl,
  });

  factory MissionMetadata.fromJson(Map<String, dynamic> json) {
    return MissionMetadata(
      opId: json['OPID']?.toString() ?? '',
      zeus: json['concatenated_Zeus']?.toString() ?? '',
      pl: json['concatenated_PL']?.toString() ?? '',
    );
  }
}


class MissionSummary {
  final String opName;
  final String date;
  final double avgFun;
  final double avgTech;
  final double avgCoord;
  final double avgPace;
  final double avgDiff;
  final int totalFeedback;
  final List<String> comments;
  final String zeus;
  final String pl;

  MissionSummary({
    required this.opName,
    required this.date,
    required this.avgFun,
    required this.avgTech,
    required this.avgCoord,
    required this.avgPace,
    required this.avgDiff,
    required this.totalFeedback,
    required this.comments,
    required this.zeus,
    required this.pl,
  });

  double get overallScore {
    double normalize(double val) {
      // 3 becomes 5
      // 1 becomes 1 (5 - 2*|1-3| = 5 - 4 = 1)
      // 5 becomes 1 (5 - 2*|5-3| = 5 - 4 = 1)
      return 5.0 - (2.0 * (val - 3.0).abs());
    }

    return (avgFun + avgTech + avgCoord + normalize(avgPace) + normalize(avgDiff)) / 5.0;
  }
}

class LeaderboardEntry {
  final String name;
  final double avgScore;
  final int count;

  LeaderboardEntry({
    required this.name,
    required this.avgScore,
    required this.count,
  });
}

class DashboardData {
  final List<MissionSummary> missionSummaries;
  final List<LeaderboardEntry> topZeuses;
  final List<LeaderboardEntry> topLeaders;
  final List<MissionSummary> topOps;
  final List<MissionSummary> topCoordOps;

  DashboardData({
    required this.missionSummaries,
    required this.topZeuses,
    required this.topLeaders,
    required this.topOps,
    required this.topCoordOps,
  });
}
