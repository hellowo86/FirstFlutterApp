import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:url_launcher/url_launcher.dart';

import 'constants.dart';
import 'manager/contents_manager.dart';
import 'model/contents.dart';
import 'model/contents_review.dart';
import 'package:intl/intl.dart';

class ContentsPage extends StatelessWidget {
  final Contents contents;

  ContentsPage(this.contents);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 300), () {
      SystemChrome.setSystemUIOverlayStyle(getSystemUiOverlayStyleTopImage());
    });

    return Scaffold(
      body: ChangeNotifierProvider<PageModel>.value(
        value: PageModel(),
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              ContentsView(contents),
              TopBar(contents),
              BottomBar(),
            ],
          ),
        ),
      ),
    );
  }
}

class PageModel extends ChangeNotifier {
  int topbarMode = 0;

  void setTopBarMode(mode) {
    topbarMode = mode;
    notifyListeners();
  }
}

class TopBar extends StatelessWidget {
  final Contents contents;

  TopBar(this.contents);

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
              NormalIcon("arrow_back", onTap: () {
                Navigator.pop(context);
              }, color: color),
              Expanded(
                child: Container(),
              ),
              Text(
                contents.likeCnt.toString(),
                style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.bold),
              ),
              NormalIcon("heart", onTap: () {}, color: color),
              NormalIcon("share", onTap: () {}, color: color),
            ],
          ),
        ),
      );
    });
  }
}

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 90,
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(150),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                textColor: Colors.white,
                color: keyColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Text('바로 계획하기', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContentsView extends StatefulWidget {
  Contents contents;

  ContentsView(this.contents);

  @override
  _ContentsViewState createState() => _ContentsViewState();
}

class _ContentsViewState extends State<ContentsView> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Contents contents = widget.contents;

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollUpdateNotification) {
          PageModel model = Provider.of<PageModel>(context);
          if (scrollNotification.metrics.pixels < size.width - 100 && model.topbarMode == 1) {
            model.setTopBarMode(0);
          } else if (scrollNotification.metrics.pixels >= size.width - 100 && model.topbarMode == 0) {
            model.setTopBarMode(1);
          }
        }
        return true;
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: size.width,
              height: size.width,
              child: Hero(
                tag: contents.imgT,
                child: CachedNetworkImage(
                  imageUrl: contents.getImageUrl(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            _makeMainContents(contents),
            if (contents.ctSubs.isNotEmpty) ..._makeStep(contents.ctSubs),
            if (!contents.addr.isNotEmpty && contents.slat != null && contents.slng != null) _makeMap(contents),
            _makeKeyword(contents),
            AuthorView(contents),
            ContentsReviewList(contents),
            SizedBox(
              height: 130,
            ),
          ],
        ),
      ),
    );
  }

  Widget _makeMainContents(Contents contents) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(contents.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal)),
          SizedBox(
            height: 10,
          ),
          Container(
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
                  ContentsManager.getContentsTypeFullText(contents),
                  style: TextStyle(color: secondTextColor, fontSize: 12, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          if (contents.isEvent())
            Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Image(
                  image: AssetImage('images/sial/sheet_time.png'),
                  width: 15,
                  height: 15,
                  color: iconColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(contents.getSimpleDateText(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          if (contents.addr.isNotEmpty)
            Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Image(
                  image: AssetImage('images/sial/sheet_location.png'),
                  width: 15,
                  height: 15,
                  color: iconColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(contents.addr, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          SizedBox(
            height: 15,
          ),
          Divider(
            height: 0.4,
            thickness: 0.4,
            color: lineColor,
          ),
          SizedBox(
            height: 25,
          ),
          Text("상세정보", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 15,
          ),
          Text(contents.content, style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget _makeKeyword(Contents contents) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(23, 0, 25, 0),
      child: Row(
        children: [
          SizedBox(
            width: 5,
          ),
          Image(
            image: AssetImage('images/sial/hashtag.png'),
            width: 17,
            height: 17,
          ),
          SizedBox(
            width: 10,
          ),
          Text(contents.getAllkeyword(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
        ],
      ),
    );
  }

  List<Widget> _makeStep(List<CtSubs> ctSubs) {
    List<Widget> children = List();
    ctSubs.forEach((item) {
      children.add(StepView(item));
    });
    return children;
  }

  Widget _makeMap(Contents contents) {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Container(
          height: 180,
          child: GoogleMap(
            mapType: MapType.normal,
            onTap: (_) {},
            zoomControlsEnabled: false,
            scrollGesturesEnabled: false,
            zoomGesturesEnabled: false,
            //gestureRecognizers: Set()..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
            initialCameraPosition: CameraPosition(
              target: LatLng(double.parse(contents.slat), double.parse(contents.slng)),
              zoom: 13,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
          child: Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Image(
                image: AssetImage('images/sial/sheet_location.png'),
                width: 15,
                height: 15,
                color: iconColor,
              ),
              SizedBox(
                width: 10,
              ),
              Text(contents.addr, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _goToTheLocation(double lat, double lng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(37.43296265331129, -122.08832357078792),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414)));
  }
}

class StepView extends StatefulWidget {
  CtSubs _item;

  StepView(this._item);

  @override
  _StepViewState createState() => _StepViewState();
}

class _StepViewState extends State<StepView> {
  String mainImg;
  CtSubs _item;

  @override
  void initState() {
    _item = widget._item;
    mainImg = _item.img1T;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (mainImg != null && mainImg.isNotEmpty)
            CachedNetworkImage(
              imageUrl: image_url_prefix + mainImg,
              fit: BoxFit.fitWidth,
            ),
          if (_item.img2T != null && _item.img2T.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 0, 0),
              child: Row(
                children: [
                  makeSubImg((size.width - 80) / 4, _item.img1T),
                  makeSubImg((size.width - 80) / 4, _item.img2T),
                  makeSubImg((size.width - 80) / 4, _item.img3T),
                  makeSubImg((size.width - 80) / 4, _item.img4T),
                ],
              ),
            ),
          if (_item.content != null && _item.content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 15, 25, 50),
              child: Text(_item.content, style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
            ),
        ],
      ),
    );
  }

  Widget makeSubImg(double size, String imgUrl) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: InkWell(
        onTap: () {
          setState(() {
            mainImg = imgUrl;
          });
        },
        child: SizedBox(
          width: size,
          height: size,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: CachedNetworkImage(
                imageUrl: image_url_prefix + imgUrl,
                fit: BoxFit.cover,
                color: mainImg == imgUrl ? Color(0x00000000) : Color(0x90000000),
                colorBlendMode: BlendMode.darken),
          ),
        ),
      ),
    );
  }
}

class AuthorView extends StatelessWidget {
  Contents contents;

  AuthorView(this.contents);

  @override
  Widget build(BuildContext context) {
    return _makeAuthor(contents);
  }

  Widget _makeAuthor(Contents contents) {
    AdUser author = contents.adUser;
    return Padding(
      padding: const EdgeInsets.fromLTRB(23, 15, 25, 0),
      child: Column(
        children: [
          Divider(
            height: 30,
            thickness: 0.4,
            color: lineColor,
          ),
          Stack(children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: lineColor,
                    child: CircleAvatar(
                      radius: 39,
                      backgroundImage: NetworkImage(image_url_prefix + author.imgT),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(author.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 5,
                        ),
                        Text(author.summary, style: TextStyle(fontSize: 13, color: secondTextColor)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (author.facebook.isNotEmpty) _makeSnsLink("ol_facebook", author.facebook),
                  if (author.insta.isNotEmpty) _makeSnsLink("ol_instagram", author.insta),
                  if (author.naver.isNotEmpty) _makeSnsLink("ol_naver", author.naver),
                  if (author.kakao.isNotEmpty) _makeSnsLink("ol_kakao", author.kakao),
                  if (author.youtube.isNotEmpty) _makeSnsLink("ol_youtube", author.youtube),
                  if (author.etc.isNotEmpty) _makeSnsLink("ol_etc", author.etc),
                ],
              ),
            )
          ]),
        ],
      ),
    );
  }

  Widget _makeSnsLink(String imgName, String link) {
    return InkWell(
        onTap: () {
          _launchURL(link);
        },
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: CircleAvatar(
            radius: 9,
            backgroundImage: AssetImage("images/sial/$imgName.png"),
          ),
        ));
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class ContentsReviewList extends StatefulWidget {
  Contents contents;

  ContentsReviewList(this.contents);

  @override
  _ContentsReviewListState createState() => _ContentsReviewListState();
}

class _ContentsReviewListState extends State<ContentsReviewList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
        future: ContentsManager().getContensReviews(widget.contents, 0),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.data.length == 4) {
            var userId = snapshot.data[0];
            var totalPages = snapshot.data[1];
            var totalElements = snapshot.data[2];
            var reviewList = snapshot.data[3] as List<ContentsReview>;
            return Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    height: 50,
                    thickness: 0.4,
                    color: lineColor,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("댓글", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 10,
                      ),
                      Text(reviewList.length.toString(), style: TextStyle(color: keyColor, fontSize: 14, fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Container(),
                      ),
                      InkWell(
                        child: Text("댓글쓰기", style: TextStyle(color: keyColor, fontSize: 14, fontWeight: FontWeight.bold)),
                        onTap: () {
                          showMaterialModalBottomSheet(
                              duration: Duration(milliseconds: 300),
                              animationCurve: Curves.fastOutSlowIn,
                              context: context,
                              builder: (context, scrollController) => SingleChildScrollView(
                                      child: Container(
                                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                    child: Padding(
                                      padding: const EdgeInsets.all(25.0),
                                      child: Expanded(
                                        child: TextField(
                                          autofocus: true,
                                          decoration: InputDecoration.collapsed(hintText: "댓글을 작성해주세요."),
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          maxLength: 4000,
                                        ),
                                      ),
                                    ),
                                  )));
                        },
                      )
                    ],
                  ),
                  if (reviewList.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 1),
                      child: Text("댓글이 없습니다.\n첫번째 댓글을 남겨보세요.", style: TextStyle(fontSize: 13, color: secondTextColor)),
                    ),
                  if (reviewList.isNotEmpty)
                    ListView.builder(
                        padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: reviewList.length,
                        itemBuilder: (context, index) {
                          var review = reviewList[index];
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 23,
                                  backgroundColor: lineColor,
                                  child: CircleAvatar(
                                    radius: 22,
                                    backgroundImage: NetworkImage(image_url_prefix + review.user.imgT),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(review.user.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Text(DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(review.regDate)),
                                                style: TextStyle(fontSize: 9, color: disableTextColor)),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(review.content, style: TextStyle(fontSize: 13, color: secondTextColor)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  if (reviewList.length > 5)
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        child: Text("전체 댓글보기", style: TextStyle(color: keyColor, fontSize: 14, fontWeight: FontWeight.bold)),
                        onTap: () {},
                      ),
                    )
                ],
              ),
            );
          } else {
            return Container(
              height: 0,
            );
          }
        });
  }
}
