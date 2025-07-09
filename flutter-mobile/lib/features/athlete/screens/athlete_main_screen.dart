// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:frontend/features/athlete/providers/assigned_plans_provider.dart';
// import 'package:frontend/features/athlete/providers/active_plan_provider.dart';
// import 'package:frontend/features/athlete/providers/training_days_provider.dart';
// import 'package:frontend/features/common/screens/settings_screen.dart';
// import 'package:frontend/features/athlete/screens/athlete_dashboard_screen.dart';
// import 'package:frontend/features/athlete/services/noftication_service.dart';

// class AthleteMainScreen extends ConsumerStatefulWidget {
//   const AthleteMainScreen({super.key});

//   @override
//   ConsumerState<AthleteMainScreen> createState() =>
//       _AthleteMainScreenState();
// }

// class _AthleteMainScreenState
//     extends ConsumerState<AthleteMainScreen> {
//   int _selectedIndex = 0;

//   final List<Widget> _screens = [
//     const AthleteDashboardScreen(), // Home
//     Center(child: Text("Activity Log")), // Placeholder
//     Center(child: Text("Profile Settings")), // Placeholder
//     const SettingsScreen(),
//   ];

//   void _onTabTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     if (index == 0) {
//       ref.invalidate(assignedPlansFutureProvider);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     Future.microtask(() async {
//       final planId = ref
//           .read(activePlanIdProvider)
//           .maybeWhen(data: (id) => id, orElse: () => null);

//       if (planId == null) return;

//       try {
//         final trainingDays = await ref.read(
//           trainingDaysProviderFamily(planId).future,
//         );

//         if (trainingDays.isNotEmpty) {
//           await NotificationService.scheduleReminderIfTrainingToday(
//             trainingDays,
//           );
//         }
//       } catch (e) {
//         print('❌ Error scheduling notification: $e');
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     print('🏁 AthleteMainScreen loaded');
//     return Scaffold(
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: _screens,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onTabTapped,
//         selectedItemColor: Colors.orange,
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.directions_run),
//             label: 'Activity',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: 'Settings',
//           ),
//         ],
//       ),
//     );
//   }
// }
