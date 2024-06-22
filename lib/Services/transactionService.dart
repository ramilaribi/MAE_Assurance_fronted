import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:perper/constants.dart';

class TransactionService {
  final String _baseUrl = baseUrl;

  Future<List<dynamic>> getUserTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse('$_baseUrl/transaction/byid');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      print('Error fetching transactions: $e');
      throw e;
    }
  }
}
