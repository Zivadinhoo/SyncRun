import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();
  String? _accessToken;

  final String baseUrl = 'http://192.168.0.53:3001';

  /// ✅ Save tokens locally
  Future<void> saveTokens(
    String accessToken,
    String refreshToken,
  ) async {
    _accessToken = accessToken;

    await _storage.write(
      key: 'accessToken',
      value: accessToken,
    );
    await _storage.write(
      key: 'refreshToken',
      value: refreshToken,
    );

    print('✅ Tokens saved to secure storage');
  }

  /// ✅ Get access token from memory or secure storage
  Future<String?> getAccessToken() async {
    if (_accessToken != null) return _accessToken;
    final token = await _storage.read(key: 'accessToken');
    _accessToken = token;
    return token;
  }

  /// ✅ Check if user is logged in (with API validation)
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    if (token == null || token.isEmpty) return false;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/me'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('🔐 isLoggedIn check: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Error checking login state: $e');
      return false;
    }
  }

  Future<void> logout() async {
    _accessToken = null;
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
    await _storage.delete(key: 'hasFinishedOnboarding');
    print('🚪 User logged out & all auth data cleared');
  }

  /// ✅ Login and save tokens
  Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      print('🚀 Trying to login with email: $email');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('📥 Response: ${response.statusCode}');
      final data = jsonDecode(response.body);

      if (data['accessToken'] == null) {
        throw Exception(
          'Access token not found in response',
        );
      }

      await saveTokens(
        data['accessToken'],
        data['refreshToken'],
      );
      return data;
    } catch (e) {
      print('🔥 Error during login: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final token = await getAccessToken();
    if (token == null) return null;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('👤 User data: ${response.body}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(
          '⚠️ Failed to fetch current user: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      print('🔥 Exception during getCurrentUser: $e');
      return null;
    }
  }

  Future<http.Response> authorizedGet(
    String endpoint,
  ) async {
    final token = await getAccessToken();
    if (token == null)
      throw Exception('❌ No access token found');

    final url = Uri.parse('$baseUrl$endpoint');
    print('🌍 Sending AUTHORIZED GET to: $url');

    final res = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('📥 [${res.statusCode}] ${res.body}');
    return res;
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});
