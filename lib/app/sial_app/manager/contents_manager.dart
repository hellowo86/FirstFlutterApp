import 'dart:math';

import 'package:dio/dio.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firstflutter/app/sial_app/constants.dart';
import 'package:firstflutter/app/sial_app/data/app.dart';
import 'package:firstflutter/app/sial_app/inapp_web_page.dart';
import 'package:firstflutter/app/sial_app/model/contents.dart';
import 'package:firstflutter/app/sial_app/model/contents_group.dart';
import 'package:firstflutter/app/sial_app/model/contents_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:share/share.dart';

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

  final String _sialMainApi = apiDomain + "api/ctMain/main";
  final String _sialMdsPickApi = apiDomain + "api/ctMain/mainTop";
  final String _sialClickApi = apiDomain + "api/clicks/content50";

  Map<String, dynamic> makeApiHeader() => {
        "x-auth-token": App.token,
      };

  static final Map<String, String> categories = {
    "1": "인테리어,가구",
    "2": "가전,디지털",
    "3": "다이어트,건강",
    "4": "도서",
    "5": "레저,스포츠",
    "6": "맛집,푸드",
    "7": "뷰티,미용",
    "8": "생활",
    "9": "여가,취미",
    "10": "반려동물",
    "11": "여행",
    "12": "문화,예술",
    "13": "가족,육아",
    "14": "음악",
    "15": "자동차",
    "16": "패션",
    "17": "비지니스,경제",
    "21": "교육,외국어",
    "19": "IT,과학",
    "22": "게임,오락",
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

  static final freeFilters = ["유료", "무료"];
  static final dateFilters = ["오늘", "내일", "이번주", "이번주말", "다음주"];
  static final contentsOrders = ["인기순", "최신순", "거리순"];

  Future<List> getSialMain() async {
    List<ContentsGroup> result = List();
    var sialMainRes = await Dio().get(_sialMainApi, options: Options(headers: makeApiHeader()));
    result.addAll((sialMainRes.data["ret"] as List<dynamic>).map((e) => ContentsGroup.fromJson(e)).toList());
    var sialMdsRes = await Dio().get(_sialMdsPickApi, options: Options(headers: makeApiHeader()));
    result.insertAll(0, (sialMdsRes.data["ret"] as List<dynamic>).map((e) => ContentsGroup.fromJson(e)).toList());
    return Future.value(result);
  }

  Future<List> getContensReviews(Contents contents, int page) async {
    List<dynamic> result = List();
    var res = await Dio()
        .get(apiDomain + "api/comments/${contents.id}?page=$page&lang=${App.locale}", options: Options(headers: makeApiHeader()));
    if (res.data["err"] == 0) {
      var userId = res.data['userId'];
      var totalPages = res.data['totalPages'];
      var totalElements = res.data['totalElements'];
      var items = (res.data['page']['content'] as List<dynamic>).map((e) => ContentsReview.fromJson(e)).toList();
      result.add(userId);
      result.add(totalPages);
      result.add(totalElements);
      result.add(items);
    }
    return Future.value(result);
  }

  Future<List> getContentsListWithFilter(Map<String, dynamic> filters) async {
    List<dynamic> result = List();
    var url = apiDomain + "api/ctMain/list";
    var type = filters.containsKey("type") ? filters["type"] : 2;
    url += "?type=$type";

    if (filters.containsKey("listName")) url += "&listName=${filters["listName"]}";
    if (filters.containsKey("order")) url += "&order=${filters["order"]}";

    if (type == 2) {
      if (filters.containsKey("far")) {
        var far = filters["far"];
        url += "&far=$far";
        if (far > 0) {
          url += "&slat=${filters["slat"]}";
          url += "&slng=${filters["slng"]}";
        }
      }

      if (filters.containsKey("day")) {
        var day = filters["day"];
        url += "&day=${filters["day"]}";
        if (day == 9) {
          url += "&startDay=${filters["startDay"]}";
          url += "&endDay=${filters["endDay"]}";
        }
      }

      if (filters.containsKey("free")) url += "&free=${filters["free"]}";
    }

    if (filters.containsKey("eventType")) {
      var subTitle = filters["eventType"] as Set<String>;
      subTitle.forEach((element) {
        url += "&eventType=$element";
      });
    }

    if (filters.containsKey("category")) {
      var category = filters["category"] as Set<String>;
      category.forEach((element) {
        url += "&category=$element";
      });
    }

    if (filters.containsKey("page")) url += "&page=${filters["page"]}";
    if (filters.containsKey("searchStr") && (filters["searchStr"] as String).isNotEmpty) url += "&searchStr=${filters["searchStr"]}";
    if (filters.containsKey("scrapType") && (filters["scrapType"] as String).isNotEmpty) url += "&scrapType=${filters["scrapType"]}";

    print("" + url);
    var res = await Dio().get(url, options: Options(headers: makeApiHeader()));
    if (res.data["err"] == 0) {
      var totalPages = res.data['totalPages'];
      var totalElements = res.data['totalElements'];
      var items = (res.data['ret'] as List<dynamic>).map((e) => Contents.fromJson(e)).toList();
      result.add(totalPages);
      result.add(totalElements);
      result.add(items);
    }
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
        var sialClickRes = await Dio().post(_sialClickApi,
            queryParameters: {
              "deviceId": App.deviceId,
              "lang": App.locale,
              "ctId": contents.id.toString(),
              "type": contents.type.toString(),
              "level": contents.level
            },
            options: Options(headers: makeApiHeader()));
        if (sialClickRes.data["err"] == 0) {
          contents.setFromJson(sialClickRes.data["content"]);
          Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) {
            return ContentsPage(contents);
          }));
        } else {}
      } else {}
    } else {
      Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) {
        return InappWebPage(contents);
      }));
    }
  }

  void shareContents(BuildContext context, Contents contents) async {
//    final DynamicLinkParameters parameters = DynamicLinkParameters(
//      uriPrefix: 'https://abc123.app.goo.gl',
//      link: Uri.parse('https://example.com/'),
//      androidParameters: AndroidParameters(
//        packageName: 'com.example.android',
//        minimumVersion: 125,
//      ),
//      iosParameters: IosParameters(
//        bundleId: 'com.example.ios',
//        minimumVersion: '1.0.1',
//        appStoreId: '123456789',
//      ),
//      googleAnalyticsParameters: GoogleAnalyticsParameters(
//        campaign: 'example-promo',
//        medium: 'social',
//        source: 'orkut',
//      ),
//      itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
//        providerToken: '123456',
//        campaignToken: 'example-promo',
//      ),
//      socialMetaTagParameters:  SocialMetaTagParameters(
//        title: 'Example of a Dynamic Link',
//        description: 'This link works whether app is installed or not!',
//      ),
//    );
//
//    final ShortDynamicLink dynamicUrl = await parameters.buildShortLink();
    Share.share('친구분이 추천하신 계획입니다.\n\n${contents.title}\n\n${""}', subject: '시간을 알차게');
  }

  Future<bool> like(Contents contents) async {
    var res = await Dio().post(apiDomain + "api/ctMain/like/${contents.id}",
        queryParameters: {
          "lang": App.locale,
          "isCheck": contents.isCheck == "0" ? "1":"0"
        },
        options: Options(headers: makeApiHeader()));
    if (res.data["err"] == 0) {
      if(contents.isCheck == "0") {
        contents.isCheck = "1";
        contents.likeCnt = (int.parse(contents.likeCnt) + 1).toString();
      }else {
        contents.isCheck = "0";
        contents.likeCnt = max(0, (int.parse(contents.likeCnt) - 1)).toString();
      }
      return true;
    }
    return false;
  }
}
