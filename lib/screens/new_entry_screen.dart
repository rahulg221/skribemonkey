import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:skribemonkey/external_apis/summarization_methods.dart';
import 'package:skribemonkey/external_apis/transcription_methods.dart';
import 'package:skribemonkey/models/patient_model.dart';
import 'package:skribemonkey/supabase/db_methods.dart';
import 'package:skribemonkey/utils/color_scheme.dart';

class NewEntryScreen extends StatefulWidget {
  final String patientId;
  final String userId;
  final String transcript;

  NewEntryScreen(
      {required this.patientId,
      required this.userId,
      required this.transcript});

  @override
  _NewEntryScreenState createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  /*String patientId, String userId, String condition,
      String urgencyLevel, String Summary*/

  Future<void> createEntry() async {
    if (widget.transcript == 'blank') {
      print("Transcript empty");
      return;
    } else {
      print(widget.transcript);
    }

    // Call the summarization method
    final summary =
        await SummarizationMethods().summarizeTranscript(widget.transcript);

    // Call the method to create a new entry
    await DatabaseMethods()
        .createEntry(widget.patientId, widget.userId, '', 5, summary!);
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
          'New Entry',
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
              GestureDetector(
                onTap: () {
                  createEntry();
                },
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Submit entry',
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
        ),
      ),
    );
  }
}
