class Plumber {
  final String name;
  final int id;
  int _age;
  int _salary;
  int _yearsExperience;

  Plumber(
    this.name,
    this._age,
    this.id,
    this._salary,
    this._yearsExperience,
  );

  Plumber.withMinSalary(
    this.name,
    this._age,
    this.id,
    this._yearsExperience,
  ) : _salary = 1000;

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
    // штрафуем сотрудника
    _salary -= ((_salary / 100) * percent).toInt();
  }

  void salaryUp(int percent) {
    // премируем сотрудника
    _salary += ((_salary / 100) * percent).toInt();
  }

  @override
  String toString() {
    return 'Plumber($name, $age, $id, $_salary)';
  }
}

class Builder {
  final String name;
  final int id;
  int _age;
  int _salary;
  int _yearsExperience;
  int _category;

  Builder(
    this.name,
    this._age,
    this.id,
    this._salary,
    this._yearsExperience,
    this._category,
  );

  Builder.withMinSalary(
    this.name,
    this._age,
    this.id,
    this._yearsExperience,
    this._category,
  ) : _salary = 1000;

  int get salary => _salary;
  int get age => _age;
  int get experience => _yearsExperience;
  int get category => _category;

  void ageIncrease() {
    _age++;
  }

  void yearsExperienceIncrease() {
    _yearsExperience++;
  }

  void salaryDown(int percent) {
    // штрафуем сотрудника
    _salary -= ((_salary / 100) * percent).toInt();
    _category--;
  }

  void salaryUp(int percent) {
    // премируем сотрудника
    _salary += ((_salary / 100) * percent).toInt();
    _category++;
  }

  @override
  String toString() {
    return 'Builder($name, $age, $id, $_salary, $_category)';
  }
}
