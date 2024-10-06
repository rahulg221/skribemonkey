import 'package:flutter/material.dart';
import 'package:skribemonkey/models/patient_model.dart';
import 'package:skribemonkey/supabase/db_methods.dart';
import 'package:skribemonkey/utils/color_scheme.dart';
import 'package:skribemonkey/screens/new_patient_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> registeredUsers = []; // To keep track of registered users
  List<Patient> patients = [];

  Future<void> fetchPatients() async {
    final _client = Supabase.instance.client;
    String userId = _client.auth.currentUser!.id;
    print(userId);

    List<Patient> patients =
        await DatabaseMethods().fetchPatientByDoctor(userId);

    print(patients);

    setState(() {
      patients = patients;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

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
                'S.M.',
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
                child: SizedBox(
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
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: 50,
                  left: 10,
                  right: 10,
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 455),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 100,
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
                    top: 200 + (index * 165), // Adjust position for each button
                    left: 10,
                    right: 10,
                    child: SizedBox(
                      width: 995, // Set a fixed width
                      height: 125, // Set a fixed height
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
                              fontSize: 50,
                              fontFamily: 'quick'),
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
