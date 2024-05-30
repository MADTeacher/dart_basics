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
  var cat = Cat('Max');
  print('${cat.hashCode}');
  print('${identityHashCode(cat)}');

  var value = 10;
  print('${value.hashCode}');
  print('${identityHashCode(value)}');
}
