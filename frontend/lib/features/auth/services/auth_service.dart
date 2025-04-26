import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class AuthService {
  String? _accessToken;
  String? _refreshToken;

  bool get isLoggedIn => _accessToken != null;

  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.x.x:3001/auth/login'), // zameni IP!
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('Response status: ${response.statusCode}');
      print('RESPONSE BODY RAW: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        _accessToken = data['accessToken'];
        _refreshToken = data['refreshToken'];

        if (_accessToken == null) {
          throw Exception('Access token not found in response');
        }
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      print('🔥 CAUGHT ERROR IN LOGIN: $e');
      rethrow; // da dalje baci error ako treba
    }
  }

  String? get accessToken => _accessToken;
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});
