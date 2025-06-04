import 'package:flutter/material.dart';
import 'athlete_dashboard_screen.dart';

class AthleteMainScreen extends StatefulWidget {
  const AthleteMainScreen({super.key});

  @override
  State<AthleteMainScreen> createState() =>
      _AthleteMainScreenState();
}

class _AthleteMainScreenState
    extends State<AthleteMainScreen> {
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
