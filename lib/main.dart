import 'addpost.dart';

import 'myposts.dart';
import 'noconnection.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart'; 
import 'register.dart';
import 'login.dart';
import 'home.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "register": (context) => RegisterScreen(),
        "login": (context) => LoginScreen(),
        "home": (context) => HomeScreen(),
        "addpost": (context) => AddPostScreen(),
        "myposts": (context) => MyPostsScreen(),
      },
      home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, db) {
            if (db.connectionState == ConnectionState.active ||
                db.connectionState == ConnectionState.done) {
              return StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, authstate) {
                    if (authstate.hasData) {
                      return HomeScreen();
                    } else {
                      return LoginScreen();
                    }
                  });
            } else {
              return NoConnectoin();
            }
          }),
    );
  }
}
