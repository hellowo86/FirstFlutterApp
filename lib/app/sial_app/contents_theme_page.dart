import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:firstflutter/app/sial_app/data/app.dart';
import 'package:firstflutter/app/sial_app/utils.dart';
import 'package:firstflutter/app/sial_app/view/normal_icon.dart';
import 'package:firstflutter/app/sial_app/view/top_title_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants.dart';
import 'manager/contents_manager.dart';
import 'model/contents.dart';
import 'model/contents_review.dart';
import 'package:intl/intl.dart';

import 'view/contents_listview.dart';

class ContentsThemePage extends StatelessWidget {
  final String type;
  final String keyword;
  final List<Contents> initList;
  PageModel _model;

  ContentsThemePage(this.type, this.keyword, this.initList) {
    _model = PageModel(type, keyword, initList);
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 300), () {
      SystemChrome.setSystemUIOverlayStyle(getSystemUiOverlayStyleTopImage());
    });

    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: ChangeNotifierProvider<PageModel>.value(
        value: _model,
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(color: Colors.white),
          child: Consumer<PageModel>(
            builder: (_, model, widget) {
              Widget child;
              if (_model.isLoading) {
                child = Container(
                  child: Column(
                    children: [
                      SkeletonAnimation(
                        child: Container(
                          height: size.width,
                          width: size.width,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      makeListSkeleton()
                    ],
                  ),
                );
              } else {
                child = ContentsView(_model);
              }

              return Stack(
                children: [
                  child,
                  TopBar(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class PageModel extends ChangeNotifier {
  int topbarMode = 0;
  bool isLoading = true;
  String topImg;
  String update;
  String title;
  List<Contents> list;

  PageModel(String type, String keyword, List<Contents> initList) {
    if (type == "1") {
      _loadContentsByLocation(type, keyword);
    }
  }

  void setTopBarMode(mode) {
    topbarMode = mode;
    notifyListeners();
  }

  _loadContentsByLocation(type, keyword) async {
    isLoading = true;
    notifyListeners();
    var res = await Dio().get(apiDomain + "api/ctMain/push/list?type=$type&keyword=$keyword",
        options: Options(headers: {
          "x-auth-token": App.token,
        }));
    print(res.toString());
    if (res.data["err"] == 0) {
      var ret = res.data["ret"];
      title = ret["title"];
      topImg = ret["img"];
      update = ret["update"];
      list = (ret["list"] as List<dynamic>).map((e) => Contents.fromJson(e)).toList();
    }
    isLoading = false;
    notifyListeners();
  }
}

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    return Consumer<PageModel>(builder: (context, model, child) {
      Color color = model.topbarMode == 0 ? Colors.white : iconColor;
      SystemChrome.setSystemUIOverlayStyle(model.topbarMode == 0 ? getSystemUiOverlayStyleTopImage() : getSystemUiOverlayStyle());
      return Container(
        padding: EdgeInsets.fromLTRB(15, statusBarHeight, 15, 0),
        decoration: model.topbarMode == 1
            ? BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              )
            : BoxDecoration(color: Colors.transparent),
        child: Container(
          height: 60,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              NormalIcon("cancel", size: 15,onTap: () {
                Navigator.pop(context);
              }, color: color),
              Expanded(
                child: Container(),
              ),
              NormalIcon("share", onTap: () {}, color: color),
            ],
          ),
        ),
      );
    });
  }
}

class ContentsView extends StatefulWidget {
  PageModel model;

  ContentsView(this.model);

  @override
  _ContentsViewState createState() => _ContentsViewState();
}

class _ContentsViewState extends State<ContentsView> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print("" + widget.model.title + " /. " + widget.model.topImg);

    String title;
    String subTitle;
    String updateTitle;
    List<Contents> eventList;
    List<Contents> activityList;

    if(widget.model.title.contains("\n")) {
      title = widget.model.title.split("\n")[0];
      subTitle = widget.model.title.split("\n")[1];
    }else {
      title = null;
      subTitle = widget.model.title;
    }

    if(widget.model.update.isNotEmpty) {
      updateTitle = "마지막 업데이트 : ${widget.model.update}";
    }else {
      updateTitle = null;
    }

    if(widget.model.list != null) {
      eventList = widget.model.list.where((element) => element.isEvent() ).toList();
      activityList = widget.model.list.where((element) => element.isActivity() ).toList();
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollUpdateNotification) {
          PageModel model = Provider.of<PageModel>(context);
          if (scrollNotification.metrics.pixels < 250 && model.topbarMode == 1) {
            model.setTopBarMode(0);
          } else if (scrollNotification.metrics.pixels >= 250 && model.topbarMode == 0) {
            model.setTopBarMode(1);
          }
        }
        return true;
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 350,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    width: size.width,
                    height: 350,
                    child: CachedNetworkImage(
                      imageUrl: widget.model.topImg,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: 320,
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Color(0xffffffff), Color(0x00000000)])),
                  ),
                  Container(
                    color: Colors.white,
                    height: 50,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(25, 0, 70, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        if(title != null) Text(
                          title,
                          style: TextStyle(height: 1.3, fontSize: 28, fontWeight: FontWeight.w200),
                        ),
                        if(subTitle != null) Text(
                          subTitle,
                          style: TextStyle(height: 1.3, fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        if(updateTitle != null) Padding(
                          padding: const EdgeInsets.fromLTRB(2, 5, 0, 0),
                          child: Text(
                            updateTitle,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: disableTextColor),
                          ),
                        ),
                        Container(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if(eventList.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                    child: Text(
                      "이벤트",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: keyColor),
                    ),
                  ),
                  ContentsListView(eventList, 0, {}, scrollMode: 1,)
                ],
              ),
            if(activityList.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                    child: Text(
                      "액티비티",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: keyColor),
                    ),
                  ),
                  ContentsListView(activityList, 0, {}, scrollMode: 1,)
                ],
              ),
          ],
        ),
      ),
    );
  }
}