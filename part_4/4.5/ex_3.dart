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
  var builder = Builder.withMinSalary(
    name: 'Ivan',
    age: 30,
    id: 1,
    yearsExperience: 7,
    category: 2,
  );

  var plumber = Plumber.withMinSalary(
    name: 'Max',
    age: 22,
    id: 4,
    yearsExperience: 1,
  );

  print(builder); // Builder(Ivan, 30, 1, 3000, 2)
  print(plumber); // Plumber(Max, 22, 4, 1000)

  Employee employee = builder; // неявное приведение к Employee
  print(employee); // Builder(Ivan, 30, 1, 3000, 2)
  employee.salaryDown(50);
  print(builder); // Builder(Ivan, 30, 1, 1500, 1)

  // проверка на тип объекта
  if (employee is Plumber){
    print(employee); // ничего не выведет
  }

  if (employee is Builder){
    // появляется доступ к полям и методам Builder
    print(employee.category); // 1
  }

  employee = plumber as Employee; // явное приведение к Employee
  print(employee); // Plumber(Max, 22, 4, 1000)

  var employee2 = plumber as Employee;
  employee2.salaryUp(30);
  print(employee2); // Plumber(Max, 22, 4, 1300)
}

