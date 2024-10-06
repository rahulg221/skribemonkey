import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:skribemonkey/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:skribemonkey/supabase/db_methods.dart';


/*
class UserProvider with ChangeNotifier {
  User? _user; 

  // Function to return user
  User get getUser => _user!;

  // Function to refresh user
  Future<void> refreshUser() async {
    try {
      // Get the user data
      model.User user =
          await UserMethods().getUserDetails(supabase.auth.currentUser!.id);

      _user = user;

      notifyListeners();
    } 
    catch (e) {
      e.toString();

    }
  }
}
*/
