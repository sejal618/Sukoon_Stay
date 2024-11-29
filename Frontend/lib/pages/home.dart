import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get screen width and height using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Calculate dynamic font sizes based on the screen size
    double titleFontSize = screenWidth * 0.08; // 8% of screen width
    double subtitleFontSize = screenWidth * 0.05; // 5% of screen width
    double buttonFontSize = screenWidth * 0.04; // 4% of screen width

    // Calculate dynamic logo size
    double logoWidth = screenWidth * 0.6; // Increase logo width to 60% of screen width
    double logoHeight = logoWidth * 0.5; // Adjust height-to-width ratio (50% of width)

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/images/background.jpeg'),
                
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Center content vertically
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Spacer to push content down and provide space between logo and text
                SizedBox(height: screenHeight * 0.2), // Move everything down (20% of screen height)
                
                // Logo
                Image.asset(
                  'assets/images/images/logo.png',
                  width: logoWidth, // Dynamically sized width (60% of screen width)
                  height: logoHeight, // Dynamically sized height based on width (50% of width)
                ),
                SizedBox(height: 30), // Space between logo and "Welcome Home" text

                // Text: Welcome Home
                Text(
                  'Welcome Home',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: titleFontSize, // Use dynamic font size
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato',
                  ),
                ),
                SizedBox(height: 8), // Space between title and subtitle

                // Text: Subtitle
                Text(
                  'Rent unique places to stay from local hosts in 190+ countries.',
                  style: TextStyle(
                    color: Color.fromARGB(255, 81, 81, 81),
                    fontSize: subtitleFontSize, // Use dynamic font size
                    fontFamily: 'San Francisco',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20), // Space between subtitle and button

                // SignUp Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup'); // Navigate to the SignUpPage
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: buttonFontSize), // Use dynamic font size for button text
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 45, 43, 43), // Background color
                    foregroundColor: Colors.white, // Text color
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 20), // Space between button and the arrow icon

                // Arrow icon
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 60,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
