import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class App extends ChangeNotifier {
  String authToken = "";
  int currentTab = 0;

  static String languageCode;
  static String locale;
  static String deviceId;
  static String deviceName;
  static String deviceVersion;

  App(BuildContext context) {
    setDeviceInfo(context);
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
      notifyListeners();
    }
  }
}


/*

  

 */