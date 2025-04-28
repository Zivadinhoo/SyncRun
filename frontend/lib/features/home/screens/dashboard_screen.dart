import 'package:flutter/material.dart';
import 'package:frontend/features/home/screens/home_content.dart';
import 'package:frontend/features/plans/screens/plans_screen.dart';
import 'package:frontend/features/settings/screens/settings_screen.dart';
import 'package:frontend/features/stats/screens/stats_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeContent(),
    StatsScreen(),
    PlansScreen(),
    SettingsScreen(),
  ];

  // Dummy podaci za sada (kasnije ćeš povezati sa backendom)
  final String userName = 'Uroš Živadinović';
  final String profileImageUrl = 'https://i.pravatar.cc/150?img=3';
  final String currentPlanName = 'Half Marathon 12 Weeks';
  final String nextTraining = 'Easy 8km Run';
  final double progressPercent = 0.55;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F1),
      body: _screens[_selectedIndex],
      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFE67E22),
        unselectedItemColor: Colors.black54,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Plans'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Stats'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
