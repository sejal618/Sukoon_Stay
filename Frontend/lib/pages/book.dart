// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'mock.dart'; // Add this import for the Booking model

// class BookPage extends StatefulWidget {
//   final Property property;

//   BookPage({required this.property});

//   @override
//   _BookPageState createState() => _BookPageState();
// }

// class _BookPageState extends State<BookPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController aadhaarController = TextEditingController();
//   final TextEditingController otpController = TextEditingController();

//   DateTime? _checkInDate;
//   DateTime? _checkOutDate;
//   int _adultCount = 1;
//   int _childCount = 0;
//   double _totalPrice = 0.0;
//   bool _isLoading = false;
//   String _errorMessage = '';

//   // API URL to post the booking
//   final String apiUrl = 'https://your-backend-api.com/bookings';

//   // Method to select date for check-in and check-out
//   Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2101),
//     );

//     if (picked != null) {
//       setState(() {
//         if (isCheckIn) {
//           _checkInDate = picked;
//         } else {
//           _checkOutDate = picked;
//         }
//       });
//       _fetchPricing(); // Recalculate price after date change
//     }
//   }

//   // Method to calculate pricing (stub for now)
//   Future<void> _fetchPricing() async {
//     // Placeholder for price calculation logic
//     if (_checkInDate != null && _checkOutDate != null) {
//       setState(() {
//         _totalPrice = 5000.0; // Example price, replace with actual logic
//       });
//     }
//   }

//   // Method to handle booking submission
//   Future<void> _submitBooking() async {
//     if (_formKey.currentState!.validate()) {
//       final booking = Booking(
//         id: 'generated-id',  // You can generate a new ID or fetch one dynamically if needed
//         propertyId: widget.property.name,  // Use the property name or another unique field as the propertyId
//         propertyType: widget.property.type ?? '',  // Use an empty string if type is null
//         name: nameController.text,
//         phone: phoneController.text,
//         from: _checkInDate!,
//         to: _checkOutDate!,
//         adults: _adultCount,
//         children: _childCount,
//         rooms: 1, // Set rooms as required
//         email: 'user@example.com',  // Or from user input if necessary
//       );

//       // Send booking data to the backend
//       setState(() {
//         _isLoading = true;
//         _errorMessage = '';
//       });

//       try {
//         final response = await http.post(
//           Uri.parse(apiUrl),
//           headers: {
//             'Content-Type': 'application/json',
//           },
//           body: json.encode(booking.toJson()),
//         );

//         if (response.statusCode == 200) {
//           // Successfully booked
//           Navigator.pushNamed(context, '/payment');
//         } else {
//           setState(() {
//             _errorMessage = 'Booking failed: ${response.body}';
//           });
//         }
//       } catch (e) {
//         setState(() {
//           _errorMessage = 'Failed to submit booking: $e';
//         });
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Book Page'),
//         backgroundColor: Colors.black,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [Colors.white, Colors.grey.shade200],
//             ),
//           ),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 TextFormField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
//                 const SizedBox(height: 20.0),
//                 TextFormField(controller: phoneController, decoration: InputDecoration(labelText: 'Phone')),
//                 const SizedBox(height: 20.0),
//                 GestureDetector(
//                   onTap: () => _selectDate(context, true),
//                   child: AbsorbPointer(
//                     child: TextFormField(
//                       decoration: InputDecoration(
//                         labelText: 'Check-in Date',
//                         hintText: _checkInDate != null ? DateFormat('yyyy-MM-dd').format(_checkInDate!) : 'Select Date',
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20.0),
//                 GestureDetector(
//                   onTap: () => _selectDate(context, false),
//                   child: AbsorbPointer(
//                     child: TextFormField(
//                       decoration: InputDecoration(
//                         labelText: 'Check-out Date',
//                         hintText: _checkOutDate != null ? DateFormat('yyyy-MM-dd').format(_checkOutDate!) : 'Select Date',
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20.0),
//                 _isLoading
//                     ? CircularProgressIndicator()
//                     : _errorMessage.isNotEmpty
//                         ? Text(_errorMessage, style: TextStyle(color: Colors.red))
//                         : Card(
//                             elevation: 5,
//                             child: Padding(
//                               padding: const EdgeInsets.all(15.0),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text('Total Price:', style: Theme.of(context).textTheme.titleLarge),
//                                   Text('₹${_totalPrice.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge),
//                                 ],
//                               ),
//                             ),
//                           ),
//                 const SizedBox(height: 20.0),
//                 ElevatedButton(
//                   onPressed: _submitBooking,
//                   style: ButtonStyle(
//                     padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0)),
//                     backgroundColor: WidgetStateProperty.all<Color>(Colors.grey.shade800),
//                     foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
//                   ),
//                   child: const Text('Book Now'),
//                 ),
//               ],
//             ),
//           ),fl

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:classico/otp.dart';
import 'mock.dart';

class BookPage extends StatefulWidget {
  final Property property;

  BookPage({required this.property});

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController aadhaarController = TextEditingController();
  
  // Controllers for check-in and check-out dates
  final TextEditingController checkInController = TextEditingController();
  final TextEditingController checkOutController = TextEditingController();

  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _adultCount = 1;
  int _childCount = 0;
  int _totalPrice = 0;
  bool _isLoading = false;
  String _errorMessage = '';

  // Method to select date for check-in and check-out
  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
          checkInController.text = DateFormat('yyyy-MM-dd').format(_checkInDate!); // Update the text controller
        } else {
          _checkOutDate = picked;
          checkOutController.text = DateFormat('yyyy-MM-dd').format(_checkOutDate!); // Update the text controller
        }
      });
      _fetchPricing(); // Recalculate price after date change
    }
  }

  // Method to calculate pricing (stub for now)
  // Method to calculate pricing based on number of days
Future<void> _fetchPricing() async {
  if (_checkInDate != null && _checkOutDate != null) {
    final difference = _checkOutDate!.difference(_checkInDate!).inDays;

    if (difference > 0) {
      setState(() {
        // Set your price per night here, for example, 1000 per night
        int pricePerNight = widget.property.price;
        _totalPrice = difference * pricePerNight;
      });
    } else {
      setState(() {
        _errorMessage = 'Check-out date must be later than check-in date.';
      });
    }
  }
}

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpAuthentication(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Page'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
              const SizedBox(height: 20.0),
              TextFormField(controller: phoneController, decoration: InputDecoration(labelText: 'Phone')),
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: () => _selectDate(context, true),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: checkInController, // Use the controller
                    decoration: InputDecoration(
                      labelText: 'Check-in Date',
                      hintText: _checkInDate != null ? DateFormat('yyyy-MM-dd').format(_checkInDate!) : 'Select Date',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: () => _selectDate(context, false),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: checkOutController, // Use the controller
                    decoration: InputDecoration(
                      labelText: 'Check-out Date',
                      hintText: _checkOutDate != null ? DateFormat('yyyy-MM-dd').format(_checkOutDate!) : 'Select Date',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              _isLoading
                  ? CircularProgressIndicator()
                  : _errorMessage.isNotEmpty
                      ? Text(_errorMessage, style: TextStyle(color: Colors.red))
                      : Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total Price:', style: Theme.of(context).textTheme.titleLarge),
                                Text('₹${_totalPrice.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge),
                              ],
                            ),
                          ),
                        ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _submitBooking,
                style: ButtonStyle(
                  padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0)),
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.grey.shade800),
                  foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                ),
                child: const Text('Verify Phone Number'), // Button text for phone verification
              ),
            ],
          ),
        ),
      ),
    );
  }
}
