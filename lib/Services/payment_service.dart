import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:perper/constants.dart';

class PaymentService {
  final String _baseUrl = baseUrl;

  Future<Map<String, dynamic>?> createPaymentIntent(String contractID, double amount) async {
    final url = Uri.parse('$_baseUrl/payment/pay');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'contractID': contractID, 'amount': amount, 'currency': 'usd'});

    print('Sending POST request to $url');
    print('Headers: $headers');
    print('Body: $body');

    try {
      final response = await http.post(url, headers: headers, body: body);

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to create Payment Intent: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error creating Payment Intent: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> confirmPayment(String paymentIntentId, String paymentID) async {
    final url = Uri.parse('$_baseUrl/payment/confirm');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'paymentIntentId': paymentIntentId,
      'paymentID': paymentID,
    });

    print('Sending POST request to $url');
    print('Headers: $headers');
    print('Body: $body');

    try {
      final response = await http.post(url, headers: headers, body: body);

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      return jsonDecode(response.body);
    } catch (e) {
      print('Error confirming Payment Intent: $e');
      return {'status': 'failed', 'error': e.toString()};
    }
  }
}

