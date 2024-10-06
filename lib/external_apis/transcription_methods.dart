import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'dart:html' as html;

class TranscriptionMethods {
  TranscriptionMethods();

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

  /*
  Future<String?> transcribeMp3(html.File webFile) async {
    await dotenv.load(fileName: ".env");
    String apiKey = dotenv.env['OPENAI_API_KEY'].toString();
    final String apiUrl = 'https://api.openai.com/v1/audio/transcriptions';

    try {
      // Prepare headers
      final headers = {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'multipart/form-data',
      };

      // Read the file as an array buffer
      final reader = html.FileReader();
      reader.readAsArrayBuffer(webFile);
      await reader.onLoadEnd.first;

      // Get the file data as bytes
      final fileBytes = reader.result as List<int>;

      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..headers.addAll(headers)
        ..fields['model'] = 'whisper-1'
        ..files.add(
          http.MultipartFile.fromBytes(
            'file',
            fileBytes,
            filename: webFile.name,
            contentType: MediaType('video', 'mp3'),
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

  Future<String> selectAndTranscribeFile() async {
    String transcript = '';

    html.FileUploadInputElement uploadInput = html.FileUploadInputElement()
      ..accept = 'video/mp3'; // Restrict to MP4 files
    uploadInput.click(); // Open the file picker dialog

    uploadInput.onChange.listen((event) async {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final webFile = files.first;

        // Call the transcription method
        String? resultText = await transcribeMp3(webFile);
        print(resultText);

        transcript = resultText ?? 'Transcription failed';
      }
    });

    return transcript;
  }*/
}
