import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'home_page.dart';

class addBlog extends StatefulWidget {
  @override
  State<addBlog> createState() => _addBlogState();
}

class _addBlogState extends State<addBlog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  File _image;
  String _imageUrl;
  final ImagePicker _picker = ImagePicker();

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image as File;
      print("image path $_image");
    });
  }

  Future uploadImage() async {
    FirebaseStorage storageReference = FirebaseStorage.instance;
    Reference ref = storageReference
        .ref()
        .child("blog_images")
        .child("${basename(_image.path)}.jpg");
    UploadTask uploadTask = ref.putFile(_image);
    await uploadTask.whenComplete;
    print('File Uploaded');
    ref.getDownloadURL().then((fileURL) {
      setState(() {
        _imageUrl = fileURL;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Blog"),
          backgroundColor: Colors.blue[700],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Color(0xff476cfb),
                      child: ClipOval(
                          child: SizedBox(
                        width: 180,
                        height: 180,
                        child: (_image != null)
                            ? Image.file(
                                _image,
                                fit: BoxFit.fill,
                              )
                            : Image.network(
                                "https://images.unsplash.com/photo-1546842931-886c185b4c8c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8Zmxvd2VyfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
                                fit: BoxFit.fill),
                      ))),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: IconButton(
                    icon: Icon(Icons.camera),
                    onPressed: () {
                      getImage();
                    },
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: contentController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Content",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: RaisedButton(
                child: Text("Add"),
                onPressed: ()  {
                //  await uploadImage();
                  uiD = user.uid;
                  FirebaseFirestore.instance.collection("blogs").add({
                    "title": titleController.text,
                    "content": contentController.text,
                    "uid": uiD,
                //   "image": _imageUrl == null
                  //      ? "https://images.unsplash.com/photo-1546842931-886c185b4c8c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8Zmxvd2VyfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60"
                  //     : _imageUrl
                  });
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ));
                },
              ),
            ),
          ],
        ));
  }
}
