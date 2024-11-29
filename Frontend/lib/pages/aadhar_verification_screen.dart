import 'package:flutter/material.dart';
import 'api_service.dart'; // Import the service to handle the API call

class AadhaarVerificationScreen extends StatefulWidget {
  @override
  _AadhaarVerificationScreenState createState() => _AadhaarVerificationScreenState();
}

class _AadhaarVerificationScreenState extends State<AadhaarVerificationScreen> {
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _captchaController = TextEditingController();
  final AadhaarVerificationService _aadhaarService = AadhaarVerificationService();

  Future<void> verifyAadhaar() async {
    try {
      final response = await _aadhaarService.verifyAadhaar(
        'YOUR_REQUEST_ID', // Replace with the actual request ID
        _aadhaarController.text,
        _captchaController.text,
      );
      if (response != null) {
        print('Verification Response: $response');
      } else {
        print('Failed to verify Aadhaar');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aadhaar Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _aadhaarController,
              decoration: InputDecoration(labelText: 'Aadhaar Number'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _captchaController,
              decoration: InputDecoration(labelText: 'Captcha Code'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: verifyAadhaar,
              child: Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
