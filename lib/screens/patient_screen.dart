// lib/screens/patient_screen.dart

import 'package:flutter/material.dart';
import 'package:skribemonkey/models/patient_model.dart';
import 'package:skribemonkey/utils/color_scheme.dart';

class PatientScreen extends StatelessWidget {
  final Patient patient;

  const PatientScreen({Key? key, required this.patient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(patient.name),
        backgroundColor: Palette.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Information
            Text(
              'Name: ${patient.name}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Email: ${patient.email}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Gender: ${patient.gender}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),

            // Pre-Existing Conditions
            Text(
              'Pre-Existing Conditions:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            patient.preexisting_conditions.isEmpty
                ? Text(
                    'None',
                    style: TextStyle(fontSize: 18),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: patient.preexisting_conditions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.check, color: Palette.primaryColor),
                        title: Text(
                          patient.preexisting_conditions[index],
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    },
                  ),
            SizedBox(height: 20),

            // Created At
            Text(
              'Registered On: ${patient.created_at.toLocal().toString().split(' ')[0]}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
