import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

import 'login_view.dart';
import 'main_page.dart';

class FireBaseChatApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      themes: [
        AppTheme.light(),
        AppTheme(
          id:'custom_theme',
          description: 'custom_theme',
          data: ThemeData(
            primaryColor: Colors.red
          ),
        )
      ],
      child: MaterialApp(
        home: ThemeConsumer(
          child: StreamBuilder<FirebaseUser>(
              stream: FirebaseAuth.instance.onAuthStateChanged,
              // ignore: missing_return
              builder: (context, snapshot) {
                if(snapshot.data == null) {
                  return ChangeNotifierProvider<JoinOrLogin>.value(
                      value: JoinOrLogin(),
                      child: LoginView()
                  );
                }else {
                  return MainPage(email: snapshot.data.email);
                }
              }
          ),
        ),
      ),
    );
  }
}

class JoinOrLogin extends ChangeNotifier {
  bool _isJoin = true;

  bool get isJoin => _isJoin;

  void toggle() {
    _isJoin = !_isJoin;
    notifyListeners();
  }
}