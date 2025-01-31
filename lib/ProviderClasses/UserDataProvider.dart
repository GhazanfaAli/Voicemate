import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class UserDataProvider with ChangeNotifier{
   String _firstName = '';
   String _lastName = '';

   String get firstName => _firstName;
   String get lastName => _lastName;

    final auth = FirebaseAuth.instance;

    
   Future<void> fetchUserDetails() async {
      final user = auth.currentUser; // Get the current user
      if (user == null) {
         throw Exception('No user is logged in'); // Handle the case when no user is logged in
       }

      String uid = user.uid;
      DatabaseReference userReference = FirebaseDatabase.instance.ref('Users/$uid');

      try {
         DatabaseEvent event = await userReference.once();
         if (event.snapshot.exists) {
            _firstName = event.snapshot.child('firstName').value as String? ?? '';
            _lastName = event.snapshot.child('lastName').value as String? ?? '';
           notifyListeners();
         } else {
            throw Exception('User data does not exist');
         }
      } catch (error) {
          throw Exception('Failed to fetch user details: $error');
      }
    }

    void clearUserData() {
       _firstName = '';
       _lastName = '';
      notifyListeners();
    }
  
   
 }