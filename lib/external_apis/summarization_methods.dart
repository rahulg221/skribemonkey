import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

// Write functions that takes a bunch of text and summarizes it, then we can try to work on extracting info into variables

class SummarizationMethods {
  Future<String?> askGPT(String prompt) async {
    final String apiKey = dotenv.env['OPENAI_API_KEY'] ?? 'Failed to load key';
    final Uri url = Uri.parse('https://api.openai.com/v1/chat/completions');

    // Make a post request from the GPT 3.5-turbo REST API
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "model": "gpt-3.5-turbo", // Can modify to use other models
        "messages": [
          {"role": "user", "content": prompt}
        ],
        "max_tokens": 50 // Adjust based on your needs
      }),
    );

    // Handle the response
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result['choices'][0]['message']
          ['content']; // Adjust based on response format
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return null;
    }
  }

  // Summarize the appointment transcription
  Future<String?> summarizeTranscript(String transcript) async {
    String prompt =
        "CONTEXT: Emergency room nurse speaking to patient. GOAL: Summarize symptoms and assess urgency level. FORMAT: Symptom 1 - (1 - 5, least urgent to most urgent). List in a column. If the transcript does not contain any relevant information, return 'NO RELEVANT INFO' $transcript";

    String? summary = await askGPT(prompt);

    // If successfully retrieved summary, store in Supabase
    if (summary != null) {
      // Send to database
      return summary;
    } else {
      print('Failed to get response from GPT');
    }
    return null;
  }

  // Retrieve any desired info from the medical appointment
  void extract_info() async {
    String desiredInfo = "";
    String prompt =
        "Extract the following information ($desiredInfo) from the transcribed text of a medical appointment: ";

    String? appointmentInfo = await askGPT(prompt);

    if (appointmentInfo != null) {
      // Store it/use it somewhere else
    } else {
      print('Failed to get response from GPT in extract_info()');
    }
  }
}
