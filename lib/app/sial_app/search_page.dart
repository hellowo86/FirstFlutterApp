import 'package:firstflutter/app/sial_app/utils.dart';
import 'package:firstflutter/app/sial_app/view/header_title_text.dart';
import 'package:firstflutter/app/sial_app/view/normal_text.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_text/skeleton_text.dart';

import 'constants.dart';
import 'data/app.dart';
import 'manager/contents_manager.dart';
import 'model/contents.dart';
import 'view/contents_listview.dart';
import 'view/normal_icon.dart';

class PageModel extends ChangeNotifier {
  bool isMainSearch = false;
  int topbarMode = 0;
  Map<String, dynamic> filters = Map();

  void setFilter(String key, dynamic value) {
    filters[key] = value;
    notifyListeners();
  }

  void search(String keyword) {
    var type = filters.containsKey("type") ? filters["type"] : 2;
    filters = {"searchStr": keyword, "type": type};
    topbarMode = 2;
    notifyListeners();
  }

  void setTopBarMode(mode) {
    topbarMode = mode;
    notifyListeners();
  }

  void clearSearch() {
    topbarMode = 0;
    clearFilters();
  }

  void clearFilters() {
    var type = filters.containsKey("type") ? filters["type"] : 2;
    filters = {"type": type};
    notifyListeners();
  }
}

class SearchPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SearchPage> with AutomaticKeepAliveClientMixin<SearchPage>{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PageModel>.value(
      value: PageModel(),
      child: Consumer<PageModel>(
        builder: (context, model, widget) {
          App app = Provider.of<App>(context);
          if(app.isMainSearch) {
            model.isMainSearch = true;
            model.topbarMode = 1;
            app.isMainSearch = false;
          }

          Widget body;
          if (model.topbarMode == 1) {
            body = SearchShortCut();
          } else {
            body = FutureBuilder<List>(
              future: ContentsManager().getContentsListWithFilter(model.filters),
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (snapshot.hasData && snapshot.data.isNotEmpty) {
                  var totalPages = snapshot.data[0];
                  var totalElements = snapshot.data[1];
                  List<Contents> list = snapshot.data[2];
                  return Expanded(
                    child: Column(
                      children: [
                        tab(model),
                        filterOptionView(context, model, totalPages: totalPages, totalElements: totalElements),
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
                                Text("검색결과가 없습니다.", style: TextStyle(color: disableTextColor),)
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
                          filterOptionView(context, model),
                          makeListSkeleton(),
                        ],
                      ));
                }
              },
            );
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

  Widget filterOptionView(context, PageModel model, {totalPages = 0, totalElements = 0}) {
    var filters = model.filters;
    var isSetFilter =  (filters.containsKey("far") && filters["far"] != 0)
        || filters.containsKey("free")
        || filters.containsKey("category")
        || filters.containsKey("day")
        || filters.containsKey("subTitle");
    var order = model.filters.containsKey("order") ? model.filters["order"] : 0;
    return Container(
      margin: const EdgeInsets.fromLTRB(25, 5, 25, 15),
      child: Row(
        children: [
          Text("검색결과 $totalElements건", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          Expanded(
            child: Container(),
          ),
          InkWell(
            onTap: () {
              showOrderSheet(context, model);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(contentsOrders[order], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          Container(
            width: 1,
            height: 15,
            decoration: BoxDecoration(color: lineColor),
            margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          ),
          InkWell(
            onTap: () {
              showFilterSheet(context, model);
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image(
                color: isSetFilter ? keyColor : iconColor,
                width: 15,
                height: 15,
                image: AssetImage("images/sial/filter.png"),
              ),
            ),
          )
        ],
      ),
    );
  }

  void showOrderSheet(context, PageModel model) {
    showMaterialModalBottomSheet(
        duration: Duration(milliseconds: 300),
        animationCurve: Curves.fastOutSlowIn,
        context: context,
        builder: (context, scrollController) => SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < 3; i++)
                      FlatButton(
                        onPressed: () {
                          model.setFilter("order", i);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          contentsOrders[i],
                          style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),
            )));
  }

  void showFilterSheet(context, PageModel model) {
    showMaterialModalBottomSheet(
        duration: Duration(milliseconds: 300),
        animationCurve: Curves.fastOutSlowIn,
        context: context,
        builder: (context, scrollController) {
          return FilterSheet(model);
        });
  }

  @override
  bool get wantKeepAlive => false;
}

class FilterSheet extends StatefulWidget {
  PageModel model;

  FilterSheet(this.model);

  @override
  _FilterSheetState createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  Map<String, dynamic> filters = Map();
  int type;

  @override
  void initState() {
    filters.addAll(widget.model.filters);
    type = filters.containsKey("type") ? filters["type"] : 2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var categories = ContentsManager.categories.entries.toList();
    var eventType = type == 2 ? ContentsManager.eventType.entries.toList() : ContentsManager.activityType.entries.toList();
    var freeFilters = ContentsManager.freeFilters;
    var dateFilters = ContentsManager.dateFilters;

    return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NormalIcon("reset", onTap: () {
                        setState(() {
                          filters.clear();
                        });
                      }),
                      HeaderTitleText(title: "필터"),
                      NormalIcon("check", onTap: () {
                        widget.model.filters = filters;
                        widget.model.notifyListeners();
                        Navigator.of(context).pop();
                      }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Text("카테고리", style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                Wrap(
                  spacing: 5,
                  runSpacing: -10,
                  children: [
                    for (var i = 0; i < categories.length; i++)
                      ActionChip(
                          backgroundColor: (filters.containsKey("category") && (filters["category"] as Set<String>).contains(categories[i].key)) ? keyColor : lineColor,
                          onPressed: () {
                            var key = categories[i].key;
                            var checkedItems = filters.containsKey("category") ? filters["category"] as Set<String> : Set<String>();
                            if (checkedItems.contains(key)) {
                              checkedItems.remove(key);
                            }else {
                              checkedItems.add(key);
                            }
                            setState(() {
                              filters["category"] = checkedItems;
                            });
                          },
                          label: Text(categories[i].value, style: TextStyle(
                            color: (filters.containsKey("category") && (filters["category"] as Set<String>).contains(categories[i].key)) ? Colors.white : disableTextColor,
                          ),),),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Text(type == 2 ? "이벤트 타입" : "액티비티 타입", style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                Wrap(
                  spacing: 5,
                  runSpacing: -10,
                  children: [
                    for (var i = 0; i < eventType.length; i++)
                      ActionChip(
                        backgroundColor: (filters.containsKey("eventType") && (filters["eventType"] as Set<String>).contains(eventType[i].key)) ? keyColor : lineColor,
                        onPressed: () {
                          var key = eventType[i].key;
                          var checkedItems = filters.containsKey("eventType") ? filters["eventType"] as Set<String> : Set<String>();
                          if (checkedItems.contains(key)) {
                            checkedItems.remove(key);
                          }else {
                            checkedItems.add(key);
                          }
                          setState(() {
                            filters["eventType"] = checkedItems;
                          });
                        },
                        label: Text(eventType[i].value, style: TextStyle(
                          color: (filters.containsKey("eventType") && (filters["eventType"] as Set<String>).contains(eventType[i].key)) ? Colors.white : disableTextColor,
                        ),),),
                  ],
                ),
                if(type == 2) Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Text("유/무료", style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                if(type == 2)Wrap(
                  spacing: 5,
                  runSpacing: -10,
                  children: [
                    for (var i = 0; i < freeFilters.length; i++)
                      ActionChip(
                        backgroundColor: (filters.containsKey("free") && filters["free"] == i) ? keyColor : lineColor,
                        onPressed: () {
                          var free = filters.containsKey("free") ? filters["free"] : 2;
                          setState(() {
                            if (free == i) {
                              filters["free"] = 2;
                            }else {
                              filters["free"] = i;
                            }
                          });
                        },
                        label: Text(freeFilters[i], style: TextStyle(
                          color: (filters.containsKey("free") && filters["free"] == i) ? Colors.white : disableTextColor,
                        ),),),
                  ],
                ),
                if(type == 2)Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Text("날짜", style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                if(type == 2)Wrap(
                  spacing: 5,
                  runSpacing: -10,
                  children: [
                    for (var i = 0; i < dateFilters.length; i++)
                      ActionChip(
                        backgroundColor: (filters.containsKey("day") && filters["day"] == i) ? keyColor : lineColor,
                        onPressed: () {
                          var day = filters.containsKey("day") ? filters["day"] : 0;
                          setState(() {
                            if (day == i) {
                              filters["day"] = 0;
                            }else {
                              filters["day"] = i;
                            }
                          });
                        },
                        label: Text(dateFilters[i], style: TextStyle(
                          color: (filters.containsKey("day") && filters["day"] == i) ? Colors.white : disableTextColor,
                        ),),),
                    ActionChip(
                      backgroundColor: (filters.containsKey("day") && filters["day"] == 9) ? keyColor : lineColor,
                      onPressed: () {
                        var day = filters.containsKey("day") ? filters["day"] : 0;
                        setState(() {
                          if (day == 9) {
                            filters["day"] = 0;
                          }else {
                            filters["day"] = 9;
                          }
                        });
                      },
                      label: Text("날짜지정", style: TextStyle(
                        color: (filters.containsKey("day") && filters["day"] == 9) ? Colors.white : disableTextColor,
                      ),),),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}


class SearchShortCut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageModel>(
      builder: (context, model, child) {
        Widget child;
        if (model.topbarMode == 0) {
          child = Container(
            height: 70,
            padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
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
                NormalIcon("search", onTap: () {
                  model.setTopBarMode(model.topbarMode == 0 ? 1 : 0);
                }),
              ],
            ),
          );
        } else {
          child = SearchBar(model);
        }
        return child;
      },
    );
  }
}

class SearchBar extends StatefulWidget {
  PageModel model;

  SearchBar(this.model);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.fromLTRB(20, 11, 0, 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0.8, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                NormalIcon(
                  "search",
                  size: 16,
                  color: disableTextColor,
                ),
                Expanded(
                  child: TextField(
                    style: TextStyle(fontSize: 13),
                    autofocus: true,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (text) {
                      widget.model.search(text);
                    },
                    decoration: InputDecoration.collapsed(
                      hintText: "키워드로 검색하세요.",
                      hintStyle: TextStyle(fontWeight: FontWeight.w300, color: disableTextColor),
                    ),
                  ),
                ),
              ],
            ),
          )),
          FlatButton(
            onPressed: () {
              if(widget.model.isMainSearch) {
                Provider.of<App>(context).setMainTab(0);
              }else {
                widget.model.setTopBarMode(0);
              }
            },
            child: Text(
              "취소",
              style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
