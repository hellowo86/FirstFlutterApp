import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class NormalText extends StatelessWidget {
  String title;
  NormalText(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
    );
  }
}
