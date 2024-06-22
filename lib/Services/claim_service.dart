import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import 'package:perper/constants.dart';

class ClaimService {
  final String _baseUrl = baseUrl;

  Future<void> createClaim(String title, String description) async {
    final authService = AuthService();
    final token = await authService.getToken();

    if (token == null) {
      throw Exception('No token found. Please login again.');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/Claim/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'description': description,
      }),
    );

    if (response.statusCode == 201) {
      print('Claim created successfully');
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception('Failed to create claim: ${errorResponse['message']}');
    }
  }
}
