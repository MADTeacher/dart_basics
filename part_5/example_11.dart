class Box {
  List<Book> items;
  Box(this.items);

  void printBooks(){
    items.forEach((element) {
      print(element.name);
    });
  }

  void operator +(Book book){
    items.add(book);
  }
}

class Book{
  final String name;
  final int pages;

  Book(this.name, this.pages);

  Box operator +(Book otherBook){
    return Box([this, otherBook]);
  }
}

void main(List<String> arguments) {
  var book1 = Book('Война и Мир т.1', 1234);
  var book2 = Book('Тихий Дон т.1', 400);
  var box = book1 + book2;
  box.printBooks();
  print('-' * 30);
  box+Book('Евгений Онегин', 250);
  box.printBooks();
}
