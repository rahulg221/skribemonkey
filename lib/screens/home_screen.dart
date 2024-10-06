import 'package:flutter/material.dart';
import 'package:skribemonkey/utils/color_scheme.dart';
import 'package:skribemonkey/screens/new_patient_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0), // Set desired height here
        child: SafeArea(
          child: AppBar(
            elevation: 0, // Remove elevation
            backgroundColor:
                Palette.primaryColor, // Set the AppBar's primary color
            title: Padding(
              padding: const EdgeInsets.only(
                  top: 15.0), // Add bottom padding to the title
              child: const Text(
                'Scribe Monkey',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'quick',
                  fontSize: 30,
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 15.0), // Add bottom padding to the icon
                child: IconButton(
                  icon: const Icon(Icons.search),
                  color: Colors.white,
                  iconSize: 30,
                  onPressed: () {
                    // Define what happens when the search button is pressed
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 16.0,
                    top: 15.0), // Add margin to the right and top padding
                child: Container(
                  width: 200, // Set width of the search bar
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: InputBorder.none, // Remove border
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // Set curve radius
                        borderSide: BorderSide.none, // Remove border
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // Set curve radius
                        borderSide: BorderSide.none, // Remove border
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Row(
        children: [
          // Grey Column with Image
          Container(
            width: 250, // Set width of the grey column
            color: Palette.primaryColor.withOpacity(0.3),
            child: Container(
              alignment: Alignment.topCenter, // Align image to the top
              padding:
                  const EdgeInsets.only(bottom: 100), // Add padding if needed
              child: Image.asset(
                'lib/images/logo3.png', // Adjust the path to your image
                width: 250, // Set desired image width
                height: 250, // Set desired image height
              ),
            ),
          ),
          // Main content area
          Expanded(
            child: Stack(
              // Use Stack instead of Center
              children: [
                Positioned(
                  top: 50,
                  left: 100,
                  child: MaterialButton(
                    onPressed: () {
                      // Navigate to NewPatientScreen when the button is pressed
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NewPatientScreen()),
                      );
                    },
                    color: const Color.fromARGB(255, 211, 211, 211),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(25), // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 35, horizontal: 455), // Add some padding
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Use minimum space
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 100, // Change the icon size here
                        ), // Plus icon
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
