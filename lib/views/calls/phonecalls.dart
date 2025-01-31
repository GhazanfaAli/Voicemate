import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voicemate/views/calls/signaling.dart';

class Phonecalls extends StatefulWidget {
  const Phonecalls({super.key});

  @override
  State<Phonecalls> createState() => _PhonecallsState();
}

class _PhonecallsState extends State<Phonecalls> {
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  String? roomId;
  TextEditingController textEditingController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    _localRenderer.initialize();
    _remoteRenderer.initialize();

    signaling.onAddRemoteStream = (stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    };
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title:  Text(
          'Welcome to WebRTC',
          style: GoogleFonts.arbutusSlab(
           
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Real-Time Communication",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              // Buttons Section
              Wrap(
                spacing: screenWidth * 0.03,
                runSpacing: screenHeight * 0.015,
                alignment: WrapAlignment.center,
                children: [
                  _buildButton(
                    "Open Camera & Microphone",
            //        Colors.greenAccent,
                    () {
                      signaling.openUserMedia(_localRenderer, _remoteRenderer);
                    },
                  ),
                  _buildButton(
                    "Create Room",
                  //  Colors.blueAccent,
                    () async {
                      roomId = await signaling.createRoom(_remoteRenderer);
                      textEditingController.text = roomId!;
                      setState(() {});
                    },
                  ),
                  _buildButton(
                    "Join Room",
                 //   Colors.purpleAccent,
                    () {
                      signaling.joinRoom(
                        textEditingController.text.trim(),
                        _remoteRenderer,
                      );
                    },
                  ),
                  _buildButton(
                    "Hangup",
                 //   Colors.redAccent,
                    () {
                      signaling.hangUp(_localRenderer).then((_) {
                        setState(() {
                          _localRenderer.srcObject = null;
                          _remoteRenderer.srcObject = null;
                        });
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              // Video Renderers
              Row(
                children: [
                  Expanded(
                    child: _buildVideoCard(
                      title: "Local Video",
                      height: screenHeight * 0.25,
                      child: RTCVideoView(_localRenderer, mirror: true),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Expanded(
                    child: _buildVideoCard(
                      title: "Remote Video",
                      height: screenHeight * 0.25,
                      child: RTCVideoView(_remoteRenderer),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              // Room Input Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.015,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.meeting_room, color: Colors.blueAccent, size: screenWidth * 0.06),
                      SizedBox(width: screenWidth * 0.02),
                      Expanded(
                        child: TextFormField(
                          controller: textEditingController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Room ID",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String label,  VoidCallback onPressed) {
 

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
      //    _buttonColor = color.withOpacity(0.7); // Change color on press
        });
      },
      onTapUp: (_) {
        setState(() {
      //    _buttonColor = color; // Reset color when released
        });
      },
      onTapCancel: () {
        setState(() {
     //     _buttonColor = color; // Reset color if the tap is cancelled
        });
      },
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03,
            vertical: MediaQuery.of(context).size.height * 0.015,
          ),
        //  backgroundColor: _buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.06),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildVideoCard({required String title, required Widget child, required double height}) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.04),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.04),
            child: child,
          ),
        ),
      ],
    );
  }
}
