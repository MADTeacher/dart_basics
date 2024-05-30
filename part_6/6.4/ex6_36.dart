class Cat {
  final String name;
  const Cat(this.name);
}

void main(List<String> arguments) async {
  var cat = const Cat('Max');
  var newCat = const Cat('Max');
  print('${cat.hashCode}');
  print('${newCat.hashCode}');
  print('${identical(cat, newCat)}'); // true

  var list = const [1, 2, 3];
  var newList = const [1, 2, 3];
  print('${list.hashCode}');
  print('${newList.hashCode}');
  print('${identical(list, newList)}'); // true
}
