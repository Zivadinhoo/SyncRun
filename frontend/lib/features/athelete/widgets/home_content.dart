import 'package:flutter/material.dart';
import 'package:frontend/models/athlete_home_data.dart';

class HomeContent extends StatelessWidget {
  final AthleteHomeData data;

  const HomeContent({Key? key, required this.data})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(data),
            const SizedBox(height: 32),
            _buildSectionTitle('Your Current Plan:'),
            _buildPlanName(data.currentPlanName),
            const SizedBox(height: 32),
            _buildSectionTitle('Next Training:'),
            _buildNextTraining(data.nextTraining),
            const SizedBox(height: 32),
            _buildSectionTitle('Progress:'),
            _buildProgress(data.progressPercent),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(AthleteHomeData data) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(
            data.profileImagePath,
          ),
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
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        color: Colors.black54,
      ),
    );
  }

  Widget _buildPlanName(String planName) {
    return Text(
      planName,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildNextTraining(String nextTraining) {
    return Text(
      nextTraining,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildProgress(double progressPercent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: progressPercent,
          minHeight: 10,
          backgroundColor: Colors.grey[300],
          color: const Color(0xFFE67E22),
        ),
        const SizedBox(height: 8),
        Text(
          '${(progressPercent * 100).toStringAsFixed(1)}% completed',
        ),
      ],
    );
  }
}
