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

    try {
      List<Patient> fetchedPatients =
          await DatabaseMethods().fetchPatientByDoctor(userId);

      setState(() {
        patients = fetchedPatients; // Update the state variable
      });

      print(patients);
      print('Number of patients fetched: ${patients.length}');
      for (var patient in patients) {
        print('Patient: ${patient.first_name} ${patient.last_name}');
      }
    } catch (e) {
      // Handle any errors
      print("Error fetching patients: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    print('initState called');
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
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      fetchPatients();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 175,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                            255, 211, 211, 211), // Set container color
                        borderRadius:
                            BorderRadius.circular(15), // Rounded corners
                      ),
                      child: Icon(
                        Icons.refresh,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
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
                    child: Container(
                      alignment: Alignment.center,
                      width: 175,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                            255, 211, 211, 211), // Set container color
                        borderRadius:
                            BorderRadius.circular(15), // Rounded corners
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Display buttons for registered users
              ...patients.asMap().entries.map((entry) {
                int index = entry.key;
                Patient patient = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: SizedBox(
                    width: 350, // Set a fixed width
                    height: 50, // Set a fixed height
                    child: MaterialButton(
                      onPressed: () {
                        // Handle button press for the patient
                      },
                      color: Palette.primaryColor, // Change color if needed
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        '${patient.first_name} ${patient.last_name}', // Assuming Patient has a `name` field
                        textAlign: TextAlign.center, // Center the text
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: 'quick',
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ));
  }
}
