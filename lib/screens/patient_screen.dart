import 'package:flutter/material.dart';
import 'package:skribemonkey/utils/color_scheme.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class PatientScreen extends StatefulWidget {
  const PatientScreen({super.key});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  final FlutterSoundRecorder recorder = FlutterSoundRecorder();
  bool isRecording = false;
  String audioPath = "";

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  Future<void> initRecorder() async {
    await recorder.openRecorder();
  }

  Future<void> requestMicrophonePermission() async {
    print("Checking microphone permission");
    var status = await Permission.microphone.request(); // Check current status
    print("Current permission status: $status");

    if (status.isPermanentlyDenied) {
      openAppSettings();
    }
    //if (status.isDenied) {
    //openAppSettings();
    //}

    if (status.isGranted) {
      print('Microphone permission already granted');
      startRecording();
    } else {
      print("Requesting microphone permission");
      status = await Permission.microphone.request(); // Request permission
      print("New permission status: $status");

      if (status.isGranted) {
        print('Microphone permission granted');
        startRecording(); // Start recording if permission is granted
      } else {
        print('Microphone permission denied');
      }
    }
  }

  Future<void> startRecording() async {
    audioPath = 'audio_outputs/audiofile.ogg'; // Might need to change
    await recorder.startRecorder(toFile: audioPath);

    // Update recording state
    setState(() {
      isRecording = true;
    });
  }

  Future<void> stopRecording() async {
    await recorder.stopRecorder();

    // Update recording state
    setState(() {
      isRecording = false;
    });
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

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
                  width: isRecording ? 90 : 85,
                  height: isRecording ? 85 : 80,
                  child: FloatingActionButton(
                    elevation: 0,
                    onPressed: () async {
                      if (isRecording) {
                        stopRecording();
                      } else {
                        await requestMicrophonePermission();
                      }
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
