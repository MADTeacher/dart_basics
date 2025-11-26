class Employee {
  final String name;
  final int age;
  final int id;

  Employee(this.name, this.age, this.id);

  @override
  String toString() => "Employee($name, $age, $id)";
}

void main() {
  final employee = Employee("John", 30, 1);
  print(employee); // Employee(John, 30, 1)
  final newEmployee = Employee("John", 30, employee.id + 1);
  print(newEmployee); // Employee(John, 30, 2)
}
