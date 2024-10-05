import 'package:flutter/material.dart';
import 'package:skribemonkey/screens/home_screen.dart';
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
        if (!mounted) return;
        // Navigate to the home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
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
    if (emailCont.text.isEmpty || passwordCont.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email and password.')),
      );
      return;
    }

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

  // Focus nodes for email and password fields
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Add listeners to focus nodes to detect when the fields are focused/unfocused
    emailFocusNode.addListener(() {
      setState(() {});
    });
    passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Clean up the controllers and focus nodes when the widget is disposed
    emailCont.dispose();
    passwordCont.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo2.png', width: 270, height: 270),
            Text(
              "Skribe Monkey",
              style: TextStyle(
                color: Palette.primaryColor,
                fontSize: 60,
                fontFamily: 'quick',
              ),
            ),

            const SizedBox(height: 32), // Add some space below the title
            if (isLoading)
              const CircularProgressIndicator()
            else ...[
              SizedBox(
                width: 300,
                child: TextField(
                  controller: emailCont,
                  focusNode: emailFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: emailFocusNode.hasFocus
                        ? Palette.primaryColor.withOpacity(0.1)
                        : Colors.white, // White when not focused
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color.fromARGB(255, 211, 211, 211),
                          width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Palette.primaryColor, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(
                height: 16), // Adjusted padding between email and password
            SizedBox(
              width: 300,
              child: TextField(
                controller: passwordCont,
                focusNode: passwordFocusNode,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: passwordFocusNode.hasFocus
                      ? Palette.primaryColor.withOpacity(0.1)
                      : Colors.white, // White when not focused
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: const Color.fromARGB(255, 211, 211, 211),
                        width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Palette.primaryColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                obscureText: true,
              ),
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: 150, // Reduced width of the Login button
              child: MaterialButton(
                onPressed: isLoading ? null : _handleLogin,
                color: Palette.primaryColor,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
                hoverElevation: 0, // Remove drop shadow
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
                onPressed: isLoading ? null : _handleSignUp,
                color: const Color.fromARGB(255, 228, 228, 228),
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
                hoverElevation: 0, // Remove drop shadow
                child: const Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Palette.primaryColor,
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
