import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

// ignore: must_be_immutable
class NormalIcon extends StatelessWidget {
  String icon;
  double size;
  Color color;
  void Function() onTap;

  NormalIcon(this.icon, {this.onTap, this.size = iconSize, this.color = iconColor});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.0),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image(
            image: AssetImage('images/sial/$icon.png'),
            color: color,
            width: size,
            height: size,
          ),
        ),
        onTap: () => { onTap.call() },
      ),
    );
  }
}
