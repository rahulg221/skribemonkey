import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

// Methods for Supabase following CRUD style
class DatabaseMethods {
  final SupabaseClient _client = Supabase.instance.client;

  // User methods

  // Create a User
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
      final userResponse = await _client.from('users').insert({
        'id': userId,
        'name': name,
        'email': email,
        'role': role,
        'created_at': DateTime.now().toIso8601String(), // Set current timestamp
      });
    } catch (error) {
      print("Error creating user: $error");
    }
  }

  // Fetch Users
  Future<List<Map<String, dynamic>>?> fetchUsers() async {
    try {
      // Fetch all users
      final response = await _client.from('users').select();

      if (response.isEmpty == true) {
        // Return the fetched data as a list of maps
        throw Exception('Failed to fetch users');
      } else {
        return response;
      }
    } catch (error) {
      print('Error fetching users: $error');
      return null;
    }
  }

  Future<Iterable<dynamic>?> fetchUserById(String userId) async {
    try {
      // Fetch user by ID
      final response =
          await _client.from('users').select().eq('id', userId).single();

      if (response.isEmpty == true) {
        throw Exception('Failed to fetch user: $userId');
      } else {
        return response.values;
      }
    } catch (error) {
      print('Error fetching user: $error');
      return null;
    }
  }

  // Update User
  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    try {
      final response =
          await _client.from('users').update(updates).eq('id', userId);

      if (response.statusCode != 201) {
        throw Exception("Error updating user information");
      } else {
        print("User updated successfully");
      }
    } catch (error) {
      print(error);
    }
  }

  // Delete User
  Future<void> deleteUser(String userId) async {
    try {
      final response = await _client.from('users').delete().eq('id', userId);

      if (response.statusCode != 201) {
        throw Exception("Error deleting user");
      } else {
        print('User deleted successfully');
      }
    } catch (error) {
      print(error);
    }
  }

  // Patient Methods

  // Create a Patient
  Future<void> createPatient(String name, String email, String userId,
      String gender, Iterable preexistingConditions) async {
    try {
      final String patientId = Uuid().v4();

      // Insert additional user information into the users table
      final userResponse = await _client.from('users').insert({
        'id': patientId,
        'user_id': userId,
        'name': name,
        'email': email,
        'gender': gender,
        'preexisting_conditions': preexistingConditions,
        'created_at': DateTime.now().toIso8601String(), // Set current timestamp
      });

      if (userResponse == null) {
        throw Exception("Error creating patient");
      }
    } catch (error) {
      print(error);
    }
  }

  // Fetch Patients
  Future<List<Map<String, dynamic>>?> fetchPatients() async {
    try {
      // Fetch all users
      final response = await _client.from('patients').select();

      if (response.isEmpty == true) {
        // Return the fetched data as a list of maps
        throw Exception('Failed to fetch users');
      } else {
        return response;
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<Iterable<dynamic>?> fetchPatientById(String patientId) async {
    try {
      // Fetch user by ID
      final response =
          await _client.from('users').select().eq('id', patientId).single();

      if (response.isEmpty == true) {
        throw Exception('Failed to fetch user: $patientId');
      } else {
        return response.values;
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  // Update Patient
  Future<void> updatePatient(
      String patientId, Map<String, dynamic> updates) async {
    try {
      final response =
          await _client.from('patients').update(updates).eq('id', patientId);

      if (response.statusCode != 201) {
        throw Exception("Error updating patient information");
      } else {
        print("User updated successfully");
      }
    } catch (error) {
      print(error);
    }
  }

  // Delete Patient
  Future<void> deletePatient(String patientId) async {
    try {
      final response =
          await _client.from('patients').delete().eq('id', patientId);

      if (response.statusCode != 201) {
        throw Exception("Error deleting patient");
      } else {
        print('User deleted successfully');
      }
    } catch (error) {
      print(error);
    }
  }

  // Entry Methods

  // Create a Entry
  Future<void> createEntry(
      String id,
      String patientId,
      String userId,
      String treatment,
      String condition,
      String urgencyLevel,
      String rawSummary,
      String Summary) async {
    try {
      final String entryId = Uuid().v4();

      // Insert additional user information into the users table
      final userResponse = await _client.from('entry').insert({
        'id': entryId,
        'patient_id': patientId,
        'user_id': userId,
        'condition': condition,
        'treatment': treatment,
        'urgency_level': urgencyLevel,
        'created_at': DateTime.now().toIso8601String(),
        'RAW_summary': rawSummary,
        'Summary': Summary,
      });

      if (userResponse == null) {
        throw Exception("Error creating user");
      }
    } catch (error) {
      print(error);
    }
  }

  // Fetch Entrys
  Future<List<Map<String, dynamic>>?> fetchEntrys() async {
    try {
      // Fetch all users
      final response = await _client.from('users').select();

      if (response.isEmpty == true) {
        // Return the fetched data as a list of maps
        throw Exception('Failed to fetch users');
      } else {
        return response;
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<Iterable<dynamic>?> fetchEntryById(String patientId) async {
    try {
      // Fetch user by ID
      final response =
          await _client.from('entry').select().eq('id', patientId).single();

      if (response.isEmpty == true) {
        throw Exception('Failed to fetch entry: $patientId');
      } else {
        return response.values;
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  // Update Entry
  Future<void> updateEntry(
      String patientId, Map<String, dynamic> updates) async {
    try {
      final response =
          await _client.from('entry').update(updates).eq('id', patientId);

      if (response.statusCode != 201) {
        throw Exception("Error updating entry information");
      } else {
        print("Entry updated successfully");
      }
    } catch (error) {
      print(error);
    }
  }

  // Delete Entry
  Future<void> deleteEntry(String entryId) async {
    try {
      final response = await _client.from('users').delete().eq('id', entryId);

      if (response.statusCode != 201) {
        throw Exception("Error deleting entry");
      } else {
        print('Entry deleted successfully');
      }
    } catch (error) {
      print(error);
    }
  }
}
