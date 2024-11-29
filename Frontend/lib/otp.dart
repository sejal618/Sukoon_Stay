import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pages/payment.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: OtpAuthentication(),
//     );
//   }
// }

class OtpAuthentication extends StatefulWidget {
  @override
  _OtpAuthenticationState createState() => _OtpAuthenticationState();
}

class _OtpAuthenticationState extends State<OtpAuthentication> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  String? sentOtp; // Store the OTP for validation
  bool isOtpSent = false; // Track OTP sending state

  Future<void> sendOtp(String phoneNumber) async {
    final String apiUrl = "https://www.fast2sms.com/dev/bulkV2";
    final String apiKey = "b1wOTeZJGl8imvtc6ysPjuISBYX95xQp3K7qhDHEU2zFWCdaMAPUoHZKGM60ptViFIgfXJkQYC2Dxvrh";
    // Generate a random 6-digit OTP
    final otp = (100000 + (999999 - 100000) * (DateTime.now().millisecondsSinceEpoch % 1000) ~/ 1000).toString();

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "authorization": apiKey,
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "route": "q",
        "numbers": phoneNumber,
        "message": "Your OTP is $otp",
        "language": "english",
        "flash": 0,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        isOtpSent = true;
        sentOtp = otp;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP sent to $phoneNumber")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send OTP: ${response.body}")),
      );
    }
  }

  Future<void> verifyOtp(String enteredOtp) async {
    if (sentOtp == enteredOtp) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP Verified Successfully!")),
      );
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid OTP! Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Authentication"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: "Phone Number",
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            if (!isOtpSent)
              ElevatedButton(
                onPressed: () {
                  final phoneNumber = phoneController.text;
                  if (phoneNumber.isNotEmpty) {
                    sendOtp(phoneNumber);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please enter a valid phone number")),
                    );
                  }
                },
                child: Text("Send OTP"),
              ),
            if (isOtpSent) ...[
              TextField(
                controller: otpController,
                decoration: InputDecoration(
                  labelText: "Enter OTP",
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final enteredOtp = otpController.text;
                  if (enteredOtp.isNotEmpty) {
                    verifyOtp(enteredOtp);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please enter the OTP")),
                    );
                  }
                },
                child: Text("Verify OTP"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}