import 'package:flutter/material.dart';
import 'package:frontend/features/auth/services/auth_service.dart';
import 'package:frontend/features/auth/screens/login.screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    final authService = AuthService();
    await authService.logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF6F1),
        elevation: 0,
        centerTitle: true,
        title: const Text('Settings', style: TextStyle(color: Colors.black87)),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            const Text(
              'Account Settings',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                'Logout',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              onTap: () => _logout(context),
            ),

            const Divider(height: 40),

            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.grey),
              title: const Text(
                'About SyncRun',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'SyncRun',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '© 2025 SyncRun Team',
                );
              },
            ),

            const Spacer(),

            Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
