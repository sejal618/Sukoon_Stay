// class Property {
//   final String name;
//   final String description;
//   final String image;
//   final String address;
//   final String city;
//   final String state;
//   final String pincode;
//   final List<String> amenities;
//   final List<Review> reviews;
//   final int price;
//   final String? type; // Optional type field

//   Property({
//     required this.name,
//     required this.description,
//     required this.image,
//     required this.address,
//     required this.city,
//     required this.state,
//     required this.pincode,
//     required this.amenities,
//     required this.reviews,
//     required this.price,
//     this.type,  // Optional field for the type
//   });

//   factory Property.fromJson(Map<String, dynamic> json) {
//     return Property(
//       name: json['name'],
//       description: json['description'],
//       image: json['image'],
//       address: json['address'],
//       city: json['city'],
//       state: json['state'],
//       pincode: json['pincode'],
//       amenities: List<String>.from(json['amenities']),
//       reviews: (json['reviews'] as List)
//           .map((reviewJson) => Review.fromJson(reviewJson))
//           .toList(),
//       price: json['price'],
//     );
//   }

//   // Method to create a copy of the property with a new type
//   Property copyWith({String? type}) {
//     return Property(
//       name: this.name,
//       description: this.description,
//       image: this.image,
//       address: this.address,
//       city: this.city,
//       state: this.state,
//       pincode: this.pincode,
//       amenities: this.amenities,
//       reviews: this.reviews,
//       price: this.price,
//       type: type ?? this.type,  // Preserve existing type if no new type is provided
//     );
//   }
// }

// class Review {
//   final String user;
//   final String review;

//   Review({required this.user, required this.review});

//   factory Review.fromJson(Map<String, dynamic> json) {
//     return Review(
//       user: json['user'],
//       review: json['review'],
//     );
//   }
// }


// class Host {
//   final String id;
//   final String name;
//   final String email;
//   final String phone;

//   // Constructor
//   Host({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.phone,
//   });

//   // Factory constructor to create a Host object from JSON data
//   factory Host.fromJson(Map<String, dynamic> json) {
//     return Host(
//       id: json['id'],
//       name: json['name'],
//       email: json['email'],
//       phone: json['phone'],
//     );
//   }

//   // Convert Host object to JSON if needed for any API requests or saving data
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'email': email,
//       'phone': phone,
//     };
//   }

//   // Optionally add a copyWith method for updating instances
//   Host copyWith({
//     String? id,
//     String? name,
//     String? email,
//     String? phone,
//   }) {
//     return Host(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       email: email ?? this.email,
//       phone: phone ?? this.phone,
//     );
//   }
// }

// class Booking {
//   final String id;
//   final String propertyId;
//   final String propertyType;
//   final String name;
//   final String phone;
//   final DateTime from; // Check-in date
//   final DateTime to;   // Check-out date
//   final int adults;
//   final int children;
//   final int rooms;
//   final String email;

//   Booking({
//     required this.id,
//     required this.propertyId,
//     required this.propertyType,
//     required this.name,
//     required this.phone,
//     required this.from,
//     required this.to,
//     required this.adults,
//     required this.children,
//     required this.rooms,
//     required this.email,
//   });

//   factory Booking.fromJson(Map<String, dynamic> json) {
//     return Booking(
//       id: json['_id'],
//       propertyId: json['propertyId'],
//       propertyType: json['propertyType'],
//       name: json['Name'],
//       phone: json['phone'],
//       from: DateTime.parse(json['dates']['from']),
//       to: DateTime.parse(json['dates']['to']),
//       adults: json['adults'],
//       children: json['children'] ?? 0,
//       rooms: json['rooms'],
//       email: json['email'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'propertyId': propertyId,
//       'propertyType': propertyType,
//       'Name': name,
//       'phone': phone,
//       'dates': {
//         'from': from.toIso8601String(),
//         'to': to.toIso8601String(),
//       },
//       'adults': adults,
//       'children': children,
//       'rooms': rooms,
//       'email': email,
//     };
//   }
// }


// mock.dart
class Property {
  final int id;
  final String name;
  final String image;
  final String description;
  final int price;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String landmark;
  final List<String> amenities;
  final List<Review> reviews;

  Property({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.landmark,
    required this.amenities,
    required this.reviews,
  });
}

class Review {
  final String user;
  final String review;

  Review({
    required this.user,
    required this.review,
  });
}

// List of properties (mock data with updated Indian addresses)
final List<Property> mockProperties = [
  Property(
    id: 1,
    name: "Cozy Apartment in the City Center",
    image: "assets/images/images/logo.jpeg",
    description: "Enjoy a stylish experience at this centrally-located place. The apartment is equipped with modern amenities.",
    price: 5000,
    address: "123 City Center Street, MG Road",
    city: "Bangalore",
    state: "Karnataka",
    pincode: "560001",
    landmark: "Cubbon Park",
    amenities: ["Wi-Fi", "Air Conditioning", "Kitchen", "Washer", "Dryer"],
    reviews: [
      Review(user: "John Doe", review: "Great location and very clean! Highly recommend staying here."),
      Review(user: "Jane Smith", review: "The apartment was cozy and had all the amenities we needed. Fantastic experience!"),
    ],
  ),
  Property(
    id: 2,
    name: "Beachfront Villa with Ocean View",
    image: "assets/images/images/logo.jpeg",
    description: "Relax in this beautiful beachfront villa with a stunning view of the ocean.",
    price: 12000,
    address: "456 Ocean Blvd, Beach Road",
    city: "Goa",
    state: "Goa",
    pincode: "403004",
    landmark: "Calangute Beach",
    amenities: ["Wi-Fi", "Pool", "Beach Access", "Air Conditioning"],
    reviews: [
      Review(user: "Mike Johnson", review: "Amazing property with the best view of the ocean! Highly recommend."),
      Review(user: "Emily Rose", review: "A perfect getaway! The villa was beautiful and well-maintained."),
    ],
  ),
  Property(
    id: 3,
    name: "Mountain Retreat with Fireplace",
    image: "assets/images/images/logo.jpeg",
    description: "A perfect mountain retreat with a cozy fireplace to unwind after a long day of hiking.",
    price: 8000,
    address: "789 Mountain Road, Mall Road",
    city: "Shimla",
    state: "Himachal Pradesh",
    pincode: "171001",
    landmark: "The Ridge",
    amenities: ["Wi-Fi", "Fireplace", "Hot Tub", "Kitchen", "Pet-Friendly"],
    reviews: [
      Review(user: "Chris White", review: "A peaceful getaway with stunning views of the mountains. Highly recommend!"),
      Review(user: "Sarah Green", review: "Loved the fireplace, perfect for a winter retreat. Will definitely return!"),
    ],
  ),
  Property(
    id: 4,
    name: "Luxurious Penthouse in the Heart of the City",
    image: "assets/images/images/logo.jpeg",
    description: "This luxurious penthouse offers the best city views, with modern amenities and high-end furnishings.",
    price: 25000,
    address: "101 Skyline Tower, Connaught Place",
    city: "Delhi",
    state: "Delhi",
    pincode: "110001",
    landmark: "India Gate",
    amenities: ["Pool", "Gym", "Wi-Fi", "Air Conditioning", "24/7 Security"],
    reviews: [
      Review(user: "Daniel Harris", review: "Absolutely loved this place! The views were breathtaking and the amenities were top-notch."),
      Review(user: "Olivia Baker", review: "The penthouse was even better than expected. Perfect for a city stay!"),
    ],
  ),
  Property(
    id: 5,
    name: "Charming Countryside Cottage",
    image: "assets/images/images/logo.jpeg",
    description: "Escape to the countryside and enjoy a charming cottage surrounded by nature and tranquility.",
    price: 6000,
    address: "123 Countryside Lane, Village Road",
    city: "Coorg",
    state: "Karnataka",
    pincode: "571201",
    landmark: "Abbey Falls",
    amenities: ["Wi-Fi", "Garden", "Pet-Friendly", "Barbecue", "Parking"],
    reviews: [
      Review(user: "Nathan Black", review: "A beautiful and peaceful place to relax. Perfect for a weekend retreat."),
      Review(user: "Emma White", review: "The cottage was so cozy, and the surrounding nature made the stay even more enjoyable."),
    ],
  ),
  Property(
    id: 6,
    name: "Modern Loft in the Arts District",
    image: "assets/images/images/logo.jpeg",
    description: "A spacious loft in the vibrant arts district, featuring contemporary design and close proximity to galleries and cafes.",
    price: 7000,
    address: "321 Arts Avenue, Kala Ghoda",
    city: "Mumbai",
    state: "Maharashtra",
    pincode: "400001",
    landmark: "Gateway of India",
    amenities: ["Wi-Fi", "Smart TV", "Washer", "Dryer", "Coffee Maker"],
    reviews: [
      Review(user: "David Brown", review: "Amazing loft! Perfect location for anyone interested in arts and culture."),
      Review(user: "Jessica Gray", review: "Modern and stylish! The location was very convenient for exploring the city."),
    ],
  ),
  Property(
    id: 7,
    name: "Rustic Farmhouse with Large Yard",
    image: "assets/images/images/logo.jpeg",
    description: "A charming farmhouse located in the countryside, ideal for family gatherings with plenty of outdoor space.",
    price: 5000,
    address: "654 Farm Road, Village",
    city: "Pune",
    state: "Maharashtra",
    pincode: "411033",
    landmark: "Sinhagad Fort",
    amenities: ["Wi-Fi", "Garden", "BBQ Grill", "Parking", "Playground"],
    reviews: [
      Review(user: "Megan Clark", review: "Perfect place for a family vacation! Lots of space and great amenities."),
      Review(user: "Jake Adams", review: "Loved the outdoor activities and peaceful environment. Would definitely stay again."),
    ],
  ),
  Property(
    id: 8,
    name: "Secluded Cabin in the Woods",
    image: "assets/images/images/logo.jpeg",
    description: "A secluded cabin in the woods, perfect for those seeking peace and privacy amidst nature.",
    price: 9000,
    address: "852 Woodland Trail, Pine Hills",
    city: "Nainital",
    state: "Uttarakhand",
    pincode: "263001",
    landmark: "Naini Lake",
    amenities: ["Fireplace", "Wi-Fi", "BBQ Grill", "Parking", "Pet-Friendly"],
    reviews: [
      Review(user: "Samuel Lee", review: "Such a peaceful retreat, ideal for disconnecting from the world."),
      Review(user: "Laura King", review: "Loved the rustic charm of the cabin. Perfect for a weekend getaway."),
    ],
  ),
  Property(
    id: 9,
    name: "Luxury Condo with City Views",
    image: "assets/images/images/logo.jpeg",
    description: "A luxurious condo offering breathtaking city views, with all modern amenities and easy access to city attractions.",
    price: 18000,
    address: "987 City Heights, MG Road",
    city: "Chennai",
    state: "Tamil Nadu",
    pincode: "600001",
    landmark: "Marina Beach",
    amenities: ["Pool", "Wi-Fi", "Gym", "24/7 Security", "Smart Home Features"],
    reviews: [
      Review(user: "Paul Walker", review: "Amazing views and perfect location! Great amenities and very secure."),
      Review(user: "Samantha Green", review: "Loved the luxury feel and the convenience of being close to everything."),
    ],
  ),
  Property(
    id: 10,
    name: "Chic Apartment with Balcony",
    image: "assets/images/images/logo.jpeg",
    description: "A stylish apartment with a private balcony offering great views of the city.",
    price: 7500,
    address: "741 Skyline Avenue, Bandra",
    city: "Mumbai",
    state: "Maharashtra",
    pincode: "400050",
    landmark: "Bandra-Worli Sea Link",
    amenities: ["Wi-Fi", "Air Conditioning", "Balcony", "Elevator", "Smart TV"],
    reviews: [
      Review(user: "Nina Lopez", review: "Cozy apartment with a beautiful view! Highly recommend."),
      Review(user: "John White", review: "Great location and comfortable amenities. Perfect for a weekend stay."),
    ],
  ),
  Property(
    id: 11,
    name: "Suncity APT",
    image: "assets/images/images/logo.jpeg",
    description: "It's a nice place.",
    price: 11000,
    address: "123 Sikar Road",
    city: "Jaipur",
    state: "Rajasthan",
    pincode: "302013",
    landmark: "IIIT Raichur",
    amenities: ["Wi-Fi", "Air Conditioning", "Heating", "Parking", "Valet"],
    reviews: [
      Review(user: "Sophie Turner", review: "Great for families! Loved the spacious backyard and quiet neighborhood."),
      Review(user: "Ben Ross", review: "Wonderful home with all the amenities. Perfect for a family vacation."),
    ],
  ),
];
