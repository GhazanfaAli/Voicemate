import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:voicemate/Authentication/SignUpPage.dart';
import 'package:voicemate/ProviderClasses/NecessaryProvider.dart';
import 'package:voicemate/ProviderClasses/UserDataProvider.dart';
import 'package:voicemate/ProviderClasses/ChatHelper.dart';
import 'package:voicemate/Interface/StartingPage.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyACSwyaUyj_o7fhDnjCj8uluuolLSX8HAk",
      appId: "1:456604725713:android:097dd97e6382c98954f0f0",
      messagingSenderId: "456604725713",
      projectId: "setup-7fc38",
      storageBucket: "setup-7fc38.appspot.com",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NecessaryProvider()),
        ChangeNotifierProvider(create: (_) => UserDataProvider()),
        ChangeNotifierProvider(create: (_) => ChatHelper()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(), 
    //    home: const VideoCalling(), 
      ),
    );
  }
}


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      final user = FirebaseAuth.instance.currentUser;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => user != null ? const StartingPage() : const SignUpPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/app_loading_svg.json'),
            const SizedBox(height: 20),
         
          ],
        ),
      ),
    );
  }
}
