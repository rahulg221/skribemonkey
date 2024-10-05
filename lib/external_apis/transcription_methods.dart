import 'dart:html' as html;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TranscriptionMethods {
  TranscriptionMethods();

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
}
