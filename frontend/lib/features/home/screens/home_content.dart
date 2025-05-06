import 'package:flutter/material.dart';
import 'package:frontend/models/athlete_home_data.dart';

class HomeContent extends StatelessWidget {
  final AthleteHomeData data;

  const HomeContent({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profilna slika + Ime
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(data.profileImagePath),
                  radius: 30,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    data.userName,
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

            const Text(
              'Your Current Plan:',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              data.currentPlanName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'Next Training:',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              data.nextTraining,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'Progress:',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: data.progressPercent,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              color: const Color(0xFFE67E22),
            ),
            const SizedBox(height: 8),
            Text(
              '${(data.progressPercent * 100).toStringAsFixed(1)}% completed',
            ),
          ],
        ),
      ),
    );
  }
}
