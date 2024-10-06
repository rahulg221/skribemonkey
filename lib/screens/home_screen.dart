/*import 'package:flutter/material.dart';
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
                'Skribe Monkey',
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
          // Grey Column with Image
          Container(
            width: 250, // Set width of the grey column
            color: Palette.primaryColor.withOpacity(0.3),
            child: Container(
              alignment: Alignment.topCenter, // Align image to the top
              padding:
                  const EdgeInsets.only(bottom: 100), // Add padding if needed
              child: Image.asset(
                'assets/images/logo3.png', // Adjust the path to your image
                width: 250, // Set desired image width
                height: 250, // Set desired image height
              ),
            ),
          ),
          // Main content area
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: 50,
                  left: 100,
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
                    left: 100,
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
*/

// lib/screens/home_screen.dart
// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:skribemonkey/models/patient_model.dart';
import 'package:skribemonkey/screens/new_patient_screen.dart';
import 'package:skribemonkey/screens/patient_screen.dart';
import 'package:skribemonkey/supabase/db_methods.dart';
import 'package:skribemonkey/utils/color_scheme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseMethods _dbMethods = DatabaseMethods();
  List<Patient> registeredPatients = []; // To keep track of registered patients
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    setState(() {
      _isLoading = true;
    });

    final List<Map<String, dynamic>>? patients =
        await _dbMethods.fetchPatients();

    setState(() {
      if (patients != null) {
        registeredPatients = patients.cast<Patient>();
      }
      _isLoading = false;
    });
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
                'Skribe Monkey',
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
          // Grey Column with Image
          Container(
            width: 250, // Set width of the grey column
            color: Palette.primaryColor.withOpacity(0.3),
            child: Container(
              alignment: Alignment.topCenter, // Align image to the top
              padding:
                  const EdgeInsets.only(bottom: 100), // Add padding if needed
              child: Image.asset(
                'assets/images/logo3.png', // Adjust the path to your image
                width: 250, // Set desired image width
                height: 250, // Set desired image height
              ),
            ),
          ),
          // Main content area
          Expanded(
            child: Stack(
              children: [
                // Register New Patient Button
                Positioned(
                  top: 50,
                  left: 100,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Navigate to NewPatientScreen and wait for result
                      final Patient? newPatient = await Navigator.push<Patient>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NewPatientScreen(),
                        ),
                      );

                      // If a new patient is returned, add them to the list and refresh
                      if (newPatient != null) {
                        setState(() {
                          registeredPatients.insert(0, newPatient);
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.primaryColor.withOpacity(0.7),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 455),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 50,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Register New Patient',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'quick',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Display list of registered patients
                Positioned(
                  top: 150,
                  left: 100,
                  right: 100,
                  bottom: 50,
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : registeredPatients.isEmpty
                          ? Center(child: Text('No patients registered.'))
                          : ListView.builder(
                              itemCount: registeredPatients.length,
                              itemBuilder: (context, index) {
                                final patient = registeredPatients[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 5,
                                    child: ListTile(
                                      title: Text(
                                        patient.name,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        patient.email,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      trailing: Icon(Icons.arrow_forward),
                                      onTap: () {
                                        // Navigate to PatientScreen with patient data
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PatientScreen(patient: patient),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
