import 'package:flutter/material.dart';
import 'package:skribemonkey/screens/home_screen.dart';
import 'package:skribemonkey/utils/color_scheme.dart';

class NewPatientScreen extends StatefulWidget {
  const NewPatientScreen({Key? key}) : super(key: key);

  @override
  State<NewPatientScreen> createState() => _NewPatientScreenState();
}

class _NewPatientScreenState extends State<NewPatientScreen> {
  final fNameCont = TextEditingController();
  final lNameCont = TextEditingController();
  final emailCont = TextEditingController();

  // Focus nodes for fName and lName fields
  final FocusNode fNameFocusNode = FocusNode();
  final FocusNode lNameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();

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
    emailFocusNode.addListener(() {
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
    emailCont.dispose();
    fNameFocusNode.dispose();
    lNameFocusNode.dispose();
    emailFocusNode.dispose();

    // Dispose all additional controllers
    for (var controller in additionalControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0), // Set desired height here
        child: SafeArea(
          child: AppBar(
            backgroundColor: Palette.primaryColor,
            elevation: 0, // Remove shadow
            leading: Padding(
              padding: const EdgeInsets.only(
                  top: 5.0, left: 8.0), // Add top padding here
              child: IconButton(
                icon: Icon(Icons.arrow_back,
                    size: 50, color: Colors.white), // Back button icon
                hoverColor: Colors.transparent, // Remove hover effect color
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        // To prevent overflow when keyboard appears
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo2.png',
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
                _buildTextField(fNameCont, fNameFocusNode, 'First Name'),
                const SizedBox(height: 16),
                _buildTextField(lNameCont, lNameFocusNode, 'Last Name'),
                const SizedBox(height: 16),
                _buildTextField(emailCont, emailFocusNode, 'Email'),
                const SizedBox(height: 16),
                _buildDropdownField(),
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
                  width: 600, // Set the width here to your desired value
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
                const SizedBox(height: 10),
                _buildRegisterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _buildTextField(
      TextEditingController controller, FocusNode focusNode, String label) {
    return SizedBox(
      width: 300,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: focusNode.hasFocus
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
    );
  }

  SizedBox _buildDropdownField() {
    return SizedBox(
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
    );
  }

  SizedBox _buildRegisterButton() {
    return SizedBox(
      width: 150,
      child: MaterialButton(
        onPressed: () {
          // Validate all fields
          if (fNameCont.text.isEmpty ||
              lNameCont.text.isEmpty ||
              emailCont.text.isEmpty ||
              selectedRole == null ||
              additionalControllers
                  .any((controller) => controller.text.isEmpty)) {
            // Show an alert or Snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please fill out all fields.'),
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            // Handle the registration logic here
            // You can also collect the data from all fields to pass it back
            Navigator.pop(
                context,
                fNameCont.text +
                    " " +
                    lNameCont
                        .text); // Pass the full name or any other info back
          }
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
    );
  }
}
