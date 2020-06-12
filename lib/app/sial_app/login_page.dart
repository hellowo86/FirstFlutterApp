import 'package:firstflutter/app/sial_app/data/app.dart';
import 'package:firstflutter/app/sial_app/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Consumer<App>(
        builder: (context, app, widget) {
          if(App.isLogin()) {
            Navigator.pop(context);
          }
          return SafeArea(child: LoginView());
        },
      ),
    );
  }
}
