import 'package:flutter/material.dart';
import 'package:skribemonkey/models/patient_model.dart';
import 'package:skribemonkey/screens/patient_screen.dart';
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
                        'assets/images/logo3.png', // Path to your image asset
                        width: 60, // Set desired width
                        height: 60, // Set desired height
                      ),
                      const SizedBox(
                          width: 5), // Add some spacing between image and text
                      const Padding(
                        padding: EdgeInsets.only(
                            left: 18.0), // Add left padding to the text
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
                      // Define what happens when the search button is pressed
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        fetchPatients();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 180,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                              255, 212, 212, 212), // Set container color
                          borderRadius:
                              BorderRadius.circular(15), // Rounded corners
                        ),
                        child: Icon(
                          Icons.refresh,
                          color: Palette.primaryColor,
                          size: 30,
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox()),
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
                        width: 180,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Palette.primaryColor, // Set container color
                          borderRadius:
                              BorderRadius.circular(15), // Rounded corners
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Display buttons for registered users
                ...patients.asMap().entries.map((entry) {
                  int index = entry.key;
                  Patient patient = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: SizedBox(
                      width: double.infinity, // Set a fixed width
                      height: 60, // Set a fixed height
                      child: TextButton(
                        onPressed: () {
                          final _client = Supabase.instance.client;
                          String userId = _client.auth.currentUser!.id;
                          // Handle button press for the patient
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PatientScreen(
                                patientId: patient.id,
                                userId: userId,
                              ),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 136, 151, 234),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
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
          ),
        ));
  }
}
