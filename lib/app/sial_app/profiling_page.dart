import 'package:firstflutter/app/sial_app/constants.dart';
import 'package:firstflutter/app/sial_app/manager/contents_manager.dart';
import 'package:firstflutter/app/sial_app/utils.dart';
import 'package:firstflutter/app/sial_app/view/top_title_text.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'data/app.dart';
import 'view/normal_icon.dart';

class PageModel extends ChangeNotifier {
  int topbarMode = 0;
  bool allowLocationPermission;

  PageModel(this.allowLocationPermission);

  void setTopBarMode(mode) {
    topbarMode = mode;
    notifyListeners();
  }
}

class ProfilingPage extends StatelessWidget {
  Set<String> checked = Set();

  @override
  Widget build(BuildContext context) {
    App app = Provider.of<App>(context);
    app.category.forEach((element) {
      checked.add((element));
    });
    return Scaffold(
      body: ChangeNotifierProvider<PageModel>.value(
        value: PageModel(app.allowLocationPermission),
        child: Container(
          child: Stack(
            children: [
              ScrollBody(checked),
              TopBar(checked),
            ],
          ),
        ),
      ),
    );
  }
}

class ScrollBody extends StatefulWidget {
  Set<String> checked = Set();

  ScrollBody(this.checked);

  @override
  _ScrollBodyState createState() => _ScrollBodyState();
}

class _ScrollBodyState extends State<ScrollBody> {
  Set<String> checked;
  List categories = ContentsManager.categories.keys.toList();

  @override
  void initState() {
    checked = widget.checked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollUpdateNotification) {
          PageModel model = Provider.of<PageModel>(context);
          if (scrollNotification.metrics.pixels < 10 && model.topbarMode == 1) {
            model.setTopBarMode(0);
          } else if (scrollNotification.metrics.pixels >= 10 && model.topbarMode == 0) {
            model.setTopBarMode(1);
          }
        }
        return true;
      },
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, image: DecorationImage(image: AssetImage("images/sial/interest_background.png"), fit: BoxFit.cover)),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 70, 25, 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text("위치정보 허용", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                          Consumer<PageModel>(
                            builder: (context, model, widget) {
                              return Switch(
                                  value: model.allowLocationPermission,
                                  onChanged: (value) async {
                                    if (value) {
                                      var position = await getCurrentLocation();
                                      if (position != null && position.latitude != 0.0) {
                                        Provider.of<App>(context).setAllowLocationPermission(true);
                                        Provider.of<App>(context).setCurrentLocation(position);
                                        model.allowLocationPermission = true;
                                      } else {
                                        Provider.of<App>(context).setAllowLocationPermission(false);
                                        model.allowLocationPermission = false;
                                      }
                                      print(position.toString());
                                    } else {
                                      Provider.of<App>(context).setAllowLocationPermission(false);
                                      model.allowLocationPermission = false;
                                    }
                                    model.notifyListeners();
                                  });
                            },
                          )
                        ],
                      ),
                      Text("현재 위치에서 가까운 이벤트 정를 받으려면\n위치를 허용해 주세요.", style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                      SizedBox(
                        height: 40,
                      ),
                      Text("관심사 설정", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 8,
                      ),
                      Text("관심사에 따라 더 관심있을만한 컨텐츠를\n추천합니다.", style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                    ],
                  ),
                ),
                GridView.count(
                  primary: false,
                  childAspectRatio: 0.8,
                  padding: const EdgeInsets.fromLTRB(25, 0, 0, 50),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  children: <Widget>[for (var i = 0; i < ContentsManager.categories.length; i++) categoryView(i)],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget categoryView(index) {
    return Container(
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 30,
            bottom: 0,
            top: 25,
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (checked.contains(categories[index])) {
                      checked.remove(categories[index]);
                    } else {
                      if (checked.length == 10) {
                        showToast("관심사 선택은 최대 10개 입니다");
                      } else {
                        checked.add(categories[index]);
                      }
                    }
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Image(
                      image: AssetImage("images/sial/profile_cate_$index.jpg"),
                      fit: BoxFit.cover,
                    )),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text(
                        ContentsManager.categories[categories[index]],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          if (checked.contains(categories[index]))
            Positioned(
              right: 0,
              top: 0,
              child: Image(
                width: 80,
                height: 80,
                image: AssetImage("images/sial/custom_check.png"),
              ),
            ),
        ],
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  Set<String> checked = Set();

  TopBar(this.checked);

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    return Consumer<PageModel>(builder: (context, model, child) {
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
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: NormalIcon("cancel", size: 14, onTap: () {
                    Navigator.pop(context);
                  }),
                ),
              ),
              Center(
                child: Text(
                  "맞춤설정",
                  style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  child: Text(
                    '완료',
                    style: TextStyle(color: keyColor, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    if (checked.length < 3) {
                      showToast("3개 이상의 관심사가 필수항목 입니다");
                    } else {
                      Provider.of<App>(context).setCategories(checked);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
