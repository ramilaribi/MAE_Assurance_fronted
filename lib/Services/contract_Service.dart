import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:perper/Model/contract.dart';
import 'package:perper/constants.dart';

class ContractService {
  final String _baseUrl = baseUrl;

  Future<List<Contract>> fetchContractsForUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getString('userId');
    if (token == null || userId == null) {
      throw Exception('No token or userId found');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/contract/getByUser'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'userId': userId}),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<Contract> contracts = body.map((dynamic item) {
        return Contract.fromJson(item);
      }).toList();
      return contracts;
    } else {
      throw Exception('Failed to load contracts');
    }
  }

  void checkAndMarkExpiredContracts(List<Contract> contracts) {
    final currentDate = DateTime.now();
    for (var contract in contracts) {
      if (contract.endDate.isBefore(currentDate) && contract.status != 'Expired') {
        contract.status = 'Expired';
      }
    }
  }

  String formatContractDate(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }
}
