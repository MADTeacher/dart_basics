class Employee {
  String name;
  int age;
  int salary;

  Employee(this.name, this.age, this.salary);

  @override
  String toString() {
    // чтобы печатать состояние объекта в терминале
    return 'Employee{$name, $age, $salary}';
  }
}

void changeSalary( Employee employee, int newSalary,) {
  employee.salary = newSalary;
}

void addListElement(List<int> funcList,  int b,) {
  funcList.add(b);
}

void removeSetElement(Set<int> funcSet, int b,) {
  funcSet.remove(b);
}

void updateMapValue(
  Map<String, int> funcMap, {
  required String key,
  required int value,
}) {
  funcMap[key] = value;
}

void stringUpdate(String funcString, String b) {
  funcString = b;
}

void main(List<String> arguments) {
  var myList = [10, 20];
  addListElement(myList, 3);
  print(myList); // [10, 20, 3]

  var mySet = {10, 20};
  removeSetElement(mySet, 20);
  print(mySet); // {10}

  var myMap = {
    'a': 1,
    'b': 2,
  };
  updateMapValue(myMap, key: 'b', value: 3);
  print(myMap); // {'a': 1, 'b': 3}

  var employee = Employee('Tom', 20, 100);
  changeSalary(employee, 200);
  print(employee); // Employee{Tom, 20, 200}

  var str = 'Hello';
  stringUpdate(str, 'World');
  print(str); // Hello
}
