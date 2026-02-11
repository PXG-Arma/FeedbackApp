import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'models.dart';
import 'data_processor.dart';

class IntelligenceService {
  // To be replaced by the actual n8n webhook URL
  static const String webhookUrl =
      'https://www.pxghub.com/webhook/feedbackinfo';
  static const String avatarWebhookUrl =
      'https://www.pxghub.com/webhook/get-avatar';

  static Future<DashboardData> fetchData() async {
    try {
      if (webhookUrl.contains('YOUR_N8N')) {
        return DataProcessor.process(getMockData(), getMockMetadata());
      }

      final response = await http.get(Uri.parse(webhookUrl));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        List<dynamic> feedbackList = [];
        List<dynamic> metadataList = [];

        if (decoded is Map<String, dynamic>) {
          feedbackList = decoded['feedback'] ?? [];
          metadataList = decoded['metadata'] ?? [];
        } else if (decoded is List) {
          for (var item in decoded) {
            if (item is Map<String, dynamic>) {
              if (item.containsKey('feedback')) {
                feedbackList.addAll(item['feedback'] as List);
              }
              if (item.containsKey('metadata')) {
                metadataList.addAll(item['metadata'] as List);
              } else {
                // If there's no 'metadata' key, the item itself might be a metadata object
                if (!item.containsKey('feedback') || item.keys.length > 1) {
                  metadataList.add(item);
                }
              }
            }
          }
        }

        final entries = feedbackList
            .map((j) => FeedbackEntry.fromJson(j))
            .toList();
        final metadata = metadataList
            .map((j) => MissionMetadata.fromJson(j))
            .toList();

        final dashboardData = DataProcessor.process(entries, metadata);

        // Map to cache avatar bytes to avoid redundant lookups
        final Map<String, Uint8List?> avatarCache = {};

        // Helper to fetch and cache avatars for MissionSummary
        Future<void> fetchAndAssignMission(
          MissionSummary mission,
          bool forZeus,
        ) async {
          final String? id = forZeus ? mission.zeusId : mission.plId;
          if (id != null && id.isNotEmpty && id != 'N/A') {
            if (avatarCache.containsKey(id)) {
              if (forZeus)
                mission.zeusAvatarBytes = avatarCache[id];
              else
                mission.plAvatarBytes = avatarCache[id];
            } else {
              try {
                final bytes = await fetchAvatar(id);
                avatarCache[id] = bytes;
                if (forZeus)
                  mission.zeusAvatarBytes = bytes;
                else
                  mission.plAvatarBytes = bytes;
              } catch (e) {
                print('Error fetching avatar for $id: $e');
              }
            }
          }
        }

        // Helper to fetch and cache avatars for LeaderboardEntry
        Future<void> fetchAndAssignLeader(LeaderboardEntry entry) async {
          final String? id = entry.userId;
          if (id != null && id.isNotEmpty && id != 'N/A') {
            if (avatarCache.containsKey(id)) {
              entry.avatarBytes = avatarCache[id];
            } else {
              try {
                final bytes = await fetchAvatar(id);
                avatarCache[id] = bytes;
                entry.avatarBytes = bytes;
              } catch (e) {
                print('Error fetching leaderboard avatar for $id: $e');
              }
            }
          }
        }

        // 1. Fetch for latest mission
        if (dashboardData.missionSummaries.isNotEmpty) {
          final latest = dashboardData.missionSummaries.first;
          await fetchAndAssignMission(latest, true);
          await fetchAndAssignMission(latest, false);
        }

        // 2. Fetch for Leaderboards (Top 5 each)
        for (var e in dashboardData.topZeuses.take(5)) {
          await fetchAndAssignLeader(e);
        }
        for (var e in dashboardData.topLeaders.take(5)) {
          await fetchAndAssignLeader(e);
        }

        return dashboardData;
      } else {
        throw Exception('Failed to load intelligence data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      return DataProcessor.process(getMockData(), getMockMetadata());
    }
  }

  static Future<Uint8List?> fetchAvatar(String id) async {
    try {
      final response = await http.post(
        Uri.parse(avatarWebhookUrl),
        body: json.encode({'id': id}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      print('Error calling avatar webhook for $id: $e');
    }
    return null;
  }

  static List<MissionMetadata> getMockMetadata() {
    return [
      MissionMetadata(opId: 'op123', zeus: 'Johanpe', pl: 'AquaFox'),
      MissionMetadata(opId: 'op122', zeus: 'ZeusAlpha', pl: 'LeaderBeta'),
    ];
  }

  static List<FeedbackEntry> getMockData() {
    return [
      FeedbackEntry(
        opName: 'Operation Shallow Price',
        date: '2025-01-22',
        time: '21:00',
        opid: 'op123',
        player: 'Johanpe',
        role: 'Zeus',
        key: 'k1',
        fun: 5,
        tech: 4,
        comments: 'Great mission, very immersive!',
        coord: 5,
        pace: 4,
        diff: 4,
      ),
      FeedbackEntry(
        opName: 'Operation Shallow Price',
        date: '2025-01-22',
        time: '21:05',
        opid: 'op123',
        player: 'AquaFox',
        role: 'Platoon Leader',
        key: 'k2',
        fun: 4,
        tech: 5,
        comments: 'Coordination was spot on.',
        coord: 5,
        pace: 5,
        diff: 5,
      ),
      FeedbackEntry(
        opName: 'Operation Shallow Price',
        date: '2025-01-22',
        time: '21:10',
        opid: 'op123',
        player: 'Trooper A',
        role: 'Rifleman',
        key: 'k3',
        fun: 5,
        tech: 5,
        comments: 'Exciting firefights.',
        coord: 4,
        pace: 4,
        diff: 3,
      ),
      FeedbackEntry(
        opName: 'Midnight Strike',
        date: '2025-01-15',
        time: '20:00',
        opid: 'op122',
        player: 'ZeusAlpha',
        role: 'Zeus',
        key: 'k4',
        fun: 4,
        tech: 3,
        comments: 'A bit slow at the start.',
        coord: 3,
        pace: 2,
        diff: 2,
      ),
      FeedbackEntry(
        opName: 'Midnight Strike',
        date: '2025-01-15',
        time: '20:10',
        opid: 'op122',
        player: 'LeaderBeta',
        role: 'Platoon Leader',
        key: 'k5',
        fun: 3,
        tech: 4,
        comments: 'Tech issues hampered the experience.',
        coord: 3,
        pace: 3,
        diff: 4,
      ),
    ];
  }
}
