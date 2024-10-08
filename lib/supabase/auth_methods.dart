import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Sign Up Function
Future<void> signUp(
    String email, String password, String name, String role) async {
  final _supabase = Supabase.instance.client;

  try {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      //emailRedirectTo:
      //    'io.supabase.flutterdemo://login-callback/', // Optional: For deep linking
    );

    // Make the call to the stored procedure
    final result = await _supabase.rpc('adduser', params: {
      'id': response.user?.id,
      'email': email,
      'name': name,
      'role': role,
    });

    // Check and print the result after the RPC call
    print('Stored procedure "AddUser" called successfully.');
    print('Result: $result');

    if (response.user != null) {
      // Sign-up successful
      if (kDebugMode) {
        print('Sign-up successful: ${response.user!.email}');
      }
    } else {
      // Handle the case where user is null
      if (kDebugMode) {
        print('Sign-up was successful, but user is null.');
      }
    }
  } on AuthException catch (error) {
    // Handle authentication errors
    if (kDebugMode) {
      print('Error during sign-up: ${error.message}');
    }
  } catch (error) {
    // Handle any other errors
    if (kDebugMode) {
      print('An unexpected error occurred: $error');
    }
  }
}

// Sign In Function
Future<void> signIn(String email, String password) async {
  try {
    final response = await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    // Sign-in successful
    print('Sign-in successful: ${response.user?.email}');
  } on AuthException catch (error) {
    // Handle authentication errors
    print('Error during sign-in: ${error.message}');
    // Optionally, display the error message to the user
  } catch (error) {
    // Handle other errors
    print('Unexpected error during sign-in: $error');
  }
}

// Sign Out Function
Future<void> signOut() async {
  try {
    await Supabase.instance.client.auth.signOut();

    // Sign-out successful
    if (kDebugMode) {
      print('Sign-out successful');
    }
  } on AuthException catch (error) {
    // Handle authentication errors
    if (kDebugMode) {
      print('Error during sign-out: ${error.message}');
    }
  } catch (error) {
    // Handle other errors
    if (kDebugMode) {
      print('Unexpected error during sign-out: $error');
    }
  }
}
