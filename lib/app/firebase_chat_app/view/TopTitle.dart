import 'package:flutter/material.dart';

class TopTitle extends StatelessWidget {
  String title;
  TopTitle({this.title = ""});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
    );
  }
}
