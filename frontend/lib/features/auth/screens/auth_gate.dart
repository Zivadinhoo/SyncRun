// import 'package:flutter/material.dart';
// import 'package:frontend/features/home/screens/home_screen.dart';
// import 'package:frontend/features/auth/services/auth_service.dart';
// import 'package:frontend/features/auth/screens/login.screen.dart';

// class AuthGate extends StatelessWidget {
//   const AuthGate({super.key});

//   Future<bool> checkAuthStatus() async {
//     final authService = AuthService();
//     return await authService.isLoggedIn();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<bool>(
//       future: checkAuthStatus(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         } else {
//           if (snapshot.data == true) {
//             return const HomeScreen();
//           } else {
//             return const LoginScreen();
//           }
//         }
//       },
//     );
//   }
// }
