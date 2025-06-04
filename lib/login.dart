import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = "";
  String password = "";
  var key = GlobalKey<FormState>();

  login() {
    if (key.currentState!.validate()) {
      key.currentState!.save();
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((data) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Logged in Successfully")),
        );
        Navigator.of(context).pushNamed("home");
      }).catchError((err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sorry, something went wrong: $err")),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Welcome Back"),
        centerTitle: true,
      ),
      body: Form(
        key: key,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Login to your account",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (newValue) => email = newValue!.trim(),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Enter your email";
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                onSaved: (newValue) => password = newValue!,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Enter your password";
                  if (value.length < 6) return "Password must be at least 6 characters";
                  return null;
                },
              ),
              SizedBox(height: 40),
              Center(
                child: ElevatedButton.icon(
                  onPressed: login,
                  icon: Icon(Icons.login),
                  label: Text("Login"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
