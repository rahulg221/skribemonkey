import 'package:flutter/material.dart';
import 'package:skribemonkey/utils/color_scheme.dart';

class NewPatientScreen extends StatefulWidget {
  const NewPatientScreen({super.key});

  @override
  State<NewPatientScreen> createState() => _NewPatientScreenState();
}

class _NewPatientScreenState extends State<NewPatientScreen> {
  final fNameCont = TextEditingController();
  final lNameCont = TextEditingController();

  // Focus nodes for fName and lName fields
  final FocusNode fNameFocusNode = FocusNode();
  final FocusNode lNameFocusNode = FocusNode();

  // Dropdown variables
  String? selectedRole;
  final List<String> roles = ['Male', 'Female', 'Other'];

  // List to hold additional text box controllers
  final List<TextEditingController> additionalControllers = [];

  @override
  void initState() {
    super.initState();

    // Add listeners to focus nodes to detect when the fields are focused/unfocused
    fNameFocusNode.addListener(() {
      setState(() {});
    });
    lNameFocusNode.addListener(() {
      setState(() {});
    });
  }

  void _addTextBox() {
    setState(() {
      additionalControllers.add(TextEditingController());
    });
  }

  @override
  void dispose() {
    // Clean up the controllers and focus nodes when the widget is disposed
    fNameCont.dispose();
    lNameCont.dispose();
    fNameFocusNode.dispose();
    lNameFocusNode.dispose();
    // Dispose all additional controllers
    for (var controller in additionalControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register New Patient'),
        backgroundColor: Palette.primaryColor,
        elevation: 0, // Remove shadow
      ),
      body: SingleChildScrollView(
        // To prevent overflow when keyboard appears
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // Removed Center to allow the content to start from the top
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/images/logo2.png',
                  width: 250,
                  height: 250,
                ),
                Text(
                  "Register New Patient",
                  style: TextStyle(
                    color: Palette.primaryColor,
                    fontSize: 35,
                    fontFamily: 'quick',
                  ),
                ),
                const SizedBox(height: 32), // Add some space below the title
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: fNameCont,
                    focusNode: fNameFocusNode,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      filled: true,
                      fillColor: fNameFocusNode.hasFocus
                          ? Palette.primaryColor.withOpacity(0.1)
                          : Colors.white, // White when not focused
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 211, 211, 211),
                          width: 2,
                        ),
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
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: lNameCont,
                    focusNode: lNameFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      filled: true,
                      fillColor: lNameFocusNode.hasFocus
                          ? Palette.primaryColor.withOpacity(0.1)
                          : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 211, 211, 211),
                          width: 2,
                        ),
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
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 300,
                  child: DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 211, 211, 211),
                          width: 2,
                        ),
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
                    items: roles.map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRole = newValue;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Button to add new text boxes
                MaterialButton(
                  elevation: 0,
                  hoverElevation: 0,
                  color: const Color.fromARGB(255, 211, 211, 211),
                  padding: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  onPressed: _addTextBox,
                  child: Text(
                    'Add Pre-Existing Condition',
                    style: TextStyle(
                      color: Palette.primaryColor,
                      fontSize: 15,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Display additional text boxes
                Container(
                  width: 450, // Set the width here to your desired value
                  child: ListView.builder(
                    shrinkWrap: true, // Prevent overflow
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable scrolling
                    itemCount: additionalControllers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: SizedBox(
                          width: double
                              .infinity, // Use the full width of the container
                          child: TextField(
                            controller: additionalControllers[index],
                            decoration: InputDecoration(
                              labelText: 'Condition ${index + 1}',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 32),
                SizedBox(
                  width: 150,
                  child: MaterialButton(
                    onPressed: () {
                      // Placeholder for register action
                      // Implement your registration logic here
                    },
                    color: Palette.primaryColor,
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                    hoverElevation: 0,
                    child: const Center(
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
