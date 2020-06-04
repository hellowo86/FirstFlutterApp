import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firstflutter/app/sial_app/utils.dart';
import 'package:firstflutter/app/sial_app/view/top_title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'manager/contents_manager.dart';
import 'model/contents.dart';

class ContentsPage extends StatelessWidget {
  final Contents contents;

  ContentsPage(this.contents);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: getSystemUiOverlayStyleTopImage(),
        child: ChangeNotifierProvider<PageModel>.value(
          value: PageModel(),
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollUpdateNotification) {
                  print("!!"+scrollNotification.metrics.pixels.toString());
                }
                return true;
              },
              child: Stack(
                children: [
                  ContentsView(contents),
                  TopBar(),
                  BottomBar(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PageModel extends ChangeNotifier {
  int topbarMode = 0;
}

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 70,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                child: Image(
                  image: AssetImage('images/sial/main_search_grey.png'),
                  color: Colors.white,
                  width: 18,
                  height: 18,
                ),
                onTap: () => {},
              ),
              Expanded(child: Container(),),
              InkWell(
                child: Image(
                  image: AssetImage('images/sial/main_search_grey.png'),
                  color: Colors.white,
                  width: 18,
                  height: 18,
                ),
                onTap: () => {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(100),
        ),
        child: Row(
          children: <Widget>[
            Container(
              child: RaisedButton(
                onPressed: () {Navigator.pop(context);},
                textColor: Colors.white,
                color: blueColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Text('바로 계획하기', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
            Container(
              child: RaisedButton(
                onPressed: () {},
                textColor: Colors.white,
                color: redColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Text('상품구매', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Contents contents = widget.contents;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: size.width,
            height: size.width,
            child: Hero(tag: contents.imgT, child: CachedNetworkImage(
              imageUrl: contents.getImageUrl(),
              fit: BoxFit.cover,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contents.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                          ContentsManager.getContentsTypeFullText(contents),
                          style: TextStyle(color: secondTextColor, fontSize: 12, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
                if(contents.isEvent())
                Text(contents.getSimpleDateText(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                if(contents.addr != null)
                Text(contents.addr, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                SizedBox(
                  height: 2000,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
