import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Utils {

  static void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.black87,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

   void toastMessage(String message){
      Fluttertoast.showToast(
        msg: message,
         toastLength: Toast.LENGTH_LONG, // Set the duration to long
      gravity: ToastGravity.BOTTOM, // Choose a position
      timeInSecForIosWeb: 3, // Duration in seconds for iOS and Web
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
      //  timeInSecForIosWeb: 1,
      //  backgroundColor: Colors.red,
      //  textColor: Colors.white
      );
   }
   
}