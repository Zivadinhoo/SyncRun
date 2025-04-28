import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();
  String? _accessToken;
  String? _refreshToken;

  bool get isLoggedInMemory => _accessToken != null;

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;

    await _storage.write(key: 'accessToken', value: accessToken);
    await _storage.write(key: 'refreshToken', value: refreshToken);
    print('✅ Tokens saved to storage');
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'accessToken');
    return token != null;
  }

  Future<void> logout() async {
    _accessToken = null;
    _refreshToken = null;
    await _storage.deleteAll();
  }

  Future<void> login(String email, String password) async {
    try {
      print('🚀 Trying to login with email: $email');

      final response = await http.post(
        Uri.parse('http://192.168.0.30:3001/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('Response status: ${response.statusCode}');
      print('RESPONSE BODY RAW: ${response.body}');

      final data = jsonDecode(response.body);
      print('🔵 RESPONSE BODY DECODED: $data');

      if (data['accessToken'] == null) {
        print('❗ AccessToken nije pronađen u odgovoru.');
        throw Exception('Access token not found in response');
      }

      print('💾 Saving accessToken: ${data['accessToken']}');
      await saveTokens(data['accessToken'], data['refreshToken']);
      print('✅ Tokens saved to storage');
    } catch (e) {
      print('🔥 CAUGHT ERROR IN LOGIN: $e');
      rethrow;
    }
  }

  Future<String?> getCurrentUser() async {
    final token = _accessToken ?? await _storage.read(key: 'accessToken');
    print('📦 AccessToken loaded: $token');

    if (token == null) {
      print('❗ AccessToken je null. Vraćam null iz getCurrentUser().');
      return null;
    }

    try {
      final url = 'http://192.168.0.30:3001/auth/me';
      print('🌍 Sending GET request to: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final firstName = data['firstName'] ?? '';
        final lastName = data['lastName'] ?? '';
        print('✅ Full name parsed: $firstName $lastName');
        return '$firstName $lastName';
      } else {
        print('❌ Failed to fetch user. Status code: ${response.statusCode}');
        throw Exception('Failed to fetch current user: ${response.body}');
      }
    } catch (e) {
      print('🔥 Exception during getCurrentUser: $e');
      rethrow;
    }
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});
