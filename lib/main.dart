import 'package:firstflutter/app/firebase_chat_app/splash.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "경훈아 잘하자..",
      home: Builder(
        builder: (context) =>  Scaffold(
          appBar: AppBar(
            title: Text('경훈아 잘하자'),
          ),
          body: ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.chat_bubble),
                title: Text('파이어베이스 채팅 앱'),
                onTap: () {
                  Navigator.of(context).push(_createRoute(FireBaseChatApp()));
                },
              ),
              ListTile(
                leading: Icon(Icons.chat_bubble),
                title: Text('몰라 씨발'),
                onTap: () {
                  Navigator.of(context).push(_createRoute());
                },
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('Phone'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Route _createRoute(Widget widget) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.fastOutSlowIn;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}


