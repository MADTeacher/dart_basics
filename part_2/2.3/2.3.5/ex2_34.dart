class Cat {
  final String name;
  final int age;

  Cat(this.name, this.age);
}

void main() {
  var catList = <Cat>[
    for (var i = 0; i <= 3; i++) Cat('Tommy$i', i + 1),
  ];

  for (var Cat(:name, :age) in catList) {
    print('$name is $age years old');
  }
}
