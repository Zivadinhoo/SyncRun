import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy podaci za sada
    final double totalKilometers = 42.3;
    final int runsCompleted = 5;
    final int plannedRuns = 6;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF6F1),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Your Statistics',
          style: TextStyle(color: Colors.black87),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            const Text(
              'This Week:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${totalKilometers.toStringAsFixed(1)} km',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE67E22),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Total Distance',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$runsCompleted / $plannedRuns',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE67E22),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Runs Completed',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            Center(
              child: Text(
                '🏃‍♂️ Keep pushing towards your goals!',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
