import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/athlete/providers/assigned_plans_provider.dart';
import 'athlete_dashboard_screen.dart';

class AthleteMainScreen extends ConsumerStatefulWidget {
  const AthleteMainScreen({super.key});

  @override
  ConsumerState<AthleteMainScreen> createState() =>
      _AthleteMainScreenState();
}

class _AthleteMainScreenState
    extends ConsumerState<AthleteMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const AthleteDashboardScreen(), // Home
    Center(child: Text("Activity Log")), // Placeholder
    Center(child: Text("Profile Settings")), // Placeholder
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      ref.invalidate(assignedPlansFutureProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('🏁 AthleteMainScreen loaded');
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
