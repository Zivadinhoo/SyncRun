import 'package:flutter/material.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy podaci za sada
    final String userName = 'Uroš ';
    final String profileImageUrl =
        'https://images.unsplash.com/photo-1571019613914-85f342c45f59?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80';
    final String currentPlanName = 'Half Marathon 12 Weeks';
    final String nextTraining = 'Easy 8km Run';
    final double progressPercent = 0.55;

    return SafeArea(
      // ✅ SafeArea da ne udara u notch
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profilna slika + Ime
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/urosTrci.jpeg'),
                  radius: 30,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Aktuelni plan
            const Text(
              'Your Current Plan:',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              currentPlanName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 32),

            // Sledeći trening
            const Text(
              'Next Training:',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              nextTraining,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 32),

            // Progress bar
            const Text(
              'Progress:',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progressPercent,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              color: const Color(0xFFE67E22),
            ),
            const SizedBox(height: 8),
            Text('${(progressPercent * 100).toStringAsFixed(1)}% completed'),
          ],
        ),
      ),
    );
  }
}
