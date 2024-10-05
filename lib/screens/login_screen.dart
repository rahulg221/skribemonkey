import 'package:flutter/material.dart';
import 'package:skribemonkey/screens/home_screen.dart';
import 'package:skribemonkey/utils/color_scheme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCont = TextEditingController();
  final passwordCont = TextEditingController();

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
            Image.asset(
              'lib/images/logo2.png',
              width: 250,
              height: 250,
            ),
            Text(
              "Skribe Monkey",
              style: TextStyle(
                color: Palette.primaryColor,
                fontSize: 60,
                fontFamily: 'quick',
              ),
            ),
            const SizedBox(height: 32), // Add some space below the title
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
                onPressed: () {
                  // Navigate to HomeScreen when Login is clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
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
                onPressed: () {
                  // Placeholder for sign-up action
                },
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
