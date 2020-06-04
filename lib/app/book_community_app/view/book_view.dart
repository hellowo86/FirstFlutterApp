import 'package:cached_network_image/cached_network_image.dart';
import 'package:firstflutter/app/book_community_app/model/book.dart';
import 'package:flutter/material.dart';

class BookView extends StatelessWidget {
  final Book book;

  const BookView({this.book}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                child: Card(
                  elevation: 50,
                  child: CachedNetworkImage(
                    imageUrl: book.image.replaceAll("type=m1&", ""),
                  ),
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Container(
                child: Column(
                  children: [
                    Text(book.title)
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
