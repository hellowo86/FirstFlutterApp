import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firstflutter/app/sial_app/view/normal_icon.dart';
import 'package:firstflutter/app/sial_app/view/top_title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'constants.dart';
import 'data/app.dart';
import 'manager/contents_manager.dart';
import 'model/contents.dart';
import 'utils.dart';

class InappWebPage extends StatelessWidget {
  final Contents contents;

  InappWebPage(this.contents);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: getSystemUiOverlayStyle(),
          child: ChangeNotifierProvider<PageModel>.value(
            value: PageModel(),
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: SafeArea(
                child: Column(
                  children: [
                    TopBar(),
                    Divider(
                      color: lineColor,
                      height: 0.5,
                      thickness: 0.5,
                    ),
                    ContentsView(contents),
                    Divider(
                      color: lineColor,
                      height: 0.5,
                      thickness: 0.5,
                    ),
                    BottomBar(contents),
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: () {
          print("onWillPop");
          PageModel model = Provider.of<PageModel>(context);
          model.webViewController.canGoBack().then((canGoBack) {
            if(canGoBack) model.canGoBack = canGoBack;
            else Navigator.pop(context);
          });
          return;
        },
      ),
    );
  }
}

class PageModel extends ChangeNotifier {
  WebViewController webViewController;
  bool canGoBack = false;
  bool canGoFoward = false;
}

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            NormalIcon("cancel", onTap: () {
              Navigator.pop(context);
            }, size: 15,),
          ],
        ),
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  final Contents contents;

  BottomBar(this.contents);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [],
      ),
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Consumer<PageModel>(
              builder: (context, model, child) => Opacity(
                opacity: model.canGoBack ? 1 : 0.5,
                child: NormalIcon("arrow_back", onTap: () {
                  if(model.canGoBack) Provider.of<PageModel>(context).webViewController.goBack();
                }),
              ),
            ),
            Consumer<PageModel>(
              builder: (context, model, child) => Opacity(
                opacity: model.canGoFoward ? 1 : 0.5,
                child: NormalIcon("arrow_front", onTap: () {
                  if(model.canGoFoward) Provider.of<PageModel>(context).webViewController.goForward();
                }),
              ),
            ),
            LikeButton(contents),
            NormalIcon("add_to_event", onTap: () {
              Navigator.pop(context);
            }),
            NormalIcon("share", onTap: () {
              ContentsManager().shareContents(context, contents);
            }),
            NormalIcon("baseline_more_horiz_black_48dp", onTap: () {
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }
}

class ContentsView extends StatelessWidget {
  final Contents contents;

  ContentsView(this.contents);

  @override
  Widget build(BuildContext context) {
    String initialUrl = contents.getWebUrl(App.token);
    return Expanded(
      child: WebView(
        initialUrl: initialUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          Provider.of<PageModel>(context).webViewController = webViewController;
        },
        onPageStarted: (url) {
          print('onPageStarted $url');
          PageModel model = Provider.of<PageModel>(context);
          model.webViewController.canGoBack().then((canGoBack) {
            print("canGoBack $canGoBack");
            model.canGoBack = canGoBack;
            model.notifyListeners();
          });
          model.webViewController.canGoForward().then((canGoFoward) {
            print("canGoFoward $canGoFoward");
            model.canGoFoward = canGoFoward;
            model.notifyListeners();
          });
        },

      ),
    );
  }
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
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(animated ? 1.5: 10),
        child: animated ? Lottie.asset("images/sial/heart.json", repeat: false, width: 34, height: 34)
            : contents.isCheck == "1" ? Image(
          image: AssetImage('images/sial/heart_fill.png'),
          width: 17,
          height: 17,
          color: redColor,
        )
            : Image(
          image: AssetImage('images/sial/heart.png'),
          width: 17,
          height: 17,
          color: iconColor,
        ),
      ),
      onTap: (){like();},
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
