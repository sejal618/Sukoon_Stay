// import 'package:flutter/material.dart';
// import 'mock.dart';   
// import 'chat.dart';   
// import 'book.dart';   


// class ListingPage extends StatelessWidget {
//   final Property listing;  // Declare the property that is passed from SearchPage

//   // Constructor to accept the property
//   ListingPage({required this.listing});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('Property Details'),
//         backgroundColor: Colors.black,
//       ),
//       body: SingleChildScrollView( // To make the content scrollable if necessary
//         child: Column(
//           children: [
//             Card(
//               margin: const EdgeInsets.all(10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Property Image with fallback error handling
//                   Image.network(
//                     listing.image,
//                     fit: BoxFit.cover,
//                     width: double.infinity,
//                     height: 250,
//                     errorBuilder: (context, error, stackTrace) {
//                       return const Center(child: Icon(Icons.error, size: 50));
//                     },
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Property Name
//                         Text(
//                           listing.name,
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                         const SizedBox(height: 8),

//                         // Property Description
//                         Text(
//                           listing.description,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.black,
//                           ),
//                         ),
//                         const SizedBox(height: 24),

//                         // Address Section
//                         const Text(
//                           'Address',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           listing.address,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.black,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           listing.city,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           '${listing.state} - ${listing.pincode}',
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         const SizedBox(height: 24),

//                         // Amenities Section
//                         const Text(
//                           'Amenities',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: listing.amenities
//                               .map((amenity) => Padding(
//                                     padding: const EdgeInsets.only(bottom: 6),
//                                     child: Text(
//                                       '• $amenity',
//                                       style: const TextStyle(
//                                         fontSize: 16,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                   ))
//                               .toList(),
//                         ),
//                         const SizedBox(height: 24),

//                         // Reviews Section
//                         const Text(
//                           'Reviews',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: listing.reviews.map((review) {
//                             return Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 8),
//                               child: Card(
//                                 color: Colors.grey[100],
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(12),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       // Display the reviewer's name
//                                       Text(
//                                         review.user,
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 16,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       // Display the review text
//                                       Text(
//                                         review.review,
//                                         style: const TextStyle(fontSize: 14, color: Colors.grey),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                         const SizedBox(height: 24),

//                         // Host Section
//                         const Text(
//                           'Host Information',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         // Hardcoded Host Info
//                         const Text(
//                           'Host: John Doe',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.black,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         const Text(
//                           'Experience: 5+ years in the hospitality industry',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         const SizedBox(height: 24),

//                         // Chat with Host Button
//                         ElevatedButton(
//                           onPressed: () {
//                             // Navigate to chat screen
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => ChatPage()),
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.black,
//                             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                           ),
//                           child: const Text(
//                             'Chat with Host',
//                             style: TextStyle(color: Colors.white, fontSize: 16),
//                           ),
//                         ),
//                         const SizedBox(height: 24),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Display Price and Book Now Button at the bottom
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // Display Price from the property
//                   Text(
//                     '₹${listing.price} / night',
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   // Book Now Button
//                   ElevatedButton(
//                     onPressed: () {
//                       // Navigate to book screen
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => BookPage(property: listing),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                     ),
//                     child: const Text(
//                       'Book Now',
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:classico/pages/payment.dart';
import 'package:flutter/material.dart';
import 'mock.dart'; // Import your mock.dart file
import 'chat.dart';
import 'book.dart';

class ListingPage extends StatelessWidget {
  final Property property;

  const ListingPage({Key? key, required this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(property.name),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display property image
            Image.asset(
              property.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property Name
                  Text(
                    property.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Property Description
                  Text(
                    property.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Address Section
                  const Text(
                    'Address',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    property.address,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    property.city,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${property.state} - ${property.pincode}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Amenities Section
                  const Text(
                    'Amenities',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: property.amenities
                        .map((amenity) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                '• $amenity',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),

                  // Reviews Section
                  const Text(
                    'Reviews',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: property.reviews.map((review) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Card(
                          color: Colors.grey[100],
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Display the reviewer's name
                                Text(
                                  review.user,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Display the review text
                                Text(
                                  review.review,
                                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Host Section
                  const Text(
                    'Host Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Hardcoded Host Info
                  const Text(
                    'Host: John Doe',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Experience: 5+ years in the hospitality industry',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Chat with Host Button
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to chat screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'Chat with Host',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Booking Section
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Display Price
            Text(
              '₹${property.price} / night',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            // Book Now Button
            ElevatedButton(
              onPressed: () {
                // Navigate to book screen with the current property
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookPage(property: property),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Book Now',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
