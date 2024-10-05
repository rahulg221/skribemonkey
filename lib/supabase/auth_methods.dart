import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Sign Up Function
Future<void> signUp(String email, String password) async {
  try {
    final response = await Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo:
          'io.supabase.flutterdemo://login-callback/', // Optional: For deep linking
    );

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

/*
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
*/

/// Sign In Function
Future<AuthResponse> signIn(String email, String password) async {
  try {
    final response = await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.session == null) {
      throw AuthException(message: 'Invalid email or password.');
    }

    // Sign-in successful
    if (kDebugMode) {
      print('Sign-in successful: ${response.user?.email}');
    }

    return response;
  } on AuthException catch (error) {
    // Handle authentication errors
    if (kDebugMode) {
      print('Error during sign-in: ${error.message}');
    }
    rethrow; // Propagate the exception to the caller
  } catch (error) {
    // Handle any other errors
    if (kDebugMode) {
      print('Unexpected error during sign-in: $error');
    }
    rethrow; // Propagate the exception to the caller
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
