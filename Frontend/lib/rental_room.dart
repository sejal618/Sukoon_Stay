import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Rental_listing extends StatefulWidget 
{
  const Rental_listing({super.key});

  @override
  State<Rental_listing> createState() => _Rental_listingPageState();
}

class _Rental_listingPageState extends State<Rental_listing> {
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];
  List<String> _customAmenities = []; // List to store custom entries
  bool _showTextField = false; // Flag to show or hide TextField
  final TextEditingController _customAmenityController =
      TextEditingController();

  final List<Map<String, dynamic>> _amenitySections = [
    {"title": "Basic Amenities", "icon": Icons.home},
    {"title": "Food and Kitchen Facilities", "icon": Icons.kitchen},
    {"title": "Connectivity and Technology", "icon": Icons.wifi},
    {"title": "Comfort and Lifestyle Facilities", "icon": Icons.favorite},
    {"title": "Safety and Security", "icon": Icons.security},
    {"title": "Transportation and Parking", "icon": Icons.directions_car},
    {"title": "Hygiene and Sanitation", "icon": Icons.cleaning_services},
    {
      "title": "Social and Recreational Facilities",
      "icon": Icons.sports_esports
    },
    {
      "title": "Additional Services (for Premium Options)",
      "icon": Icons.local_hospital
    },
    {"title": "Pet-Friendly Accommodation", "icon": Icons.pets},
  ];

  final List<List<String>> _amenities = [
    ["Furnished Rooms", "Air Conditioning (AC)", "Heating", "Fan", "Lighting"],
    ["Meals Provided", "Kitchen Access", "Refrigerator", "Microwave/Oven"],
    ["Wi-Fi/Internet Access", "TV", "Power Backup", "Smart Access/Keys"],
    ["Laundry Services", "Iron", "Common Lounge", "Gym/Fitness Room"],
    ["24/7 Security", "First-Aid Kits", "Fire Safety"],
    ["Parking", "Transport Services", "Cycle Rentals"],
    ["Purified Drinking Water", "Sanitary Waste Disposal"],
    ["Games Room", "Outdoor Space", "Community Events"],
    ["Concierge Service", "Room Service", "Medical Assistance"],
    ["Pet Care Areas", "Pet Sitting Services"],
  ];

  late List<List<bool>> _checkboxValues =
      _amenities.map((section) => List.filled(section.length, false)).toList();

  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _selectedImages = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  Future<void> submitData() async {
    // Collect selected amenities
    final selectedAmenities = <String>[];
    for (var i = 0; i < _checkboxValues.length; i++) {
      for (var j = 0; j < _checkboxValues[i].length; j++) {
        if (_checkboxValues[i][j]) {
          selectedAmenities.add(_amenities[i][j]);
        }
      }
    }

    var prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt_token')!;
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String Token=decodedToken['email'];
  
    print(Token);

    // Collect form data
    final dataToSend = {
      "name": _propertyNameController.text,
      "address": _addressController.text,
      "Landmark": _landmarkController.text,
      "pincode": _pincodeController.text,
      "city": _cityController.text,
      "state": _stateController.text,
      "country": _countryController.text,
      "phno": _contactNumberController.text,
      "price": _priceController.text,
      "amenities": selectedAmenities,
      // "customAmenities": _customAmenities,
      "images": _selectedImages.map((image) => image.path).toList(),
      "email": Token,
    };

    // Sending data to Node.js server
    const url = 'http://192.168.159.119:5000/RentalRegister';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(dataToSend),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Listing submitted successfully")),
        );
      } else {
        throw Exception('Failed to submit listing');
      }
    } catch (e) {
      print("Error submitting listing: $e");
    }
  }
  final _formKey = GlobalKey<FormState>();

  // Controllers for each input field
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _propertyNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Add listener to pincode controller to detect changes
    _pincodeController.addListener(_fetchCityFromPincode);
  }

  // Function to fetch city based on pincode
  void _fetchCityFromPincode() async {
    String pincode = _pincodeController.text;

    // Clear the autofill fields if the pincode length is less than 6
    if (pincode.length < 6) {
      setState(() {
        _cityController.clear();
        _stateController.clear();
        _countryController.clear();
      });
      return; // No need to proceed if pincode is incomplete
    }

    // Make sure pincode has 6 digits before making the request
    if (pincode.length == 6) {
      final url = Uri.parse('https://api.postalpincode.in/pincode/$pincode');

      try {
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          print(data);
          if (data[0]['Status'] == 'Success') {
            print("done");
            // Assuming the first PostOffice entry has the necessary information
            final postOffice = data[0]['PostOffice'][0];
            setState(() {
              _cityController.text = postOffice['District'];
              _stateController.text = postOffice['State'];
              _countryController.text = 'India'; // Since this API is for India
            });
          } else {
            _showError('Invalid pincode');
            // Clear the autofill fields in case of an invalid pincode
            setState(() {
              _cityController.clear();
              _stateController.clear();
              _countryController.clear();
            });
          }
        } else {
          _showError('Error fetching location data');
        }
      } catch (error) {
        _showError('Failed to connect to location service');
      }
    }
  }

  // Helper method to show an error message
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
          "List your property",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        Text(
          "(Rental)",
          style: TextStyle(color: Colors.white, fontSize: 22),
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


body:
Padding(
  padding: const EdgeInsets.all(16.0),
  child: SingleChildScrollView(
    child: Column(
      children: [
        ElevatedButton.icon(
          onPressed: _pickImages,
          icon: const Icon(Icons.add_a_photo),
          label: const Text(
            "Add Images",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (_selectedImages.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedImages.map((image) {
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(image, width: 100, height: 100, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _selectedImages.remove(image);
                        });
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Please fill out your location details',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _addressController,
                          decoration: const InputDecoration(
                            labelText: 'Address',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _landmarkController,
                          decoration: const InputDecoration(
                            labelText: 'Landmark',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a landmark';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _pincodeController,
                                decoration: const InputDecoration(
                                  labelText: 'Pincode',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your pincode';
                                  }
                                  if (value.length != 6) {
                                    return 'Pincode should be 6 digits';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _cityController,
                                decoration: const InputDecoration(
                                  labelText: 'City',
                                  border: OutlineInputBorder(),
                                ),
                                readOnly: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _stateController,
                                decoration: const InputDecoration(
                                  labelText: 'State',
                                  border: OutlineInputBorder(),
                                ),
                                readOnly: true,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _countryController,
                                decoration: const InputDecoration(
                                  labelText: 'Country',
                                  border: OutlineInputBorder(),
                                ),
                                readOnly: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Other Details',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _propertyNameController,
                    decoration: const InputDecoration(
                      labelText: 'Property Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the property name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _contactNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Contact Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a contact number';
                      }
                      if (value.length != 10) {
                        return 'Contact number should be 10 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price/night',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the price';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _amenitySections.length,
          itemBuilder: (context, sectionIndex) {
            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        _amenitySections[sectionIndex]['icon'],
                        color: Colors.blue,
                      ),
                      title: Text(
                        _amenitySections[sectionIndex]['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...List.generate(
                      _amenities[sectionIndex].length,
                      (itemIndex) {
                        return CheckboxListTile(
                          activeColor: Colors.blue,
                          title: Text(_amenities[sectionIndex][itemIndex]),
                          value: _checkboxValues[sectionIndex][itemIndex],
                          onChanged: (value) {
                            setState(() {
                              _checkboxValues[sectionIndex][itemIndex] = value!;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        // Additional amenities section
        SizedBox(
          width: 500,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Add something extra", style: TextStyle(fontSize: 18)),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.blue),
                onPressed: () {
                  setState(() {
                    _showTextField = true;
                  });
                },
              ),
            ],
          ),
        ),
        if (_showTextField)
          SizedBox(
            width: 500,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customAmenityController,
                    decoration: const InputDecoration(hintText: "Enter amenity"),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  onPressed: () {
                    setState(() {
                      if (_customAmenityController.text.isNotEmpty) {
                        _customAmenities.add(_customAmenityController.text);
                        _customAmenityController.clear();
                      }
                      _showTextField = false;
                    });
                  },
                ),
              ],
            ),
          ),
        const SizedBox(height: 10),
        // Display custom amenities
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _customAmenities.map((customAmenity) {
            return Chip(
              label: Text(customAmenity),
              deleteIcon: const Icon(Icons.close),
              onDeleted: () {
                setState(() {
                  _customAmenities.remove(customAmenity);
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        // ElevatedButton(onPressed: (){submitData();}, child: Text('SUBMIT')),
        ElevatedButton(
  onPressed: () {
    print("I am in submit");
    submitData();
    // Uncomment below to show a Snackbar with a message after submitting
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: const Text("Values have been submitted!"),
    //     duration: const Duration(seconds: 2), // Duration for how long it appears
    //   ),
    // );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.black, // Black background color
    foregroundColor: Colors.white, // White text color
    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0), // Adjust button padding
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0), // Rounded corners
    ),
    elevation: 6, // Add some shadow to elevate the button
    shadowColor: Colors.grey.withOpacity(0.3), // Subtle shadow for modern feel
  ),
  child: const Text(
    'Submit',
    style: TextStyle(
      fontSize: 18.0, // Slightly larger text for better visibility
      fontWeight: FontWeight.bold, // Bold text for emphasis
    ),
  ),
)

      ],
    ),
  ),
)
    );
  }
}

// @override
// void dispose() {
//   _addressController.dispose();
//   _landmarkController.dispose();
//   _pincodeController.dispose();
//   _cityController.dispose();
//   _stateController.dispose();
//   _countryController.dispose();
//   super.dispose();
// }
