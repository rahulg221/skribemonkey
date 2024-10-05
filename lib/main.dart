import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:skribemonkey/external_apis/transcription_methods.dart';

Future<void> main() async {
  // Load environment variables
  await dotenv.load(fileName: ".env")
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Dem',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Skribe monkey'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final transcriptMethods = TranscriptionMethods();
  String transcript = 'mt transcript';

  Future<void> selectAndTranscribeFile() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement()
      ..accept = 'video/mp3'; // Restrict to MP4 files
    uploadInput.click(); // Open the file picker dialog

    uploadInput.onChange.listen((event) async {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final webFile = files.first;

        // Call the transcription method
        String? resultText = await transcriptMethods.transcribeMp3(webFile);
        print(resultText);

        // Update the UI with the result
        setState(() {
          transcript = resultText ?? 'Transcription failed';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              transcript,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: selectAndTranscribeFile,
              child: const Text('Transcribe'),
            ),
          ],
        ),
      ),
    );
  }
}
