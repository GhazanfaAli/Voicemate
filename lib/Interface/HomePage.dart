// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:translation_app/Authentication/LoginPage.dart';

// class HomePage extends StatelessWidget{
//   FirebaseAuth auth = FirebaseAuth.instance;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//               Text('HomePage'),
//               SizedBox(height: 100),
//               TextButton(
//                  onPressed: (){auth.signOut(); Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));},
//                  child: Text('Exit',style: TextStyle(fontSize: 30,color: Colors.amber),),
//                )
//           ],
//         ),
//       ),
//     );
//   }
// }