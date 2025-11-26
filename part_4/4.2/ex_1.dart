class Book{
  static var bookPages = 10;

  int get pages => bookPages;
}

void main(List<String> arguments) {
  var book1 = Book();
  print(book1.pages); // 10
  Book.bookPages = 20; // меняем значение
  var book2 = Book();
  print(book2.pages); // 20
}
