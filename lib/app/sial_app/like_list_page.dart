import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'manager/contents_manager.dart';
import 'utils.dart';
import 'view/contents_listview.dart';
import 'view/normal_icon.dart';


class PageModel extends ChangeNotifier {
  int topbarMode = 0;
  Map<String, dynamic> filters = {
    "listName" : "like"
  };

  void setFilter(String key, dynamic value) {
    filters[key] = value;
    notifyListeners();
  }

  void setTopBarMode(mode) {
    topbarMode = mode;
    notifyListeners();
  }
}

class LikeListPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<LikeListPage> with AutomaticKeepAliveClientMixin<LikeListPage>{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PageModel>.value(
      value: PageModel(),
      child: Consumer<PageModel>(
        builder: (context, model, widget) {
          Widget body = FutureBuilder<List>(
            future: ContentsManager().getContentsListWithFilter(model.filters),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData && snapshot.data.isNotEmpty) {
                var totalPages = snapshot.data[0];
                var totalElements = snapshot.data[1];
                var list = snapshot.data[2];
                return Expanded(
                  child: Column(
                    children: [
                      tab(model),
                      Divider(
                        height: 0.4,
                        thickness: 0.4,
                        color: lineColor,
                      ),
                      Expanded(
                        child: list.isNotEmpty ? ContentsListView(list) : Container(child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(width: 100, image: AssetImage('images/sial/empty_search.png'),),
                              SizedBox(height: 10,),
                              Text("좋아요 목록이 없습니다.", style: TextStyle(color: disableTextColor),)
                            ],
                          ),
                        ),),
                      ),
                    ],
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
                    child: Column(
                      children: [
                        tab(model),
                        makeListSkeleton(),
                      ],
                    ));
              }
            },
          );
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
              ],
            ),
          ),
        );
      },
    );
  }
}