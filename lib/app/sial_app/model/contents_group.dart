import 'package:firstflutter/app/sial_app/model/contents.dart';

class ContentsGroup {
  String title;
  String img;
  int viewMode;
  int sectionId;
  List<Contents> list;

  ContentsGroup.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    img = json['img'];
    viewMode = json['view'];
    sectionId = json['sectionId'];
    list = (json['list'] as List<dynamic>)
        .map((e) => Contents.fromJson(e))
        .toList();
  }
}
