import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String email = "";
  String password = "";
  final key = GlobalKey<FormState>();

  register() async {
    if (key.currentState!.validate()) {
      key.currentState!.save();

      try {
        final data = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await FirebaseFirestore.instance
            .collection("users")
            .doc(data.user!.uid)
            .set({"email": email, "createdAt": Timestamp.now()});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Your Account Added Successfully")),
        );

        Navigator.of(context).pushNamed("login");
      } catch (err) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $err")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Join Us")),
      body: Form(
        key: key,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email";
                  }
                  if (!value.contains('@')) {
                    return "Please enter a valid email";
                  }
                  return null;
                },
                onSaved: (newValue) {setState((){
                   email = newValue!;
                });},
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
                  onSaved: (newValue) {
                  setState(() {
                    password = newValue!;
                  });
                },              ),
              SizedBox(height: 50),
              ElevatedButton(onPressed: register, child: Text("Register")),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).popAndPushNamed("login");
                },
                child: Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
