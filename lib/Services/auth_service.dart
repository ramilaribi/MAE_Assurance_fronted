import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:perper/constants.dart';
class AuthService {
  final String _baseUrl = baseUrl;

  Future<Map<String, dynamic>> login(String id, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': id,
        'password': password,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['user'] != null) {
        await saveUserInfo(data['user'], data['token']);
        return data;
      } else {
        throw Exception('User data is missing in the response');
      }
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception('Failed to login: ${errorResponse['error']}');
    }
  }

  Future<void> saveUserInfo(Map<String, dynamic> user, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user));
    await prefs.setString('token', token);
    await prefs.setString('userId', user['_id']);
  }

  Future<Map<String, dynamic>?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    if (userString != null) {
      return jsonDecode(userString);
    }
    return null;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> clearUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove('token');
    await prefs.remove('userId');
  }

  Future<void> updateUser(String id, String fullName, String email, String phoneNumber, String address, String birthdate) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.put(
      Uri.parse('$_baseUrl/user/update'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'address': address,
        'birthdate': birthdate,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await saveUserInfo(data['user'], token); // Update local storage with new user info
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception('Failed to update user: ${errorResponse['message']}');
    }
  }

  Future<void> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/forgetPwd'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'data': email,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('resetToken', data['token']); // Ensure token is saved here
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception('Failed to request password reset: ${errorResponse['error']}');
    }
  }

  Future<void> otpVerification(String email, String code) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('resetToken') ?? '';
    print('Token being sent: $token');
    print('Code being sent: $code');

    final response = await http.post(
      Uri.parse('$_baseUrl/otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'data': code,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await prefs.setString('resetToken', data['token']);
    } else {
      final errorResponse = jsonDecode(response.body);
      print('Error Response: $errorResponse');
      throw Exception('Failed to verify OTP: ${errorResponse['error']}');
    }
  }

  Future<String?> getResetToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('resetToken');
  }

  Future<void> resetPassword(String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    final resetToken = prefs.getString('resetToken') ?? '';

    final response = await http.post(
      Uri.parse('$_baseUrl/newPwd'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $resetToken',
      },
      body: jsonEncode(<String, String>{
        'password': newPassword,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      final errorResponse = jsonDecode(response.body);
      print('Error Response: $errorResponse');
      throw Exception('Failed to reset password: ${errorResponse['error']}');
    }
  }
}
