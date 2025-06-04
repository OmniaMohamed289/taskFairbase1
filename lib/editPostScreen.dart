import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditPostScreen extends StatefulWidget {
  final String postId;
  final String initialText;
  final String imageUrl;

  const EditPostScreen({
    super.key,
    required this.postId,
    required this.initialText,
    required this.imageUrl,
  });

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  void _updatePost() async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .update({
      'title': _controller.text,
      'updatedAt': Timestamp.now(),
    });

    Navigator.pop(context); // رجوع بعد الحفظ
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Post')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (widget.imageUrl.isNotEmpty)
              Image.network(widget.imageUrl, height: 200),
            SizedBox(height: 10),
            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Edit your post...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updatePost,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
