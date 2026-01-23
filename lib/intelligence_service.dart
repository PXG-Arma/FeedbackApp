import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';
import 'data_processor.dart';

class IntelligenceService {
  // To be replaced by the actual n8n webhook URL
  static const String webhookUrl = 'https://www.pxghub.com/webhook/feedbackinfo';

  static Future<DashboardData> fetchData() async {
    try {
      // Check if we have data in the URL (like the React app did)
      // This is useful for passing data directly from n8n to the web app
      // via URL parameters if we don't want to make an extra HTTP call.
      
      // For now, let's implement the HTTP fetch as requested for n8n.
      // If the URL is empty or invalid, we fallback to mock data for demonstration.
      
      if (webhookUrl.contains('YOUR_N8N')) {
        return DataProcessor.process(getMockData());
      }

      final response = await http.get(Uri.parse(webhookUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final entries = jsonList.map((j) => FeedbackEntry.fromJson(j)).toList();
        return DataProcessor.process(entries);
      } else {
        throw Exception('Failed to load intelligence data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      return DataProcessor.process(getMockData());
    }
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
