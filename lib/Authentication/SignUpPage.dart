import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import 'package:provider/provider.dart';
import 'package:voicemate/Authentication/LoginPage.dart';
import 'package:voicemate/Interface/StartingPage.dart';
import 'package:voicemate/ProviderClasses/UserDataProvider.dart';
import 'package:voicemate/views/chat_screen/tanveer/utils.dart';

import '../ProviderClasses/NecessaryProvider.dart';

class SignUpPage extends StatefulWidget{
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

    final firstNamekey = GlobalKey<FormState>();
    final lastNamekey = GlobalKey<FormState>(); 
    final emailkey = GlobalKey<FormState>();
    final passwordkey = GlobalKey<FormState>();

    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    bool isLoading = false;

    FirebaseAuth auth = FirebaseAuth.instance;
 //   firebaseStorage.FirebaseStorage storage = firebaseStorage.FirebaseStorage.instance;
  //  DatabaseReference dataBaseRef = FirebaseDatabase.instance.ref('Post');
   // FirebaseFirestore _fireStore = FirebaseFirestore.instance;

     File? image;
     final picker = ImagePicker();
   
    Future getGalleryImage() async{
      final pickedImage = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if(pickedImage!=null){
        image = File(pickedImage.path);
      }else{
        print('No image picked');
      }
    }

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

     double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;
     final provider = Provider.of<NecessaryProvider>(context, listen: true);
     final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: provider.isDark?Colors.black:Colors.white,
      body: SingleChildScrollView(
        child: Padding(
           padding:  EdgeInsets.only(top: screenHeight*0.1, bottom: 20,left: 15,right: 15),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
            children: [

               Text('Create Account', style: TextStyle(fontSize: 33,fontWeight: FontWeight.bold, color: isDarkMode?Colors.white:Colors.black),),          
               const SizedBox(height: 10), 

               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children:[
                   Text('Already have an account?', style: TextStyle(fontSize: 16, color: provider.isDark?Colors.white:Colors.black),),
                   TextButton(
                     onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>const LoginPage()));},
                     child: const Text('Sign In',style: TextStyle(fontSize:18, color: Colors.blue),),),
                 ]),

               
               
      //-------------- Upload image on Firebase Storage ---------------\\   
   Lottie.asset(
     'assets/signup_lottie.json',
    
   ),
      // ---------------------------------------------------------------------\\
                const SizedBox(height: 25),
                Row(
                 children: [ 
                    Expanded(
                      child: Form(
                         key: firstNamekey,
                         child: FormFieldWidget(controller: firstNameController, text:'FirstName',icon: Icons.person,type: TextInputType.text,isDarkMode: provider.isDark,message:'Enter FirstName'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Form(
                         key: lastNamekey,
                         child: FormFieldWidget(controller: lastNameController, text:'LastName',icon: Icons.person,type: TextInputType.text, isDarkMode: provider.isDark,message:'Enter LastName'),
                      ),
                    ),                   
                 ]),

                 const SizedBox(height: 15),

                    Form(
                       key: emailkey,
                       child: FormFieldWidget(controller: emailController,text:'Email', icon:Icons.email,type: TextInputType.emailAddress, isDarkMode: provider.isDark,message:'Enter email'),
                    ),

                  const SizedBox(height: 15),
                  Form(
                     key: passwordkey,
                     child: PasswordWidget(passwordController: passwordController, provider: provider, isDarkMode: isDarkMode)),
                  
                  const SizedBox(height: 25),

              InkWell(
                onTap: () async{
                   if(firstNamekey.currentState!.validate()&& lastNamekey.currentState!.validate()&& emailkey.currentState!.validate()&&passwordkey.currentState!.validate()){
                        provider.isSignUpLoading = true;
                     try{
                        UserCredential userCredential = await auth.createUserWithEmailAndPassword(
                             email: emailController.text.toString(),
                             password: passwordController.text.toString()
                         );
        
              // Storing User details in FireStore database
                     
                       userCredential.user!.updateProfile(displayName: firstNameController.text.toString());
                     
                       DatabaseReference userRef = FirebaseDatabase.instance.ref('Users/${auth.currentUser!.uid}');
                         await userRef.set({
                          'firstName': firstNameController.text.toString(),
                          'lastName': lastNameController.text.toString(),
                          'email': emailController.text.toString(),
                           'status': 'Unavailable',
                         });
                       
                // Fetch user details using userDataProvider
                       Provider.of<UserDataProvider>(context, listen: false).fetchUserDetails();

                        provider.isSignUpLoading = false;
                        Utils().toastMessage('Account has been created');
                           Navigator.push(context, MaterialPageRoute(builder: (context)=>const StartingPage())
                         );
                     
                     }catch(error){
                        provider.isSignUpLoading = false;
                        Utils().toastMessage(error.toString()); 
                     } 
                     // ------- Commented Code --------\\
 //-----------------------------------------------------------------------------------                      
                      //  provider.isSignUpLoading = true;
                      // 
                      //  firebaseStorage.Reference ref = firebaseStorage.FirebaseStorage.instance.ref('/FolderName/'+DateTime.now().microsecondsSinceEpoch.toString());
                      //  firebaseStorage.UploadTask uploadTask = ref.putFile(image!.absolute);
                      //
                      //   Future.value(uploadTask).then((value) async{
                      //       var newUrl = await ref.getDownloadURL();
                      //       dataBaseRef.child('1').set({
                      //         'id': '123',
                      //         'title': newUrl.toString(),
                      //       });   
                      //    }).then((value){
                      //         provider.isSignUpLoading = false;
                      //         Navigator.push(context, MaterialPageRoute(builder: (context)=>StartingPage()));
                      //    }).onError((error, StackTrace){
                      //          provider.isSignUpLoading = false;
                      //    });
//------------------------------------------------------------------------------------                      
                   
                       }},
                     child: provider.SignUpWidget(provider.isSignUpLoading),
                    ),

               ],
           ),
        
         ),
       ),
     );
   }
 }


class PasswordWidget extends StatelessWidget {
  const PasswordWidget({
    super.key,
    required this.passwordController,
    required this.provider,
    required this.isDarkMode,
  });

  final TextEditingController passwordController;
  final NecessaryProvider provider;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: provider.isPasswordVisible,
      style: TextStyle(color: provider.isDark?Colors.white:Colors.black),
      decoration: InputDecoration(
         hintText: 'Password',
         hintStyle: TextStyle(color: isDarkMode?Colors.white:Colors.black),
         prefixIcon:Icon(Icons.lock, color: isDarkMode?Colors.white:Colors.black,),
         suffixIcon: InkWell(
          onTap: (){
            provider.changeVisibility(); 
           },
          child: Icon(provider.isPasswordVisible?Icons.visibility:Icons.visibility_off, color:provider.isDark?Colors.white:Colors.black,)),
         border: OutlineInputBorder(
           borderRadius: BorderRadius.circular(10),
         ),   
       ),
      validator: (value){
        if(value!.isEmpty){
           return 'Enter password'; 
        }else if(value.length<6){
           return 'Password must contain 6 letters';
        }else{
          return null;
        }
      },
                        );
  }
}

class FormFieldWidget extends StatelessWidget {

  FormFieldWidget({
     super.key, required this.controller, required this.text,required this.type,
     required this.icon, required this.isDarkMode,required this.message
   });
  final TextEditingController controller;
  final text;
  IconData icon;
  final type;
  bool isDarkMode;
  final message;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      style: TextStyle(color: isDarkMode?Colors.white:Colors.black),
      decoration: InputDecoration(
        hintText: text.toString(),
        hintStyle: TextStyle(color: isDarkMode?Colors.white:Colors.black),
        prefixIcon:Icon(icon, color: isDarkMode?Colors.white:Colors.black,),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),   
      ),
      validator: (value){
        if(value!.isEmpty){
          return message;
        }else{
          return null;
        }
      },

    );

  }
}

