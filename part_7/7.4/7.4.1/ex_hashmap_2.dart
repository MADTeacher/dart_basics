import 'dart:collection';

class Person {
  final String name;
  final int age;

  Person(this.name, this.age);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Person &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          age == other.age;

  @override
  int get hashCode => name.hashCode ^ age.hashCode;

  @override
  String toString() => 'Person{name: $name, age: $age}';
}

void main() {
  final Map<Person, String> myHashMap = HashMap<Person, String>(
    equals: (Person a, Person b) => a == b,
    hashCode: (Person p) => p.hashCode,
  );

  myHashMap[Person('Alice', 30)] = 'Developer';
  myHashMap[Person('Bob', 25)] = 'Designer';

  print(myHashMap);
}
