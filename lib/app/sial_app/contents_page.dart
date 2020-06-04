import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firstflutter/app/sial_app/utils.dart';
import 'package:firstflutter/app/sial_app/view/normal_icon.dart';
import 'package:firstflutter/app/sial_app/view/top_title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'manager/contents_manager.dart';
import 'model/contents.dart';

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
              NormalIcon("arrow_back", onTap: () { Navigator.pop(context); }, color: color),
              Expanded(
                child: Container(),
              ),
              Text(contents.likeCnt.toString(), style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.bold),),
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
                color: blueColor,
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
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
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
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(contents.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal)),
                  SizedBox(height: 10,),
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
                  SizedBox(height: 15,),
                  if (contents.isEvent()) Row(
                    children: [
                      SizedBox(width: 5,),
                      Image(image: AssetImage('images/sial/sheet_time.png'), width: 15, height: 15, color: iconColor,),
                      SizedBox(width: 10,),
                      Text(contents.getSimpleDateText(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  if (contents.addr.isNotEmpty)
                    Row(
                      children: [
                        SizedBox(width: 5,),
                        Image(image: AssetImage('images/sial/sheet_location.png'), width: 15, height: 15, color: iconColor,),
                        SizedBox(width: 10,),
                        Text(contents.addr, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  SizedBox(height: 15,),
                  Divider(height: 0.4, thickness: 0.4, color: lineColor,),
                  SizedBox(height: 25,),
                  Text("상세정보", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 15,),
                  Text(contents.content, style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                  SizedBox(height: 15,),
                ],
              ),
            ),
            if(contents.ctSubs.isNotEmpty) ..._makeStep(contents.ctSubs),
            SizedBox(height: 100,),
          ],
        ),
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
            if(mainImg != null && mainImg.isNotEmpty)
              CachedNetworkImage(
                imageUrl: image_url_prefix + mainImg,
                fit: BoxFit.fitWidth,
              ),
            if(_item.img2T != null && _item.img2T.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 25, 0, 0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: SizedBox(
                        width: (size.width - 80) / 4,
                        height: (size.width - 80) / 4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: CachedNetworkImage(
                            imageUrl: image_url_prefix + _item.img2T,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            if(_item.content != null && _item.content.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 20, 25, 40),
                child: Text(_item.content, style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
              )
          ],
        ),
    );
  }
}

