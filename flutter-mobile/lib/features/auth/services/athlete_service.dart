import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, dynamic>>> fetchAssignedPlans(
  String token,
) async {
  final response = await http.get(
    Uri.parse('http://192.168.0.45:3001/assigned-plans/my'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to fetch assigned plans');
  }
}
