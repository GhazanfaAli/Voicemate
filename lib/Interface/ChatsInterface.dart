import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:voicemate/Interface/ChatPage.dart';
import 'package:voicemate/Interface/StartingPage.dart';
import 'package:voicemate/views/chat_screen/tanveer/utils.dart';

class Chatsinterface extends StatefulWidget {
  const Chatsinterface({super.key});

  @override
  State<Chatsinterface> createState() => _ChatsInterfaceState();
}

class _ChatsInterfaceState extends State<Chatsinterface> {
  TextEditingController searchController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference chatData = FirebaseDatabase.instance.ref('Users');

  String chatRoomId(String user1, String user2) {
    if (user1.isEmpty || user2.isEmpty) {
      throw ArgumentError('User names must not be empty');
    }
    if (user1[0].toLowerCase().codeUnits[0] > user2[0].toLowerCase().codeUnits[0]) {
      return '$user1$user2';
    } else {
      return '$user2$user1';
    }
  }

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Chat',
          style: GoogleFonts.robotoSlab(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StartingPage()),
              );
            },
            child: const Icon(Icons.home, size: 32, color: Colors.white),
          ),
          const SizedBox(width: 25),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.02,
            bottom: screenHeight * 0.05,
            left: screenWidth * 0.05,
            right: screenWidth * 0.04,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: SizedBox(
                  height: screenHeight * 0.065,
                  width: screenWidth * 0.85,
                  child: TextFormField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.trim().toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Search',
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: AnimationLimiter(
                  child: FirebaseAnimatedList(
                    query: chatData,
                    defaultChild: Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: ListView.builder(
                        itemCount: 6,
                        itemBuilder: (context, index) => ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey.shade300,
                          ),
                          title: Container(
                            height: 15,
                            width: 100,
                            color: Colors.grey.shade300,
                          ),
                          subtitle: Container(
                            height: 10,
                            width: 80,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),
                    itemBuilder: (context, snapshot, animation, index) {
                      String firstName = snapshot.child('firstName').value as String;
                      String lastName = snapshot.child('lastName').value as String;

                      // Check if the user matches the search query
                      String fullName = '$firstName $lastName'.toLowerCase();
                      if (searchQuery.isNotEmpty && !fullName.contains(searchQuery)) {
                        return const SizedBox(); // Hide users who don't match
                      }

                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Card(
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                onTap: () async {
                                  String currentUserName = auth.currentUser?.displayName ?? 'Unknown';
                                  String currentUserId = auth.currentUser?.uid ?? '';
                                  String otherUserName = snapshot.child('firstName').value.toString();
                                  String otherUserId = snapshot.key ?? '';

                                  if (currentUserName.isNotEmpty &&
                                      currentUserId.isNotEmpty &&
                                      otherUserName.isNotEmpty &&
                                      otherUserId.isNotEmpty) {
                                    String chatId = chatRoomId(currentUserId, otherUserId);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                          chatId: chatId,
                                          userMap: {
                                            'firstName': otherUserName,
                                            'uid': otherUserId,
                                          },
                                        ),
                                      ),
                                    );
                                  } else {
                                    Utils().toastMessage('Invalid user data');
                                  }
                                },
                                leading: const CircleAvatar(
                                  backgroundImage: AssetImage('assets/user.png'),
                                ),
                                title: Text(
                                  '$firstName $lastName',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: Image(
                                  height: 28,
                                  width: 28,
                                  image: AssetImage('assets/email.png'),),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}