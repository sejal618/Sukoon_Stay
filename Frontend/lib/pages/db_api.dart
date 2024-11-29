// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import 'mock.dart';  // Ensure this contains your Property model class

// // class ApiService {
// //   static const String baseUrl = 'http://192.168.159.119:5000';  // Your backend URL

// //   // Fetch properties from the hotel database
// //   Future<List<Property>> fetchHotelProperties() async {
// //     try {
// //       final response = await http.get(Uri.parse('$baseUrl/HotelRegister'));

// //       if (response.statusCode == 200) {
// //         List jsonResponse = json.decode(response.body);
// //         // Return properties with 'Hotel' as their type
// //         return jsonResponse.map((property) => Property.fromJson(property).copyWith(type: 'Hotel')).toList();
// //       } else {
// //         print('Failed to load hotel properties, status code: ${response.statusCode}');
// //         return [];
// //       }
// //     } catch (e) {
// //       print('Error fetching hotel properties: $e');
// //       return [];
// //     }
// //   }

// //   // Fetch properties from the PG database
// //   Future<List<Property>> fetchPGProperties() async {
// //     try {
// //       final response = await http.get(Uri.parse('$baseUrl/PGRegister'));

// //       if (response.statusCode == 200) {
// //         List jsonResponse = json.decode(response.body);
// //         // Return properties with 'PG' as their type
// //         return jsonResponse.map((property) => Property.fromJson(property).copyWith(type: 'PG')).toList();
// //       } else {
// //         print('Failed to load PG properties, status code: ${response.statusCode}');
// //         return [];
// //       }
// //     } catch (e) {
// //       print('Error fetching PG properties: $e');
// //       return [];
// //     }
// //   }

// //   // Fetch properties from the rental database
// //   Future<List<Property>> fetchRentalProperties() async {
// //     try {
// //       final response = await http.get(Uri.parse('$baseUrl/RentalRegister'));

// //       if (response.statusCode == 200) {
// //         List jsonResponse = json.decode(response.body);
// //         // Return properties with 'Rental' as their type
// //         return jsonResponse.map((property) => Property.fromJson(property).copyWith(type: 'Rental')).toList();
// //       } else {
// //         print('Failed to load rental properties, status code: ${response.statusCode}');
// //         return [];
// //       }
// //     } catch (e) {
// //       print('Error fetching rental properties: $e');
// //       return [];
// //     }
// //   }

// //   // Fetch all properties and dynamically add a 'type' field based on the source
// //   Future<List<Property>> fetchProperties() async {
// //     try {
// //       // Fetch properties from different sources
// //       List<Property> hotelProperties = await fetchHotelProperties();
// //       List<Property> pgProperties = await fetchPGProperties();
// //       List<Property> rentalProperties = await fetchRentalProperties();

// //       // Combine all properties into one list
// //       List<Property> allProperties = [];
// //       allProperties.addAll(hotelProperties);
// //       allProperties.addAll(pgProperties);
// //       allProperties.addAll(rentalProperties);

// //       return allProperties;
// //     } catch (e) {
// //       print('Error fetching all properties: $e');
// //       return [];
// //     }
// //   }

// // Future<Host> fetchHostDetails() async {
// //   try {
// //     final response = await http.get(Uri.parse('$baseUrl/hosts'));

// //     if (response.statusCode == 200) {
// //       List jsonResponse = json.decode(response.body);
// //       if (jsonResponse.isNotEmpty) {
// //         return Host.fromJson(jsonResponse[0]); 
// //       } else {
// //         throw Exception('No hosts found');
// //       }
// //     } else {
// //       throw Exception('Failed to load host details, status code: ${response.statusCode}');
// //     }
// //   } catch (e) {
// //     print('Error fetching host details: $e');
// //     throw Exception('Error fetching host details');
// //   }
// // }

// // }

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'mock.dart';  // Ensure this contains your Property model class
// import 'property_listing.dart';

// class ApiService {
//   static const String baseUrl = 'https://192.168.159.119:5000';  // Your backend URL

//   // Helper method for fetching property data
//   Future<List<Property>> _fetchPropertiesFromEndpoint(String endpoint, String type) async {
//     try {
//       print('Fetching $type properties from $baseUrl/$endpoint...');
      
//       // Make the HTTP request
//       final response = await http.get(Uri.parse('$baseUrl/$endpoint'));

//       // Check if the response status code is 200 (OK)
//       if (response.statusCode == 200) {
//         // Parse the JSON response body
//         List jsonResponse = json.decode(response.body);
//         print("CODING STARTED");
        
//         // Check if the response contains properties
//         if (jsonResponse.isNotEmpty) {
//           print('$type properties fetched successfully: ${jsonResponse.length} properties found');
          
//           // Convert the JSON data into a List of Property objects with the correct type
//           return jsonResponse
//               .map((property) => Property.fromJson(property).copyWith(type: type))
//               .toList();
//         } else {
//           print('No $type properties found in the response.');
//           return [];  // Return empty list if no properties are found
//         }
//       } else {
//         // Handle unsuccessful HTTP responses (status codes other than 200)
//         print('Failed to load $type properties, status code: ${response.statusCode}');
//         return [];
//       }
//     } catch (e) {
//       // Handle any errors that occur during the fetch process
//       print('Error fetching $type properties: $e');
//       return [];
//     }
//   }


//   // Fetch properties from different sources
//   Future<List<Property>> fetchHotelProperties() async {
//     return _fetchPropertiesFromEndpoint('HotelRegister', 'Hotel');
//   }

//   Future<List<Property>> fetchPGProperties() async {
//     return _fetchPropertiesFromEndpoint('PGRegister', 'PG');
//   }

//   Future<List<Property>> fetchRentalProperties() async {
//     return _fetchPropertiesFromEndpoint('RentalRegister', 'Rental');
//   }

//   // Fetch all properties from different sources
//   Future<List<Property>> fetchProperties() async {
//     try {
//       print('Fetching all properties...');
//       List<Property> hotelProperties = await fetchHotelProperties();
//       List<Property> pgProperties = await fetchPGProperties();
//       List<Property> rentalProperties = await fetchRentalProperties();

//       List<Property> allProperties = [];
//       allProperties.addAll(hotelProperties);
//       allProperties.addAll(pgProperties);
//       allProperties.addAll(rentalProperties);

//       print('All properties fetched successfully: ${allProperties.length} properties found');
//       return allProperties;
//     } catch (e) {
//       print('Error fetching all properties: $e');
//       return [];
//     }
//   }

//   // Fetch host details
//   Future<Host> fetchHostDetails() async {
//     try {
//       print('Fetching host details from $baseUrl/hosts...');
//       final response = await http.get(Uri.parse('$baseUrl/hosts'));

//       if (response.statusCode == 200) {
//         List jsonResponse = json.decode(response.body);
//         if (jsonResponse.isNotEmpty) {
//           print('Host details fetched successfully: ${jsonResponse.length} hosts found');
//           return Host.fromJson(jsonResponse[0]);
//         } else {
//           print('No hosts found.');
//           throw Exception('No hosts found');
//         }
//       } else {
//         print('Failed to load host details, status code: ${response.statusCode}');
//         throw Exception('Failed to load host details');
//       }
//     } catch (e) {
//       print('Error fetching host details: $e');
//       throw Exception('Error fetching host details');
//     }
//   }
// }
