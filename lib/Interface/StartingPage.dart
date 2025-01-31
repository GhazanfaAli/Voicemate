import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:voicemate/Authentication/LoginPage.dart';
import 'package:voicemate/Interface/ChatsInterface.dart';
import 'package:voicemate/ProviderClasses/NecessaryProvider.dart';
import 'package:voicemate/ProviderClasses/UserDataProvider.dart';
import 'package:voicemate/views/calls/phonecalls.dart';
import 'package:voicemate/views/home/home_screen.dart';
import 'package:voicemate/views/settings/setting.dart';

class StartingPage extends StatefulWidget {
  const StartingPage({super.key});

  @override
  State<StartingPage> createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  TextEditingController searchController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NecessaryProvider>(context, listen: false).setBackgroundColor(isDarkMode);
    });
  }

  Future<void> logout(BuildContext context) async {
    try {
      // Clear user-related data from the provider
      Provider.of<UserDataProvider>(context, listen: false).clearUserData();
      // Sign out from Firebase Auth
      await auth.signOut();
      // Navigate to the Login Page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false, // Removes all previous routes
      );
    } catch (e) {
      // Show error message on logout failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final provider = Provider.of<NecessaryProvider>(context);

    final userData = Provider.of<UserDataProvider>(context, listen: false);
    userData.fetchUserDetails();

    return Scaffold(
      backgroundColor: provider.isDark ? Colors.black : Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.07,
            bottom: screenHeight * 0.1,
            left: screenWidth * 0.03,
            right: screenWidth * 0.03,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.03, right: screenWidth * 0.03),
                        child:  Text(
                          'Welcome!',
                          style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 23, color: provider.isDark ? Colors.white : Colors.black,),
                        ),
                      ),
                      Consumer<UserDataProvider>(
                        builder: (context, dataProvider, index) {
                          if (dataProvider.firstName.isEmpty || dataProvider.lastName.isEmpty) {
                            return const CircularProgressIndicator();
                          }
                          return Padding(
                            padding: EdgeInsets.only(left: screenWidth * 0.03, right: screenWidth * 0.03),
                            child: Text(
                              '${dataProvider.firstName} ${dataProvider.lastName}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: Colors.blue),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(width: screenWidth * 0.35),
                  Icon(Icons.notifications, size: screenWidth * 0.08, color: provider.isDark ? Colors.white : Colors.black),
                  SizedBox(width: screenWidth * 0.09),
                  Icon(Icons.local_library_outlined, size: screenWidth * 0.08, color: provider.isDark ? Colors.white : Colors.black),
                ],
              ),

              SizedBox(height: screenHeight * 0.08),

              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.03, right: screenWidth * 0.03),
                child: SizedBox(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.065,
                  child: TextFormField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      suffixIcon: const Icon(Icons.search),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.05),

              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.06, right: screenWidth * 0.03),
                child: Text(
                  'Navigate Your World',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.045,
                    color: provider.isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.05),
              AnimationConfiguration.synchronized(
                duration: const Duration(milliseconds: 1500),
                child: FadeInAnimation(
                 // flipAxis: FlipAxis.y,
                  child: FadeInAnimation(
                    curve: Curves.linear,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeTab()));
                                  },
                                  child: SizedBox(
                                    width: screenWidth * 0.15,
                                    height: screenHeight * 0.08,
                                    child: Image.asset('assets/home.png'),
                                  ),
                                ),
                                Text(
                                  'Home',
                                  style: TextStyle(
                                    color: provider.isDark ? Colors.white : Colors.black,
                                    fontSize: screenWidth * 0.035,fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Chatsinterface()));
                                  },
                                  child: SizedBox(
                                    width: screenWidth * 0.15,
                                    height: screenHeight * 0.08,
                                    child: Image.asset('assets/chat.png'),
                                  ),
                                ),
                                Text(
                                  'Chat',
                                  style: TextStyle(
                                    color: provider.isDark ? Colors.white : Colors.black,
                                    fontSize: screenWidth * 0.035,fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                    
                        SizedBox(height: screenHeight * 0.05),
                    
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Phonecalls()));
                                  },
                                  child: SizedBox(
                                    width: screenWidth * 0.15,
                                    height: screenHeight * 0.08,
                                    child: Image.asset('assets/phone_call.png'),
                                  ),
                                ),
                                Text(
                                  'Call',
                                  style: TextStyle(
                                    color: provider.isDark ? Colors.white : Colors.black,
                                    fontSize: screenWidth * 0.035,fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                    
                        SizedBox(height: screenHeight * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage()));
                                  },
                                  child: SizedBox(
                                    width: screenWidth * 0.15,
                                    height: screenHeight * 0.08,
                                    child: Image.asset('assets/settings.png'),
                                  ),
                                ),
                                Text(
                                  'Settings',
                                  style: TextStyle(
                                    color: provider.isDark ? Colors.white : Colors.black,
                                    fontSize: screenWidth * 0.035,fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    logout(context);
                                  },
                                  child: SizedBox(
                                    width: screenWidth * 0.15,
                                    height: screenHeight * 0.08,
                                    child: Image.asset('assets/logout.png'),
                                  ),
                                ),
                                Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: provider.isDark ? Colors.white : Colors.black,
                                    fontSize: screenWidth * 0.035,fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.1),
            ],
          ),
        ),
      ),
    );
  }
}