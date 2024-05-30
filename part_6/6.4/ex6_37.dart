class Cat {
  final String name;
  const Cat(this.name);
}

void main(List<String> arguments) async {
  foo();
  var intValue = 10;
  var doubleValue = 10.1;
  var stringValue = '10 1!';
  var cat = const Cat('Max');
  print(identityHashCode(intValue)); 
  print(identityHashCode(doubleValue)); 
  print(identityHashCode(stringValue));
  print(identityHashCode(cat));

  var newCat = Cat('Alex');
  print(identityHashCode(newCat));
}

void foo() {
  var intValue = 10;
  var doubleValue = 10.1;
  var stringValue = '10 1!';
  var cat = const Cat('Max');
  print(identityHashCode(intValue));
  print(identityHashCode(doubleValue));
  print(identityHashCode(stringValue));
  print(identityHashCode(cat));

  var newCat = Cat('Alex');
  print(identityHashCode(newCat));
}
