import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'data/app.dart';
import 'manager/contents_manager.dart';
import 'view/normal_icon.dart';

class PageModel extends ChangeNotifier {
  bool isJoin = false;

  void toggle() {
    isJoin = !isJoin;
    notifyListeners();
  }
}

class LoginPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

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
              PageModel model = Provider.of<PageModel>(context);
              if (snapshot.hasData) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          width: 80,
                          image: AssetImage("images/sial/timeblocks_text_logo.png"),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Image(
                          width: 150,
                          image: AssetImage("images/sial/typo_text.png"),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        Expanded(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                if(model.isJoin) TextFormField(
                                    controller: _nameController,
                                    style: TextStyle(fontSize: 13, color: textColor),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      hintText: "이름",
                                    ),
                                    keyboardType: TextInputType.text,
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return '이름을 입력해주세요.';
                                      } else {
                                        return null;
                                      }
                                    }),
                                if(model.isJoin) SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                    controller: _emailController,
                                    style: TextStyle(fontSize: 13, color: textColor),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      hintText: "아이디 또는 이메일",
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (String value) {
                                      if (!value.contains('@')) {
                                        return '이메일을 입력해주세요.';
                                      } else {
                                        return null;
                                      }
                                    }),
                                SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                    controller: _passController,
                                    style: TextStyle(fontSize: 13, color: textColor),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      hintText: "비밀번호",
                                    ),
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: true,
                                    validator: (String value) {
                                      if (value.length < 6) {
                                        return '6자리 이상의 비밀호를 입력해주세요.';
                                      } else {
                                        return null;
                                      }
                                    }),
                                SizedBox(
                                  height: 15,
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          "비밀번호를 잊으셨나요?",
                                          style: TextStyle(fontSize: 12, color: blueColor),
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () {
                              if(_formKey.currentState.validate()) {
                                model.isJoin? _register(context) : _login(context);
                              }
                            },
                            textColor: Colors.white,
                            color: keyColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            padding: const EdgeInsets.all(12.0),
                            child: Text(model.isJoin?"회원가입" : '로그인', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            textColor: Colors.white,
                            color: Color(0xff3b5998),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            padding: const EdgeInsets.all(12.0),
                            child: Text('페이스북으로 로그인', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                              onTap: () {
                                model.toggle();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  model.isJoin ? "이미 계정이 있으신가요? 로그인하기" : "계정이 없으신가요? 가입하기",
                                  style: TextStyle(fontSize: 12, color: textColor),
                                ),
                              )),
                        ),
                      ],
                    ),
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

  void _register(BuildContext context) async {

  }

  void _login(BuildContext context) async {
    var res = await Dio().post(apiDomain + "api/users/login",
        queryParameters: {
          "email" : _emailController.text,
          "passwd": _passController.text,
          "lang": App.locale,
          "ver": "1.0.0",
          "aType": "E",
        },
        options: Options(headers: {
          "x-auth-token": "",
        }));
    print(res);
    if(res.data["err"] == 0) {
      Provider.of<App>(context).login(res);
    }else {
      final snackBar = SnackBar(content: Text(res.data['msg']),);
      Scaffold.of(context).showSnackBar(snackBar);
    }
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
            NormalIcon("cancel", onTap: () {}, color: iconColor),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
