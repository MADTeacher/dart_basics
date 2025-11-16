class Employee {
  final String name;
  final int age;
  final int salary;

  Employee(this.name, this.age, this.salary);
}

void main() {
  var employee = Employee("John", 25, 50000);
  var Employee(
    name: empName,
    age: empAge,
    salary: empSalary,
  ) = employee;
  print("Name: $empName, Age: $empAge, Salary: $empSalary");
  // Name: John, Age: 25, Salary: 50000

  employee = Employee("Alex", 19, 3000);
  var Employee(
    name: empName1,
    salary: empSalary1,
  ) = employee;
  print("Name: $empName1,  Salary: $empSalary1"); // Name: Alex,  Salary: 3000
}
