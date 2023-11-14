class Employee {
  final String name;
  final int age;
  final String position;
  final int salary;

  Employee(this.name, this.age, this.position, this.salary);

  @override
  String toString() {
    // чтобы печатать состояние объекта в терминале
    return 'Employee{$name, $age, $position, $salary}';
  }
}

void main() {
  var myList = [
    Employee('Maxim', 22, 'Tranee', 2000),
    Employee('Alexandr', 30, 'Manager', 30000),
    Employee('Anna', 27, 'Team Leader', 29000),
    Employee('John', 22, 'Junior', 4000),
  ];

  for (var element in myList) {
    switch (element) {
      case Employee(
              name: String(length: >= 5),
            ):
        print('Full match: $element');
      default:
        print('No match: $element');
    }
  }
}
