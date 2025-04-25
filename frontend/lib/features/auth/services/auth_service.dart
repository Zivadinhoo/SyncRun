import 'dart:convert';
import "package:frontend/core/services/secure_storage_service.dart";
import 'package:http/http.dart' as http;

class AuthService {
  final String _baseUrl = 'http://localhost:3000';
  final SecureStorageService _secureStorageService = SecureStorageService();

  Future<void> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final accessToken = data['accessToken'];

        if (accessToken != null) {
          await _secureStorageService.saveToken(accessToken);
        } else {
          throw Exception('No token in response');
        }
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Login failed $e');
      rethrow;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _secureStorageService.getToken();
    return token != null && token.isNotEmpty;
  }
}
