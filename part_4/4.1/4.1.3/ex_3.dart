class Book{
  final String name;
  final int pages;
  static var _booksMap = <String, Book>{};

  Book.fromSettings(this.name, this.pages);

  factory Book(String name, int pages){
    var cache = name.toLowerCase() + pages.toString();
    return _booksMap.putIfAbsent(cache, 
              () => Book.fromSettings(name, pages));
  }
}

void main(List<String> arguments) {
  var book1 = Book('Война и Мир т.1', 1234);
  var book2 = Book('Тихий Дон т.1', 400);
  var book3 = Book('Евгений Онегин', 250);
  var book4 = Book('Война и Мир т.1', 1234);
  print(identical(book2, book3)); // false
  print(identical(book1, book4)); // true
}
