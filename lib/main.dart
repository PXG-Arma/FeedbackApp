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
      home: const MainContainer(),
    );
  }
}

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  late Future<DashboardData> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = IntelligenceService.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.8, -0.8),
            radius: 1.2,
            colors: [
              Color(0x33FF6B00), // Subtle Phoenix Glow
              Color(0xFF030508),
            ],
          ),
        ),
        child: FutureBuilder<DashboardData>(
          future: _dataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: PhoenixTheme.primary),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data found.'));
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
        ),
      ),
    );
  }
}
