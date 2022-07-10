import 'dart:async';
import 'package:blog_sharing_application/screens/PostDetailsPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Add_blog.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

String uiD;
final user = FirebaseAuth.instance.currentUser;

class _HomePageState extends State<HomePage> {
  StreamSubscription<QuerySnapshot> subscription;

  List<DocumentSnapshot> snapshot;

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("blogs");

  passData(DocumentSnapshot snap) {
    uiD = user.uid;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PostDetails(snap),
    ));
  }

  void initState() {
    super.initState();
    subscription = collectionReference.snapshots().listen((data) {
      setState(() {
        snapshot = data.docs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Blog Application',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => addBlog(),
              ));
              print("Add button pressed");
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      drawer: Drawer(
          child: ListView(children: [
        UserAccountsDrawerHeader(
          accountName: Text(
            user.email,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          accountEmail: Text(
            user.email,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              user.email.substring(0, 1),
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(
            Icons.home,
            color: Colors.black,
          ),
          title: const Text(
            'Home',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.person,
            color: Colors.black,
          ),
          title: const Text(
            'Profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.settings,
            color: Colors.black,
          ),
          title: const Text(
            'Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        const ListTile(
          leading: Icon(
            Icons.exit_to_app,
            color: Colors.black,
          ),
        ),
      ])),
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue[900],
                Colors.blue[600],
                Colors.blue[400],
              ],
            ),
          ),
          child: snapshot.isNotEmpty
              ? ListView.builder(
                  itemCount: snapshot.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 0.0,
                      color: Colors.transparent.withOpacity(0.2),
                      margin: EdgeInsets.all(10.0),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              child: Text(
                                snapshot[index]["title"],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                              ),
                              onTap: () {
                                passData(snapshot[index]);
                              },
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              snapshot[index]["content"],
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Card(
                  elevation: 0.0,
                  color: Colors.transparent.withOpacity(0.2),
                  margin: EdgeInsets.all(10.0),
                  child: const Center(
                    child: Text(
                      "No Blogs Found",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )),
    );
  }
}
