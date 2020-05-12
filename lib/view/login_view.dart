import 'package:firstflutter/data/join_or_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              InkWell(
                onTap: () {
                  Provider.of<JoinOrLogin>(context).toggle();
                },
                child: Text('계정이 없으신가요? 가입하기'),
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
        child: Image.asset('images/loading.gif'),
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
                        icon: Icon(Icons.email),
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
                    decoration: InputDecoration.collapsed(
                        hintText: '비밀번호'
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
                Text('비밀번호를 잊어버리셨나요?'),
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
      child: RaisedButton(
        child: Text('로그인'),
        color: Colors.blue,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22)
        ),
        onPressed: () {
          if(_formKey.currentState.validate()) {
            print('야호!!');
          }
        },
      ),
    ),
  );
}