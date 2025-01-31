import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voicemate/Authentication/LoginPage.dart';
import 'package:voicemate/ProviderClasses/UserDataProvider.dart';
import 'package:voicemate/views/about%20us/aboutus.dart';
import 'package:voicemate/views/chat_screen/tanveer/utils.dart';
import 'package:voicemate/views/settings/icon_widget.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isDarkMode = false;
  FirebaseAuth auth = FirebaseAuth.instance;


Future<void> _sendEmail(String subject, String body) async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: 'salam032136muet@gmail.com',
    queryParameters: {
      'subject': Uri.encodeComponent(subject),
      'body': Uri.encodeComponent(body),
    },
  );

  try {
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      // Fallback: Show a dialog with the email address
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No email client found. Please send an email to salam032136muet@gmail.com')),
      );
      // Optionally show a dialog to copy the email address or open a web-based client
      _showNoEmailClientDialog();
    }
  } catch (e) {
    print("Error launching email: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not launch email app: $e')),
    );
  }
}

void _showNoEmailClientDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('No Email Client Found'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Please send an email to: salam032136muet@gmail.com'),
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: 'salam032136muet@gmail.com'));
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Email address copied to clipboard')),
                );
              },
              child: const Text('Copy Email Address'),
            ),
            TextButton(
              onPressed: () {
                launchUrl(Uri.parse('https://mail.google.com'));
              },
              child: const Text('Open Gmail (Web)'),
            ),
          ],
        ),
      );
    },
  );
}
  Future<void> logout(BuildContext context) async {
    try {
      //=> Clear user-related data from the provider
      Provider.of<UserDataProvider>(context, listen: false).clearUserData();
     
      await auth.signOut();
      //=> Navigate to the Login Page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false, 
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    }
  }

  
  Future<void> deleteAccount(BuildContext context) async {
    User? user = auth.currentUser ;

    if (user != null) {
      //=> Re-authenticate the user
      String email = user.email!;
      String password = ''; // You need to get the password from the user

      //=> Show a dialog to get the password
      String? passwordInput = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          TextEditingController passwordController = TextEditingController();
          return AlertDialog(
            title: Text('Re-authenticate'),
            content: TextField(
              controller: passwordController,
              decoration: InputDecoration(hintText: 'Enter your password'),
              obscureText: true,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(passwordController.text);
                },
                child: Text('Submit'),
              ),
            ],
          );
        },
      );

      if (passwordInput != null && passwordInput.isNotEmpty) {
        try {
          //--> Re-authenticate the user
          AuthCredential credential = EmailAuthProvider.credential(
            email: email,
            password: passwordInput,
          );

          await user.reauthenticateWithCredential(credential);
         
          await user.delete();
       
          Provider.of<UserDataProvider>(context, listen: false).clearUserData();
       
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        } catch (e) {
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Delete account failed: $e')),
          );
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: size.height * 0.02,
          ),
          children: [
            buildUserProfile(size),
            SizedBox(height: size.height * 0.02),
            buildSettingsSection(
              title: 'General',
              children: [
                buildAccountSettings(context),
                buildLogOut(),
                buildDeleteAccount(),
              ],
            ),
            buildSettingsSection(
              title: 'Feedback',
              children: [
                buildReportBug(context),
                buildSendFeedback(context),
              ],
            ),
            buildSettingsSection(
              title: 'Notifications',
              children: [
                buildNotificationSettings(),
                buildDoNotDisturb(),
              ],
            ),
            buildSettingsSection(
              title: 'Appearance',
              children: [
                buildDarkModeToggle(),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget buildUserProfile(Size size) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(size.width * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: size.width * 0.12,
            backgroundImage: const AssetImage('assets/logo.png'),
          ),
          SizedBox(width: size.width * 0.04),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [            
                  Consumer<UserDataProvider>(builder: (context, dataProvider, index){
                          if(dataProvider.firstName.isEmpty|| dataProvider.lastName.isEmpty){
                             return const CircularProgressIndicator();
                           }
                          return Text('${dataProvider.firstName} ${dataProvider.lastName}',style: TextStyle(
                        
                            fontWeight: FontWeight.bold,fontSize:size.width*0.06));
                         }),
              SizedBox(height: size.height * 0.01),
              TextButton(
                onPressed: () {
                  Utils.showSnackBar(context, 'Edit Profile Clicked');
                },
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

 Widget buildSettingsSection({
  required String title,
  required List<Widget> children,
}) {
  final size = MediaQuery.of(context).size;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
        child: Text(
          title,
          style: TextStyle(
            fontSize: size.width * 0.045,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size.width * 0.04), 
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 158, 158, 158).withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size.width * 0.04), // Ensures rounded corners
          child: Column(
            children: children,
          ),
        ),
      ),
      SizedBox(height: size.height * 0.02),
    ],
  );
}

  Widget buildLogOut() => SimpleSettingsTile(
        title: 'Logout',
        leading: IconWidget(icon: Icons.logout, color: Colors.blue),
        onTap: () => logout(context), // Call logout function
      );

  Widget buildDeleteAccount() => SimpleSettingsTile(
        title: 'Delete Account',
        leading: IconWidget(icon: Icons.delete, color: Colors.pink),
        onTap: () => deleteAccount(context), // Call delete account function
      );


      void _showBugReportDialog(BuildContext context) {
  TextEditingController bugController = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Report a Bug'),
        content: TextField(
          controller: bugController,
          decoration: const InputDecoration(hintText: 'Describe the bug'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final bugReport = bugController.text;
              if (bugReport.isNotEmpty) {
                _sendEmail('Bug Report', bugReport);
              }
              Navigator.of(context).pop();
            },
            child: const Text('Submit'),
          ),
        ],
      );
    },
  );
}


  Widget buildReportBug(BuildContext context) => SimpleSettingsTile(
        title: 'Report a Bug',
        leading: IconWidget(icon: Icons.bug_report, color: Colors.teal),
        onTap: () {
          _showBugReportDialog(context);
        },
      );
void _showFeedbackDialog(BuildContext context) {
  TextEditingController feedbackController = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Send Feedback'),
        content: TextField(
          controller: feedbackController,
          decoration: const InputDecoration(hintText: 'Your feedback'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final feedback = feedbackController.text;
              if (feedback.isNotEmpty) {
                _sendEmail('Feedback', feedback);
              }
              Navigator.of(context).pop();
            },
            child: const Text('Submit'),
          ),
        ],
      );
    },
  );
}
  Widget buildSendFeedback(BuildContext context) => SimpleSettingsTile(
        title: 'Send Feedback',
        leading: IconWidget(icon: Icons.thumb_up, color: Colors.purple),
        onTap: ()  {
           _showFeedbackDialog(context);
        },
      );

  Widget buildAccountSettings(BuildContext context) => SimpleSettingsTile(
        title: 'Account',
        leading: IconWidget(icon: Icons.person, color: Colors.green),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AccountPage()),
          );
        },
      );

  Widget buildNotificationSettings() => SimpleSettingsTile(
        title: 'Notification Settings',
        leading: IconWidget(icon: Icons.notifications, color: Colors.blueGrey),
        onTap: () => Utils.showSnackBar(context, 'Clicked Notification Settings'),
      );

  Widget buildDoNotDisturb() => SimpleSettingsTile(
        title: 'About us',
        leading: IconWidget(icon: Icons.group_sharp, color: Colors.redAccent),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutUsPage())),
      );

  Widget buildDarkModeToggle() {
    final size = MediaQuery.of(context).size;
    return SwitchListTile(
      title: Text(
        'Dark Mode',
        style: TextStyle(fontSize: size.width * 0.04),
      ),
      secondary: IconWidget(icon: Icons.dark_mode, color: Colors.black),
      value: isDarkMode,
      onChanged: (value) {
        setState(() {
          isDarkMode = value;
        });
      },
    );
  }
}

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(size.width * 0.05),
        child: ListView(
          children: [
            SimpleSettingsTile(
              title: 'Change Password',
              leading: IconWidget(icon: Icons.lock, color: Colors.orange),
              onTap: () => Utils.showSnackBar(context, 'Clicked Change Password'),
            ),
            SimpleSettingsTile(
              title: 'Privacy Settings',
              leading: IconWidget(icon: Icons.privacy_tip, color: Colors.green),
              onTap: () => Utils.showSnackBar(context, 'Clicked Privacy Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
