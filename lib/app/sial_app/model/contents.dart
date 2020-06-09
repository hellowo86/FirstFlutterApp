import 'package:firstflutter/app/sial_app/constants.dart';
import 'package:firstflutter/app/sial_app/data/app.dart';
import 'package:firstflutter/app/sial_app/utils.dart';
import 'package:intl/intl.dart';

class Contents {
  int id;
  int oriId;
  List<CtSubs> ctSubs;
  AdUser adUser;
  List<CtItems> ctItems;
  int type;
  int campaign;
  String title;
  String subTitle;
  String eventType;
  String notiMsg;
  String spot;
  int frequency;
  int dailyCap;
  int isFree;
  int targetingOs;
  String content;
  String timezone;
  int startTime;
  int endTime;
  String country;
  String imgO;
  String imgT;
  String imgS;
  String allDay;
  int eventStartTime;
  int eventEndTime;
  int isActive;
  int isDelete;
  String addr;
  String slat;
  String slng;
  String placeId;
  int regDate;
  int updDate;
  String url;
  int isDirect;
  String linkKey;
  int category1;
  int category2;
  int category3;
  int quality;
  int step;
  int cntTotalView;
  int cntTotalClick;
  int cntTotalVisit;
  String keyword1;
  String keyword2;
  String keyword3;
  String keyword;
  int targetingAge1;
  int targetingAge2;
  int targetingGender;
  String targetingAddr11;
  String targetingAddr21;
  String targetingAddr31;
  int cntView;
  int cntClick;
  String level;
  String preference;
  int preferStartTime;
  int preferEndTime;
  String mp4Url;
  String linkMsg;
  String likeCnt;
  String isCheck;
  String website;
  String scrapType;
  int habitCount;

  Contents(
      {this.id,
        this.oriId,
        this.ctSubs,
        this.adUser,
        this.ctItems,
        this.type,
        this.campaign,
        this.title,
        this.subTitle,
        this.eventType,
        this.notiMsg,
        this.spot,
        this.frequency,
        this.dailyCap,
        this.isFree,
        this.targetingOs,
        this.content,
        this.timezone,
        this.startTime,
        this.endTime,
        this.country,
        this.imgO,
        this.imgT,
        this.imgS,
        this.allDay,
        this.eventStartTime,
        this.eventEndTime,
        this.isActive,
        this.isDelete,
        this.addr,
        this.slat,
        this.slng,
        this.placeId,
        this.regDate,
        this.updDate,
        this.url,
        this.isDirect,
        this.linkKey,
        this.category1,
        this.category2,
        this.category3,
        this.quality,
        this.step,
        this.cntTotalView,
        this.cntTotalClick,
        this.cntTotalVisit,
        this.keyword1,
        this.keyword2,
        this.keyword3,
        this.keyword,
        this.targetingAge1,
        this.targetingAge2,
        this.targetingGender,
        this.targetingAddr11,
        this.targetingAddr21,
        this.targetingAddr31,
        this.cntView,
        this.cntClick,
        this.level,
        this.preference,
        this.preferStartTime,
        this.preferEndTime,
        this.mp4Url,
        this.linkMsg,
        this.likeCnt,
        this.isCheck,
        this.website,
        this.scrapType,
        this.habitCount});

  Contents.fromJson(Map<String, dynamic> json) {
    setFromJson(json);
  }

  void setFromJson(Map<String, dynamic> json) {
    id = json['id'];
    oriId = json['oriId'];
    if (json['ctSubs'] != null) {
      ctSubs = new List<CtSubs>();
      json['ctSubs'].forEach((v) {
        ctSubs.add(new CtSubs.fromJson(v));
      });
    }
    adUser =
    json['adUser'] != null ? new AdUser.fromJson(json['adUser']) : null;
    if (json['ctItems'] != null) {
      ctItems = new List<CtItems>();
      json['ctItems'].forEach((v) {
        ctItems.add(new CtItems.fromJson(v));
      });
    }
    type = json['type'];
    campaign = json['campaign'];
    title = json['title'];
    subTitle = json['subTitle'];
    eventType = json['eventType'];
    notiMsg = json['notiMsg'];
    spot = json['spot'];
    frequency = json['frequency'];
    dailyCap = json['dailyCap'];
    isFree = json['isFree'];
    targetingOs = json['targetingOs'];
    content = json['content'];
    timezone = json['timezone'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    country = json['country'];
    imgO = json['imgO'];
    imgT = json['imgT'];
    imgS = json['imgS'];
    allDay = json['allDay'];
    eventStartTime = json['eventStartTime'];
    eventEndTime = json['eventEndTime'];
    isActive = json['isActive'];
    isDelete = json['isDelete'];
    addr = json['addr'];
    slat = json['slat'];
    slng = json['slng'];
    placeId = json['placeId'];
    regDate = json['regDate'];
    updDate = json['updDate'];
    url = json['url'];
    isDirect = json['isDirect'];
    linkKey = json['linkKey'];
    category1 = json['category1'];
    category2 = json['category2'];
    category3 = json['category3'];
    quality = json['quality'];
    step = json['step'];
    cntTotalView = json['cntTotalView'];
    cntTotalClick = json['cntTotalClick'];
    cntTotalVisit = json['cntTotalVisit'];
    keyword1 = json['keyword1'];
    keyword2 = json['keyword2'];
    keyword3 = json['keyword3'];
    keyword = json['keyword'];
    targetingAge1 = json['targetingAge1'];
    targetingAge2 = json['targetingAge2'];
    targetingGender = json['targetingGender'];
    targetingAddr11 = json['targetingAddr11'];
    targetingAddr21 = json['targetingAddr21'];
    targetingAddr31 = json['targetingAddr31'];
    cntView = json['cntView'];
    cntClick = json['cntClick'];
    level = json['level'];
    preference = json['preference'];
    preferStartTime = json['preferStartTime'];
    preferEndTime = json['preferEndTime'];
    mp4Url = json['mp4Url'];
    linkMsg = json['linkMsg'];
    likeCnt = json['likeCnt'];
    isCheck = json['isCheck'];
    website = json['website'];
    scrapType = json['scrapType'];
    habitCount = json['habitCount'];
  }

  String getImageUrl() {
    return imgT.startsWith('http') ? imgT : imgDomain + imgT;
  }

  bool isActivity() => type == 0;
  bool isEvent() => type != 0;

  static DateFormat _df = DateFormat("yy.M.d (E)");

  String getSimpleDateText() {
    if(eventStartTime != null && eventStartTime > 0) {
      DateTime start = DateTime.fromMillisecondsSinceEpoch(eventStartTime);
      DateTime end = DateTime.fromMillisecondsSinceEpoch(eventEndTime);
      if(allDay == "Y") {
        if(isSameDay(start, end)) {
          return _df.format(start);
        }else {
          return _df.format(start) + " - " + _df.format(end);
        }
      }else {
        if(isSameDay(start, end)) {
          return _df.format(start);
        }else {
          return _df.format(start) + " - " + _df.format(end);
        }
      }
    }else {
      return "";
    }
  }

  String getWebUrl(String authToken) {
    return apiDomain + "web/bridge/" + linkKey
        + "?level=$level"
        + (authToken.isNotEmpty ? "&token=$authToken" : "");
  }

  String getAllkeyword() {
    return "${keyword1.isEmpty ? "" : "#$keyword1 "}${keyword2.isEmpty ? "" : "#$keyword2 "}${keyword3.isEmpty ? "" : "#$keyword3 "}";
  }
}

class CtSubs {
  int id;
  int ctId;
  String content;
  String img1O;
  String img1T;
  String img2O;
  String img2T;
  String img3O;
  String img3T;
  String img4O;
  String img4T;
  int ordering;

  CtSubs(
      {this.id,
        this.ctId,
        this.content,
        this.img1O,
        this.img1T,
        this.img2O,
        this.img2T,
        this.img3O,
        this.img3T,
        this.img4O,
        this.img4T,
        this.ordering});

  CtSubs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ctId = json['ctId'];
    content = json['content'];
    img1O = json['img1O'];
    img1T = json['img1T'];
    img2O = json['img2O'];
    img2T = json['img2T'];
    img3O = json['img3O'];
    img3T = json['img3T'];
    img4O = json['img4O'];
    img4T = json['img4T'];
    ordering = json['ordering'];
  }
}

class CtItems {
  String title;
  String content;
  String price;
  String imgT;

  CtItems(
      {this.title,
        this.content,
        this.price,
        this.imgT});

  CtItems.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    price = json['price'];
    imgT = json['imgT'];
  }
}

class AdUser {
  int id;
  String email;
  String name;
  String summary;
  String desc;
  String addr;
  String phone;
  String imgB;
  String imgO;
  String imgT;
  int regDate;
  String homepage;
  String facebook;
  String naver;
  String kakao;
  String insta;
  String youtube;
  String etc;
  int cntInvitation;
  double score;
  int replyCnt;
  String snsTopicName;
  double balances;
  String regMonth;
  int cntLimitInvite;

  AdUser(
      {this.id,
        this.email,
        this.name,
        this.summary,
        this.desc,
        this.addr,
        this.phone,
        this.imgB,
        this.imgO,
        this.imgT,
        this.regDate,
        this.homepage,
        this.facebook,
        this.naver,
        this.kakao,
        this.insta,
        this.youtube,
        this.etc,
        this.cntInvitation,
        this.score,
        this.replyCnt,
        this.snsTopicName,
        this.balances,
        this.regMonth,
        this.cntLimitInvite});

  AdUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    summary = json['summary'];
    desc = json['desc'];
    addr = json['addr'];
    phone = json['phone'];
    imgB = json['imgB'];
    imgO = json['imgO'];
    imgT = json['imgT'];
    regDate = json['regDate'];
    homepage = json['homepage'];
    facebook = json['facebook'];
    naver = json['naver'];
    kakao = json['kakao'];
    insta = json['insta'];
    youtube = json['youtube'];
    etc = json['etc'];
    cntInvitation = json['cntInvitation'];
    score = json['score'];
    replyCnt = json['replyCnt'];
    snsTopicName = json['snsTopicName'];
    balances = json['balances'];
    regMonth = json['regMonth'];
    cntLimitInvite = json['cntLimitInvite'];
  }
}