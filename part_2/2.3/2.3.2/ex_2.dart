void main() {
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

  if (myMap case {'person1': [String name, int age]}) {
    print('person1: $name, age: $age'); // person1: Alex, age: 22
  }

  if (myMap
      case {
        'employee': {
          'name': String empName,
          'age': int empAge,
          'salary': int empsalary,
          'boss': {
            'name': String bossName,
          },
        }
      }) {
    print(
      'employee: $empName, age: $empAge, salary: $empsalary, boss: $bossName',
    );
    // employee: John, age: 25, salary: 1000, boss: Alex
  }

  if (myMap case {'employee': {'boss': {'idEmployees': List<int> ids}}}) {
    print('ids: $ids'); // ids: [1, 2, 3]
  }

  if (myMap case {'person2': [String name, String age]}) {
    print('person1: $name, age: $age'); // person1: Alex, age: 22
  } else{
    print('Ошибка вышла =('); // Ошибка вышла =(
  }
}
