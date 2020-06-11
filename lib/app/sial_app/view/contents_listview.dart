import 'package:cached_network_image/cached_network_image.dart';
import 'package:firstflutter/app/sial_app/manager/contents_manager.dart';
import 'package:firstflutter/app/sial_app/model/contents.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constants.dart';
import '../utils.dart';


class ContentsListView extends StatefulWidget {
  List<Contents> _items;
  int totalPages;
  Map<String, dynamic> filters;

  ContentsListView(this._items, this.totalPages, this.filters);

  @override
  _ContentsListViewState createState() => _ContentsListViewState();
}

class _ContentsListViewState extends State<ContentsListView> {
  final cardSize = 100.0;
  var isLoading = false;
  List<Contents> _items = List();

  @override
  void initState() {
    _items.addAll(widget._items);
    super.initState();
  }

  _loadMore(int nextPage) async {
    setState(() {
      isLoading = true;
    });
    widget.filters["page"] = nextPage;
    List<dynamic> result = await ContentsManager().getContentsListWithFilter(widget.filters);
    List<Contents> list = result[2];
    setState(() {
      _items.addAll(list);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          int nextPage = (widget.filters.containsKey("page") ? widget.filters["page"] : 0) + 1;
          if(nextPage < widget.totalPages && !isLoading) {
            _loadMore(nextPage);
          }
        }
        return true;
      },
      child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 50),
          itemCount: _items.length + (isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if(index == _items.length) {
              return Container(
                height: 40,
                child: Center(
                  child: SizedBox(
                    width: 30, height: 30,
                      child: CircularProgressIndicator(strokeWidth: 2,)),
                ),
              );
            }
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
                            InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image(
                                  image: AssetImage('images/sial/add_to_event.png'),
                                  width: 15,
                                  height: 15,
                                  color: disableTextColor,
                                ),
                              ),
                              onTap: () => {

                              },
                            ),
                            LikeButton(contents),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class LikeButton extends StatefulWidget {
  Contents contents;

  LikeButton(this.contents);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  Contents contents;
  bool animated = false;

  @override
  void initState() {
    contents = widget.contents;
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(animated ? 1.5: 10),
        child: animated ? Lottie.asset("images/sial/heart.json", repeat: false, width: 32, height: 32)
        : contents.isCheck == "1" ? Image(
          image: AssetImage('images/sial/heart_fill.png'),
          width: 15,
          height: 15,
          color: redColor,
        )
        : Image(
          image: AssetImage('images/sial/heart.png'),
          width: 15,
          height: 15,
          color: disableTextColor,
        ),
      ),
      onTap: (){like();},
    );
  }

  void like() async {
    bool result = await ContentsManager().like(contents);
    if(result) {
      setState(() {
        animated = contents.isCheck == "1";
      });
    }
  }
}


