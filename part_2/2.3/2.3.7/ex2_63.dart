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
          salary: > 10000,
          age: < 30,
        ):
        print('Элитальный сотрудник: $element');
      // какие-то операции над сотрудником
      case _:
        print('Что ты тут забыл? : $element');
    }
  }
}
