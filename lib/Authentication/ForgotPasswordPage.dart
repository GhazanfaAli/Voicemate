import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voicemate/Authentication/LoginPage.dart';
import 'package:voicemate/Authentication/SignUpPage.dart';
import 'package:voicemate/views/chat_screen/tanveer/utils.dart';

import '../ProviderClasses/NecessaryProvider.dart';

class ForgotPasswordPage extends StatefulWidget{
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  
  TextEditingController emailController = TextEditingController();
  final emailkey = GlobalKey<FormState>(); 
  final auth = FirebaseAuth.instance;

   @override
  void didChangeDependencies() {
     super.didChangeDependencies();
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    
   WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NecessaryProvider>(context, listen: false).setBackgroundColor(isDarkMode);
    });
  }

  @override
  Widget build(BuildContext context){
    final isDarkMode = MediaQuery.of(context).platformBrightness==Brightness.dark;
    final provider = Provider.of<NecessaryProvider>(context);
    return Scaffold(
      backgroundColor: provider.isDark?Colors.black:Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 10,left: 32,right: 32,bottom: 50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
             Text('Forgot Password?', style: TextStyle(fontSize: 25, color: provider.isDark?Colors.white:Colors.black),),

             const SizedBox(height: 20),
             Form(
               key: emailkey,
               child: FormFieldWidget(
                  controller:emailController, text: 'Email', type: TextInputType.emailAddress, icon: Icons.email, isDarkMode: isDarkMode, message: 'Enter email'),
              ),
        
             const SizedBox(height: 30),
             InkWell(
               onTap: (){
                 if(emailkey.currentState!.validate()){
                       provider.isSubmitLoading = true;
                     auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value){
                          Utils().toastMessage('Email is sent to recover password, please check it out!');
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginPage()));
                    }).onError((error, StackTrace){
                         Utils().toastMessage(error.toString());
                    }); 
                 }
               },
               child: provider.PasswordForgottenWidget(provider.isSubmitLoading),
             ), 

           ],),
        ),
      ),
    );
  }
}