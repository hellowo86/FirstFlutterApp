class Book {
  String title; //검색 결과 문서의 제목을 나타낸다. 제목에서 검색어와 일치하는 부분은 태그로 감싸져 있다.
  String link;	//검색 결과 문서의 하이퍼텍스트 link를 나타낸다.
  String image;	//썸네일 이미지의 URL이다. 이미지가 있는 경우만 나타납난다.
  String author;	//저자 정보이다.
  String price;	//정가 정보이다. 절판도서 등으로 가격이 없으면 나타나지 않는다.
  String discount;	//할인 가격 정보이다. 절판도서 등으로 가격이 없으면 나타나지 않는다.
  String publisher;	//출판사 정보이다.
  String isbn;	//ISBN 넘버이다.
  String description;	//검색 결과 문서의 내용을 요약한 패시지 정보이다. 문서 전체의 내용은 link를 따라가면 읽을 수 있다. 패시지에서 검색어와 일치하는 부분은 태그로 감싸져 있다.
  String pubdate;	//출간일 정보이다.

  Book.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        link = json['link'],
        image = json['image'],
        author = json['author'],
        price = json['price'],
        discount = json['discount'],
        publisher = json['publisher'],
        isbn = json['isbn'],
        description = json['description'],
        pubdate = json['pubdate'];

  @override
  String toString() {
    return 'Book{title: $title, link: $link, image: $image, author: $author, price: $price, discount: $discount, publisher: $publisher, isbn: $isbn, description: $description, pubdate: $pubdate}';
  }
}