import 'package:firstflutter/app/sial_app/constants.dart';
import 'package:firstflutter/app/sial_app/manager/contents_manager.dart';
import 'package:firstflutter/app/sial_app/view/top_title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/app.dart';
import 'view/normal_icon.dart';

class ProfilingPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<ProfilingPage> {
  List categories = ContentsManager.categories.keys.toList();
  Set<String> checked = Set();
  
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    Provider.of<App>(context).category.forEach((element) {
      checked.add((element));
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, image: DecorationImage(image: AssetImage("images/sial/interest_background.png"), fit: BoxFit.cover)),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopBar(),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text("위치정보 허용", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                          Switch(value: false, onChanged: null)
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
                  padding: const EdgeInsets.fromLTRB(25,0,0,25),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  children: <Widget>[
                    for(var i = 0; i < ContentsManager.categories.length; i++)
                      categoryView(i)
                  ],
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
            left: 0, right: 30, bottom: 0, top: 25,
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: InkWell(
                onTap: (){
                  setState(() {
                    if(checked.contains(categories[index])) {
                      checked.remove(categories[index]);
                    }else{
                      checked.add(categories[index]);
                    }
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Image(image: AssetImage("images/sial/profile_cate_$index.jpg"), fit: BoxFit.cover,)),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text(ContentsManager.categories[categories[index]], style: TextStyle(fontWeight: FontWeight.bold),),
                    )
                  ],
                ),
              ),
            ),
          ),
          if(checked.contains(categories[index])) Positioned(
            right: 0, top: 0,
            child: Image(width: 80, height: 80, image: AssetImage("images/sial/custom_check.png"),),
          ),
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
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
