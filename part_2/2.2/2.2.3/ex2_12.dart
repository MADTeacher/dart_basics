void main(List<String> arguments) {
  Map<String, dynamic> myMap = {
    'person1': ['Alex', 22],
    'person2': ['Max', 52],
    'employee': {
      'name': 'John',
      'age': 25,
      'salary': 1000,
      'boss': {
        'name': 'Alex',
        'idEmployees': [1, 2, 3],
      }
    },
  };

  var {'person1': [name, age]} = myMap;
  print('person1: $name, age: $age'); // person1: Alex, age: 22

  var {
    'employee': {
      'name': empName,
      'age': empAge,
      'salary': empsalary,
      'boss': {
        'name': bossName,
      },
    }
  } = myMap;
  print(
      'employee: $empName, age: $empAge, salary: $empsalary, boss: $bossName');
  // employee: John, age: 25, salary: 1000, boss: Alex

  var {'employee': {'boss': {'idEmployees': [...ids]}}} = myMap;
  print('ids: $ids'); // ids: [1, 2, 3]
}
