import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:skribemonkey/screens/home_screen.dart';
import 'package:skribemonkey/screens/login_screen.dart';
import 'package:skribemonkey/screens/new_patient_screen.dart';
import 'package:skribemonkey/screens/register_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: 'https://mzsakyycsslkjszjhhmg.supabase.co',
    anonKey: 'SUPABASE_ANON_KEY',
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
      title: 'Skribe Monkey',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(appBar: AppBar(), body: LoginScreen()),
      //routes: {'/new-patient': (context) => const NewPatientScreen()},
    );
  }
}
