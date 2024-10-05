// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skribemonkey/external_apis/summarization_methods.dart';
import 'package:skribemonkey/external_apis/transcription_methods.dart';
import 'package:skribemonkey/main.dart';

import 'package:flutter_test/flutter_test.dart';

void main() async {
  setUpAll(() async {
    await dotenv.load(fileName: ".env");
  });

  test('should return an answer from gpt god', () async {
    // Assuming askGPT is an async method that returns a Future<String>
    final res = await SummarizationMethods().askGPT('hi whats your name');

    // Print the result (for debugging purposes)
    print(res);

    // Check if the response is not null or empty
    expect(res, isNotNull);
    expect(res, isNotEmpty);
  });
}
