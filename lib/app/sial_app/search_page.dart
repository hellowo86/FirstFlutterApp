import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'manager/contents_manager.dart';
import 'view/normal_icon.dart';

class PageModel extends ChangeNotifier {
  int topbarMode = 0;

  void setTopBarMode(mode) {
    topbarMode = mode;
    notifyListeners();
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PageModel>.value(
      value: PageModel(),
      child: Column(
        children: [
          TopBar(),
          tab(),
          filter(),
          Divider(height: 0.4, thickness: 0.4, color: lineColor,),
          FutureBuilder<List>(
            future: ContentsManager().getSialMain(),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData && snapshot.data.isNotEmpty) {
                return Expanded(
                  child: Container(),
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
                  child: Center(
                    child: SizedBox(
                      child: CircularProgressIndicator(),
                      width: 20,
                      height: 20,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget tab() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        children: [
          Expanded(
            child: Center(child: Text("이벤트", style: TextStyle(color: keyColor, fontSize: 14, fontWeight: FontWeight.bold))),
          ),
          Expanded(
            child: Center(child: Text("액티비티", style: TextStyle(color: subColor, fontSize: 14, fontWeight: FontWeight.bold))),
          )
        ],
      ),
    );
  }

  Widget filter() {
    return Container(
      margin: const EdgeInsets.fromLTRB(25, 15, 25, 15),
      child: Row(
        children: [
          Text("검색결과 0건", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          Expanded(
            child: Container(),
          ),
          InkWell(
            onTap: (){},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("인기순", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image(color: iconColor, width: 15, height:15, image: AssetImage("images/sial/filter.png"),),
            ),
          )
        ],
      ),
    );
  }
}


class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            NormalIcon("search", onTap: () {}),
          ],
        ),
      ),
    );
  }
}