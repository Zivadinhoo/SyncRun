import 'package:flutter/material.dart';

class PlansScreen extends StatelessWidget {
  const PlansScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy podaci (kasnije ćeš ih učitavati sa backenda)
    final List<Map<String, dynamic>> trainingDays = [
      {'day': 'Monday', 'training': 'Easy Run 8km', 'status': 'done'},
      {'day': 'Tuesday', 'training': 'Rest', 'status': 'rest'},
      {'day': 'Wednesday', 'training': 'Tempo Run 6km', 'status': 'upcoming'},
      {'day': 'Thursday', 'training': 'Easy Run 6km', 'status': 'upcoming'},
      {'day': 'Friday', 'training': 'Rest', 'status': 'rest'},
      {'day': 'Saturday', 'training': 'Long Run 15km', 'status': 'upcoming'},
      {'day': 'Sunday', 'training': 'Recovery 5km', 'status': 'upcoming'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F1),
      appBar: AppBar(
        title: const Text('My Training Plan'),
        backgroundColor: const Color(0xFFE67E22),
      ),
      body: ListView.separated(
        itemCount: trainingDays.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final day = trainingDays[index];
          return ListTile(
            leading: Text(
              day['day'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            title: Text(day['training'], style: const TextStyle(fontSize: 16)),
            trailing: _buildStatusIcon(day['status']),
          );
        },
      ),
    );
  }

  // Helper funkcija za prikaz ikonica statusa
  Widget _buildStatusIcon(String status) {
    switch (status) {
      case 'done':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'rest':
        return const Icon(Icons.hotel, color: Colors.blueGrey);
      case 'upcoming':
        return const Icon(Icons.access_time, color: Colors.orange);
      default:
        return const Icon(Icons.help_outline, color: Colors.grey);
    }
  }
}
