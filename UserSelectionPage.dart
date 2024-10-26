import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        automaticallyImplyLeading: false, // This will hide the back button
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade200, Colors.blue.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to SmartBook!',
                    style: GoogleFonts.poppins(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Please choose an option to continue:',
                    style: GoogleFonts.poppins(
                      fontSize: 18.0,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40), // Add spacing before buttons
                  ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to create user page
                      Navigator.pushNamed(context, '/createUser');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue, // Background color
                      padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      shadowColor: Colors.black45,
                    ),
                    icon: Icon(Icons.person_add, color: Colors.white),
                    label: Text(
                      'Signup',
                      style: GoogleFonts.poppins(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Add spacing between buttons
                  ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to user list page
                      Navigator.pushNamed(context, '/userList');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue, // Background color
                      padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      shadowColor: Colors.black45,
                    ),
                    icon: Icon(Icons.login, color: Colors.white),
                    label: Text(
                      'Login',
                      style: GoogleFonts.poppins(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
