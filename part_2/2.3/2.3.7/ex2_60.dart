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
    Employee('Max', 22, 'Tranee', 2000),
    Employee('Alex', 30, 'Manager', 30000),
    Employee('Anna', 27, 'Team Leader', 29000),
    Employee('John', 22, 'Junior', 4000),
  ];

  for (var element in myList) {
    switch (element) {
      case Employee(
              name: 'Max',
              age: 22,
              position: 'Tranee',
              salary: 2000,
            ) ||
            Employee(
              name: 'Alex',
              age: 30,
              position: 'Manager',
              salary: 30000,
            ):
        print('Full match: $element');
      case Employee(
          name: 'Anna',
          salary: 29000,
        ):
        print('Partial match: $element');
      default:
        print('No match: $element');
    }
  }
}
