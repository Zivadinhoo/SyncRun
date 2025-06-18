import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<Map<String, String>> getAuthorizedHeaders() async {
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'accessToken');

  if (token == null) {
    throw Exception('Access token not found');
  }

  return {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };
}
