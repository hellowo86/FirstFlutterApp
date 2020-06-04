import 'package:dio/dio.dart';
import 'package:firstflutter/app/sial_app/constants.dart';
import 'package:firstflutter/app/sial_app/data/app.dart';
import 'package:firstflutter/app/sial_app/inapp_web_page.dart';
import 'package:firstflutter/app/sial_app/model/contents.dart';
import 'package:firstflutter/app/sial_app/model/contents_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../contents_page.dart';

class ContentsManager {
  static final ContentsManager _instance = ContentsManager._internal();

  factory ContentsManager() {
    return _instance;
  }

  ContentsManager._internal() {
    //클래스가 최초 생성될때 1회 발생
    //초기화 코드
  }

  final String _sialMainApi = api_prefix + "api/ctMain/main";
  final String _sialMdsPickApi = api_prefix + "api/ctMain/mainTop";
  final String _sialClickApi = api_prefix + "api/clicks/content50";
  final Map<String, dynamic> _apiHeader = {
    "x-auth-token": "",
  };

  static final Map<String, String> activityType = {
    "81": "만들기",
    "82": "생활노하우",
    "83": "일상탈출",
    "84": "자기관리",
    "85": "쿠킹",
    "86": "스타일링",
    "87": "자기개발",
  };

  static final Map<String, String> eventType = {
    "51": "전시회",
    "52": "강연,세미나",
    "53": "클래스",
    "54": "방송",
    "55": "친목,모임",
    "56": "공연,영화",
    "57": "경기",
    "58": "출시,오픈",
    "59": "세일",
    "60": "모집,공모",
    "61": "지원사업",
    "62": "축제",
  };

  Future<List> getSialMain() async {
    List<ContentsGroup> result = List();
    var sialMainRes = await Dio().get(_sialMainApi, options: Options(headers: _apiHeader));
    result.addAll((sialMainRes.data["ret"] as List<dynamic>).map((e) => ContentsGroup.fromJson(e)).toList());
    var sialMdsRes = await Dio().get(_sialMdsPickApi, options: Options(headers: _apiHeader));
    result.insertAll(0, (sialMdsRes.data["ret"] as List<dynamic>).map((e) => ContentsGroup.fromJson(e)).toList());
    return Future.value(result);
  }

  static String getContentsTypeText(Contents contents) {
    if (contents.isActivity()) {
      return activityType[contents.eventType];
    } else {
      return eventType[contents.eventType];
    }
  }

  static String getContentsTypeFullText(Contents contents) {
    if (contents.isActivity()) {
      return "액티비티 > " + activityType[contents.eventType];
    } else {
      return "이벤트 > " + eventType[contents.eventType];
    }
  }

  void pushContentsPage(BuildContext context, Contents contents, void Function() callback, {isClick = true}) async {
    if (contents.isDirect == 0 || contents.isDirect == 5) {
      if (isClick) {
        print(App.deviceId);
        print(App.languageCode);
        print(contents.id);
        print(contents.type.toString());
        print(contents.level);
        var sialClickRes = await Dio().post(_sialClickApi,
            data: {
              "deviceId": App.deviceId,
              "lang": App.locale,
              "ctId": contents.id,
              "type": contents.type.toString(),
              "level": contents.level
            },
            options: Options(headers: _apiHeader));
        print(sialClickRes.toString());
//        Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) {
//          return ContentsPage(contents);
//        }));
      } else {}
    } else {
      Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) {
        return InappWebPage(contents);
      }));
    }
  }
}
