import 'package:cached_network_image/cached_network_image.dart';
import 'package:firstflutter/app/sial_app/manager/contents_manager.dart';
import 'package:firstflutter/app/sial_app/model/contents.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../utils.dart';

class ContentsListView extends StatelessWidget {
  var cardSize = 100.0;
  List<Contents> _items;

  ContentsListView(this._items);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
      itemCount: _items.length,
        itemBuilder: (context, index) {
        var contents = _items[index];
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ContentsManager().pushContentsPage(context, contents, () {});
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
            height: 120,
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: cardSize,
                          height: cardSize,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: contents.getImageUrl(),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          width: cardSize,
                          height: cardSize,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(8)), border: Border.all(color: Color(0x30000000), width: 0.5)),
                        ),
                      ],
                    ),
                    SizedBox(width: 15,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                            child: Text(
                              contents.title,
                              maxLines: 2,
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                                child: Container(
                                  height: 24,
                                  padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
                                  decoration: BoxDecoration(
                                    color: Color(0xffefefef),
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        ContentsManager.getContentsTypeText(contents),
                                        style: TextStyle(color: secondTextColor, fontSize: 12, fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              if (contents.isEvent())
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                                  child: Text(
                                    contents.getSimpleDateText(),
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                                  ),
                                ),
                            ],
                          ),
                          if (contents.likeCnt != null && int.parse(contents.likeCnt) > 0)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                              child: Text(
                                "좋아요 ${contents.likeCnt}개",
                                style: TextStyle(color: disableTextColor, fontSize: 12, fontWeight: FontWeight.normal),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child:InkWell(
                          child: Image(
                            image: AssetImage('images/sial/add_to_event.png'),
                            width: 15,
                            height: 15,
                            color: iconColor,
                          ),
                          onTap: () => {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child:  InkWell(
                          child: Image(
                            image: AssetImage('images/sial/heart.png'),
                            width: 15,
                            height: 15,
                            color: iconColor,
                          ),
                          onTap: () => {},
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
