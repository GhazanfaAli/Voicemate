import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ChatHelper with ChangeNotifier{

    bool isLoading = false;
    Map<String,dynamic> userMap = {};
    FirebaseAuth auth = FirebaseAuth.instance;

    void SearchLoading(bool isValueLoading){
       isLoading = isValueLoading;
       notifyListeners();
    }

  // void onSearch(final searchController) async{
  //     isLoading = true;
  //     DatabaseReference userRefernce = FirebaseDatabase.instance.ref('Users');
  //    // query to find user by email
  //     try{
  //        final dataSnapShot = await userRefernce.orderByChild('email').equalTo(searchController.text.toString()).get(); 

  //        if(dataSnapShot.exists){
  //           Map<String,dynamic> data = Map<String,dynamic>.from(dataSnapShot.value as Map);
          
  //           String userId = data.keys.first;
  //           userMap = Map<String, dynamic>.from(data[userId]);
  //           Utils().toastMessage('UserFound');
  //           isLoading = false;

  //         }else{
  //            userMap = {};
  //            isLoading = false;
  //            Utils().toastMessage('No user found');
  //       }}catch(error){
  //           isLoading = false;
  //           Utils().toastMessage(error.toString());
  //       }
  //       notifyListeners();
  //   } 

 }
