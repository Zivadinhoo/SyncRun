import 'package:flutter/material.dart';
import 'package:frontend/features/home/screens/home_content.dart';
import 'package:frontend/features/plans/screens/plans_screen.dart';
import 'package:frontend/features/settings/screens/settings_screen.dart';
import 'package:frontend/features/stats/screens/stats_screen.dart';
import 'package:frontend/models/athlete_home_data.dart';

class AthleteDashboardScreen extends StatefulWidget {
  const AthleteDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AthleteDashboardScreen> createState() => _AthleteDashboardScreenState();
}

class _AthleteDashboardScreenState extends State<AthleteDashboardScreen> {
  int _selectedIndex = 0;

  final homeData = AthleteHomeData(
    userName: 'Uros',
    profileImagePath: 'assets/images/urosTrci.jpeg',
    currentPlanName: 'Marathon 4 weeks',
    nextTraining: 'Long run 20km',
    progressPercent: 0.40,
  );

  late final List<Widget> _screens = [
    HomeContent(data: homeData),
    const StatsScreen(),
    const PlansScreen(),
    const SettingsScreen(),
  ];

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
