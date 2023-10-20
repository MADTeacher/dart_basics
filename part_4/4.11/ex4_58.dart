class MyID {
  final int id;
  final String idString;

  MyID(this.id): idString = id.toString();

  @override
  String toString() {
    return idString;
  }
}

class Product<T>{
  T id;
  final String name;
  final double price;

  Product(this.id, this.name, this.price);

  T getId() => id;
  void setId(T idProduct) => id = idProduct;

  @override
  String toString() {
    return 'Продукт: $name с id: $id стоит $price тугриков';
  }
}

void main(List<String> arguments) {
  var product = Product<int>(0, 'Булочка', 33.5);
  print(product);
  var newProduct = Product<MyID>(MyID(10), 'Пирожок', 50);
  print(newProduct);
}
