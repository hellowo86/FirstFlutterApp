import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstflutter/app/book_community_app/data/app.dart';
import 'package:firstflutter/app/book_community_app/manager/book_manager.dart';
import 'package:firstflutter/app/book_community_app/view/book_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

import 'model/book.dart';

class BookCommunityApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<App>.value(
      value: App(),
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.yellow,
        ),
        home: Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                OutlineButton(
                  child: Text("hjjh"),
                  onPressed: () async {},
                ),
                MyStatefulWidget(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: (index) => {},
            currentIndex: 0,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.mail),
                title: Text('First'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text('Second'),
              )
            ])
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: new BookManager().getBookList("query"),
      // a previously-obtained Future<List> or null
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          return Expanded(
            child: ListView.builder(
                shrinkWrap: false,
                itemCount: snapshot.data.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (BuildContext _context, int i) {
                  Book book = snapshot.data[i];
                  return BookView(book: book);
                }),
          );
        } else if (snapshot.hasError) {
          children = <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            )
          ];
        } else {
          children = <Widget>[
            SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Awaiting result...'),
            )
          ];
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        );
      },
    );
  }
}
