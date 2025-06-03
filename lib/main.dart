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
      title: 'Flutter Firebase Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: 'register',
      routes: {
        'register': (context) => RegisterScreen(),
        'login': (context) => LoginScreen(),
        'home': (context) => HomeScreen(),
      },
    );
  }
}
