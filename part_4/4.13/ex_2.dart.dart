extension type EmployeeID(int id){}

class Employee {
  final String name;
  final int age;
  final EmployeeID id;

  Employee(this.name, this.age, this.id);

  @override
  String toString() => "Employee($name, $age, $id)";
}

void main() {
  final employee = Employee("John", 30, EmployeeID(1));
  print(employee); // Employee(John, 30, 1)
  // Error: The operator '+' isn't defined for the class 'EmployeeID'.
  // final newEmployee = Employee("John", 30, employee.id + 1);
}
