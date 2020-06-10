import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class App extends ChangeNotifier {
  static String token;
  String name = "";
  String email = "";
  String imgT = "";
  int gender = 0;
  int birth = 0;
  List<String> category = List();
  int currentTab = 0;
  bool isMainSearch = false;
  PageController controller;
  double slat = 0.0;
  double slng = 0.0;
  bool allowLocationPermission = false;

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
    gender = prefs.getInt('gender');
    birth = prefs.getInt('birth');
    category = prefs.getStringList('category');
    slat = prefs.getDouble('slat');
    slng = prefs.getDouble('slng');
    if(prefs.containsKey("allowLocationPermission")) allowLocationPermission = prefs.getBool('allowLocationPermission');
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

  void login(Response<dynamic> res, Response<dynamic> profileRes) async {
    Map<String, dynamic> ret = res.data['ret'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = res.data['token'];
    name = ret['name'];
    email = ret['email'];
    imgT = ret['imgT'];
    var profile = profileRes.data["userProfile"];
    if(profile != null) {
      gender = profile['gender'];
      var date = DateTime(int.parse(profile['yyyy']),
          int.parse(profile['mm']),
          int.parse(profile['dd']));
      birth = date.millisecondsSinceEpoch;

      category = List();
      List<dynamic> cate = profile["userCategory"];
      cate.forEach((element) {
        category.add(element["categoryId"].toString());
      });
    }else {
      gender = 0;
      birth = DateTime(2020, 10, 10).millisecondsSinceEpoch;
      category = List();
    }

    await prefs.setString('token', token);
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('imgT', imgT);
    await prefs.setInt('gender', gender);
    await prefs.setInt('birth', birth);
    await prefs.setStringList('category', category);
    notifyListeners();
  }

  void join(Response<dynamic> res, n, e) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = res.data['token'];
    name = n;
    email = e;
    imgT = null;
    gender = 0;
    birth = DateTime(2020, 10, 10).millisecondsSinceEpoch;
    category = List();

    await prefs.setString('token', token);
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('imgT', imgT);
    await prefs.setInt('gender', gender);
    await prefs.setInt('birth', birth);
    await prefs.setStringList('category', category);
    notifyListeners();
  }

  void setProfileImg(String imgT) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.imgT = imgT;
    await prefs.setString('imgT', imgT);
    notifyListeners();
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = null;
    await prefs.setString('token', token);
    notifyListeners();
  }

  void setCategories(Set<String> checked) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    category = checked.toList();
    await prefs.setStringList('category', category);
    _postProfileData();
    notifyListeners();
  }

  _postProfileData() async {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(birth);
    var res = await Dio().post(apiDomain + "api/mem/profiles",
        queryParameters: {
          "country": locale,
          "gender": gender.toString(),
          "yyyy": dateTime.year.toString(),
          "mm": dateTime.month.toString(),
          "dd": dateTime.day.toString(),
          "addr1": "",
          "addr2": "",
          "addr3": "",
          "slat": slat.toString(),
          "slng": slng.toString(),
          "category": category.join(":"),
        },
        options: Options(headers: {
          "x-auth-token": token,
        }));
    print(res);
  }

  void setCurrentLocation(Position position) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    slat = position.latitude;
    slng = position.longitude;
    await prefs.setDouble('slat', slat);
    await prefs.setDouble('slng', slng);
  }

  void setAllowLocationPermission(bool permission) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    allowLocationPermission = permission;
    await prefs.setBool('allowLocationPermission', allowLocationPermission);
  }
}


/*

  

 */