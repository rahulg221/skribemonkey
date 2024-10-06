import 'package:flutter/material.dart';
import 'package:skribemonkey/utils/color_scheme.dart';

class PatientScreen extends StatefulWidget {
  const PatientScreen({super.key});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150, // Adjust width as needed
          color: Palette.primaryColor,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Text(
                  "Name",
                  style: TextStyle(
                      fontFamily: 'quick', fontSize: 25, color: Colors.white),
                ),
              ), // Replace with your TextBox widget
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Text(
                  "Contact",
                  style: TextStyle(
                      fontFamily: 'quick', fontSize: 25, color: Colors.white),
                ),
              ), // Replace with your TextBox widget
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Text(
                  "Gender",
                  style: TextStyle(
                      fontFamily: 'quick', fontSize: 25, color: Colors.white),
                ),
              ), // Replace with your TextBox widget
            ],
          ),
        ),
        Expanded(
          child: const Placeholder(),
        ),
      ],
    );
  }
}
