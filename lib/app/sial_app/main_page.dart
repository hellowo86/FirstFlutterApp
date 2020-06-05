import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firstflutter/app/sial_app/account_page.dart';
import 'package:firstflutter/app/sial_app/constants.dart';
import 'package:firstflutter/app/sial_app/like_list_page.dart';
import 'package:firstflutter/app/sial_app/manager/contents_manager.dart';
import 'package:firstflutter/app/sial_app/model/contents_group.dart';
import 'package:firstflutter/app/sial_app/search_page.dart';
import 'package:firstflutter/app/sial_app/view/normal_icon.dart';
import 'package:firstflutter/app/sial_app/view/normal_text.dart';
import 'package:firstflutter/app/sial_app/view/top_title_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'contents_page.dart';
import 'data/app.dart';
import 'model/contents.dart';
import 'utils.dart';
import 'view/header_title_text.dart';

class SialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<App>.value(
      value: App(context),
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: keyColor,
          accentColor: keyColor,
          textTheme: GoogleFonts.notoSansTextTheme(Theme.of(context).textTheme.apply(bodyColor: textColor)),
        ),
        home: Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: getSystemUiOverlayStyle(),
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: SafeArea(
            child: Consumer<App>(
              builder: (context, app, widget) {
                Widget child;
                if(app.currentTab == 1) child = SearchPage();
                else if(app.currentTab == 2) child = LikeListPage();
                else if(app.currentTab == 3) child = AccountPage();
                else child = SialMain();
                return Column(
                  children: [
                    Expanded(
                      child: child,
                    ),
                    BottomBar(app),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('images/sial/typo_logo.png'),
              width: 150,
            ),
            Expanded(
              child: Container(),
            ),
            NormalIcon("setting", onTap: () {}),
            NormalIcon("search", onTap: () {}),
          ],
        ),
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  App app;

  BottomBar(this.app);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              app.setMainTab(0);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(
                    image: AssetImage('images/sial/home.png'),
                    color: app.currentTab == 0 ? keyColor : subColor,
                    width: 17,
                    height: 17,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "홈",
                    style: TextStyle(
                      fontSize: 9,
                      color: app.currentTab == 0 ? keyColor : subColor,
                    ),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              app.setMainTab(1);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(
                    image: AssetImage('images/sial/list.png'),
                    color: app.currentTab == 1 ? keyColor : subColor,
                    width: 17,
                    height: 17,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "목록",
                    style: TextStyle(
                      fontSize: 9,
                      color: app.currentTab == 1 ? keyColor : subColor,
                    ),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              app.setMainTab(2);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(
                    image: AssetImage('images/sial/search.png'),
                    color: app.currentTab == 2 ? keyColor : subColor,
                    width: 17,
                    height: 17,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "검색",
                    style: TextStyle(
                      fontSize: 9,
                      color: app.currentTab == 2 ? keyColor : subColor,
                    ),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              app.setMainTab(3);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(
                    image: AssetImage('images/sial/account.png'),
                    color: app.currentTab == 3 ? keyColor : subColor,
                    width: 17,
                    height: 17,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "계정",
                    style: TextStyle(
                      fontSize: 9,
                      color: app.currentTab == 3 ? keyColor : subColor,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SialMain extends StatefulWidget {
  SialMain({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<SialMain> {
  PageController _pagerController = PageController(
    initialPage: 0,
  );

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        TopBar(),
        Divider(height: 0.4, thickness: 0.4, color: lineColor,),
        FutureBuilder<List>(
          future: ContentsManager().getSialMain(),
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData && snapshot.data.isNotEmpty) {
              return Expanded(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(),
                    child: Column(
                      children: [
                        _makeMdsPickPager(size, snapshot.data[0]),
                        ..._makeContentsGroupScroll(size, snapshot.data.length > 1 ? snapshot.data.sublist(1, snapshot.data.length) : List())
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Expanded(
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Error: ${snapshot.error}'),
                    )
                  ],
                ),
              );
            } else {
              return Expanded(
                child: Center(
                  child: SizedBox(
                    child: CircularProgressIndicator(),
                    width: 20,
                    height: 20,
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _makeMdsPickPager(Size size, ContentsGroup mdsPick) => Container(
        height: size.width,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pagerController,
              itemBuilder: (context, position) {
                Contents contents = mdsPick.list[position];
                return GestureDetector(
                  onTap: () {
                    ContentsManager().pushContentsPage(context, contents, () {});
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.bottomCenter,
                    children: [
                      Hero(
                        tag: contents.imgT,
                        child: CachedNetworkImage(
                          imageUrl: contents.getImageUrl(),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        height: 280,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Color(0x4d000000), Color(0x00000000)])),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(50, 0, 70, 80),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(),
                            ),
                            Text(
                              contents.title,
                              style: TextStyle(color: Colors.white, height: 1.3, fontSize: 28, fontWeight: FontWeight.w800),
                            ),
                            Container(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: Text(
                                    ContentsManager.getContentsTypeText(contents),
                                    style: TextStyle(color: disableTextColor, fontSize: 12, fontWeight: FontWeight.normal),
                                  ),
                                ),
                                Container(
                                  width: 10,
                                ),
                                Text(
                                  contents.getSimpleDateText(),
                                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: mdsPick.list.length,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: SmoothPageIndicator(
                  controller: _pagerController,
                  count: mdsPick.list.length,
                  effect: SlideEffect(
                    spacing: 0.0,
                    radius: 0.0,
                    dotWidth: size.width * 0.65 / mdsPick.list.length,
                    dotHeight: 3.0,
                    paintStyle: PaintingStyle.fill,
                    strokeWidth: 0.0,
                    dotColor: Color(0x10000000),
                    activeDotColor: Color(0xffffffff),
                  ),
                ),
              ),
            )
          ],
        ),
      );

  List<Widget> _makeContentsGroupScroll(Size size, List<ContentsGroup> items) {
    List<Widget> children = List();
    items.forEach((group) {
      children.add(
        Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    HeaderTitleText(title: group.title),
                    Expanded(
                      child: Container(),
                    ),
                    InkWell(
                      child: Row(
                        children: [
                          NormalText("모두보기"),
                          Icon(
                            Icons.keyboard_arrow_right,
                            size: 20,
                          ),
                        ],
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              Container(
                height: 290,
                decoration: BoxDecoration(color: Color(0x00f0f0f0)),
                child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    scrollDirection: Axis.horizontal,
                    itemCount: group.list.length,
                    separatorBuilder: (context, index) => Container(
                          width: 10,
                        ),
                    itemBuilder: (context, index) => _makeContentsCard(size, group.list[index])),
              )
            ],
          ),
        ),
      );
    });
    return children;
  }

  Widget _makeContentsCard(Size size, Contents contents) {
    return GestureDetector(
      onTap: () {
        ContentsManager().pushContentsPage(context, contents, () {});
      },
      child: SizedBox(
        width: 175,
        height: 290,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: 175,
                  height: 175,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: contents.getImageUrl(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: 175,
                  height: 175,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)), border: Border.all(color: Color(0x30000000), width: 0.5)),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      child: Image(
                        image: AssetImage('images/sial/inspire_heart.png'),
                        width: 18,
                        height: 18,
                      ),
                      onTap: () => {},
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
              child: Text(
                contents.title,
                maxLines: 2,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
              child: Container(
                height: 24,
                padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
                decoration: BoxDecoration(
                  color: Color(0xffefefef),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      ContentsManager.getContentsTypeText(contents),
                      style: TextStyle(color: secondTextColor, fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),
            if (contents.isEvent())
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                child: Text(
                  contents.getSimpleDateText(),
                  maxLines: 1,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                ),
              ),
            if (contents.likeCnt != null && int.parse(contents.likeCnt) > 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                child: Text(
                  "좋아요 ${contents.likeCnt}개",
                  style: TextStyle(color: disableTextColor, fontSize: 12, fontWeight: FontWeight.normal),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
