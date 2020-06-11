import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_text/skeleton_text.dart';

import 'data/app.dart';

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

Widget makeListSkeleton() => Expanded(
  child: SingleChildScrollView(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
    child: Column(
      children: [for (var i = 0; i < 10; i++) makeListItemSkeleton()],
    ),
  ),
);

Widget makeListItemSkeleton() => Padding(
  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SkeletonAnimation(
        child: Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: Colors.grey[300],
          ),
        ),
      ),
      SizedBox(
        width: 15,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          SkeletonAnimation(
            child: Container(
              width: 200,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SkeletonAnimation(
            child: Container(
              width: 170,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SkeletonAnimation(
            child: Container(
              width: 150,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
            ),
          ),
        ],
      ),
    ],
  ),
);

Future<Position> allowLocationPermission(context) async {
  Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  if (position != null && position.latitude != 0.0) {
    Provider.of<App>(context).setAllowLocationPermission(true);
    Provider.of<App>(context).setCurrentLocation(position);
  }
  return position;
}

Future<Position> getCurrentLocation() async {
  return await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}