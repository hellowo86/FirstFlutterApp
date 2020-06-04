import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

bool isSameDay(DateTime s, DateTime e) {
  return s.year == e.year && s.month == e.month && s.day == e.day;
}

SystemUiOverlayStyle getSystemUiOverlayStyle() {
  if (Platform.isAndroid) {
    return SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark);
  } else {
    return SystemUiOverlayStyle.dark;
  }
}

SystemUiOverlayStyle getSystemUiOverlayStyleTopImage() {
  if (Platform.isAndroid) {
    return SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light);
  } else {
    return SystemUiOverlayStyle.light;
  }
}