import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:skribemonkey/external_apis/summarization_methods.dart';
import 'package:skribemonkey/external_apis/transcription_methods.dart';

void main() {
  test('should summarize some text from a selected mp3 file', () async {
    String? transcription = await TranscriptionMethods()
        .transcribeMp3FromAssets('assets/yapsesh.mp3');

    // Print the transcription
    if (transcription != null) {
      print(transcription);
    } else {
      print("Transcription failed.");
    }

    // Call the summarization method
    final summary =
        await SummarizationMethods().summarizeTranscript(transcription!);

    // Print the summary (for debugging purposes)
    print(summary);

    // Check if the response is not null or empty
    expect(summary, isNotNull);
    expect(summary, isNotEmpty);
  });
}
