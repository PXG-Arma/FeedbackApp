import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models.dart';
import 'intelligence_service.dart';
import 'dashboard.dart';
import 'theme.dart';

void main() {
  runApp(const PXGFeedbackApp());
}

class PXGFeedbackApp extends StatelessWidget {
  const PXGFeedbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PXG Intelligence',
      debugShowCheckedModeBanner: false,
      theme: PhoenixTheme.darkTheme,
      home: const DashboardLoader(),
    );
  }
}

class DashboardLoader extends StatefulWidget {
  const DashboardLoader({super.key});

  @override
  State<DashboardLoader> createState() => _DashboardLoaderState();
}

class _DashboardLoaderState extends State<DashboardLoader> {
  late Future<DashboardData> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = IntelligenceService.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DashboardData>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: PhoenixTheme.background,
            body: Center(
              child: CircularProgressIndicator(color: PhoenixTheme.primary),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        } else if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: Text('No data found.')));
        }

        return DashboardScreen(
          data: snapshot.data!,
          onRefresh: () {
            setState(() {
              _dataFuture = IntelligenceService.fetchData();
            });
          },
        );
      },
    );
  }
}
