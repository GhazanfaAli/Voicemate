  

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voicemate/views/chat_screen/tanveer/utils.dart';




class ChatPage extends StatefulWidget{

   final Map<String,dynamic> userMap;
   final String chatId;

    ChatPage({required this.chatId, required this.userMap});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
 
   TextEditingController messageController = TextEditingController();
   FirebaseAuth auth = FirebaseAuth.instance;
   DatabaseReference userRef = FirebaseDatabase.instance.ref();

  void onSendMessage(ChatProvider chatProvider) async{
     if(messageController.text.isNotEmpty){
       
       if(chatProvider.isEditing){
           await userRef.child('chatRoom/${widget.chatId}/chats/${chatProvider.editingMessageKey}')
            .update({
              'message': messageController.text.trim(),
              'isUpdated': true,
             });
           chatProvider.stopEditing(); 
           messageController.clear();
        }else{
          Map<String,dynamic> messages = {
             'sendBy': auth.currentUser?.uid,
             'message': messageController.text.trim(),
             'time': DateTime.now().millisecondsSinceEpoch,
           };
       
          messageController.clear();
          await userRef.child('chatRoom/${widget.chatId}/chats').push().set(messages);
        }
      }else{
        Utils().toastMessage('Enter some text');
      }
  } 

  @override
  Widget build(BuildContext context) {
     double screenHeight = MediaQuery.of(context).size.height;
     double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(

      appBar: AppBar(
         automaticallyImplyLeading: false,  
       //  leading: SizedBox(width: 15,height:15,child: CircleAvatar(child: Icon(Icons.person,size: 30,),backgroundColor: Colors.green,)),
         title: Text(widget.userMap['firstName'] ?? 'Chat'),
         backgroundColor: Colors.blue,
         actions: [
           SizedBox(width: 8),

           PopupMenuButton(
             icon: Icon(Icons.more_vert),
             itemBuilder: (context){
               return [
                 PopupMenuItem(
                   value: 1,
                   child: ListTile(
                     title: Text('View Contact',style: TextStyle(fontSize: 17,fontWeight: FontWeight.normal)),
                     trailing: Icon(Icons.view_agenda)),
                  ),
                 PopupMenuItem(
                   value: 1,
                   child: ListTile(
                     title: Text('Block',style: TextStyle(fontSize: 17,fontWeight: FontWeight.normal),),
                     trailing: Icon(Icons.block)),
                  ),
                 PopupMenuItem(
                   value: 1,
                   child: ListTile(
                     title: Text('Clear chat',style: TextStyle(fontSize: 17,fontWeight: FontWeight.normal)),
                     trailing: Icon(Icons.clear)),
                  ),

               ];
           })
         ],
       ),

      body: Consumer<ChatProvider>(
         builder: (context,chatProvider,child){
           return SingleChildScrollView(
             child: Padding(
               padding: EdgeInsets.only(top:0,bottom: 0,left:screenWidth*0.02,right:screenWidth*0.02),
               child: Column(
                 children: [
        
                   SizedBox(
                     width: screenWidth,
                     height: screenHeight*0.8,
                     child: StreamBuilder<DatabaseEvent>(
                       stream: userRef.child('chatRoom/${widget.chatId}/chats').orderByChild('time').onValue,
                       builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapShot){
                         if(snapShot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                         if(snapShot.hasData && snapShot.data!.snapshot.value!=null){
                            Map<dynamic, dynamic> messages = snapShot.data!.snapshot.value as Map<dynamic, dynamic>;
                            List<Map<String,dynamic>> messageList = messages.entries.map((entry)=>{
                               'key':entry.key,
                               'data':entry.value
                             }).toList();
                        // Sorting messages wrt time
                            messageList.sort((a, b){
                               var timeA = a['data']['time'] ?? 0;
                               var timeB = b['data']['time'] ?? 0;
                               return timeA.compareTo(timeB); // Sort by time
                             });
                            return ListView.builder(
                               itemCount: messageList.length,  
                               itemBuilder: (context,index){
                                   var newMessage = messageList[index]['data'];
                                   var messageKey = messageList[index]['key'];

                                   var messageTime = DateTime.fromMillisecondsSinceEpoch(newMessage['time']);
                                   var formattedTime = '${messageTime.day}-${messageTime.month}-${messageTime.year}';

                                   bool isTopMessage = true;
                                   if(index > 0){
                                      var previousMessageTime = DateTime.fromMillisecondsSinceEpoch(messageList[index-1]['data']['time']);
                                      var previousFormattedDate = '${previousMessageTime.day}-${previousMessageTime.month}-${previousMessageTime.year}';
                                     if(formattedTime==previousFormattedDate){
                                        isTopMessage = false;
                                     }
                                   }
                            //  print('Message is sent by : ${auth.currentUser!.displayName}');
                           //   print('Message is sent by : ${auth.currentUser!.uid}');
                                  return Column(
                                    children: [
                                      if(isTopMessage)
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Container(
                                              margin: EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text(formattedTime),
                                            ),
                                          ),                                      

                                      Container(
                                         alignment: newMessage['sendBy'] == auth.currentUser!.uid ? Alignment.centerRight : Alignment.centerLeft,                                 
                                         child: ConstrainedBox(
                                           constraints: BoxConstraints(
                                              maxWidth: screenWidth*0.55
                                            ),
                                           child: Container(                                    
                                             decoration: BoxDecoration(
                                               borderRadius: BorderRadius.circular(10),
                                               color: Colors.blue,
                                              ),  
                                             padding: EdgeInsets.symmetric(vertical: 5,horizontal: 8),
                                             margin: EdgeInsets.symmetric(vertical: 5,horizontal: 8),
                                            
                                            child: InkWell(
                                              onTap: (){
                                                if(newMessage['sendBy']==auth.currentUser?.uid){
                                                  showDialog(
                                                     context: context,
                                                     builder: (context){
                                                       return AlertDialog(
                                                         content: Column(
                                                           mainAxisSize: MainAxisSize.min,
                                                           children: [
                                                              TextButton(
                                                                onPressed: (){
                                                                   Navigator.pop(context);
                                                                   chatProvider.startEditing(messageKey, newMessage['message']);                 
                                                                   messageController.text = newMessage['message'];                                                          
                                                                 },
                                                                child: Text('Edit')
                                                              ),
                                                             TextButton(
                                                                onPressed: () async{
                                                                  await userRef.child('chatRoom/${widget.chatId}/chats/$messageKey').remove();
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Text('Delete')
                                                              ),
                                                             TextButton(
                                                                onPressed: (){Navigator.pop(context);},
                                                                child: Text('Cancel')
                                                              ),
                                                           ],
                                                        ),
                                                       );
                                                  });}else{
                                                     
                                                  showDialog(
                                                    context: context,
                                                    builder: (context){
                                                      return AlertDialog(
                                                        content: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                             TextButton(
                                                                onPressed: () async{
                                                                  await userRef.child('chatRoom/${widget.chatId}/chats/$messageKey').remove();
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Text('Delete')
                                                              ),
                                                             TextButton(
                                                                onPressed: (){Navigator.pop(context);},
                                                                child: Text('Cancel')
                                                              ),
                                                           ],
                                                        ),
                                                       );
                                                   });
                                                 }
                                               },
                                              child: Column(
                                                children: [
                                                   Text(newMessage['message'], style: TextStyle(fontSize: 17, color: Colors.white)),
                                                   if(newMessage['isUpdated']==true)
                                                       Text('Edited',style: TextStyle(fontSize: 10)),
                                                 ],
                                               ),
                                             ),
                                                                              ),
                                         )),
                                    ],
                                  );
                               });
                        }else{
                          return Center(child: Text('No messages yet'),);
                        }
                     }, 
                   )
                 ),
        
                Row(
                  children: [
                    SizedBox(width: 10),
                    Container(
                      height: screenHeight*0.065,
                      width: screenWidth*0.78,
                      child: TextFormField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: 'Send Message',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )
                        ),
                      ),
                    ),
                
                 //   SizedBox(width: 10),
                    IconButton(onPressed: (){onSendMessage(chatProvider);}, icon: Icon(Icons.send)),
                  
                  ],
                ),
        
               SizedBox(height: 20),
        
               ],
             ),
           ),
         );},
       ),
    
     );
   }
 }

 ///  ===-----------------------------====---------------------------===-------------------------------===--------------



class ChatProvider with ChangeNotifier{          ///------> This is used to update the message
    String? _editingMessageKey;
    String _editingMessageText = '';
    bool _isEditing = false;

    String? get editingMessageKey => _editingMessageKey;
    String get editingMessageText => _editingMessageText;
    bool get isEditing => _isEditing;

    void startEditing(String messageKey, String messageText){
       _editingMessageKey = messageKey;
       _editingMessageText = messageText;
       _isEditing = true;
    }

    void stopEditing(){
       _editingMessageKey = null;
       _editingMessageText = ''; 
       _isEditing = false;
    }


 }




