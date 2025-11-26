extension type EmployeeID(int id){
  bool operator >(EmployeeID other){
    return id > other.id;
  }

  bool operator <(EmployeeID other){
    return id < other.id;
  }

  bool operator >=(EmployeeID other){
    return id >= other.id;
  }

  bool operator <=(EmployeeID other){
    return id <= other.id;
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
  final employee = Employee("John", 30, EmployeeID(1));
  final newEmployee = Employee("John", 30, EmployeeID(2));
  print(employee.id > newEmployee.id); // false
  print(employee.id < newEmployee.id); // true
  print(employee.id >= newEmployee.id); // false
  print(employee.id <= newEmployee.id); // true
}
