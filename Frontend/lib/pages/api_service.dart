import 'dart:convert';
import 'package:http/http.dart' as http;

class AadhaarVerificationService {
  final String baseUrl = 'https://dg-sandbox.setu.co/api/okyc';
  final String clientId = 'YOUR_CLIENT_ID';
  final String clientSecret = 'YOUR_CLIENT_SECRET';
  final String productInstanceId = 'YOUR_PRODUCT_INSTANCE_ID';

  // Method to create Aadhaar verification request
  Future<Map<String, dynamic>?> createVerificationRequest() async {
    final url = Uri.parse('$baseUrl/create');
    
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-client-id': clientId,
        'x-client-secret': clientSecret,
        'x-product-instance-id': productInstanceId,
      },
      body: jsonEncode({
        'redirectURL': 'https://setu.co'
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return null;
    }
  }

  // Method to verify Aadhaar with OTP
  Future<Map<String, dynamic>?> verifyAadhaar(
    String requestId,
    String aadhaarNumber,
    String captchaCode,
  ) async {
    final url = Uri.parse('$baseUrl/$requestId/verify');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-client-id': clientId,
        'x-client-secret': clientSecret,
        'x-product-instance-id': productInstanceId,
      },
      body: jsonEncode({
        'aadhaarNumber': aadhaarNumber,
        'captchaCode': captchaCode,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return null;
    }
  }
}
