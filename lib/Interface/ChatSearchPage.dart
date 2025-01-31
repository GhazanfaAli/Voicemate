// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:translation_app/Interface/ChatPage.dart';
// import 'package:translation_app/Interface/StartingPage.dart';
// import 'package:translation_app/ProviderClasses/ChatHelper.dart';
// import 'package:translation_app/Utils.dart';

// class ChatSearchPage extends StatefulWidget{
//   @override
//   State<ChatSearchPage> createState() => _ChatSearchPageState();
// }

// class _ChatSearchPageState extends State<ChatSearchPage> {

//   TextEditingController searchController = TextEditingController();
//   bool isLoading = false;

//   String chatRoomId(String user1, String user2){
//     // Ensure both user1 and user2 are non-null and non-empty
//       if (user1.isEmpty || user2.isEmpty) {
//           throw ArgumentError('User names must not be empty');
//        }
//        // Compare the first character ASCII codes and return chatRoomId
//       if(user1[0].toLowerCase().codeUnits[0] > user2[0].toLowerCase().codeUnits[0]){
//          return '$user1$user2';
//       }else{
//          return '$user2$user1'; 
//       }
//    }

//   void onSearch(final searchController) async{
//       final provider = Provider.of<ChatHelper>(context, listen: false);
//       provider.SearchLoading(true); // Update loading state

//       DatabaseReference userReference = FirebaseDatabase.instance.ref('Users');
//      // query to find user by email
//       try{
//          final dataSnapShot = await userReference.orderByChild('email')
//                                .equalTo(searchController.text.trim()).get(); 

//          if(dataSnapShot.exists){
//             Map<String,dynamic> data = Map<String,dynamic>.from(dataSnapShot.value as Map);
          
//             String userId = data.keys.first;
//             provider.userMap = Map<String, dynamic>.from(data[userId]);
//             Utils().toastMessage('UserFound');
//             provider.SearchLoading(false);

//           }else{
//             provider.userMap = {};
//             provider.SearchLoading(false);
//             Utils().toastMessage('No user found');
//         }}catch(error){
//             provider.SearchLoading(false);
//             Utils().toastMessage(error.toString());
//         }finally{
//             provider.SearchLoading(false);
//         }
//     } 


//   @override
//   Widget build(BuildContext context) {

//      final screenHeight = MediaQuery.of(context).size.height;
//      final screenWidth = MediaQuery.of(context).size.width;
//      final isDarkMode = MediaQuery.of(context).platformBrightness==Brightness.dark; 
//      final provider = Provider.of<ChatHelper>(context, listen:false);  

//      return Scaffold(
//        appBar: AppBar(
//          automaticallyImplyLeading: false,
//          title: Text('Chat'),
//          actions: [
//            InkWell(
//              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>StartingPage()));},
//              child: Icon(Icons.home),
//            ),
//            SizedBox(width: 25),
//          ],
//        ),
//        body: Padding(
//          padding: EdgeInsets.only(top: screenHeight*0.02,bottom: screenHeight*0.05,left: screenWidth*0.05,right: screenWidth*0.04),
//          child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 10),
//                 child: SizedBox(
//                   height: screenHeight*0.065,
//                   width: screenWidth*0.85,
//                   child: TextFormField(
//                      controller: searchController,
//                      decoration: InputDecoration(
//                        hintText: 'Search',
//                        suffixIcon: provider.isLoading
//                            ? CircularProgressIndicator()
//                            : InkWell(
//                               onTap: (){
//                                 onSearch(searchController);
//                               },
//                              child: Icon(Icons.search),
//                             ),
//                        border: OutlineInputBorder(
//                            borderRadius: BorderRadius.circular(20),
//                        )
//                      ),
//                   ),
//                 ),
//                ),

//               SizedBox(height: 30),

//               provider.userMap!=null && provider.userMap.isNotEmpty
              
//               ?  Container(
//                    decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(20),
//                      color: Colors.green
//                     ),

//                     child: ListTile(
//                        onTap: () async{

//                      String chatId = '';
//                      String user1 = provider.auth.currentUser?.displayName ?? '';
//                      String user2 = provider.userMap['firstName'] ?? '';

//                      String user1Uid = provider.auth.currentUser?.uid ?? '';
//                      String user2Uid = provider.userMap['uid'] ?? '';

//                    if (user1.isEmpty || user2.isEmpty||user1Uid.isEmpty||user2Uid.isEmpty){
//                         // Handle the error case appropriately
//                           print('One or both usernames are invalid');
//                           Utils().toastMessage('Invalid user data');
//                     } else {
//                           chatId = chatRoomId(user1, user2);
//                           print('Chat Room ID: $chatId');
//                     };

//                DatabaseReference chatRoomRef = FirebaseDatabase.instance.ref('chatRoom/$chatId');

//                         // Ensure chat room exists
//                       await chatRoomRef.set({
                        
//                       //     'users': [provider.userMap['firstName'], FirebaseAuth.instance.currentUser!.displayName],
//                       //     'lastUpdated': DateTime.now().millisecondsSinceEpoch,
//                       //  });

//                         'users': {
//                            user1Uid: true,  // Add the current user UID
//                            user2Uid: true,  // Add the other user UID (make sure it's coming from the search result)
//                          },
//                       });

//                         Navigator.push(context,MaterialPageRoute(builder: (context)=>ChatPage(chatId: chatId, userMap: provider.userMap)));  
//                       },
//                       title: Text(provider.userMap['firstName']??'',style: TextStyle(fontWeight: FontWeight.bold,fontSize:18,color: Colors.white),),
//                       subtitle: Text(provider.userMap['email']??'',style: TextStyle(fontSize: 15,color: Colors.white)),
//                       trailing: Icon(Icons.message,color: Colors.white,),
//                     ),
//                 )
//               : Container(child: Text('Search your friend to chat with'),),
               
//             ],
          
//          ),
//        ),
//      );
//   }
// }