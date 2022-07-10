import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'edit_blog.dart';
import 'home_page.dart';

class PostDetails extends StatefulWidget {
  final DocumentSnapshot snapshot;

  PostDetails(this.snapshot);
  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Details"),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        actions: (uiD==widget.snapshot['uid'])?[
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditBlog(widget.snapshot),
              ));
              print("Add button pressed");
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection("blogs")
                  .doc(widget.snapshot.id)
                  .delete();
              Navigator.of(context).pop();
            },
          ),
        ]:[],
      ),
      body: Card(
        elevation: 10,
        margin: EdgeInsets.all(10),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  CircleAvatar(
                    child: Text(widget.snapshot['title'][0]),
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.snapshot['title'],
                    style: TextStyle(fontSize: 22, color: Colors.blue[300]),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                widget.snapshot['content'],
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
