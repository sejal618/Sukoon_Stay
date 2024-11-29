import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'PGroom.dart';
import 'rental_room.dart';
import 'Hotelstay.dart';

class AddListingPage extends StatefulWidget {
  const AddListingPage({super.key});

  @override
  State<AddListingPage> createState() => _AddListingPageState();
}

class _AddListingPageState extends State<AddListingPage> {
  String? username;
  final TextEditingController _dobController = TextEditingController();

  // Helper method to build a text form field with a given label
  Widget _buildTextFormField(String label, {TextEditingController? controller, bool readOnly = false, VoidCallback? onTap}) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly, // Enable read-only mode for non-editable fields
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onTap: onTap, // Optional tap handler for special interactions
    );
  }

  // Helper function for navigation
  void _navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  // Function to load user data and decode email from token
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');
    
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      setState(() {
        username = decodedToken['username'];
      });
    } else {
      setState(() {
        username = "Guest";
      });
    }
  }

  // Function to show property type selection dialog
  void _showPropertyTypeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            'Select Property Type',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'PG room',
                  style: TextStyle(color: Colors.grey[300]),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PG_listing()),
                  );
                },
              ),
              Divider(color: Colors.grey[700]),
              ListTile(
                title: Text(
                  'Rental',
                  style: TextStyle(color: Colors.grey[300]),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Rental_listing()),
                  );
                },
              ),
              Divider(color: Colors.grey[700]),
              ListTile(
                title: Text(
                  'Hotel room',
                  style: TextStyle(color: Colors.grey[300]),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Hotel_listing()),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[400]),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Function to show a date picker for DOB field
Future<void> _selectDOB() async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900), // Set earliest selectable date
    lastDate: DateTime.now(), // Set latest selectable date
    builder: (context, child) {
      // Customizing the date picker colors
      return Theme(
        data: ThemeData.dark().copyWith(
          primaryColor: Colors.black, // Black background for the picker
          colorScheme: ColorScheme.dark().copyWith(
            primary: Colors.white, // White for selected dates and header
            surface: Colors.black, // Black background for the calendar
            onSurface: Colors.grey, // Grey for unselected dates
            secondary: Colors.grey, // Grey for selected date accent
          ),
          dialogBackgroundColor: Colors.black, // Black background for the dialog
        ),
        child: child!,
      );
    },
  );

  if (pickedDate != null) {
    setState(() {
      _dobController.text = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
    });
  }
}

final TextEditingController _genderController = TextEditingController();

void _showGenderSelectionDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Select Gender',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                'Male',
                style: TextStyle(color: Colors.grey[300]),
              ),
              onTap: () {
                setState(() {
                  _genderController.text = 'Male';
                });
                Navigator.pop(context);
              },
            ),
            Divider(color: Colors.grey[700]),
            ListTile(
              title: Text(
                'Female',
                style: TextStyle(color: Colors.grey[300]),
              ),
              onTap: () {
                setState(() {
                  _genderController.text = 'Female';
                });
                Navigator.pop(context);
              },
            ),
            Divider(color: Colors.grey[700]),
            ListTile(
              title: Text(
                'Other',
                style: TextStyle(color: Colors.grey[300]),
              ),
              onTap: () {
                setState(() {
                  _genderController.text = 'Other';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[400]),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}



  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Host Account", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 12, 12, 12),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(0),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16.0),
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.verified_user, size: 48, color: Colors.blue),
                const SizedBox(height: 8),
                Text(
                  "Welcome ${username ?? "Guest"}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.black87),
          const SizedBox(height: 24),
          Column(
            children: [
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "General Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildTextFormField("Full Name"),
                        const SizedBox(height: 8),
                        _buildTextFormField(
                          "DOB",
                          controller: _dobController,
                          readOnly: true,
                          onTap: _selectDOB,
                        ),
                        const SizedBox(height: 8),
                        _buildTextFormField(
  "Gender",
  controller: _genderController,
  readOnly: true,
  onTap: _showGenderSelectionDialog, // Show the gender dialog when tapped
),
                        const SizedBox(height: 8),
                        _buildTextFormField("Nationality"),
                        const SizedBox(height: 8),
                        _buildTextFormField("City"),
                        const SizedBox(height: 8),
                        _buildTextFormField("State"),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Divider(color: Colors.black87),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
               child: ClipRRect(
  borderRadius: BorderRadius.circular(12),
 child: Card(
  color: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  elevation: 4.0,
  margin: EdgeInsets.zero,
  child: SizedBox(
    height: 230, // Slightly increased height for better spacing
    child: ListView.separated(
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, index) {
        final titles = [
          'List Your Property',
          'See Your Listing',
          'Bookings',
        ];

        final routes = [
          '/listProperty',
          '/see_listing',
          '/bookingRequests',
        ];

        final icons = [
          Icons.add_business_outlined, // Icon for 'List Your Property'
          Icons.view_list_outlined,   // Icon for 'See Your Listing'
          Icons.book_online_outlined, // Icon for 'Bookings'
        ];

        return InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: () {
            if (index == 0) {
              _showPropertyTypeDialog(); // Custom dialog for the first option
            } else {
              _navigateTo(context, routes[index]); // Navigate to the respective route
            }
          },
          child: ListTile(
            leading: Icon(
              icons[index],
              color: Colors.black87,
            ),
            title: Text(
              titles[index],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ),
        );
      },
      separatorBuilder: (context, index) =>
          Divider(color: Colors.grey[300], thickness: 0.8),
      itemCount: 3, // Matches the number of titles and routes
    ),
  ),
),

),

              ),
            ],
          ),
        ],
      ),
    );
  }
}
