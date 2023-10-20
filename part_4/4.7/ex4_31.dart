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
    Builder('Alex', 22, 1, 2000, 1, 1),
    Plumber('John', 27, 4, 9000, 3),
    Builder('Max', 33, 2, 12000, 10, 3),
    Plumber('Kate', 23, 4, 9000, 3),
  ];

  for (var it in listEmployee){
    if (it is Plumber){
      it.salaryDown(10);
    }
    if (it is Builder){
      it.salaryUp(10);
    }
    print(it);
  }
}


