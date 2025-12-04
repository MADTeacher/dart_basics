class Employee {
  final String name;
  final int age;
  final int salary;

  Employee(this.name, this.age, this.salary);
}

class Cat {
  final String name;
  final int age;

  Cat(this.name, this.age);
}

void main() {
  dynamic obj = Employee('John', 30, 1000);

  if (obj case Cat(:String name, : int age)) {
    print('Cat name is $name, age is $age');
  }

  if (obj case Employee(:String name, : int age, : int salary)) {
    print('Employee name is $name, age is $age, salary is $salary');
  } // Employee name is John, age is 30, salary is 1000

  if (obj case Employee(:String name)) {
    print('Employee name is $name'); // Employee name is John
  }

  obj = Cat('Tom', 20);
  if (obj case Employee(:String name, : int age)) {
    print('Employee name is $name, age is $age');
  }

  if (obj case Cat(:String name, : int age)) {
    print('Cat name is $name, age is $age'); // Cat name is Tom, age is 20
  }
}
