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
                padding: const EdgeInsets.only(top: 70.0),
                child: Text(
                  "Name",
                  style: TextStyle(
                      fontFamily: 'quick', fontSize: 25, color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: Text(
                  "Contact",
                  style: TextStyle(
                      fontFamily: 'quick', fontSize: 25, color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: Text(
                  "Gender",
                  style: TextStyle(
                      fontFamily: 'quick', fontSize: 25, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            alignment:
                Alignment.bottomCenter, // Align children to bottom center
            children: [
              const Placeholder(),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 30.0), // Adjust as needed
                child: Container(
                  width: 85,
                  height: 80,
                  child: FloatingActionButton(
                    elevation: 0,
                    onPressed: () {
                      // Add your microphone action here
                    },
                    child: const Icon(Icons.mic,
                        color: Colors.white, // Change the icon color here
                        size: 50),
                    backgroundColor:
                        Palette.primaryColor, // Set the background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
