import 'dart:convert';
import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../data/app.dart';
import '../manager/contents_manager.dart';
import 'normal_icon.dart';

class PageModel extends ChangeNotifier {
  bool isFindPass = false;
  bool isJoin = false;

  void toggle() {
    isJoin = !isJoin;
    notifyListeners();
  }
}

class LoginView extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final GlobalKey<FormState> _findPassFormKey = GlobalKey<FormState>();
  final TextEditingController _findPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if(Platform.isIOS){ //check for ios if developing for both android & ios
      AppleSignIn.onCredentialRevoked.listen((_) {
        print("Credentials revoked");
      });
    }

    return ChangeNotifierProvider<PageModel>.value(
      value: PageModel(),
      child: Column(
        children: [
          TopBar(),
          FutureBuilder<int>(
            future: Future.value(0),
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              PageModel model = Provider.of<PageModel>(context);
              if(model.isFindPass) {
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
                        Text(
                          "비밀번호를 잊어버리셨나요?",
                          style: TextStyle(fontSize: 14, color: textColor, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "기존에 가입하신 이메일을 입력하시면\n비밀번호변경 메일을 발송해드립니다.",
                          style: TextStyle(fontSize: 12, color: textColor),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        Expanded(
                          child: Form(
                            key: _findPassFormKey,
                            child: Column(
                              children: [
                                TextFormField(
                                    controller: _findPassController,
                                    style: TextStyle(fontSize: 13, color: textColor),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: subColor, width: 0.0),
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      hintStyle: TextStyle(color: subColor),
                                      hintText: "이메일을 입력하세요",
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (String value) {
                                      if (!value.contains('@')) {
                                        return '이메일을 입력해주세요.';
                                      } else {
                                        return null;
                                      }
                                    }),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () {
                              if (_findPassFormKey.currentState.validate()) {
                                _findPass(context);
                              }
                            },
                            textColor: Colors.white,
                            color: keyColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            padding: const EdgeInsets.all(12.0),
                            child: Text("비밀번호변경 메일받기", style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }else {
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
                                if (model.isJoin)
                                  TextFormField(
                                      controller: _nameController,
                                      style: TextStyle(fontSize: 13, color: textColor),
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: subColor, width: 0.0),
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                        hintStyle: TextStyle(color: subColor),
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
                                if (model.isJoin)
                                  SizedBox(
                                    height: 10,
                                  ),
                                TextFormField(
                                    controller: _emailController,
                                    style: TextStyle(fontSize: 13, color: textColor),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: subColor, width: 0.0),
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      hintStyle: TextStyle(color: subColor),
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
                                  height: 10,
                                ),
                                TextFormField(
                                    controller: _passController,
                                    style: TextStyle(fontSize: 13, color: textColor),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: subColor, width: 0.0),
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      hintStyle: TextStyle(color: subColor),
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
                                      onTap: () {
                                        model.isFindPass = true;
                                        model.notifyListeners();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          "비밀번호를 잊으셨나요?",
                                          style: TextStyle(fontSize: 12, color: keyColor),
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
                              if (_formKey.currentState.validate()) {
                                model.isJoin ? _register(context) : _login(context);
                              }
                            },
                            textColor: Colors.white,
                            color: keyColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(18)),
                            ),
                            padding: const EdgeInsets.all(12.0),
                            child: Text(model.isJoin ? "회원가입" : '로그인', style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
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
                              borderRadius: BorderRadius.all(Radius.circular(18)),
                            ),
                            padding: const EdgeInsets.all(12.0),
                            child: Text('페이스북으로 로그인', style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () async {
                              if(await AppleSignIn.isAvailable()) {
                                final AuthorizationResult result = await AppleSignIn.performRequests([
                                  AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
                                ]);
                                switch (result.status) {
                                  case AuthorizationStatus.authorized:
                                    print(result.credential.user);//All the required credentials
                                    break;
                                  case AuthorizationStatus.error:
                                    print("Sign in failed: ${result.error.localizedDescription}");
                                    break;
                                  case AuthorizationStatus.cancelled:
                                    print('User cancelled');
                                    break;
                                }
                              }else{
                                print('Apple SignIn is not available for your device');
                              }
                            },
                            textColor: Colors.white,
                            color: Color(0xff000000),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(18)),
                            ),
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(color: Colors.white ,width: 20, height: 20, image: AssetImage("images/sial/apple.png"),),
                                Text('애플아이디로 로그인', style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
                              ],
                            ),
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
              }
            },
          ),
        ],
      ),
    );
  }

  void _register(BuildContext context) async {
    var res = await Dio().post(apiDomain + "api/users/join",
        queryParameters: {
          "name": _nameController.text,
          "email": _emailController.text,
          "passwd": _passController.text,
          "lang": App.locale,
          "ver": "1.0.0",
          "aType": "E",
          "deviceId": App.deviceId,
          "key": "",
        },
        options: Options(headers: {
          "x-auth-token": "",
        }));
    print(res);

    if (res.data["err"] == 0) {
      Provider.of<App>(context).join(res, _nameController.text, _emailController.text);
    } else {
      final snackBar = SnackBar(
        content: Text(res.data['msg']),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  void _login(BuildContext context) async {
    var res = await Dio().post(apiDomain + "api/users/login",
        queryParameters: {
          "email": _emailController.text,
          "passwd": _passController.text,
          "lang": App.locale,
          "ver": "1.0.0",
          "aType": "E",
        },
        options: Options(headers: {
          "x-auth-token": "",
        }));
    print(res);

    if (res.data["err"] == 0) {
      String token = res.data['token'];
      var profileRes = await Dio().get(apiDomain + "api/mem/profiles",
          options: Options(headers: {
            "x-auth-token": token,
          }));
      print(profileRes);

      if (profileRes.data["err"] == 0) {
        Provider.of<App>(context).login(res, profileRes);
      }
    } else {
      final snackBar = SnackBar(
        content: Text(res.data['msg']),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  void _findPass(BuildContext context) async {
    var res = await Dio().get(apiDomain + "password/forgetPassword?email=${_findPassController.text}&lang=${App.locale}",
        options: Options(headers: {
          "x-auth-token": "",
        }));
    print(res.data);
    var data = json.decode(res.data);
    if (data["err"] == 0) {
      final snackBar = SnackBar(
        content: Text("변경메일이 발송되었습니다."),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        content: Text(data['msg']),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
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
            NormalIcon("cancel", onTap: () {
              var model = Provider.of<PageModel>(context);
              if(model.isFindPass) {
                model.isFindPass = false;
                model.notifyListeners();
              }else {
                if(Navigator.canPop(context)) {
                  Navigator.pop(context);
                }else {
                  Provider.of<App>(context).setMainTab(0);
                }
              }
            }, color: iconColor, size: 15,),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
