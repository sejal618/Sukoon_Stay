import 'package:flutter/material.dart';
//import 'pages/api_service.dart'; 
import 'pages/home.dart';
import 'pages/search.dart';
//import 'pages/book.dart';
import 'pages/chat.dart';
import 'pages/payment.dart';
import 'signup.dart';
import 'see_listing.dart';
//import 'pages/cnf.dart';
import 'otp.dart';
// import 'pages/aadhaar_verification_screen.dart';

void main() {
  runApp(SukoonStayApp());
}

class SukoonStayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SukoonStay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      scaffoldBackgroundColor: const Color.fromARGB(217, 255, 255, 255), // Correct way to set white color

        fontFamily: 'Sans', // You can add a custom font if you want
      ),
      initialRoute: '/',
      routes: {
       '/': (context) => HomePage(),
        '/signup': (context) => SignupPage(),
      // '/search': (context) => SearchPage(),
      //'/book': (context) => BookPage(),
        '/chat': (context) => ChatScreen(),
        //'/next': (context) => NextPage(),
      //  '/payment': (context) => PaymentPage(),
        '/see_listing': (context) => PropertyListScreen(),
      //  'otp' : (context) => OtpAuthentication(),
        //'/cnf': (context) => BookingConfirmedPage(),
        //'/property_listing': (context) => ListingPage(),
        // '/aadhaar_verification': (context) => AadhaarVerificationScreen(),  // Add the route for Aadhaar verification screen
      },
    );
  }
}
