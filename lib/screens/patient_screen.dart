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

  Future<Patient> getPatientData() async {
    patient = await DatabaseMethods().fetchPatientById(widget.patientId);
    print(patient);

    return patient!;
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
        child: Column(
          children: [
            Text('Patient ID: ${widget.patientId}'),
            Text('Patient ID: ${patient?.first_name}'),
          ],
        ),
      ),
    );
  }
}
