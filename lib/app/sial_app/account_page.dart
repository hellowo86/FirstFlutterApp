import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'data/app.dart';
import 'utils.dart';
import 'view/login_view.dart';
import 'manager/contents_manager.dart';
import 'view/normal_icon.dart';

class PageModel extends ChangeNotifier {}

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<App>(
      builder: (context, app, widget) {
        if (!App.isLogin()) {
          return LoginView();
        } else {
          return ProfileView(app);
        }
      },
    );
  }
}

class ProfileView extends StatelessWidget {
  App app;

  ProfileView(this.app);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PageModel>.value(
      value: PageModel(),
      child: Column(
        children: [
          TopBar(),
          SingleChildScrollView(
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
                        InkWell(
                          onTap: () async {
                            final ProgressDialog pr = ProgressDialog(context);
                            pr.show();
                            final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
                            if (pickedFile != null) {
                              var res = await Dio().post(apiDomain + "api/users/setName",
                                  data: FormData.fromMap({
                                    "name": app.name,
                                    "lang": App.locale,
                                    "file": await MultipartFile.fromFile(pickedFile.path, filename: pickedFile.path.split("/").last),
                                  }),
                                  options: Options(headers: {
                                    "x-auth-token": App.token,
                                  }));
                              print(res);
                              if (res.data["err"] == 0) {
                                app.setProfileImg(res.data['imgT']);
                              }
                            }
                            pr.hide();
                          },
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: subColor,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: (app.imgT != null && app.imgT.isNotEmpty)
                                  ? NetworkImage(app.imgT)
                                  : AssetImage("images/sial/default_people_img.png"),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0),
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
                            Container(width: 100, child: Text("이름", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                            Text(app.name, style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(width: 100, child: Text("이메일", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                            Text(app.email, style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("맞춤정보 설정", style: TextStyle(color: keyColor, fontSize: 14, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 50,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(width: 100, child: Text("성별", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                            Text(app.gender == 0 ? "알수없음" : app.gender == 1 ? "남" : "여", style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(width: 100, child: Text("생년월일", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                            Text(DateFormat().add_yMMMd().format(DateTime.fromMillisecondsSinceEpoch(app.birth)),
                                style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(width: 100, child: Text("관심사", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                            Flexible(
                              child: Text(
                                app.category.map((e) => ContentsManager.categories[e]).toList().join(", "),
                                style: TextStyle(fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: double.infinity,
                        child: RaisedButton(
                          onPressed: () {
                            showAlertDialog(context, app, "로그아웃", sub:"로그아웃 하시겠습니까?", actionTitle: "로그아웃", action: (){app.logout();});
                          },
                          textColor: Colors.white,
                          color: disableTextColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          padding: const EdgeInsets.all(12.0),
                          child: Text('로그아웃', style: TextStyle(fontSize: 13)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
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
