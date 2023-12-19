extension type EmployeeID(int id) {
  bool isEqualTo(EmployeeID other) {
    return id == other.id;
  }
}

class Employee {
  final String name;
  final int age;
  final EmployeeID id;

  Employee(this.name, this.age, this.id);

  @override
  String toString() => "Employee($name, $age, $id)";
}

void main() {
  final employee1 = Employee("John", 30, EmployeeID(1));
  final employee2 = Employee("John", 30, EmployeeID(2));
  // т.к. в Dart все объект, то к полю id класса Employee
  // по умолчанию применима операция сравнения ==
  print(employee1.id == employee2.id); // false
  print(employee1.id == employee1.id); // true
  print(employee1.id.isEqualTo(employee2.id)); // false
  print(employee1.id.isEqualTo(employee1.id)); // true
}
