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

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PageModel>.value(
      value: PageModel(),
      child: Column(
        children: [
          TopBar(),
          FutureBuilder<int>(
            future: Future.value(0),
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(30),
                        child: Center(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: subColor,
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: AssetImage("images/sial/default_people_img.png"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Icon(
                                      Icons.photo_camera,
                                      color: iconColor,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("가입정보", style: TextStyle(color: keyColor, fontSize: 14, fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 50,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 100,
                                      child: Text("이름", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                                  Text("sssss", style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      width: 100,
                                      child: Text("이메일", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                                  Text("ssss", style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
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
            Stack(
              alignment: Alignment.topRight,
              children: [
                NormalIcon("alarm", onTap: () {}),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 2,
                    backgroundColor: keyColor,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
