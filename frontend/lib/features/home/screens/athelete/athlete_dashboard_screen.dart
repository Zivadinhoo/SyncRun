import 'package:flutter/material.dart';
import 'package:frontend/features/auth/screens/login.screen.dart';
import 'package:frontend/features/auth/services/auth_service.dart';
import 'package:frontend/features/home/screens/home_content.dart';
import 'package:frontend/features/home/services/athlete_home_service.dart';
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
  late Future<AthleteHomeData> _homeDataFuture;

  @override
  void initState() {
    super.initState();
    _homeDataFuture = AthleteHomeService().fetchHomeData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _screensWith(AthleteHomeData data) {
    return [
      HomeContent(data: data),
      const StatsScreen(),
      const PlansScreen(),
      const SettingsScreen(),
    ];
  }

  Future<void> _logout(BuildContext context) async {
    await AuthService().logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF6F1),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black87),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFFDF6F1),
      body: FutureBuilder<AthleteHomeData>(
        future: _homeDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final screens = _screensWith(snapshot.data!);
            return screens[_selectedIndex];
          } else {
            return const Center(child: Text('No data'));
          }
        },
      ),
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
