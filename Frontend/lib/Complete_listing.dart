import 'package:flutter/material.dart';
import 'see_listing.dart';
import 'Host_account.dart';

class CompleteListingPage extends StatelessWidget {
  final Property listing; // Accept the listing object from the previous screen

  const CompleteListingPage({Key? key, required this.listing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set the background color to black
      appBar: AppBar(
        title: const Text('Listing Details', style:TextStyle(color : Colors.white)),
        backgroundColor: Colors.black, // Dark grey for the app bar
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Listing Image Section
              listing.images?.isNotEmpty == true
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        listing.images![0], // Display the first image
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 250,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Icon(Icons.error, size: 50, color: Colors.white));
                        },
                      ),
                    )
                  : Container(
                      height: 250,
                      color: Colors.grey[700],
                      child: const Icon(Icons.error, size: 50, color: Colors.white),
                    ),
              
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Listing Name
                    Text(
                      listing.name ?? 'No Name Provided',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // White text for better visibility
                      ),
                    ),
                    const SizedBox(height: 8),

                    const SizedBox(height: 24),

                    // Address Section
                    const Text(
                      'Address',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      listing.address ?? 'Address not available',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      listing.city ?? 'City not available',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${listing.state ?? "State not available"} - ${listing.pincode ?? "Pincode not available"}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),

                    // Amenities Section
                    const Text(
                      'Amenities',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (listing.amenities ?? [])
                          .map((amenity) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle, color: Colors.green, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      amenity,
                                      style: const TextStyle(fontSize: 16, color: Colors.white), // White text
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 24),

                    // Reviews Section
                    const Text(
                      'Reviews',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    // Reviews code commented out, you can enable this as needed

                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Price and Booking Section
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[900], // Dark grey background for the price section
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price
                    Text(
                      '₹${listing.price?.toStringAsFixed(2) ?? "0.00"} / night',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    // Book Now Button
                    ElevatedButton(
                      onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AddListingPage()),
  );
},

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey, // Button color
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        'Edit',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
