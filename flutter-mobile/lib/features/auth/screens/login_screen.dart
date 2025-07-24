import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/features/auth/services/auth_service.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(
    text: 'dusantrkac@gmail.com',
  );
  final _passwordController = TextEditingController(
    text: 'test123',
  );

  bool _obscurePassword = true;
  bool _isLoading = false;

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = AuthService();
      final response = await authService.login(
        email,
        password,
      );

      final accessToken = response['accessToken'];
      final refreshToken = response['refreshToken'];

      if (accessToken != null && refreshToken != null) {
        const storage = FlutterSecureStorage();
        await storage.write(
          key: 'accessToken',
          value: accessToken,
        );
        await storage.write(
          key: 'refreshToken',
          value: refreshToken,
        );

        if (!mounted) return;
        context.go('/athlete/dashboard');
      } else {
        throw Exception(
          "No access token found in response",
        );
      }
    } catch (e) {
      debugPrint('❌ Login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().contains('401') ||
                    e.toString().contains('Unauthorized')
                ? 'Invalid credentials. Please try again.'
                : 'Login failed: $e',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 👟 App logo or icon
                const SizedBox(height: 40),
                // Image.asset(
                //   'assets/images/syncrun_logo.png', // Replace with your logo
                //   height: 80,
                // ),
                const SizedBox(height: 24),
                Text(
                  'Welcome to Syncrun, your journey starts now 🏃‍♂️',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Let’s sync your run journey.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface
                        .withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // 📧 Email
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 🔒 Password
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // 🟨 Login button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor:
                          colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          24,
                        ),
                      ),
                      elevation: 4,
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                            : const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                  ),
                ),
                const SizedBox(height: 24),

                // 🧾 Register link
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don’t have an account?",
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface
                            .withOpacity(0.7),
                      ),
                    ),
                    TextButton(
                      onPressed:
                          () => context.go('/register'),
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
