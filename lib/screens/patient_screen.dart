import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:skribemonkey/models/entry_model.dart';
import 'package:skribemonkey/models/patient_model.dart';
import 'package:skribemonkey/screens/new_entry_screen.dart';
import 'package:skribemonkey/supabase/db_methods.dart';
import 'package:skribemonkey/utils/color_scheme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PatientScreen extends StatefulWidget {
  final String patientId;
  final String userId;

  PatientScreen({required this.patientId, required this.userId});

  @override
  _PatientScreenState createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  Patient? patient;
  String firstName = '';
  String lastName = '';
  String email = '';
  String gender = '';
  List<dynamic> preexistingConditions = [];
  List<Patient> patients = [];
  List<Entry> entries = [];

  Future<void> getPatientData() async {
    patient = await DatabaseMethods().fetchPatientById(widget.patientId);

    setState(() {
      firstName = patient!.first_name;
      lastName = patient!.last_name;
      email = patient!.email;
      gender = patient!.gender;
      preexistingConditions = patient!.preexisting_conditions;
    });
  }

  Future<void> fetchEntries() async {
    try {
      List<Entry> fetchedEntries =
          await DatabaseMethods().fetchEntryByPatient(widget.patientId);

      setState(() {
        entries = fetchedEntries; // Update the state variable
      });

      print(entries);
      print('Number of entries fetched: ${entries.length}');
    } catch (e) {
      // Handle any errors
      print("Error fetching entries: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getPatientData();
    fetchEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.primaryColor,
        elevation: 0, // Remove shadow
        leading: Padding(
          padding: const EdgeInsets.only(
              top: 5.0, left: 8.0), // Add top padding here
          child: IconButton(
            icon: Icon(Icons.arrow_back,
                size: 35, color: Colors.white), // Back button icon
            hoverColor: Colors.transparent, // Remove hover effect color
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Text(
          'Patient Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'quick',
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Patient name: $firstName $lastName',
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20,
                  fontFamily: 'quick',
                ),
              ),
              Text(
                'Email: $email',
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20,
                  fontFamily: 'quick',
                ),
              ),
              Text(
                'Gender: $gender',
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20,
                  fontFamily: 'quick',
                ),
              ),
              Text(
                'Conditions: ${preexistingConditions.join(', ')}',
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20,
                  fontFamily: 'quick',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      fetchEntries();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 160,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                            255, 211, 211, 211), // Set container color
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
                  const SizedBox(width: 30), // Add space between the buttons
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewEntryScreen(
                                  patientId: patient!.id,
                                  userId: widget.userId,
                                )),
                      );
                    },
                    child: Container(
                      width: 160,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                            255, 211, 211, 211), // Set container color
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'New entry',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 20,
                            fontFamily: 'quick',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ...entries.asMap().entries.map((entry) {
                int index = entry.key;
                Entry entryItem = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    width: 350, // Set a fixed width
                    height: 120, // Set a fixed height
                    child: MaterialButton(
                      onPressed: () {
                        // Handle button press for the entry
                      },
                      color: Palette.primaryColor, // Change color if needed
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          // Assuming Entry has relevant fields like `title`, `description`, or `date`
                          '${entryItem.summary}',
                          textAlign: TextAlign.center, // Center the text
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'quick',
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
