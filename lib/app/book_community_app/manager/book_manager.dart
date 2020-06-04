import 'package:dio/dio.dart';
import 'package:firstflutter/app/book_community_app/model/book.dart';

class BookManager {
  final String _bookListApi = "https://openapi.naver.com/v1/search/book.json";
  final Map<String, dynamic> _apiHeader = {
    "X-Naver-Client-Id" : "R97rKvLPwpLO47FCPZI9",
    "X-Naver-Client-Secret" : "rcCBiYWhsB",
  };

  Future<List> getBookList(String query) async {
    var ret = await Dio().get(
        _bookListApi + "?query=사랑",
        options: Options(headers: _apiHeader)
    );
    List<dynamic> items = ret.data["items"];
    return Future.value(items.map((e) => Book.fromJson(e)).toList());
  }
}