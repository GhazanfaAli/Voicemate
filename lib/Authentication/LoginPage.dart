import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voicemate/Authentication/ForgotPasswordPage.dart';
import 'package:voicemate/Authentication/SignUpPage.dart';
import 'package:voicemate/Interface/StartingPage.dart';
import 'package:voicemate/ProviderClasses/NecessaryProvider.dart';
import 'package:voicemate/views/chat_screen/tanveer/utils.dart';

import '../ProviderClasses/UserDataProvider.dart';


class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

   final emailkey = GlobalKey<FormState>();
   final passwordkey = GlobalKey<FormState>(); 

   TextEditingController emailController = TextEditingController();
   TextEditingController passwordController = TextEditingController();

   FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void didChangeDependencies() {
     super.didChangeDependencies();
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    
   WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NecessaryProvider>(context, listen: false).setBackgroundColor(isDarkMode);
    });
  }


  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final provider = Provider.of<NecessaryProvider>(context);

    return Scaffold(
       backgroundColor: provider.isDark?Colors.black:Colors.white,
       body: SingleChildScrollView(
         child: Padding(
           padding: EdgeInsets.only(top: screenHeight*0.1,bottom: 20,left: 20,right: 20),
           child: Column(
            children: [
                const Text('Voicemate',style: TextStyle(fontSize: 30, color: Colors.blue, fontWeight: FontWeight.bold),),
                
                 SizedBox(height: screenHeight*0.1),
                Form(
                   key: emailkey,
                   child: FormFieldWidget(controller: emailController, text: 'Email', icon: Icons.email,type: TextInputType.emailAddress, isDarkMode: isDarkMode, message:'Enter email')
                 ),
                
                 const SizedBox(height: 15),
                Form(
                   key: passwordkey,
                   child: PasswordWidget(passwordController: passwordController, provider: provider, isDarkMode: isDarkMode)
                 ),
               
                SizedBox(height: screenHeight*0.06),
                InkWell(
                   onTap: (){
                      if(emailkey.currentState!.validate() && passwordkey.currentState!.validate()){
                         provider.isLoginLoading = true;
                         auth.signInWithEmailAndPassword(
                            email: emailController.text.toString(),
                            password: passwordController.text.toString()
                          ).then((value){
                              Provider.of<UserDataProvider>(context, listen: false).fetchUserDetails();
                              provider.isLoginLoading = false;
                             Utils().toastMessage('Signed in Successfully'); 
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const StartingPage()));
                          }).onError((error,StackTrace){
                               provider.isLoginLoading = false;
                              Utils().toastMessage(error.toString());
                          });

                       }
                    },
                   child: provider.LoginWidget(provider.isLoginLoading),
                 ),
           
                SizedBox(height: screenHeight*0.07),
                TextButton(
                   onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const ForgotPasswordPage()));}, 
                   child: const Text('Forgotten Password?',style: TextStyle(fontSize: 20,color: Colors.blue)),
                 ),
         
                const SizedBox(height: 10), 
                Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10),
                   child: Row(
                    children: [
                       const Expanded(child: Divider(thickness: 1.2)),
                       const SizedBox(width: 12), 
                       Text('Or',style: TextStyle(fontSize: 15,color: isDarkMode?Colors.white:Colors.black),),
                       const SizedBox(width: 12), 
                       const Expanded(child: Divider(thickness: 1.2)),
                     ]),
                 ),
         
                const SizedBox(height: 20),
                InkWell(
                  onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignUpPage()));
                   },
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.75,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                     ),
                    child: const Center(child: Text('Create Account'),),
                   ),
                ),
         
         
            ],), 
          ),
       ),
         
     );
  }
}