// // import 'package:flutter/material.dart';
// // import 'db_api.dart';
// // import 'mock.dart';
// // import 'property_listing.dart';
// // import 'dart:ui';

// // class SearchPage extends StatefulWidget {
// //   @override
// //   _SearchPageState createState() => _SearchPageState();
// // }

// // class _SearchPageState extends State<SearchPage> {
// //   // Controller for search input
// //   TextEditingController _searchController = TextEditingController();

// //   // List to store fetched properties from the backend
// //   List<Property> _properties = [];
// //   List<Property> _filteredProperties = [];

// //   // Flag to indicate loading state
// //   bool _isLoading = true;

// //   // Error flag to show if an error occurs while fetching properties
// //   bool _hasError = false;

// //   // Price range for filtering
// //   double _minPrice = 0;
// //   double _maxPrice = 10000;
// //   double _selectedMinPrice = 0;
// //   double _selectedMaxPrice = 10000;

// //   // For Type filtering
// //   List<String> _selectedTypes = [];

// //   // Track the currently selected filter category (Type or Price)
// //   String _selectedFilter = 'Type';

// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchProperties(); // Fetch the properties when the page is initialized
// //   }

// //   @override
// //   void dispose() {
// //     _searchController.dispose();
// //     super.dispose();
// //   }

// //   // Fetch properties from the backend API
// // Future<void> _fetchProperties([String propertyType = "all"]) async {
// //   print("Hi there, we started fetching properties for $propertyType.");

// //   try {
// //     ApiService apiService = ApiService();
// //     var response = await apiService.fetchProperties(propertyType);

// //     print("Raw Response: $response"); // Debugging line to check raw API response

// //     // Check for invalid or empty response
// //     if (response == null || response['status'] != "success" || response['data'] == null || response['data'] is! List) {
// //       print("Invalid response structure or no properties found.");
// //       if (mounted) {
// //         setState(() {
// //           _isLoading = false;
// //           _hasError = true;
// //         });
// //       }
// //       return;
// //     }

// //     // Parse response into a list of Property objects
// //     List<Property> properties = (response['data'] as List)
// //         .map((data) => Property.fromJson(data as Map<String, dynamic>))
// //         .toList();

// //     if (properties.isEmpty) {
// //       print("No properties found.");
// //     } else {
// //       print("${properties.length} properties fetched successfully.");
// //     }

// //     // Set the state after fetching properties
// //     if (mounted) {
// //       setState(() {
// //         _properties = properties;
// //         _filteredProperties = properties; // Initially show all properties
// //         _isLoading = false;
// //         _hasError = false; // Reset error state on successful fetch
// //       });
// //     }

// //     print("Fetched Properties: $properties"); // Debugging line to check fetched data
// //   } catch (e, stackTrace) {
// //     print('Error fetching properties: $e');
// //     print('Stack Trace: $stackTrace'); // Debugging line for stack trace

// //     if (mounted) {
// //       setState(() {
// //         _isLoading = false;
// //         _hasError = true;
// //       });
// //     }
// //   }
// // }



// //   // Function to filter properties based on search input and selected filters
// //   void _filterProperties() {
// //     setState(() {
// //       _filteredProperties = _properties.where((property) {
// //         // Filter by search
// //         bool matchesSearch = property.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
// //             property.city.toLowerCase().contains(_searchController.text.toLowerCase()) ||
// //             property.description.toLowerCase().contains(_searchController.text.toLowerCase());

// //         // Filter by types if selected
// //         bool matchesType = _selectedTypes.isEmpty || _selectedTypes.contains(property.type);

// //         // Filter by price range
// //         bool matchesPrice = property.price >= _selectedMinPrice && property.price <= _selectedMaxPrice;

// //         // If no filters are selected, show all properties
// //         return matchesSearch && matchesType && matchesPrice;
// //       }).toList();
// //     });
// //   }

// //   // Function to show the filter dialog with two tabs (Type and Price)
// //   void _showFilterDialog() {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: const Text('Filter Properties'),
// //           content: SizedBox(
// //             height: 350, // Adjust size as needed
// //             child: Column(
// //               children: [
// //                 // Top panel with filter categories (Type and Price)
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                   children: [
// //                     GestureDetector(
// //                       onTap: () {
// //                         setState(() {
// //                           _selectedFilter = 'Type';
// //                         });
// //                       },
// //                       child: Container(
// //                         padding: const EdgeInsets.all(8.0),
// //                         color: _selectedFilter == 'Type' ? Colors.grey : Colors.transparent,
// //                         child: const Text('Type'),
// //                       ),
// //                     ),
// //                     GestureDetector(
// //                       onTap: () {
// //                         setState(() {
// //                           _selectedFilter = 'Price';
// //                         });
// //                       },
// //                       child: Container(
// //                         padding: const EdgeInsets.all(8.0),
// //                         color: _selectedFilter == 'Price' ? Colors.grey : Colors.transparent,
// //                         child: const Text('Price'),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 10), // Space between panels and content
// //                 // Content that changes based on the selected filter
// //                 Expanded(
// //                   child: _selectedFilter == 'Type' ? _buildTypeTab() : _buildPriceTab(),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   // Function to build the Type Tab content with round ticks instead of checkboxes
// //   Widget _buildTypeTab() {
// //     return ListView(
// //       children: ['Hotel', 'PG', 'Rental'].map((type) {
// //         return ListTile(
// //           title: Text(type),
// //           leading: CircleAvatar(
// //             backgroundColor: _selectedTypes.contains(type) ? Colors.green : Colors.grey,
// //             radius: 12,
// //             child: Icon(
// //               Icons.check,
// //               size: 18,
// //               color: Colors.white,
// //             ),
// //           ),
// //           onTap: () {
// //             setState(() {
// //               if (_selectedTypes.contains(type)) {
// //                 _selectedTypes.remove(type);
// //               } else {
// //                 _selectedTypes.add(type);
// //               }
// //             });
// //             _filterProperties(); // Apply filter after selection
// //           },
// //         );
// //       }).toList(),
// //     );
// //   }

// //   // Function to build the Price Tab content with a slider and sort buttons
// //   Widget _buildPriceTab() {
// //     return Column(
// //       children: [
// //         // Price Range Slider
// //         RangeSlider(
// //           values: RangeValues(_selectedMinPrice, _selectedMaxPrice),
// //           min: _minPrice,
// //           max: _maxPrice,
// //           divisions: 100,
// //           labels: RangeLabels(
// //             '₹${_selectedMinPrice.toStringAsFixed(0)}',
// //             '₹${_selectedMaxPrice.toStringAsFixed(0)}',
// //           ),
// //           onChanged: (RangeValues values) {
// //             setState(() {
// //               _selectedMinPrice = values.start;
// //               _selectedMaxPrice = values.end;
// //             });
// //             _filterProperties(); // Apply filter after price selection
// //           },
// //         ),
// //         const SizedBox(height: 10), // Space between slider and buttons
// //         // Sort buttons under the price range
// //         Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //           children: [
// //             ElevatedButton(
// //               onPressed: () {
// //                 setState(() {
// //                   _filteredProperties.sort((a, b) => a.price.compareTo(b.price)); // Lowest to highest
// //                 });
// //               },
// //               child: const Text('Price: Low to High'),
// //             ),
// //             ElevatedButton(
// //               onPressed: () {
// //                 setState(() {
// //                   _filteredProperties.sort((a, b) => b.price.compareTo(a.price)); // Highest to lowest
// //                 });
// //               },
// //               child: const Text('Price: High to Low'),
// //             ),
// //           ],
// //         ),
// //       ],
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Search Properties'),
// //         backgroundColor: Colors.black,
// //         foregroundColor: Colors.white,
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           children: [
// //             // Row to hold the search field and the filter button side by side
// //             Row(
// //               children: [
// //                 // Search input field
// //                 Expanded(
// //                   child: TextField(
// //                     controller: _searchController,
// //                     onChanged: (value) => _filterProperties(),
// //                     decoration: const InputDecoration(
// //                       labelText: 'Search',
// //                       border: OutlineInputBorder(),
// //                       suffixIcon: Icon(Icons.search),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(width: 10), // Add some space between the search bar and filter button

// //                 // Square filter button
// //                 IconButton(
// //                   icon: const Icon(Icons.filter_list),
// //                   onPressed: () {
// //                     // Show the filter dialog when the filter button is tapped
// //                     _showFilterDialog();
// //                   },
// //                   iconSize: 30,  // Adjust icon size for better visibility
// //                   color: Colors.black,
// //                   padding: EdgeInsets.zero,  // Remove padding to make it square
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 20),
// //             // Loading indicator, error message or property list
// //             _isLoading
// //                 ? const Center(child: CircularProgressIndicator())
// //                 : _hasError
// //                     ? Column(
// //                         children: [
// //                           const Icon(Icons.error, color: Colors.red, size: 40),
// //                           const SizedBox(height: 10),
// //                           Text(
// //                             'Error fetching properties. Please try again.',
// //                             style: TextStyle(color: Colors.red),
// //                           ),
// //                           const SizedBox(height: 20),
// //                         ],
// //                       )
// //                     : Expanded(
// //                         child: ListView.builder(
// //                           itemCount: _filteredProperties.length,
// //                           itemBuilder: (context, index) {
// //                             final property = _filteredProperties[index];
// //                             print("Displaying property: ${property.name}");  // Debugging line
// //                             return Card(
// //                               margin: const EdgeInsets.symmetric(vertical: 8.0),
// //                               child: ListTile(
// //                                 leading: Image.network(property.image, width: 50, height: 50, fit: BoxFit.cover),
// //                                 title: Text(property.name),
// //                                 subtitle: Text('${property.type}'),
// //                                 trailing: Text('₹${property.price}'),
// //                                 onTap: () {
// //                                   // Navigate to property details page
// //                                   Navigator.push(
// //                                     context,
// //                                     MaterialPageRoute(
// //                                       builder: (context) => ListingPage(property: property),
// //                                     ),
// //                                   );
// //                                 },
// //                               ),
// //                             );
// //                           },
// //                         ),
// //                       ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }


// // // import 'package:flutter/material.dart';
// // // import 'db_api.dart';
// // // import 'mock.dart';
// // // import 'property_listing.dart';

// // // class SearchPage extends StatefulWidget {
// // //   @override
// // //   _SearchPageState createState() => _SearchPageState();
// // // }

// // // class _SearchPageState extends State<SearchPage> {
// // //   // Controller for search input
// // //   TextEditingController _searchController = TextEditingController();

// // //   // List to store fetched properties from the backend
// // //   List<Property> _properties = [];
// // //   List<Property> _filteredProperties = [];

// // //   // Flag to indicate loading state
// // //   bool _isLoading = true;

// // //   // Error flag to show if an error occurs while fetching properties
// // //   bool _hasError = false;

// // //   // Price range for filtering
// // //   double _minPrice = 0;
// // //   double _maxPrice = 10000;
// // //   double _selectedMinPrice = 0;
// // //   double _selectedMaxPrice = 10000;

// // //   // For Type filtering
// // //   List<String> _selectedTypes = [];

// // //   // Track the currently selected filter category (Type or Price)
// // //   String _selectedFilter = 'Type';

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _fetchProperties(); // Fetch the properties when the page is initialized
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _searchController.dispose();
// // //     super.dispose();
// // //   }

// // //   // Fetch properties from the backend API
// // //   Future<void> _fetchProperties() async {
// // //     try {
// // //       ApiService apiService = ApiService();
// // //       List<Property> properties = await apiService.fetchProperties();
// // //       setState(() {
// // //         _properties = properties;
// // //         _filteredProperties = properties;  // Initially show all properties
// // //         _isLoading = false;
// // //         _hasError = false;  // Reset error state on successful fetch
// // //       });
// // //       print("Fetched Properties: $properties");  // Debugging line
// // //     } catch (e) {
// // //       // Handle error if fetching fails
// // //       setState(() {
// // //         _isLoading = false;
// // //         _hasError = true;
// // //       });
// // //       // Optionally, show an error message to the user
// // //       print('Error fetching properties: $e');
// // //     }
// // //   }

// // //   // Function to filter properties based on search input and selected filters
// // //   void _filterProperties() {
// // //     setState(() {
// // //       _filteredProperties = _properties.where((property) {
// // //         // Filter by search
// // //         bool matchesSearch = property.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
// // //             property.city.toLowerCase().contains(_searchController.text.toLowerCase()) ||
// // //             property.description.toLowerCase().contains(_searchController.text.toLowerCase());

// // //         // Filter by types if selected
// // //         bool matchesType = _selectedTypes.isEmpty || _selectedTypes.contains(property.type);

// // //         // Filter by price range
// // //         bool matchesPrice = property.price >= _selectedMinPrice && property.price <= _selectedMaxPrice;

// // //         // If no filters are selected, show all properties
// // //         return matchesSearch && matchesType && matchesPrice;
// // //       }).toList();
// // //     });
// // //   }

// // //   // Function to show the filter dialog with two tabs (Type and Price)
// // //   void _showFilterDialog() {
// // //     showDialog(
// // //       context: context,
// // //       builder: (BuildContext context) {
// // //         return AlertDialog(
// // //           title: const Text('Filter Properties'),
// // //           content: SizedBox(
// // //             height: 350, // Adjust size as needed
// // //             child: Row(
// // //               children: [
// // //                 // Left panel with filter categories (Type and Price)
// // //                 Container(
// // //                   width: 120,
// // //                   child: Column(
// // //                     children: [
// // //                       ListTile(
// // //                         title: const Text('Type'),
// // //                         onTap: () {
// // //                           setState(() {
// // //                             _selectedFilter = 'Type';
// // //                           });
// // //                         },
// // //                       ),
// // //                       ListTile(
// // //                         title: const Text('Price'),
// // //                         onTap: () {
// // //                           setState(() {
// // //                             _selectedFilter = 'Price';
// // //                           });
// // //                         },
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 // Right panel with content that changes based on the selected filter
// // //                 Expanded(
// // //                   child: _selectedFilter == 'Type' ? _buildTypeTab() : _buildPriceTab(),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }

// // //   // Function to build the Type Tab content with round ticks instead of checkboxes
// // //   Widget _buildTypeTab() {
// // //     return ListView(
// // //       children: ['Hotel', 'PG', 'Rental'].map((type) {
// // //         return ListTile(
// // //           title: Text(type),
// // //           leading: CircleAvatar(
// // //             backgroundColor: _selectedTypes.contains(type) ? Colors.green : Colors.grey,
// // //             radius: 12,
// // //             child: Icon(
// // //               Icons.check,
// // //               size: 18,
// // //               color: Colors.white,
// // //             ),
// // //           ),
// // //           onTap: () {
// // //             setState(() {
// // //               if (_selectedTypes.contains(type)) {
// // //                 _selectedTypes.remove(type);
// // //               } else {
// // //                 _selectedTypes.add(type);
// // //               }
// // //             });
// // //             _filterProperties(); // Apply filter after selection
// // //           },
// // //         );
// // //       }).toList(),
// // //     );
// // //   }

// // //   // Function to build the Price Tab content
// // //   Widget _buildPriceTab() {
// // //     return Column(
// // //       children: [
// // //         // Price Range Slider
// // //         RangeSlider(
// // //           values: RangeValues(_selectedMinPrice, _selectedMaxPrice),
// // //           min: _minPrice,
// // //           max: _maxPrice,
// // //           divisions: 100,
// // //           labels: RangeLabels(
// // //             '₹${_selectedMinPrice.toStringAsFixed(0)}',
// // //             '₹${_selectedMaxPrice.toStringAsFixed(0)}',
// // //           ),
// // //           onChanged: (RangeValues values) {
// // //             setState(() {
// // //               _selectedMinPrice = values.start;
// // //               _selectedMaxPrice = values.end;
// // //             });
// // //             _filterProperties(); // Apply filter after price selection
// // //           },
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text('Search Properties'),
// // //         backgroundColor: Colors.black,
// // //         foregroundColor: Colors.white,
// // //       ),
// // //       body: Padding(
// // //         padding: const EdgeInsets.all(16.0),
// // //         child: Column(
// // //           children: [
// // //             // Row to hold the search field and the filter button side by side
// // //             Row(
// // //               children: [
// // //                 // Search input field
// // //                 Expanded(
// // //                   child: TextField(
// // //                     controller: _searchController,
// // //                     onChanged: (value) => _filterProperties(),
// // //                     decoration: const InputDecoration(
// // //                       labelText: 'Search',
// // //                       border: OutlineInputBorder(),
// // //                       suffixIcon: Icon(Icons.search),
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 const SizedBox(width: 10), // Add some space between the search bar and filter button

// // //                 // Square filter button
// // //                 IconButton(
// // //                   icon: const Icon(Icons.filter_list),
// // //                   onPressed: () {
// // //                     // Show the filter dialog when the filter button is tapped
// // //                     _showFilterDialog();
// // //                   },
// // //                   iconSize: 30,  // Adjust icon size for better visibility
// // //                   color: Colors.black,
// // //                   padding: EdgeInsets.zero,  // Remove padding to make it square
// // //                 ),
// // //               ],
// // //             ),
// // //             const SizedBox(height: 20),
// // //             // Loading indicator, error message or property list
// // //             _isLoading
// // //                 ? const Center(child: CircularProgressIndicator())
// // //                 : _hasError
// // //                     ? Column(
// // //                         children: [
// // //                           const Icon(Icons.error, color: Colors.red, size: 40),
// // //                           const SizedBox(height: 10),
// // //                           Text(
// // //                             'Error fetching properties. Please try again.',
// // //                             style: TextStyle(color: Colors.red),
// // //                           ),
// // //                           const SizedBox(height: 20),
// // //                         ],
// // //                       )
// // //                     : Expanded(
// // //                         child: Column(
// // //                           children: [
// // //                             Expanded(
// // //                               child: ListView.builder(
// // //                                 itemCount: _filteredProperties.length,
// // //                                 itemBuilder: (context, index) {
// // //                                   final property = _filteredProperties[index];
// // //                                   print("Displaying property: ${property.name}");  // Debugging line
// // //                                   return Card(
// // //                                     margin: const EdgeInsets.symmetric(vertical: 8.0),
// // //                                     child: ListTile(
// // //                                       leading: Image.network(property.image, width: 50, height: 50, fit: BoxFit.cover),
// // //                                       title: Text(property.name),
// // //                                       subtitle: Text('Type: ${property.type}'),
// // //                                       trailing: Text('₹${property.price}/night'),
// // //                                       onTap: () {
// // //                                         // Navigate to the ListingPage and pass the selected property
// // //                                         Navigator.push(
// // //                                           context,
// // //                                           MaterialPageRoute(
// // //                                             builder: (context) => ListingPage(property: property),
// // //                                           ),
// // //                                         );
// // //                                       },
// // //                                     ),
// // //                                   );
// // //                                 },
// // //                               ),
// // //                             ),
// // //                             Padding(
// // //                               padding: const EdgeInsets.all(8.0),
// // //                               child: Column(
// // //                                 children: [
// // //                                   const Text("Sort:", style: TextStyle(fontSize: 18)),
// // //                                   Row(
// // //                                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // //                                     children: [
// // //                                       ElevatedButton(
// // //                                         onPressed: () {
// // //                                           setState(() {
// // //                                             _filteredProperties.sort((a, b) => a.price.compareTo(b.price)); // Lowest to highest
// // //                                           });
// // //                                         },
// // //                                         child: const Text('Price: Low to High'),
// // //                                       ),
// // //                                       ElevatedButton(
// // //                                         onPressed: () {
// // //                                           setState(() {
// // //                                             _filteredProperties.sort((a, b) => b.price.compareTo(a.price)); // Highest to lowest
// // //                                           });
// // //                                         },
// // //                                         child: const Text('Price: High to Low'),
// // //                                       ),
// // //                                     ],
// // //                                   ),
// // //                                 ],
// // //                               ),
// // //                             ),
// // //                           ],
// // //                         ),
// // //                       ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:jwt_decoder/jwt_decoder.dart'; // For decoding JWT tokens
// import 'property_listing.dart';

// class Property {
//   final String? name;
//   final String? address;
//   final String? state;
//   final String? city;
//   final String? pincode;
//   final String? landmark;
//   final double? price;
//   final String? phoneNumber;
//   final List<String>? images; // List of image URLs
//   final List<String>? amenities; // List of amenities

//   Property({
//     this.name,
//     this.address,
//     this.state,
//     this.city,
//     this.pincode,
//     this.landmark,
//     this.price,
//     this.phoneNumber,
//     this.images,
//     this.amenities,
//   });

//   // Factory method to create a Property object from a Map
//   factory Property.fromMap(Map<String, dynamic> map) {
//     return Property(
//       name: map['name']?.toString(),
//       address: map['address']?.toString(),
//       state: map['state']?.toString(),
//       city: map['city']?.toString(),
//       pincode: map['pincode']?.toString(),
//       landmark: map['Landmark']?.toString(),
//       price: map['price']?.toDouble(),
//       phoneNumber: map['phno']?.toString(),
//       images: map['images'] != null ? List<String>.from(map['images']) : [],
//       amenities: map['amenities'] != null ? List<String>.from(map['amenities']) : [],
//     );
//   }
// }

// class SearchPage extends StatefulWidget {
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   List<Property> propertyList = [];
//   bool isLoading = true;
//   String errorMessage = "";

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   // Function to decode the JWT token and extract email
//   Future<String?> _getEmailFromToken() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('jwt_token');
//       print("Stored token: $token");

//       if (token == null) {
//         setState(() {
//           errorMessage = "Token not found!";
//         });
//         return null;
//       }

//       if (JwtDecoder.isExpired(token)) {
//         setState(() {
//           errorMessage = "Token is expired!";
//         });
//         return null;
//       }

//       Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
//       print("Decoded Token: $decodedToken");
//       return decodedToken['email'];
//     } catch (e) {
//       setState(() {
//         errorMessage = "Error decoding token: $e";
//       });
//       return null;
//     }
//   }

//   // Function to fetch all property listings
//   Future<void> fetchPropertyListings() async {
//     try {
//       final url = Uri.parse('http://192.168.159.119:5000/allListings'); // Updated URL

//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = jsonDecode(response.body);

//         if (responseData['status'] == 'accommodation list') {
//           setState(() {
//             // Combine all properties (hotels, PGs, and rentals) into one list
//             propertyList = List<Property>.from(responseData['data'].map((item) => Property.fromMap(item)));
//           });
//         } else {
//           setState(() {
//             errorMessage = responseData['message'] ?? "Failed to fetch data!";
//           });
//         }
//       } else {
//         setState(() {
//           errorMessage = "HTTP Error: ${response.statusCode}";
//         });
//       }
//     } catch (error) {
//       setState(() {
//         errorMessage = "Network Error: $error";
//       });
//     }
//   }

//   // Wrapper function to fetch data
//   Future<void> fetchData() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = "";
//     });

//     // Call the function to fetch property listings
//     await fetchPropertyListings();

//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(70), // Set the height of the AppBar
//         child: AppBar(
//           title: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: const [
//               Text(
//                 "Property list",
//                 style: TextStyle(color: Colors.white, fontSize: 25),
//               ),
//             ],
//           ),
//           centerTitle: true,
//           backgroundColor: Colors.black,
//           elevation: 4.0,
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
//           ),
//           iconTheme: const IconThemeData(color: Colors.white), // Makes the arrow white
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : errorMessage.isNotEmpty
//                 ? Center(
//                     child: Text(
//                       errorMessage,
//                       style: const TextStyle(color: Colors.red, fontSize: 16),
//                     ),
//                   )
//                 : propertyList.isEmpty
//                     ? const Center(
//                         child: Text(
//                           "No properties found",
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                         ),
//                       )
//                     : ListView.builder(
//                         itemCount: propertyList.length,
//                         itemBuilder: (context, index) {
//                           final property = propertyList[index];

//                           return Card(
//                             margin: const EdgeInsets.symmetric(vertical: 8.0),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                             ),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                   color: Colors.grey, // Border color
//                                   width: 1.0, // Border width
//                                 ),
//                                 borderRadius: BorderRadius.circular(8.0), // Rounded corners for the border
//                               ),
//                               child: ListTile(
//                                 contentPadding: const EdgeInsets.all(12.0),
//                                 leading: const Icon(
//                                   Icons.home,
//                                   size: 40,
//                                   color: Colors.black,
//                                 ),
//                                 title: Text(
//                                   property.name ?? 'Unnamed Property',
//                                   style: const TextStyle(
//                                     fontSize: 25,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 subtitle: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       property.address ?? 'Unknown Location',
//                                       style: const TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.w500,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                     Text(
//                                       property.city ?? 'Unknown City',
//                                       style: const TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w400,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 trailing: Text(
//                                   property.price != null
//                                       ? '\$${property.price!.toStringAsFixed(2)}\n/night'
//                                       : 'Price not available',
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => ListingPage(
//                                         listing: property,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'mock.dart';
import 'property_listing.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Controller for search input
  TextEditingController _searchController = TextEditingController();

  // List to store filtered properties based on search
  List<Property> _filteredProperties = mockProperties;

  // Function to filter properties based on search input
  void _filterProperties() {
    setState(() {
      _filteredProperties = mockProperties.where((property) {
        return property.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            property.city.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            property.description.toLowerCase().contains(_searchController.text.toLowerCase());
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Properties'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search input field
            TextField(
              controller: _searchController,
              onChanged: (value) => _filterProperties(),
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            // Display filtered properties in a ListView
            Expanded(
              child: ListView.builder(
                itemCount: _filteredProperties.length,
                itemBuilder: (context, index) {
                  final property = _filteredProperties[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Image.asset(property.image, width: 50, height: 50, fit: BoxFit.cover),
                      title: Text(property.name),
                      subtitle: Text(property.city),
                      trailing: Text('₹${property.price}/night'),
                      onTap: () {
                        // Navigate to the property listing page and pass the property object
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListingPage(property: property),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
