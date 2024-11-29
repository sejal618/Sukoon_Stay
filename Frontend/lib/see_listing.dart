import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; // For decoding JWT tokens
import 'Complete_listing.dart';

class Property {
  final String? name;
  final String? address;
  final String? state;
  final String? city;
  final String? pincode;
  final String? landmark;
  final double? price;
  final String? phoneNumber;
  final List<String>? images; // List of image URLs
  final List<String>? amenities; // List of amenities

  Property({
    this.name,
    this.address,
    this.state,
    this.city,
    this.pincode,
    this.landmark,
    this.price,
    this.phoneNumber,
    this.images,
    this.amenities,
  });

  // Factory method to create a Property object from a Map
  factory Property.fromMap(Map<String, dynamic> map) {
  return Property(
    name: map['name']?.toString(), // Safely convert to String
    address: map['address']?.toString(), // Safely convert to String
    state: map['state']?.toString(), // Safely convert to String
    city: map['city']?.toString(), // Safely convert to String
    pincode: map['pincode']?.toString(), // Convert to String
    landmark: map['Landmark']?.toString(), // Ensure key is correct and convert
    price: map['price']?.toDouble(), // Convert to double if it's a number
    phoneNumber: map['phno']?.toString(), // Convert phone number to String
    images: map['images'] != null ? List<String>.from(map['images']) : [], // Safely convert images list
    amenities: map['amenities'] != null ? List<String>.from(map['amenities']) : [], // Safely convert amenities list
  );
}

}

class PropertyListScreen extends StatefulWidget {
  @override
  _PropertyListScreenState createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  List<Property> propertyList = [];
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Function to decode the JWT token and extract email
  Future<String?> _getEmailFromToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token'); // Ensure the key matches where you save the token.
      print("Stored token: $token");

      if (token == null) {
        setState(() {
          errorMessage = "Token not found!";
        });
        return null;
      }

      if (JwtDecoder.isExpired(token)) {
        setState(() {
          errorMessage = "Token is expired!";
        });
        return null;
      }

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      print("Decoded Token: $decodedToken"); // Log the decoded token for inspection
      return decodedToken['email']; // Assuming 'email' is the correct key for email in the JWT payload.
    } catch (e) {
      setState(() {
        errorMessage = "Error decoding token: $e"; // Handle decoding errors
      });
      return null;
    }
  }

  // Function to fetch user listings
  Future<void> fetchUserListings(String email) async {
    try {
      // Use a single endpoint `/userListings` as defined in your Node.js code
      final url = Uri.parse('http://192.168.159.119:5000/userListings?email=$email'); // Ensure URL matches your backend.

      // Send GET request to the backend
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == 'ok') {
          setState(() {
            propertyList = List<Property>.from(responseData['data'].map((item) => Property.fromMap(item)));
          });
        } else {
          setState(() {
            errorMessage = responseData['message'] ?? "Failed to fetch data!"; // Customize error message for API responses.
          });
        }
      } else {
        setState(() {
          errorMessage = "HTTP Error: ${response.statusCode}"; // Customize HTTP error handling.
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = "Network Error: $error"; // Handle network errors gracefully.
      });
    }
  }

  // Wrapper function to fetch data
  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    // Get email from token
    String? email = await _getEmailFromToken();
    if (email == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Call the function to fetch user listings
    await fetchUserListings(email);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: PreferredSize(
  preferredSize: const Size.fromHeight(70), // Set the height of the AppBar
  child: AppBar(
    title: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          "Property list",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ],
    ),
    centerTitle: true,
    backgroundColor: Colors.black,
    elevation: 4.0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
    ),
    iconTheme: const IconThemeData(color: Colors.white), // Makes the arrow white
  ),
),
body: Padding(
  padding: const EdgeInsets.all(16.0),
  child: isLoading
      ? const Center(child: CircularProgressIndicator())
      : errorMessage.isNotEmpty
          ? Center(
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            )
          : propertyList.isEmpty
              ? const Center(
                  child: Text(
                    "No properties found",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
              : ListView.builder(
                  itemCount: propertyList.length,
                  itemBuilder: (context, index) {
                    final property = propertyList[index]; // Directly use the Property object

                 return Card(
  margin: const EdgeInsets.symmetric(vertical: 8.0),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),
  child: Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.grey, // Border color
        width: 1.0, // Border width
      ),
      borderRadius: BorderRadius.circular(8.0), // Rounded corners for the border
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.all(12.0),
      leading: const Icon(
        Icons.home,
        size: 40,
        color: Colors.black,
      ),
      title: Text(
        property.name ?? 'Unnamed Property', // Use the `name` from the `Property` object
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.black, // Highlight the name with a color
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            property.address ?? 'Unknown Location', // Use the `address` from the `Property` object
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500, // Slightly bolder to make it noticeable
              color: Colors.grey, // Subtle color for the address
            ),
          ),
          Text(
            property.city ?? 'Unknown City', // Display the city if available
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.grey, // Subtle color for the city
            ),
          ),
        ],
      ),
      trailing: Text(
        property.price != null
            ? '\$${property.price!.toStringAsFixed(2)}\n/night' // Display price per night
            : 'Price not available', // Default text if price is null
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black, // Price color
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompleteListingPage(
              listing: property, // Pass the Property object directly
            ),
          ),
        );
      },
    ),
  ),
);

                  },
                ),
),
    );
  }
}