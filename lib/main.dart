import 'dart:io';
import 'package:flutter/material.dart';
import 'package:skribemonkey/screens/home_screen.dart';
import 'dart:html' as html;
import 'package:skribemonkey/external_apis/transcription_methods.dart';

Future<void> main() async {
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
        home: Scaffold(appBar: AppBar(), body: LoginScreen()));
  }
}
