import 'package:flutter/material.dart';
import 'package:skribemonkey/screens/home_screen.dart';
import 'package:skribemonkey/screens/login_screen.dart';
import 'package:skribemonkey/screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://mzsakyycsslkjszjhhmg.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im16c2FreXljc3Nsa2pzempoaG1nIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjgwOTIzMzEsImV4cCI6MjA0MzY2ODMzMX0.YV_zNu8oP2lQNyz5Py-yRuH0Vdctocl_gnGfl67KWgE',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Dem',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Scaffold(appBar: AppBar(), body: RegisterScreen()));
  }
}
