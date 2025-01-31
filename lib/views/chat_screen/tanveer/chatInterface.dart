import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:voicemate/views/chat_screen/tanveer/chatHelper.dart';
import 'package:voicemate/views/chat_screen/tanveer/chatpage.dart';
import 'package:voicemate/views/chat_screen/tanveer/utils.dart';

class Chatsinterface extends StatefulWidget{
  const Chatsinterface({super.key});

   @override
   State<Chatsinterface> createState() => _ChatsInterfaceState();
}

class _ChatsInterfaceState extends State<Chatsinterface> {

    TextEditingController searchController = TextEditingController();
    bool isLoading = false;

    FirebaseAuth auth = FirebaseAuth.instance;
    DatabaseReference chatData = FirebaseDatabase.instance.ref('Users');



  String chatRoomId(String user1, String user2){
    // Ensure both user1 and user2 are non-null and non-empty
      if (user1.isEmpty || user2.isEmpty) {
          throw ArgumentError('User names must not be empty');
       }
       // Compare the first character ASCII codes and return chatRoomId
      if(user1[0].toLowerCase().codeUnits[0] > user2[0].toLowerCase().codeUnits[0]){
         return '$user1$user2';
      }else{
         return '$user2$user1'; 
      }
   }


  @override
  Widget build(BuildContext context) {

      final screenHeight = MediaQuery.of(context).size.height;
      final screenWidth = MediaQuery.of(context).size.width;
      final isDarkMode = MediaQuery.of(context).platformBrightness==Brightness.dark; 
      final provider = Provider.of<ChatHelper>(context, listen:false);  

    return Scaffold(

       appBar: AppBar(
         automaticallyImplyLeading: false,
         title: const Text('Chat'),

       ),
      
       body: Padding(
         padding: EdgeInsets.only(top: screenHeight*0.02,bottom: screenHeight*0.05,left: screenWidth*0.05,right: screenWidth*0.04),
         child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: SizedBox(
                  height: screenHeight*0.065,
                  width: screenWidth*0.85,
                  child: TextFormField(
                     controller: searchController,
                     decoration: InputDecoration(
                       hintText: 'Search',
                        suffixIcon: const Icon(Icons.search),
                       //provider.isLoading
                      //      ? CircularProgressIndicator()
                      //      : InkWell(
                      //         onTap: (){
                      //      //  onSearch(searchController);
                      //         },
                      //        child: Icon(Icons.search),
                      //       ),
                       border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(20),
                       )
                     ),
                  ),
                ),
               ),


              const SizedBox(height: 30),

             Expanded(
               child: FirebaseAnimatedList(
                  query: chatData, 
                  itemBuilder: (context,snapshot,animation,index){
                     String email = snapshot.child('email').value as String;
                     String firstName = snapshot.child('firstName').value as String;
                     String lastName = snapshot.child('lastName').value as String;
               //  print(firstName.toString());
                 return ListTile(

                     onTap: () async {
        
         String currentUserName = auth.currentUser?.displayName ?? 'Unknown';
         String currentUserId = auth.currentUser?.uid ?? '';
         String otherUserName = snapshot.child('firstName').value.toString();
         String otherUserId = snapshot.key ?? '';

          if (currentUserName.isNotEmpty && currentUserId.isNotEmpty && otherUserName.isNotEmpty && otherUserId.isNotEmpty) {
             // Generate chatRoomId
              String chatId = chatRoomId(currentUserId, otherUserId); 

              // Navigate to ChatPage with chatId and userMap
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => ChatPage(chatId: chatId, userMap: {'firstName': otherUserName,'uid': otherUserId,},
                ),
               ),
              );
             } else {
                Utils().toastMessage('Invalid user data');
             }
    
               
               
                    },

                

                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text('$firstName $lastName'),
                    trailing: const Icon(Icons.message),
                 );
                             }
             ),
           ),         


          ]),
       ),
     );
  }
}