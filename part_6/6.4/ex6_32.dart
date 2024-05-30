class Cat {
  final String name;
  const Cat(this.name);
}

void main(List<String> arguments) async {
  var cat = Cat('Max');
  print('Cat hashCode: ${cat.hashCode}');

  var value = 10;
  print('Value hashCode: ${value.hashCode}');
}
