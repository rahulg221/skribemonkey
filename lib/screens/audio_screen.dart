import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecorder extends StatefulWidget {
  @override
  _AudioRecorderState createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  FlutterSoundRecorder? _flutterSound;
  bool _isRecording = false;
  bool _isRecorderInitialized = false;

  @override
  void initState() {
    super.initState();
    _flutterSound = FlutterSoundRecorder();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    try {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw Exception('Microphone permission not granted');
      }
      await _flutterSound!.openRecorder();
      setState(() {
        _isRecorderInitialized = true;
      });
      print("Recorder initialized successfully.");
    } catch (e) {
      print("Error initializing recorder: $e");
    }
  }

  Future<void> _startRecording() async {
    if (!_isRecorderInitialized) {
      print("Recorder is not initialized. Ensure it is properly initialized.");
      return;
    }
    try {
      await _flutterSound!.startRecorder(toFile: 'audio.wav');
      setState(() {
        _isRecording = true;
      });
      print("Recording started successfully.");
    } catch (e) {
      print("Error starting recording: $e");
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _flutterSound!.stopRecorder();
      setState(() {
        _isRecording = false;
      });
      print("Recording stopped successfully.");
    } catch (e) {
      print("Error stopping recording: $e");
    }
  }

  @override
  void dispose() {
    _flutterSound!.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Recorder'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _isRecording ? _stopRecording : _startRecording,
          child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
        ),
      ),
    );
  }
}
