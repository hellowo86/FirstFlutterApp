import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class HeaderTitleText extends StatelessWidget {
  String title;
  HeaderTitleText({this.title = ""});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    );
  }
}
