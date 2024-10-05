// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:skribemonkey/utils/color_scheme.dart';
import 'package:skribemonkey/supabase/auth_methods.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCont = TextEditingController();
  final passwordCont = TextEditingController();
  bool isLoading = false;

// Function to handle login
  Future<void> _handleLogin() async {
    if (emailCont.text.isEmpty || passwordCont.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your email and password.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await signIn(emailCont.text.trim(), passwordCont.text.trim());

      // Check if the user is logged in
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        // Navigate to the home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Login failed. Please check your credentials.')),
        );
      }
    } catch (error) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during login: $error')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to handle sign-up
  Future<void> _handleSignUp() async {
    setState(() {
      isLoading = true;
    });

    try {
      await signUp(emailCont.text.trim(), passwordCont.text.trim());

      // Inform the user to verify their email
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Sign-up successful. Please verify your email.')),
      );
    } catch (error) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during sign-up: $error')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Skribe Monkey",
              style: TextStyle(
                color: Palette.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 60,
              ),
            ),
            const SizedBox(height: 32), // Add some space below the title
            SizedBox(
              width: 300,
              child: TextField(
                controller: emailCont,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 300,
              child: TextField(
                controller: passwordCont,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 150, // Reduced width of the Login button
              child: MaterialButton(
                onPressed: () {
                  isLoading ? null : _handleLogin();
                },
                color: Palette.primaryColor,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0, // Remove drop shadow
                child: const Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 150, // Same width as Login button
              child: MaterialButton(
                onPressed: () {
                  isLoading ? null : _handleSignUp;
                },
                color: Palette.secondaryColor,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0, // Remove drop shadow
                child: const Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
