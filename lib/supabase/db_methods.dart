import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:skribemonkey/models/entry_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:skribemonkey/models/patient_model.dart';

// Methods for Supabase following CRUD style
class DatabaseMethods {
  final _client = Supabase.instance.client;

  Future<void> uploadAudioFile(String audioPath, String fileName) async {
    try {
      // Upload the audio file to Supabase storage directly using the file path
      final response =
          await _client.storage.from('audio').upload(fileName, File(audioPath));

      // Check if the upload was successful
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  // User methods

  // Create a User
  /*
  Future<void> createUser(
      String name, String email, String password, String role) async {
    try {
      // Sign up the user with email and password
      final authResponse =
          await _client.auth.signUp(email: email, password: password);

      if (authResponse.user == null) {
        throw Exception('Error creating user. Please try again later');
      }

      // After signing up, get the user's ID
      final userId = authResponse.user?.id ?? 'unknown-id';

      // Insert additional user information into the users table
      await _client.rpc('AddUser', params: {
        'id': userId,
        'name': name,
        'email': email,
        'role': role,
        'created_at': DateTime.now().toIso8601String()
      });
    } on PostgrestException catch (error) {
      print(error.toString());
    }
  }*/

  // Fetch Users
  Future<List<Map<String, dynamic>>?> fetchUsers() async {
    try {
      // Fetch all users
      final response = await _client.rpc('SelectAllUsers');

      if (response.error == null) {
        throw Exception('Failed to fetch users');
      } else {
        final List<Map<String, dynamic>> rows = response.data;
        return rows;
      }
    } on PostgrestException catch (error) {
      print(error.toString());
    }
  }

  Future<Iterable<dynamic>?> fetchUserById(String userId) async {
    try {
      // Fetch user by ID
      final response = await _client.rpc('GetUserByID', params: {'id': userId});

      if (response.error == null) {
        throw Exception('Failed to fetch user: $userId');
      } else {
        final List<dynamic> rows = response.data;
        return rows;
      }
    } on PostgrestException catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Update User
  Future<void> updateUser(
      String userId, String name, String email, String role) async {
    try {
      await _client.rpc('UpdateUser',
          params: {'name': name, 'email': email, 'role': role});
    } on PostgrestException catch (error) {
      print(error.toString());
    }
  }

  // Delete User
  Future<void> deleteUser(String userId) async {
    try {
      await _client.rpc('DeleteUser', params: {'id': userId});
    } on PostgrestException catch (error) {
      print(error.toString());
    }
  }

  // Patient Methods

  // Create a Patient
  Future<void> createPatient(String firstName, String lastName, String email,
      String gender, Iterable preexistingConditions) async {
    final _client = Supabase.instance.client;
    final currentUser = _client.auth.currentUser;

    if (currentUser == null) {
      throw Exception('User is not logged in');
    }

    try {
      // Print the details of the patient being created
      print('Creating patient record with the following details:');
      print('User ID: ${currentUser.id}');
      print('First Name: $firstName');
      print('Last Name: $lastName');
      print('Email: $email');
      print('Gender: $gender');
      print('Pre-existing Conditions: $preexistingConditions');

      // Insert additional user information into the users table
      await _client.rpc('addpatient', params: {
        'id': Uuid().v4(),
        'user_id': currentUser.id,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'gender': gender,
        'preexisting_conditions': preexistingConditions,
      });

      // Print success message
      print('Patient record created successfully.');
    } on PostgrestException catch (error) {
      // Print error details if PostgrestException occurs
      print('PostgrestException: ${error.message}');
    } catch (error) {
      // Print error details if a different type of exception occurs
      print('An unexpected error occurred: $error');
    }
  }

  // Fetch Patients
  Future<List<Map<String, dynamic>>?> fetchPatients() async {
    try {
      // Fetch all users
      final response = await _client.rpc('selectallpatients');

      if (response.error == null) {
        throw Exception('Failed to fetch patients');
      } else {
        final List<Map<String, dynamic>> rows = response.data;
        return rows;
      }
    } on PostgrestException catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<Patient?> fetchPatientById(String patientId) async {
    print('fetching');
    try {
      // Fetch user by ID
      Map<String, dynamic> patientData =
          await _client.rpc('getpatientbyid', params: {'p_id': patientId});

      print(patientData);
      final patient = Patient.fromJson(patientData);
      print(patient);

      return patient;
    } on PostgrestException catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<List<Entry>> fetchEntryByPatient(String patientId) async {
    try {
      // Fetch user by ID
      List<Map<String, dynamic>> entries =
          await _client.rpc('getentrybypatient', params: {'p_id': patientId});

      print(entries);
      print(entries.map((e) => Entry.fromJson(e)).toList());

      return entries.map((e) => Entry.fromJson(e)).toList();
    } on PostgrestException catch (error) {
      print(error.toString());

      throw Exception('An unexpected error occured: $error');
    }
  }

  // Fetch Patients by their Doctor
  Future<List<Patient>> fetchPatientByDoctor(String userId) async {
    try {
      // Fetch user by ID
      List<Map<String, dynamic>> patients =
          await _client.rpc('getpatientbydoctor', params: {'dr_id': userId});

      print(patients);
      print(patients.map((e) => Patient.fromJson(e)).toList());

      return patients.map((e) => Patient.fromJson(e)).toList();
    } on PostgrestException catch (error) {
      print(error.toString());

      throw Exception('An unexpected error occured: $error');
    }
  }

  // Update Patient
  Future<void> updatePatient(String patient_id, String user_id, String name,
      String email, String gender, Iterable preexisting_conditions) async {
    try {
      await _client.rpc('UpdatePatient', params: {
        'user_id': user_id,
        'name': name,
        'email': email,
        'gender': gender,
        'preexisting_conditions': preexisting_conditions
      });
    } on PostgrestException catch (error) {
      print(error.toString());
    }
  }

  // Delete Patient
  Future<void> deletePatient(String patientId) async {
    try {
      await _client.rpc('DeletePatient', params: {'id': patientId});
    } on PostgrestException catch (error) {
      print(error.toString());
    }
  }

  // Entry Methods

  // Create a Entry
  Future<void> createEntry(String patientId, String userId, String condition,
      int urgencyLevel, String Summary) async {
    try {
      final String entryId = Uuid().v4();

      // Insert additional user information into the users table
      await _client.rpc('addentry', params: {
        'id': entryId,
        'patient_id': patientId,
        'user_id': userId,
        'condition': 'mt',
        'urgency_level': urgencyLevel,
        //'created_at': DateTime.now().toIso8601String(),
        'Summary': Summary
      });
    } on PostgrestException catch (error) {
      print(error.toString());
    }
  }

  // Fetch Entrys
  Future<List<Map<String, dynamic>>?> fetchEntrys() async {
    try {
      // Fetch all users
      final response = await _client.rpc('SelectAllEntries');

      if (response.error == null) {
        throw Exception('Failed to fetch entries');
      } else {
        final List<Map<String, dynamic>> rows = response.data;
        return rows;
      }
    } on PostgrestException catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<Iterable<dynamic>?> fetchEntryById(String entryId) async {
    try {
      // Fetch user by ID
      final response =
          await _client.rpc('GetEntryByID', params: {'id': entryId});

      if (response.error == null) {
        throw Exception('Failed to fetch entry: $entryId');
      } else {
        final List<dynamic> rows = response.data;
        return rows;
      }
    } on PostgrestException catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<Iterable<dynamic>?> fetchOrderedEntries() async {
    try {
      // Fetch user by ID
      final response = await _client.rpc('SelectOrderedEntries');

      if (response.error == null) {
        throw Exception('Failed to fetch entries');
      } else {
        final List<dynamic> rows = response.data;
        return rows;
      }
    } on PostgrestException catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Update Entry
  Future<void> updateEntry(String entry_id, String user_id, String condition,
      String treatment, String urgency_level) async {
    try {
      await _client.rpc('UpdateEntry', params: {
        'user_id': user_id,
        'condition': condition,
        'treatment': treatment,
        'urgency_level': urgency_level,
        'id': entry_id
      });
    } on PostgrestException catch (error) {
      print(error.toString());
    }
  }

  // Delete Entry
  Future<void> deleteEntry(String entry_id) async {
    try {
      await _client.rpc('DeleteEntry', params: {'id': entry_id});
    } on PostgrestException catch (error) {
      print(error.toString());
    }
  }
}
