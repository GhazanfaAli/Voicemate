import 'dart:io';

import 'package:flutter/material.dart';

class NecessaryProvider with ChangeNotifier {

     bool isDark = false;
     bool isPasswordVisible = true; 
     bool isSignUpLoading = false;
     bool isLoginLoading = false;
     bool isSubmitLoading = false;

     void setBackgroundColor(bool isDarkMode){
       if(isDark!=isDarkMode){
           isDark = isDarkMode;
           notifyListeners();
        }
      }  
        
     void changeVisibility(){
       isPasswordVisible = !isPasswordVisible;
       notifyListeners();
     }       

    Widget SignUpWidget(bool isLoading) {
        isSignUpLoading = isLoading;
       return Container(
         height: 50,
         width: 270,
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(20),
           border: Border.all(color: Colors.grey),
           color: Colors.green
          ),
         child: Center(child: isLoading?
                   const CircularProgressIndicator(strokeWidth: 3,color: Colors.white)
                 : const Text('SignUp'),
           ),
       );
     } 

      Widget LoginWidget(bool isLoading) {
        isLoginLoading = isLoading;
       return Container(
         height: 50,
         width: 270,
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(20),
           border: Border.all(color: Colors.grey),
           color: Colors.green
          ),
         child: Center(child: isLoading?
                   const CircularProgressIndicator(strokeWidth: 3,color: Colors.white)
                 : const Text('Login'),
           ),
       );
     } 

      Widget PasswordForgottenWidget(bool isLoading) {
        isSubmitLoading = isLoading;
       return Container(
         height: 50,
         width: 270,
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(20),
           border: Border.all(color: Colors.grey),
           color: Colors.green
          ),
         child: Center(child: isLoading?
                   const CircularProgressIndicator(strokeWidth: 3,color: Colors.white)
                 : const Text('Submit'),
           ),
       );
     } 


    Widget imageUploadWidget(File? image,final isDarkMode){      
        return Container(
           height: 200,
           width: 200,
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(100),
             border: Border.all(color:isDark?Colors.white:Colors.black26),
            ),
           child: image!=null? 
                 ClipRRect(borderRadius: BorderRadius.circular(100),child: Image.file(image.absolute,fit: BoxFit.cover),)
               : Icon(Icons.image,size: 35 , color: (isDark?Colors.white:Colors.black),),
           );
     }

 }

