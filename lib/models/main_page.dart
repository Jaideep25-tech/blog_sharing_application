import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/home_page.dart';
import '../screens/login.dart';

class mainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context , snapshot){
            if(snapshot.hasData){
              return HomePage();
            }
            else{
              return LoginPage();
            }
          },
          ),
    );
  }
}
