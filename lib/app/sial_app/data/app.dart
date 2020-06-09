import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:dio/src/response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends ChangeNotifier {
  static String token;
  String name;
  String email;
  String imgT;
  int currentTab = 0;
  bool isMainSearch = false;
  PageController controller;

  static String languageCode;
  static String locale;
  static String deviceId;
  static String deviceName;
  static String deviceVersion;

  App(BuildContext context, PageController controller) {
    this.controller = controller;
    setUserInfo();
    setDeviceInfo(context);
  }

  void setUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name');
    email = prefs.getString('email');
    imgT = prefs.getString('imgT');
    token = prefs.getString('token');
  }

  static setDeviceInfo(BuildContext context) async {
    languageCode = Localizations.localeOf(context).languageCode;
    //List languages = await Devicelocale.preferredLanguages;
    locale = await Devicelocale.currentLocale;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        deviceId = build.androidId;  //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        deviceId = data.identifierForVendor;  //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
  }
  void setMainTab(index) {
    if(index != currentTab) {
      currentTab = index;
      controller.jumpToPage(currentTab);
      notifyListeners();
    }
  }

  void startMainSearch() {
    if(currentTab != 1) {
      currentTab = 1;
      isMainSearch = true;
      controller.jumpToPage(currentTab);
      notifyListeners();
    }
  }

  bool isLogin() => token != null && token.isNotEmpty;

  void login(Response<dynamic> res) async {
    Map<String, dynamic> ret = res.data['ret'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = ret['name'];
    email = ret['email'];
    imgT = ret['imgT'];
    token = res.data['token'];
    await prefs.setString('token', token);
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('imgT', imgT);
    notifyListeners();
  }
}


/*

  

 */