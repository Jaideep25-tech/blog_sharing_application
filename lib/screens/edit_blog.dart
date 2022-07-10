import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home_page.dart';

class EditBlog extends StatefulWidget {
  final DocumentSnapshot snapshot;

  const EditBlog(this.snapshot);
  @override
  State<EditBlog> createState() => _EditBlogState();
}

class _EditBlogState extends State<EditBlog> {
  String x;
  String y;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.snapshot['title']),
          backgroundColor: Colors.green,
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                initialValue: widget.snapshot['title'],
                decoration: InputDecoration(
                  hintText: "Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  x = value;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                initialValue: widget.snapshot['content'],
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Content",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  y = value;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: RaisedButton(
                child: Text("Update"),
                onPressed: () {
                  x == null ? x = widget.snapshot['title'] : x = x;
                  y == null ? y = widget.snapshot['content'] : y = y;
                  FirebaseFirestore.instance
                      .collection("blogs")
                      .doc(widget.snapshot.id)
                      .update({
                    "title": x,
                    "content": y,
                  });
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (c) => HomePage()));
                },
              ),
            ),
          ],
        ));
  }
}
