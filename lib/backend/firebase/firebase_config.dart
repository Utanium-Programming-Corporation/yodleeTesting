import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyC9NpzZYIkVib5TCiObehnJ_l_6hOLqJP0",
            authDomain: "yodleetestingred.firebaseapp.com",
            projectId: "yodleetestingred",
            storageBucket: "yodleetestingred.appspot.com",
            messagingSenderId: "88647450412",
            appId: "1:88647450412:web:8358b27afa0b3ed0413689"));
  } else {
    await Firebase.initializeApp();
  }
}
