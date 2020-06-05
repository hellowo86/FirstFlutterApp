class ContentsReview {
  int id;
  String content;
  int regDate;
  ContentsUser user;

  ContentsReview.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    regDate = json['regDate'];
    user = ContentsUser.fromJson(json['user']);
  }
}

class ContentsUser {
  int id;
  String name;
  String imgT;

  ContentsUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imgT = json['imgT'];
  }
}
