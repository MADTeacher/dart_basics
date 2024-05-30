class Cat {
  final String name;
  const Cat(this.name);

  @override
  int get hashCode => name.hashCode + 20;

  @override
  bool operator ==(Object other) {
    return other is Cat && name == other.name;
  }
}

void main(List<String> arguments) async {
  var cat1 = Cat('Max');
  var cat2 = Cat('Alex');
  print('Max: ${cat1.hashCode}, Alex: ${cat2.hashCode}');
  print(cat1 == cat2); // false

  cat2 = Cat('Max');
  print('Max1: ${cat1.hashCode}, Max2: ${cat2.hashCode}');
  print(cat1 == cat2); // true
}
