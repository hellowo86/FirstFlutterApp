import 'dart:io';

import 'package:firstflutter/app/sial_app/constants.dart';
import 'package:firstflutter/app/sial_app/login_page.dart';
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

const skeletonColor = Color(0xfff0f0f0);

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
                color: skeletonColor,
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
                    color: skeletonColor,
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
                    color: skeletonColor,
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
                    color: skeletonColor,
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

BoxDecoration getBottomSheetBoxDecoration() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    );

void showLoginDialog(context, App app, String title) {
  showAlertDialog(context, app, title, sub: "로그인이 필요한 기능입니다.\n지금 로그인 하시겠습니까?", cancelTitle: "나중에", actionTitle: "로그인", action: () {
    Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) {
      return LoginPage();
    }));
  });
}

Future<void> showAlertDialog(context, App app, String title, {String sub, String cancelTitle, String actionTitle, Function action}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        titleTextStyle: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
        contentTextStyle: TextStyle(color: textColor, height: 1.4, fontSize: 14, fontWeight: FontWeight.normal),
        contentPadding: const EdgeInsets.fromLTRB(25, 15, 25, 5),
        actionsPadding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(sub),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              cancelTitle == null ? '취소' : cancelTitle,
              style: TextStyle(color: disableTextColor),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(
              actionTitle == null ? "확인" : actionTitle,
              style: TextStyle(color: keyColor),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              action.call();
            },
          ),
        ],
      );
    },
  );
}
