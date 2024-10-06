import 'package:flutter/material.dart';
import 'package:skribemonkey/models/patient_model.dart';
import 'package:skribemonkey/supabase/db_methods.dart';
import 'package:skribemonkey/utils/color_scheme.dart';
import 'package:skribemonkey/screens/new_patient_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> registeredUsers = []; // To keep track of registered users

  // For search bar
  bool isSearchBarVisible = false;
  TextEditingController searchCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0), // Set desired height here
        child: SafeArea(
          child: AppBar(
            elevation: 0, // Remove elevation
            backgroundColor:
                Palette.primaryColor, // Set the AppBar's primary color
            title: Padding(
              padding: const EdgeInsets.only(
                  top: 15.0), // Add bottom padding to the title
              child: Center(
                // Center the Row
                child: Row(
                  mainAxisSize:
                      MainAxisSize.min, // Make the Row as small as possible
                  children: [
                    Image.asset(
                      'assets/images/logo4.png', // Path to your image asset
                      width: 60, // Set desired width
                      height: 60, // Set desired height
                    ),
                    const SizedBox(
                        width: 5), // Add some spacing between image and text
                    const Padding(
                      padding: EdgeInsets.only(
                          left: 20.0), // Add left padding to the text
                      child: Text(
                        'Skribe Monkey',
                        style: TextStyle(
                          color: Color.fromARGB(255, 22, 22, 149),
                          fontFamily: 'quick',
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 12.0), // Add bottom padding to the icon
                child: IconButton(
                  icon: const Icon(Icons.search),
                  color: Colors.white,
                  iconSize: 35,
                  onPressed: () {
                    setState(() {
                      isSearchBarVisible = !isSearchBarVisible; // Toggle search bar visibility
                      if (isSearchBarVisible) {
                        searchCont.clear(); // Clear the search field when opened
                      }
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 27.0,
                    top: 15.0), // Add margin to the right and top padding
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          if (isSearchBarVisible) // Show the search bar if visible
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchCont,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchCont.clear(); // Clear search input
                    },
                  ),
                ),
              ),
            ),
          Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: 50,
                  left: 20, // Adjusted to use relative positioning
                  right: 20, // Allows for a margin on the right
                  child: MaterialButton(
                    onPressed: () async {
                      // Navigate to NewPatientScreen and wait for result
                      final newUser = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NewPatientScreen(),
                        ),
                      );

                      // If a new user is returned, add them to the list
                      if (newUser != null) {
                        setState(() {
                          registeredUsers.add(newUser);
                        });
                      }
                    },
                    color: const Color.fromARGB(255, 211, 211, 211),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.add,
                          color: Palette.primaryColor,
                          size: 75,
                        ),
                      ],
                    ),
                  ),
                ),
                // Display buttons for registered users
                ...registeredUsers.asMap().entries.map((entry) {
                  int index = entry.key;
                  String userName = entry.value;
                  return Positioned(
                    top: 175 + (index * 130), // Adjust position for each button
                    left: 20, // Adjusted to use relative positioning
                    right: 20, // Allows for a margin on the right
                    child: SizedBox(
                      height: 90, // Set a fixed height
                      child: MaterialButton(
                        onPressed: () {
                          // Handle button press for the user

                        },
                        color: Palette.primaryColor, // Change color if needed
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          userName,
                          textAlign: TextAlign.center, // Center the text
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 35, // Reduced font size for better fit
                            fontFamily: 'quick',
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
