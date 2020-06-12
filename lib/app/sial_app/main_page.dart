import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firstflutter/app/sial_app/account_page.dart';
import 'package:firstflutter/app/sial_app/constants.dart';
import 'package:firstflutter/app/sial_app/like_list_page.dart';
import 'package:firstflutter/app/sial_app/manager/contents_manager.dart';
import 'package:firstflutter/app/sial_app/model/contents_group.dart';
import 'package:firstflutter/app/sial_app/profiling_page.dart';
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
import 'package:lottie/lottie.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'contents_page.dart';
import 'data/app.dart';
import 'model/contents.dart';
import 'utils.dart';
import 'view/header_title_text.dart';

const cardSize = 175.0;

class SialApp extends StatelessWidget {
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    ContentsManager().getThemeContentsByLocation(context);
    return ChangeNotifierProvider<App>.value(
      value: App(context, controller),
      child: OKToast(
        child: MaterialApp(
          theme: ThemeData(
            primaryColor: keyColor,
            accentColor: keyColor,
            textTheme: GoogleFonts.notoSansTextTheme(Theme.of(context).textTheme.apply(bodyColor: textColor)),
          ),
          home: Home(),
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: getSystemUiOverlayStyle(),
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: SafeArea(
            child: Consumer<App>(
              builder: (context, app, widget) {
                return Column(
                  children: [
                    Expanded(
                      child: PageView(
                        physics:new NeverScrollableScrollPhysics(),
                        controller: app.controller,
                        children: [
                          SialMain(),
                          SearchPage(),
                          LikeListPage(),
                          AccountPage(),
                        ],
                      ),
                    ),
                    BottomBar(),
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
      height: topbarSize,
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
            NormalIcon("setting", onTap: () {
              if(App.isLogin()) {
                Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) {
                  return ProfilingPage();
                }));
              }else {
               showLoginDialog(context, Provider.of<App>(context), "맞춤설정");
              }
            }),
            NormalIcon("search", onTap: () {
              Provider.of<App>(context).startMainSearch();
            }),
          ],
        ),
      ),
    );
  }
}

class BottomBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    App app = Provider.of<App>(context);
    return Container(
      height: 53,
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
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                app.setMainTab(0);
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                app.setMainTab(1);
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                app.setMainTab(2);
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image(
                      image: AssetImage('images/sial/like_list.png'),
                      color: app.currentTab == 2 ? keyColor : subColor,
                      width: 17,
                      height: 17,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "좋아요",
                      style: TextStyle(
                        fontSize: 9,
                        color: app.currentTab == 2 ? keyColor : subColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                app.setMainTab(3);
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
          ),
        ],
      ),
    );
  }
}

class SialMain extends StatefulWidget {

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<SialMain> with AutomaticKeepAliveClientMixin<SialMain>  {
  PageController _pagerController = PageController(
    initialPage: 0,
  );

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        TopBar(),
        Divider(
          height: 0.4,
          thickness: 0.4,
          color: lineColor,
        ),
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
                        ..._makeContentsGroupScroll(
                            size, snapshot.data.length > 1 ? snapshot.data.sublist(1, snapshot.data.length) : List())
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: SkeletonAnimation(
                          child: Container(
                            width: 250,
                            height: 18,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _cardSkeleton(),
                              SizedBox(
                                width: 15,
                              ),
                              _cardSkeleton(),
                              SizedBox(
                                width: 15,
                              ),
                              _cardSkeleton(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _cardSkeleton() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonAnimation(
            child: Container(
              width: cardSize,
              height: cardSize,
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
              width: cardSize,
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
      );

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
        width: cardSize,
        height: 290,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: cardSize,
                  height: cardSize,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: contents.getImageUrl(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: cardSize,
                  height: cardSize,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)), border: Border.all(color: Color(0x30000000), width: 0.5)),
                ),
                LikeButton(contents)
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

  @override
  bool get wantKeepAlive => true;
}

class LikeButton extends StatefulWidget {
  Contents contents;

  LikeButton(this.contents);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  Contents contents;
  bool animated = false;

  @override
  void initState() {
    contents = widget.contents;
  }
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.all(animated ? 1.5: 10),
          child: animated ? Lottie.asset("images/sial/heart.json", repeat: false, width: 32, height: 32)
              : contents.isCheck == "1" ? Image(
            image: AssetImage('images/sial/heart_fill.png'),
            width: 15,
            height: 15,
            color: redColor,
          )
              : Image(
            image: AssetImage('images/sial/inspire_heart.png'),
            width: 15,
            height: 15,
          ),
        ),
        onTap: (){like();},
      ),
    );
  }

  void like() async {
    bool result = await ContentsManager().like(context, contents);
    if(result) {
      setState(() {
        animated = contents.isCheck == "1";
      });
    }
  }
}
