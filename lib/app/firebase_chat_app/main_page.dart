import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstflutter/app/firebase_chat_app/chat_page.dart';
import 'package:firstflutter/app/firebase_chat_app/view/TopTitle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainPage extends StatelessWidget {
  final String email;

  MainPage({this.email});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(children: <Widget>[
                Expanded(
                  child: TopTitle(title: 'Chats'),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () => { FirebaseAuth.instance.signOut() },
                ),
              ],),
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () => { Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage()),)},
            ),
          ],
        ),
      ),
    );
  }
}