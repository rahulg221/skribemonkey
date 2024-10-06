import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:skribemonkey/external_apis/summarization_methods.dart';
import 'package:skribemonkey/external_apis/transcription_methods.dart';
import 'package:skribemonkey/models/entry_model.dart';
import 'package:skribemonkey/models/patient_model.dart';
import 'package:skribemonkey/screens/new_entry_screen.dart';
import 'package:skribemonkey/supabase/db_methods.dart';
import 'package:skribemonkey/utils/color_scheme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';

class PatientScreen extends StatefulWidget {
  final String patientId;
  final String userId;

  PatientScreen({required this.patientId, required this.userId});

  @override
  _PatientScreenState createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  final FlutterSoundRecorder recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String audioPath = '';
  String transcript = 'blank';
  Patient? patient;
  String firstName = '';
  String lastName = '';
  String email = '';
  String gender = '';
  List<dynamic> preexistingConditions = [];
  List<Patient> patients = [];
  List<Entry> entries = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> initRecorder() async {
    await recorder.openRecorder();
  }

  void init() {
    initRecorder();
    getPatientData();
    fetchEntries();
  }

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

  Future<void> createEntry(transcript) async {
    if (transcript == 'blank') {
      print("Transcript empty");
      return;
    } else {
      print(transcript);
    }

    // Call the summarization method
    final summary =
        await SummarizationMethods().summarizeTranscript(transcript);

    // Call the method to create a new entry
    await DatabaseMethods()
        .createEntry(widget.patientId, widget.userId, '', 5, summary!);
  }

  Future<void> fetchEntries() async {
    try {
      List<Entry> fetchedEntries =
          await DatabaseMethods().fetchEntryByPatient(widget.patientId);

      setState(() {
        entries = fetchedEntries;
      });

      print(entries);
      print('Number of entries fetched: ${entries.length}');
    } catch (e) {
      print("Error fetching entries: $e");
    }
  }

  Future<void> requestMicrophonePermission() async {
    print("Checking microphone permission");
    var status = await Permission.microphone.request();

    if (status.isPermanentlyDenied) {
      openAppSettings(); // Redirect user to app settings if permanently denied
    }

    if (status.isGranted) {
      print('Microphone permission granted');
      startRecording();
    } else if (status.isDenied) {
      print("Microphone permission denied. Try again later.");
    }
  }

  Future<void> startRecording() async {
    if (_isRecording) {
      print("Already recording.");
      return; // Prevent starting another recording
    }

    try {
      print('Attempting to start recording...');
      final directory = await getApplicationDocumentsDirectory();
      audioPath =
          '${directory.path}/audiofile_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await recorder.startRecorder(
        toFile: audioPath,
        codec: Codec.aacMP4,
      );

      setState(() {
        _isRecording = true;
      });

      print('Recording started: $audioPath');
    } catch (e) {
      print("Error starting the recorder: $e");
    }
  }

  Future<void> stopRecording() async {
    if (!_isRecording) {
      print("Not currently recording.");
      return; // Prevent stopping if not recording
    }

    try {
      // Stop the recorder
      await recorder.stopRecorder();

      // Close the recorder after stopping
      await recorder.closeRecorder();

      setState(() {
        _isRecording = false; // Update the recording state
      });

      print('Recording stopped: $audioPath');
    } catch (e) {
      print("Error stopping the recorder: $e");
    }
  }

  @override
  void dispose() {
    if (_isRecording) {
      stopRecording(); // Call stop recording to ensure it's closed properly
    }
    recorder.closeRecorder();
    super.dispose();
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
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                      255, 136, 151, 234), // Set container color
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Full Name: $firstName $lastName',
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
                        'Conditions: ${preexistingConditions.join(", ")}',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          fontFamily: 'quick',
                        ),
                      ),
                      Text(
                        transcript,
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
              const SizedBox(height: 20),
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
                            255, 212, 212, 212), // Set container color
                        borderRadius:
                            BorderRadius.circular(12), // Rounded corners
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
                      // Attempt to transcribe the audio file
                      String? transcript = await TranscriptionMethods()
                          .transcribeM4aFromFilePicker();
                      //String? transcript = await TranscriptionMethods()
                      //  .transcribeM4aFromDirectory('audiofile3.m4a');

                      // Check if the transcript is not null before proceeding
                      if (transcript != null) {
                        // If the transcription was successful, create an entry
                        createEntry(transcript);
                      } else {
                        // Handle the case where transcription failed or was canceled
                        print('Transcription failed or was canceled.');
                        // Optionally, show an alert or some message to the user
                      }
                    },
                    child: Container(
                      width: 160,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Palette.primaryColor, // Set container color
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'New entry',
                          style: TextStyle(
                            color: Colors.white,
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
                    width: double.infinity, // Set a fixed width
                    height: 120, // Set a fixed height
                    child: MaterialButton(
                      onPressed: () {
                        // Handle button press for the entry
                      },
                      color: const Color.fromARGB(
                          255, 136, 151, 234), // Change color if needed
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          // Assuming Entry has relevant fields like `title`, `description`, or `date`
                          '${entryItem.summary}',
                          textAlign: TextAlign.center, // Center the text
                          style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: _isRecording ? Colors.black : Palette.primaryColor,
        onPressed: () async {
          if (_isRecording) {
            await stopRecording();
          } else {
            //await requestMicrophonePermission();
            startRecording();
          }
        },
        child: Icon(Icons.mic, color: Colors.white, size: 30),
      ),
    );
  }
}
