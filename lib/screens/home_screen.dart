import 'package:flutter/material.dart';
import 'package:skribemonkey/utils/color_scheme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(
              bottom: 8.0), // Add bottom padding to the title
          child: const Text('Welcome!'), // Set the title to "Welcome!"
        ),
        backgroundColor: Palette.primaryColor, // Set the AppBar's primary color
        actions: [
          // Search bar icon button
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Define what happens when the search button is pressed
            },
          ),
          // Search TextField
          Container(
            width: 200, // Set width of the search bar
            margin:
                const EdgeInsets.only(right: 16.0), // Add margin to the right
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Home Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
