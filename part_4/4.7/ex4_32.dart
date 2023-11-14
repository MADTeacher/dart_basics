class Employee {
  final String name;
  final int id;
  int _age;
  int _salary;
  int _yearsExperience;

  Employee(
    this.name,
    this._age,
    this.id,
    this._salary,
    this._yearsExperience,
  );

  Employee.named({
    required String name,
    required int age,
    required int id,
    required int salary,
    required int yearsExperience,
  }) : this(name, age, id, salary, yearsExperience);

  factory Employee.createChild({
    required String name,
    required int age,
    required int id,
    required int salary,
    required int yearsExperience,
    required int typeChild,
  }) {
    return switch (typeChild) {
      1 => Builder(
          name,
          age,
          id,
          salary,
          yearsExperience,
          (yearsExperience ~/ 3) == 0 ? 1 : (yearsExperience ~/ 3),
        ),
      _ => Plumber(name, age, id, salary, yearsExperience),
    };
  }

  int get salary => _salary;
  int get age => _age;
  int get experience => _yearsExperience;

  void ageIncrease() {
    _age++;
  }

  void yearsExperienceIncrease() {
    _yearsExperience++;
  }

  void salaryDown(int percent) {
    // увеличиваем оклад
    _salary -= ((_salary / 100) * percent).toInt();
  }

  void salaryUp(int percent) {
    // уменьшаем оклад
    _salary += ((_salary / 100) * percent).toInt();
  }

  @override
  String toString() {
    return 'Employee($name, $age, $id, $_salary)';
  }
}

class Plumber extends Employee { // наследование
  Plumber(
    super.name,
    super.age,
    super.id,
    super.salary,
    super.yearsExperience,
  );


  Plumber.withMinSalary({
    required super.name,
    required super.age,
    required super.id,
    required super.yearsExperience,
  }) : super.named(salary: 1000);

  @override
  String toString() {
    return 'Plumber($name, $age, $id, $_salary)';
  }
}

class Builder extends Employee { // наследование
  int _category;

  Builder(
    super.name,
    super.age,
    super.id,
    super.salary,
    super.yearsExperience,
    this._category,
  );

  Builder.withMinSalary({
    required super.name,
    required super.age,
    required super.id,
    required super.yearsExperience,
    required int category,
  })  : _category = category,
        super.named(salary: 3000);
  
  int get category => _category;
  
  @override
  void salaryDown(int percent) {
    // штрафуем сотрудника
    super.salaryDown(percent);
    _category--;
  }

  @override
  void salaryUp(int percent) {
    // премируем сотрудника
    super.salaryUp(percent);
    _category++;
  }

  @override
  String toString() {
    return 'Builder($name, $age, $id, $_salary, $_category)';
  }
}


void main() {
  var listEmployee = <Employee>[
    Employee.createChild(
      name: 'Alex',
      age: 22,
      id: 1,
      salary: 2000,
      yearsExperience: 1,
      typeChild: 1,
    ),
    Employee.createChild(
      name: 'John',
      age: 27,
      id: 4,
      salary: 9000,
      yearsExperience: 10,
      typeChild: 2,
    ),
  ];

  for (var it in listEmployee) {
    if (it is Plumber) {
      it.salaryDown(10);
    }
    if (it is Builder) {
      it.salaryUp(10);
    }
    print(it);
  }
}



