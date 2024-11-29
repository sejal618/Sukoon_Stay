// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'db_api.dart'; 
// import 'mock.dart';

// class BookingConfirmedPage extends StatelessWidget {
//   final Property property;
//   final String userName;
//   final String userPhone;
//   final int numOfPeople;
//   final double totalPrice;
//   final String bookingDate;

//   BookingConfirmedPage({
//     required this.property,
//     required this.userName,
//     required this.userPhone,
//     required this.numOfPeople,
//     required this.totalPrice,
//     required this.bookingDate,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Booking Confirmed'),
//         backgroundColor: Colors.black, 
//         foregroundColor: Colors.white,
//       ),
//       body: 
//       FutureBuilder(
//         future: ApiService().fetchHostDetails(property), // Fetch host details
//         builder: (context, AsyncSnapshot<Host> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error loading host details'));
//           }

//           if (!snapshot.hasData) {
//             return Center(child: Text('No host data available'));
//           }

//           final host = snapshot.data!;

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Booking Confirmation Title
//                 Text(
//                   'Your booking is confirmed!',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 SizedBox(height: 20),
                
//                 // Listing Details
//                 _buildDetailRow('Property:', property.name),
//                 _buildDetailRow('Location:', '${property.city}, ${property.state}'),
//                 _buildDetailRow('Booking Date:', bookingDate),
//                 _buildDetailRow('Number of People:', '$numOfPeople'),
//                 _buildDetailRow('Phone Number:', userPhone),
//                 _buildDetailRow('User Name:', userName),
//                 SizedBox(height: 20),
                
//                 // Invoice Section (Price Calculation)
//                 _buildInvoiceRow('Base Price:', '₹${property.price}'),
//                 _buildInvoiceRow('GST (12%):', '₹${(property.price * 0.12).toStringAsFixed(2)}'),
//                 _buildInvoiceRow('Service Charge (5%):', '₹${(property.price * 0.05).toStringAsFixed(2)}'),
//                 _buildInvoiceRow('Total Price:', '₹${totalPrice.toStringAsFixed(2)}'),
//                 SizedBox(height: 20),
                
//                 // Host Details Section
//                 Text(
//                   'Host Details:',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 _buildDetailRow('Host Name:', host.name),
//                 _buildDetailRow('Host Phone:', host.phone),
//                 _buildDetailRow('Host Email:', host.email),
                
//                 SizedBox(height: 20),
                
//                 // Button to go back or perform an action
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context); // Going back to the previous page
//                   },
//                   style: ElevatedButton.styleFrom(backgroundColor : Colors.black),
//                   child: Text('Back to Home', style: TextStyle(color: Colors.white)),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // Helper function to display rows for details
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Text(
//             '$label ',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper function to display invoice rows for pricing
//   Widget _buildInvoiceRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(fontSize: 18, color: Colors.black),
//           ),
//           Text(
//             value,
//             style: TextStyle(fontSize: 18, color: Colors.black),
//           ),
//         ],
//       ),
//     );
//   }
// }
