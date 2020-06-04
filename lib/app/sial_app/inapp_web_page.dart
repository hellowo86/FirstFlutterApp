import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firstflutter/app/sial_app/view/normal_icon.dart';
import 'package:firstflutter/app/sial_app/view/top_title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
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
                    BottomBar(),
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
            NormalIcon("cancel", () {
              Navigator.pop(context);
            }, size: 15,),
          ],
        ),
      ),
    );
  }
}

class BottomBar extends StatelessWidget {

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
                child: NormalIcon("arrow_back", () {
                  if(model.canGoBack) Provider.of<PageModel>(context).webViewController.goBack();
                }),
              ),
            ),
            Consumer<PageModel>(
              builder: (context, model, child) => Opacity(
                opacity: model.canGoFoward ? 1 : 0.5,
                child: NormalIcon("arrow_front", () {
                  if(model.canGoFoward) Provider.of<PageModel>(context).webViewController.goForward();
                }),
              ),
            ),
            NormalIcon("heart", () {
              Navigator.pop(context);
            }),
            NormalIcon("add_to_event", () {
              Navigator.pop(context);
            }),
            NormalIcon("share", () {
              Navigator.pop(context);
            }),
            NormalIcon("baseline_more_horiz_black_48dp", () {
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
    String initialUrl = contents.getWebUrl(Provider.of<App>(context).authToken);
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