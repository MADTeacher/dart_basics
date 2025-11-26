class Item{
  final String name;
  final int value;
  Item(this.name, this.value);
}

class Book extends Item{
  Book(String name, int pages): super(name, pages);

  Box operator +(Book otherBook){
    return Box([this, otherBook]);
  }
}

class Magazine extends Item{
  Magazine(String name, int pages): super(name, pages);
}

class Box<T extends Item> {
  List<T> items;
  Box(this.items);

  void printBooks(){
    items.forEach((element) {
      print(element.name);
    });
  }

  void operator +(T book){
    items.add(book);
  }
}

void main(List<String> arguments) {
  var book1 = Book('Война и Мир т.1', 1234);
  var book2 = Book('Тихий Дон т.1', 400);
  var box = book1 + book2;
  box.printBooks();
  print('-' * 30);
  box+ Magazine('Огонёк', 250);
  box.printBooks();
}
