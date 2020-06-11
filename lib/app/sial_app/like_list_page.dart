import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'manager/contents_manager.dart';
import 'model/contents.dart';
import 'utils.dart';
import 'view/contents_listview.dart';
import 'view/normal_icon.dart';


class PageModel extends ChangeNotifier {
  int topbarMode = 0;
  List<dynamic> listData;
  bool isLoading = false;
  Map<String, dynamic> filters = {
    "listName" : "like"
  };

  void setFilter(String key, dynamic value) {
    filters[key] = value;
    loadData();
  }

  void setTopBarMode(mode) {
    topbarMode = mode;
    notifyListeners();
  }

  void loadData() async {
    isLoading = true;
    notifyListeners();
    listData = await ContentsManager().getContentsListWithFilter(filters);
    isLoading = false;
    notifyListeners();
  }
}

class LikeListPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<LikeListPage> with AutomaticKeepAliveClientMixin<LikeListPage>{
  PageModel _model = PageModel();

  @override
  void initState() {
    _model.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PageModel>.value(
      value: _model,
      child: Consumer<PageModel>(
        builder: (context, model, widget) {
          Widget body;

          if (!model.isLoading && model.listData != null && model.listData.isNotEmpty) {
            var totalPages = model.listData[0];
            var totalElements = model.listData[1];
            List<Contents> list = model.listData[2];
            body = Expanded(
              child: Column(
                children: [
                  tab(model),
                  Divider(
                    height: 0.4,
                    thickness: 0.4,
                    color: lineColor,
                  ),
                  Expanded(
                    child: list.isNotEmpty
                        ? ContentsListView(list, totalPages, model.filters)
                        : Container(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              width: 100,
                              image: AssetImage('images/sial/empty_search.png'),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "검색결과가 없습니다.",
                              style: TextStyle(color: disableTextColor),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            body = Expanded(
                child: Column(
                  children: [
                    tab(model),
                    makeListSkeleton(),
                  ],
                ));
          }

          return Column(
            children: [
              TopBar(),
              body,
            ],
          );
        },
      ),
    );
  }

  Widget tab(PageModel model) {
    var type = model.filters.containsKey("type") ? model.filters["type"] : 2;
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FlatButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () {
              model.setFilter("type", 2);
            },
            child: Text("이벤트", style: TextStyle(color: type == 2 ? keyColor : subColor, fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          FlatButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () {
              model.setFilter("type", 0);
            },
            child: Text("액티비티", style: TextStyle(color: type == 0 ? keyColor : subColor, fontSize: 14, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageModel>(
      builder: (context ,model, child) {
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
              ],
            ),
          ),
        );
      },
    );
  }
}