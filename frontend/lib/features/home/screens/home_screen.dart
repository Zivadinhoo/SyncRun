// import 'package:flutter/material.dart';
// import 'package:frontend/features/auth/screens/login.screen.dart';
// import 'package:frontend/features/auth/services/auth_service.dart';
// import 'package:frontend/features/home/screens/dashboard_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   String? fullName;
//   final AuthService _authService = AuthService();
//   bool showWelcome = true;

//   @override
//   void initState() {
//     super.initState();
//     loadCurrentUser();
//   }

//   Future<void> loadCurrentUser() async {
//     try {
//       final name = await _authService.getCurrentUser();
//       setState(() {
//         fullName = name;
//       });

//       // Posle što učitamo korisnika, sačekamo 2 sekunde pa sakrijemo welcome
//       Future.delayed(const Duration(seconds: 1), () {
//         if (mounted) {
//           setState(() {
//             showWelcome = false;
//           });

//           // Onda nakon 300ms fade-out, prebacimo na Dashboard
//           Future.delayed(const Duration(milliseconds: 300), () {
//             if (mounted) {
//               Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(builder: (_) => const DashboardScreen()),
//               );
//             }
//           });
//         }
//       });
//     } catch (e) {
//       print('🔥 Error loading user: $e');
//       setState(() {
//         fullName = 'Guest';
//       });
//     }
//   }

//   void _logout(BuildContext context) async {
//     await _authService.logout();
//     Navigator.of(context).pushAndRemoveUntil(
//       MaterialPageRoute(builder: (context) => const LoginScreen()),
//       (route) => false,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: ElevatedButton.icon(
//               icon: const Icon(Icons.logout),
//               label: const Text('Logout'),
//               onPressed: () => _logout(context),
//             ),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
//         child:
//             fullName == null
//                 ? const Center(child: CircularProgressIndicator())
//                 : Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     AnimatedOpacity(
//                       opacity: showWelcome ? 1.0 : 0.0,
//                       duration: const Duration(
//                         milliseconds: 300,
//                       ), // Brži fade-in
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(
//                                 Icons.waving_hand_rounded, // Ikonica pozdrava
//                                 size: 32,
//                                 color: Color(0xFFE67E22), // Narandžasta boja
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 'Welcome back,',
//                                 style: TextStyle(
//                                   fontSize: 22,
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 fullName!,
//                                 style: const TextStyle(
//                                   fontSize: 34,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.orange,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 12),
//                         ],
//                       ),
//                     ),
//                     // 👇 Kasnije ubaciti sadržaj dashboard-a
//                     if (!showWelcome)
//                       Expanded(
//                         child: Center(
//                           child: Text(
//                             '🏃‍♂️ Dashboard',
//                             style: TextStyle(
//                               fontSize: 20,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//       ),
//     );
//   }
// }
