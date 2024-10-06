import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';

class TranscriptionMethods {
  TranscriptionMethods();

  Future<String?> transcribeM4aFromFilePicker() async {
    // Load dotenv if it's not already loaded
    if (!dotenv.isInitialized) {
      await dotenv.load(fileName: ".env");
    }

    String apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      print('Error: API key not found in .env');
      return null;
    }

    final String apiUrl = 'https://api.openai.com/v1/audio/transcriptions';

    try {
      // Open the file picker to select an audio file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, // Set to custom
        allowedExtensions: ['m4a'], // Specify allowed extensions
      );

      // Check if the user has selected a file
      if (result == null || result.files.isEmpty) {
        print('Error: No file selected');
        return null;
      }

      // Get the selected file
      final String? filePath = result.files.single.path;

      // Check if filePath is null
      if (filePath == null) {
        print('Error: File path is null');
        return null;
      }

      final File file = File(filePath);

      // Check if the file exists
      if (!file.existsSync()) {
        print('Error: audio file not found at $filePath');
        return null;
      }

      // Read file as bytes
      final bytes = await file.readAsBytes();

      // Prepare headers for the transcription request
      final headers = {
        'Authorization': 'Bearer $apiKey',
      };

      // Create a multipart request to send to the OpenAI API
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..headers.addAll(headers)
        ..fields['model'] = 'whisper-1'
        ..files.add(
          http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: file.uri.pathSegments.last, // Use the actual filename
            contentType: MediaType('audio', 'm4a'), // Change as needed
          ),
        );

      // Send the request
      final response = await request.send();

      // Process the response
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);
        return jsonResponse['text'];
      } else {
        print('Error: ${response.statusCode}');
        print('Response body: ${await response.stream.bytesToString()}');
        return null;
      }
    } catch (e) {
      print('An error occurred: $e');
      return null;
    }
  }

  Future<String?> transcribeMp3FromAssets(String assetPath) async {
    // Load dotenv if it's not already loaded
    if (!dotenv.isInitialized) {
      await dotenv.load(fileName: ".env");
    }

    String apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      print('Error: API key not found in .env');
      return null;
    }

    final String apiUrl = 'https://api.openai.com/v1/audio/transcriptions';

    try {
      // Load the asset file as bytes
      final fileBytes = await rootBundle.load(assetPath);
      final bytes = fileBytes.buffer.asUint8List();

      // Prepare headers for the transcription request
      final headers = {
        'Authorization': 'Bearer $apiKey',
      };

      // Create a multipart request to send to the OpenAI API
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..headers.addAll(headers)
        ..fields['model'] = 'whisper-1'
        ..files.add(
          http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: 'yapsesh.mp3', // Hardcoded filename for the request
            contentType: MediaType('audio', 'mp3'),
          ),
        );

      // Send the request
      final response = await request.send();

      // Process the response
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);
        return jsonResponse['text'];
      } else {
        print('Error: ${response.statusCode}');
        print(await response.stream.bytesToString());
        return null;
      }
    } catch (e) {
      print('An error occurred: $e');
      return null;
    }
  }
}
