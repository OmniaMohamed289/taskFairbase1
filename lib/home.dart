import 'package:cloud_firestore/cloud_firestore.dart';
import 'post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var user = FirebaseAuth.instance.currentUser;
  var posts = FirebaseFirestore.instance.collection("posts");
  logout() async {
    await FirebaseAuth.instance.signOut();
  }

  likePost(String postid) async {
    // ["hdjkghsdjk","jfgasjhgfjasg","kfhjkashfjk"]
    var currentPost = await posts.doc(postid).get();

    List likes = currentPost["likes"] ?? [];

    if (likes.contains(user!.uid)) {
      //unlike
      likes.remove(user!.uid);
    } else {
      //like
      likes.add(user!.uid);
    }

    await posts.doc(postid).update({"likes": likes});
  }

  commentonPost(String postid) async {
    //["uid":"ghfghfjh","text":"fgfgfg",]
    var currentPost = await posts.doc(postid).get();

    List comments = currentPost["comments"] ?? [];

    var controller = TextEditingController();

    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Add Comment"),
              content: TextField(
                controller: controller,
                decoration: InputDecoration(hintText: "Enter your Comment"),
              ),
              actions: [
                TextButton(onPressed: () async {
                  var comment= controller.text;
                  await posts.doc(postid).update({
                    "comments" : FieldValue.arrayUnion([
                      {
                        "userId":user!.uid,
                        "test":comment,
                        "timestamp":Timestamp.now()
                      },
                    ])
                  });
                  Navigator.of(context).pop();
                }, child: Text("Save")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${user!.email}"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed("myposts");
              },
              icon: Icon(Icons.list_alt_outlined)),
          IconButton(onPressed: logout, icon: Icon(Icons.login)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed("addpost");
          }),
      body: StreamBuilder(
          stream: posts.snapshots(),
          builder: (context, responce) {
            if (responce.connectionState == ConnectionState.done ||
                responce.connectionState == ConnectionState.active) {
              if (responce.data!.docs.isNotEmpty) {
                return ListView(
                    children: responce.data!.docs
                        .map((item) => PostCard(
                              post: item.data(),
                              fristButtonOnPress: () {
                                likePost(item.id);
                              },
                              fristIcon: Icon(Icons.favorite_border),
                              secondButtonOnPress: () {
                                commentonPost(item.id);
                              },
                              secondIcon: Icon(Icons.comment_outlined),
                            ))
                        .toList());
              } else {
                return Center(
                  child: Text("NO Data Found"),
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
