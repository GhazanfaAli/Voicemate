import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:translator_plus/translator_plus.dart'; // Import the translator package
import 'package:voicemate/views/audio_data/speect_to_text.dart';
import 'package:voicemate/views/chat_screen/tanveer/utils.dart';

class ChatPage extends StatefulWidget {
  final Map<String, dynamic> userMap;
  final String chatId;

  const ChatPage({super.key, required this.chatId, required this.userMap});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference userRef = FirebaseDatabase.instance.ref();
  FlutterTts flutterTts = FlutterTts();

  // Language selection variables
  String selectedLanguage = 'hi'; // Default to Hindi
  final List<String> languages = ['Hindi', 'English', 'Urdu'];

  void onSendMessage(String message, {String? translatedMessage}) async {
    print("Original Message: $message");
    print("Translated Message: $translatedMessage");

    if (message.isNotEmpty || (translatedMessage != null && translatedMessage.isNotEmpty)) {
      Map<String, dynamic> messages = {
        'sendBy': auth.currentUser?.displayName ?? 'Unknown',
        'message': message.trim(),
        'translatedMessage': translatedMessage ?? '',
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      messageController.clear();
      await userRef.child('chatRoom/${widget.chatId}/chats').push().set(messages);
    } else {
      Utils().toastMessage('Enter some text');
    }
  }

  void _speakTranslatedText(String translatedText) async {
    if (translatedText.isNotEmpty) {
      await flutterTts.speak(translatedText);
    }
  }

  Future<String> translateMessage(String message, String targetLanguage) async {
    if (message.isEmpty) {
      return ''; // Return empty if the message is empty
    }

    final translator = GoogleTranslator();
    var translation = await translator.translate(message, to: targetLanguage);
    return translation.text;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(widget.userMap['firstName'] ?? 'Chat',style: GoogleFonts.roboto(color: Colors.white,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 0,
            bottom: 0,
            left: screenWidth * 0.02,
            right: screenWidth * 0.02,
          ),
          child: Column(
            children: [
              SizedBox(
                width: screenWidth,
                height: screenHeight * 0.8,
                child: StreamBuilder<DatabaseEvent>(
                  stream: userRef.child('chatRoom/${widget.chatId}/chats').orderByChild('time').onValue,
                  builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapShot) {
                    if (snapShot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapShot.hasData && snapShot.data!.snapshot.value != null) {
                      Map<dynamic, dynamic> messages = snapShot.data!.snapshot.value as Map<dynamic, dynamic>;
                      List<dynamic> messageList = messages.values.toList();
                      messageList.sort((a, b) => a['time'].compareTo(b['time']));

                      return ListView.builder(
                        itemCount: messageList.length,
                        itemBuilder: (context, index) {
                          var newMessage = messageList[index];
                          String translatedMessage = newMessage['translatedMessage'] ?? '';
                          return Container(
                            alignment: newMessage['sendBy'] == auth.currentUser!.displayName
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              constraints: BoxConstraints(
          maxWidth: screenWidth * 0.7, 
        ),
                              decoration: BoxDecoration(
                                
                                 boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2), // Shadow color
        blurRadius: 6, // How blurry the shadow is
        offset: const Offset(7, 7), // X and Y offset of the shadow
      ),
    ],
                               gradient: newMessage['sendBy'] == auth.currentUser!.displayName
          ? const LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF50C9C3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : const LinearGradient(
              colors: [Color(0xFFF48FB1), Color(0xFFFF8A65)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                              child: Column(
                                crossAxisAlignment: newMessage['sendBy'] == auth.currentUser!.displayName
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    newMessage['message'],
                                    style: const TextStyle(fontSize: 17, color: Colors.white),
                                  ),
                                  if (translatedMessage.isNotEmpty)
                                    Text(
                                      '[Translated] $translatedMessage',
                                      style: const TextStyle(fontSize: 15, color: Colors.white70),
                                    ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (translatedMessage.isNotEmpty)
                                        IconButton(
                                          icon: Icon(Icons.volume_up, color: Colors.white),
                                          onPressed: () {
                                            _speakTranslatedText(translatedMessage);
                                          },
                                        ),
                                      IconButton(
                                        icon: Icon(Icons.translate, color: Colors.white),
                                        onPressed: () async {
                                          String targetLanguage = selectedLanguage; // Use the selected language
                                          String translatedText = await translateMessage(newMessage['message'], targetLanguage);
                                          Utils().toastMessage('Translated to $targetLanguage: $translatedText');
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          
                          );
                        },
                      );

                      
                    } else {
                      return const Center(child: Text('No messages yet'));
                    }
                  },
                ),
              ),
             Row(
  children: [
    const SizedBox(width: 8),
    // Language selection Dropdown
    Container(
      decoration: BoxDecoration(
        color: Colors.teal.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedLanguage,
          icon: const Icon(Icons.language, color: Colors.teal),
          items: languages.map((String language) {
            return DropdownMenuItem<String>(
              value: language == 'Hindi'
                  ? 'hi'
                  : language == 'English'
                      ? 'en'
                      : 'ur',
              child: Text(language, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedLanguage = newValue!;
            });
          },
        ),
      ),
    ),
    const SizedBox(width: 8),
    Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: TextField(
          controller: messageController,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Type a message',
            hintStyle: TextStyle(color: Colors.grey.shade600),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            border: InputBorder.none,
            suffixIcon: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Translate Message"),
                      content: SpeechToTextWithTranslation(
                        onSendTranslatedText: (translatedText) {
                          onSendMessage(messageController.text, translatedMessage: translatedText);
                        },
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Close"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  'assets/translate.png',
                  height: 24,
                  width: 24,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    const SizedBox(width: 8),
    GestureDetector(
      onTap: () {
        onSendMessage(messageController.text);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Colors.teal, Colors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Icon(Icons.send, color: Colors.white),
      ),
    ),
    const SizedBox(width: 8),
  ],
),
 const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}