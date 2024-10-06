import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:skribemonkey/models/patient_model.dart';
import 'package:skribemonkey/supabase/db_methods.dart';
import 'package:skribemonkey/utils/color_scheme.dart';

class PatientScreen extends StatefulWidget {
  final String patientId;

  PatientScreen({required this.patientId});

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

  @override
  void initState() {
    super.initState();
    getPatientData();
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
            ],
          ),
        ),
      ),
    );
  }
}
