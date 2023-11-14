class Employee {
  final String name;
  final int age;
  final int salary;

  Employee(this.name, this.age, this.salary);
}

void main() {
  var employee = Employee("John", 25, 50000);
  var Employee(:name, :age, :salary) = employee;
  print("Name: $name, Age: $age, Salary: $salary"); 
  // Name: John, Age: 25, Salary: 50000

  employee =Employee("Alex", 19, 3000);
  Employee(:name, :salary) = employee;
  print("Name: $name, Salary: $salary"); // Name: Alex, Salary: 3000

  Employee(:age,) = employee;
  print("Age: $age"); // Age: 19

}
