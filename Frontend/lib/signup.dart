import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'Host_account.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'pages/search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/search.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupState();
}

class _SignupState extends State<SignupPage> {
  final PageController _pageController = PageController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _clientUsernameController =
      TextEditingController();
  final TextEditingController _clientPasswordController =
      TextEditingController();
  final TextEditingController _clientemailController = TextEditingController();
  final TextEditingController _clientphoneController = TextEditingController();
  final TextEditingController _clientnameController = TextEditingController();

  Color linkColor = Colors.blue; // Default link color

  Future<void> registerHost() async {
    const url = 'http://192.168.159.119:5000/register-host';

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'name':_nameController.text, // Make sure to use .text to get the value from TextEditingController
        'email': _emailController.text,
        'phone': _phoneController.text,
        'username': _usernameController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == 'registered') {
        print('Host registered successfully');
        Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HostLoginPage()), // Add closing parenthesis here
                  );
        // Show success alert dialog
        _showAlertDialog(
            context, 'Registration Success', 'Host registered successfully.');
      }
       else {
        print(data['status']);
        Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HostLoginPage()), // Add closing parenthesis here
                  );
        _showAlertDialog(context, 'Registration done', data['status']);
      }
    } else {
      print('Registration failed with status code: ${response.statusCode}');
      _showAlertDialog(context, 'Registration Failed',
          'An error occurred. Please try again.');
    }
  }

  void _showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

Future<void> registerClient() async {
  const url = 'http://192.168.159.119:5000/register-client';

  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'name': _clientnameController.text, // Use the client name controller
      'email': _clientemailController.text, // Use the client email controller
      'phone': _clientphoneController.text, // Use the client phone controller
      'username': _clientUsernameController.text, // Use the client username controller
      'password': _clientPasswordController.text, // Use the client password controller
    }),
  );

  print('Request body: ${jsonEncode({
    'name': _clientnameController.text,
    'email': _clientemailController.text,
    'phone': _clientphoneController.text,
    'username': _clientUsernameController.text,
    'password': _clientPasswordController.text,
  })}');

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data['status'] == 'registered') {
      print('Client registered successfully');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ClientLoginPage(),
        ),
      );
      // Show success alert dialog
      _showAlertDialog(
        context,
        'Registration Success',
        'Client registered successfully.',
      );
    } else {
      print(data['status']);
      Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ClientLoginPage()), // Add closing parenthesis here
                  );
      _showAlertDialog(context, 'Registration done', data['status']);
    }
  } else {
    print('Registration failed with status code: ${response.statusCode}');
    _showAlertDialog(context, 'Registration Failed',
        'An error occurred. Please try again.');
  }
}

  // void _showAlertDialog(BuildContext context, String title, String message) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(title),
  //         content: Text(message),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text('OK'),
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _emailController.dispose();

    _clientUsernameController.dispose();
    _clientPasswordController.dispose();
    _clientnameController.dispose();
    _clientphoneController.dispose();
    _clientemailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 450,
                  height: 700, // Height to accommodate all fields
                  child: PageView(
                    controller: _pageController,
                    children: [
                      _buildSignUpCard("Host", showNext: true),
                      _buildSignUpCard("Client", showNext: false),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpCard(String userType, {required bool showNext}) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Sign Up as $userType",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Welcome to SukoonStay",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: userType == "Host"
                  ? _nameController
                  : _clientnameController,
              labelText: 'Name',
              icon: Icons.badge,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: userType == "Host"
                  ? _usernameController
                  : _clientUsernameController,
              labelText: 'Username',
              icon: Icons.person,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: userType == "Host"
                  ? _passwordController
                  : _clientPasswordController,
              labelText: 'Password',
              icon: Icons.lock,
              obscureText: true,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: userType == "Host"
                  ? _phoneController
                  : _clientphoneController,
              labelText: 'Phone Number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: userType == "Host"
                  ? _emailController
                  : _clientemailController,
              labelText: 'Email',
              icon: Icons.mail,
              keyboardType: TextInputType.text,
              // _buildDatePickerField(
              //   controller:
              //       userType == "Host" ? _dobController : TextEditingController(),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              ),
              onPressed: () {
                if (userType == "Host") {
                  registerHost();
                  
                  // Call registerHost function for Host sign up
                } else if (userType == "Client") {
                  registerClient();
                  
                }
              },
              child: const Text(
                'Sign Up',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  linkColor = Colors.lightBlue; // Change color on hover
                });
              },
              onExit: (_) {
                setState(() {
                  linkColor = Colors.blue; // Revert to original color
                });
              },
              child: Text.rich(
                TextSpan(
                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                  children: [
                    const TextSpan(text: "Already have an account? "),
                    TextSpan(
                      text: "Log In",
                      style: TextStyle(
                        color: linkColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none, // No underline
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Navigate to the appropriate login page
                          if (userType == "Host") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HostLoginPage(),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ClientLoginPage(),
                              ),
                            );
                          }
                        },
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            if (showNext) ...[
              Text(
                "Next: Sign Up as Client",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_forward,
                  size: 30,
                  color: Colors.black,
                ),
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ] else ...[
              Text(
                "Back to Sign Up as Host",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: Colors.black,
                ),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
    );
  }

  // Widget _buildDatePickerField({required TextEditingController controller}) {
  //   return TextField(
  //     controller: controller,
  //     readOnly: true,
  //     decoration: InputDecoration(
  //       labelText: 'Date of Birth',
  //       prefixIcon: Icon(Icons.calendar_today, color: Colors.black),
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //       filled: true,
  //       fillColor: Colors.grey.shade100,
  //     ),
  //     onTap: () async {
  //       final DateTime? pickedDate = await showDatePicker(
  //         context: context,
  //         initialDate: DateTime.now(),
  //         firstDate: DateTime(1900),
  //         lastDate: DateTime.now(),
  //       );
  //       if (pickedDate != null) {
  //         controller.text = "${pickedDate.toLocal()}".split(' ')[0];
  //       }
  //     },
  //   );
  // }
}

class HostLoginPage extends StatefulWidget {
  const HostLoginPage({Key? key}) : super(key: key);

  @override
  _HostLoginPageState createState() => _HostLoginPageState();
}

class _HostLoginPageState extends State<HostLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  // Function to log in the user
  Future<void> loginUserHost() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    const url = 'http://192.168.159.119:5000/login-user-host';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'username': usernameController.text,
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'Logged in') {
          // Store token using SharedPreferences
          print(data['token']);
          var prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', data['token']);
          await prefs.setBool('is_loggedin',true);
          // Navigate to another page after successful login

         Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddListingPage(), // This is fine now
                                ),
                              );
        } else {
          _showError(data['error']);
        }
      } else {
        _showError('Login failed. Please check your credentials.');
      }
    } catch (e) {
      print(e.toString());
      _showError('An error occurred. Please try again. : ${e.toString()}');
    }

    setState(() {
      isLoading = false;
    });
  }

  // Function to display error messages
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: Center(
        child: SizedBox(
          width: 450,
          child: Card(
            color: Colors.white,
            elevation: 5,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Host Login",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: usernameController,
                      labelText: 'Username',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: passwordController,
                      labelText: 'Password',
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 24),
                            ),
                            onPressed: () {

                              loginUserHost();
                            },
                            child: const Text(
                              'Log In',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: const TextStyle(color: Colors.black54),
                        children: [
                          TextSpan(
                            text: "Sign Up",
                            style: const TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pop(
                                    context); // Go back to the signup page
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }
}

class ClientLoginPage extends StatefulWidget {
  const ClientLoginPage({Key? key}) : super(key: key);

  @override
  _ClientLoginPageState createState() => _ClientLoginPageState();
}

class _ClientLoginPageState extends State<ClientLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  // Function to log in the user
  Future<void> loginUserClient() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    const url =
        'http://192.168.159.119:5000/login-user-client'; // Adjusted URL for client

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'username': usernameController.text,
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'Logged in') {
          // Store token using SharedPreferences
          // SharedPreferences prefs = await SharedPreferences.getInstance();
          // prefs.setString('jwt_token', data['data']);
          // Navigate to another page after successful login
          Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SearchPage(), // This is fine now
                                ),
                              );
        } else {
          _showError(data['error']);
        }
      } else {
        _showError('Login failed. Please check your credentials.');
      }
    } catch (e) {
      _showError('An error occurred. Please try again.');
    }

    setState(() {
      isLoading = false;
    });
  }

  // Function to display error messages
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: Center(
        child: SizedBox(
          width: 450,
          child: Card(
            color: Colors.white,
            elevation: 5,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Client Login",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: usernameController,
                      labelText: 'Username',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: passwordController,
                      labelText: 'Password',
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 24),
                            ),
                            onPressed: () {
                             loginUserClient();
                            },
                            child: const Text(
                              'Log In',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: const TextStyle(color: Colors.black54),
                        children: [
                          TextSpan(
                            text: "Sign Up",
                            style: const TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pop(
                                    context); // Go back to the signup page
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Custom text field widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $labelText';
        }
        return null;
      },
    );
  }
}
