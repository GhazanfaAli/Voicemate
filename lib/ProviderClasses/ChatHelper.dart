import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ChatHelper with ChangeNotifier{

    bool isLoading = false;
    Map<String,dynamic> userMap = {};
    FirebaseAuth auth = FirebaseAuth.instance;

    void SearchLoading(bool isValueLoading){
       isLoading = isValueLoading;
       notifyListeners();
    }



 }

