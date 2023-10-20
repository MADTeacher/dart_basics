class Book {
  final String name;
  final int pages;

  Book(this.name, this.pages);

  Box operator +(Book otherBook) {
    return Box([this, otherBook]);
  }

  @override
  String toString() {
    return 'Book($name, $pages)';
  }
}

class Box {
  final List<Book> _items;
  Box(this._items);

  int get size => _items.length;

  String _printBooks() {
    var str = '[';
    for (var element in _items) {
      str += ('$element, ');
    }
    str += ']';
    return str;
  }

  void operator +(Object book) {
    if (book is Book) {
      _items.add(book);
    }
    if (book is Box) {
      _items.addAll(book._items);
    }
  }

  Book operator [](int index) {
    if (index < 0 || index >= _items.length) {
      throw RangeError.range(index, 0, _items.length);
    }
    return _items[index];
  }

  void operator []=(int index, Book book) {
    if (index < 0 || index >= _items.length) {
      throw RangeError.range(index, 0, _items.length);
    }
    _items[index] = book;
  }

  @override
  String toString() {
    return _printBooks();
  }
}

extension TrueBox on Box {
  void add(Object book){
    this + book;
  }
}

void main(List<String> arguments) {
  var book1 = Book('ВиМ т.1', 1234);
  var book2 = Book('ТД т.1', 400);
  var box = book1 + book2;
  
  var box2 = Box([
    Book('Мы', 233),
    Book('Честь имею', 600),
  ]);
  box2.add(box);
  print(box2);
}

