import 'package:cloud_firestore/cloud_firestore.dart';
import 'post.dart';
import 'editPostScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyPostsScreen extends StatefulWidget {
  const MyPostsScreen({super.key});

  @override
  State<MyPostsScreen> createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends State<MyPostsScreen> {
  var posts = FirebaseFirestore.instance.collection("posts");

  deletePost(String id) {
    posts.doc(id).delete().then((_) {
      print("Post deleted");
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Posts"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed("addpost");
        },
      ),
      body: StreamBuilder(
        stream: posts
            .where("creatorId",
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, response) {
          if (response.connectionState == ConnectionState.active ||
              response.connectionState == ConnectionState.done) {
            if (response.hasData && response.data!.docs.isNotEmpty) {
              return ListView(
                children: response.data!.docs.map((item) {
                  final data = item.data();
                  final imageUrl = (data['imageUrl'] != null &&
                          data['imageUrl'].toString().isNotEmpty)
                      ? data['imageUrl']
                      : data['body'] ?? '';

                  return PostCard(
                    post: data,
                    fristButtonOnPress: () {
                      deletePost(item.id);
                    },
                    fristIcon: Icon(Icons.delete, color: Colors.red),
                    secondButtonOnPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPostScreen(
                            postId: item.id,
                            initialText: data['title'] ?? '',
                            imageUrl: imageUrl,
                          ),
                        ),
                      );
                    },
                    secondIcon: Icon(Icons.edit, color: Colors.amber),
                  );
                }).toList(),
              );
            } else {
              return Center(child: Text("No Data Found"));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
