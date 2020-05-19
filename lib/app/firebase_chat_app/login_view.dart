import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'splash.dart';

class LoginView extends StatelessWidget {
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CustomPaint(
            size: size,
            painter: LoginBackground(isJoin: Provider.of<JoinOrLogin>(context).isJoin),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _LogoImage(size),
              Stack(
                children: <Widget>[
                  _InputForm(size),
                  _LoginBtn(size)
                ],
              ),
              Container(height: size.height * 0.1,),
              Consumer<JoinOrLogin>(
                builder: (context, joinOrLogin, child) => InkWell(
                  onTap: () {
                    joinOrLogin.toggle();
                  },
                  child: Text(
                    !joinOrLogin.isJoin? "계정이 없으신가요? 가입하기" : "이미 계정이 있으신가요? 로그인하기",
                    style: TextStyle(color: joinOrLogin.isJoin?Colors.red:Colors.blue),
                  ),
                ),
              ),
              Container(height: size.height * 0.05,)
            ],
          )
        ],
      ),
    );
  }

  Widget _LogoImage(Size size) =>  Expanded(
    child: Padding(
      padding: const EdgeInsets.only(top: 60, left: 60, right: 60, bottom: 30),
      child: FittedBox(
        fit: BoxFit.contain,
        child: CircleAvatar(backgroundImage: AssetImage('images/7pv.gif')),
      ),
    ),
  );

  Widget _InputForm(Size size) {
    return Padding(
      padding: EdgeInsets.fromLTRB(25, 0, 25, 22),
      child: Card(
        elevation: 40,
        shadowColor: Colors.grey[50],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25)
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 10, 25, 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.email, size: 20),
                        labelText: '이메일'
                    ),
                    validator: (String value) {
                      if(value.isEmpty) {
                        return '이메일을 입력해주세요.';
                      }else {
                        return null;
                      }
                    }
                ),
                TextFormField(
                    obscureText: true,
                    controller: _passController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.vpn_key, size: 20,),
                        labelText: '비밀번호'
                    ),
                    validator: (String value) {
                      if(value.isEmpty) {
                        return '비밀번호를 입력해주세요.';
                      }else {
                        return null;
                      }
                    }
                ),
                Container(height: 20,),
                Consumer<JoinOrLogin>(
                  builder: (context, joinOrLogin, child) => joinOrLogin.isJoin? Container(height: 0,) : Text('비밀번호를 잊어버리셨나요?')
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _LoginBtn(Size size) => Positioned(
    left: size.width*0.15,
    right: size.width*0.15,
    bottom: 0,
    child: SizedBox(
      height: 45,
      child: Consumer<JoinOrLogin>(
        builder: (context, joinOrLogin, child) => RaisedButton(
          child: Text(joinOrLogin.isJoin?'회원가입':'로그인'),
          color: joinOrLogin.isJoin?Colors.red:Colors.blue,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22)
          ),
          onPressed: () {
            if(_formKey.currentState.validate()) {
              joinOrLogin.isJoin? _register(context) : _login(context);
            }
          },
        ),
      ),
    ),
  );

  void _register(BuildContext context) async {
    final AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passController.text);
    final FirebaseUser user = result.user;

    if(user == null) {
      final snackBar = SnackBar(content: Text("다시 시도해주세요."),);
      Scaffold.of(context).showSnackBar(snackBar);
    }else {

    }
  }

  void _login(BuildContext context) async {
    try{
      final AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passController.text);
    }catch(e) {
      final snackBar = SnackBar(content: Text("다시 시도해주세요."),);
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }
}

class LoginBackground extends CustomPainter {
  LoginBackground({@required this.isJoin});

  final bool isJoin;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = isJoin?Colors.red:Colors.blue;
    canvas.drawCircle(Offset(size.width*0.5, size.height*0.2), size.height*0.5, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}