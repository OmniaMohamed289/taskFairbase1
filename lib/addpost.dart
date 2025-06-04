import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  String title = "";
  String body = "";
  bool isPrivate = true;
  String image = "https://firebasestorage.googleapis.com/v0/b/weallbeam.firebasestorage.app/o/default.png?alt=media&token=63da4649-5910-4bad-bd81-f4b96248ad45";
  var key = GlobalKey<FormState>();

 savepost(){
  key.currentState!.save();
  FirebaseFirestore.instance.collection("posts").add({
    "title":title,
    "body":body,
    "image":image,
    "isPrivate":isPrivate,
    "timestamp":Timestamp.now(),
    "creatorId":FirebaseAuth.instance.currentUser!.uid,
    "creatoremail":FirebaseAuth.instance.currentUser!.email,
    "likes": [],
    "comments": []
  }).then((res){
    print(res);
    Navigator.of(context).pop();
  }).catchError((err){
    print(err);
  });

 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Post"),
      ),
      body: Form(
        key: key,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
          child: ListView(
            children: [
              TextFormField(
                onSaved: (newValue) {
                  setState(() {
                    title = newValue!;
                  });
                },
              ),
              TextFormField(
                onSaved: (newValue) {
                  setState(() {
                    body = newValue!;
                  });
                },
              ),
              TextFormField(
                onSaved: (newValue) {
                  setState(() {
                    
                    image = newValue==null|| newValue.isEmpty?"https://firebasestorage.googleapis.com/v0/b/weallbeam.firebasestorage.app/o/default.png?alt=media&token=63da4649-5910-4bad-bd81-f4b96248ad45":newValue;
                  });
                },
              ),
              SwitchListTile(
                title: Text("Only me"),
                value: isPrivate, 
                onChanged: (val){
                setState(() {
                  isPrivate = val;
                });
              }),
              SizedBox(height: 50,),
              ElevatedButton(onPressed: savepost, child: Text("Add Post"))
            ],
          ),
        ),
      ),
    );
  }
}
