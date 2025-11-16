void main() {
  var myList = [
    <int, String>{1: 'Oo', 2: '-_-'},
    <int, int>{1: 1},
    <String, double>{'^_^': 3.14, "(╯'□')╯︵ ┻━┻": 0.000001},
    <String, dynamic>{
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
    },
  ];

    for (var element in myList) {
    switch (element) {
      case {1: 'Oo', 2: String smile}:
        print('Full match with $smile');
      case {"(╯'□')╯︵ ┻━┻": double zero}:
        print("(╯'□')╯︵ ┻━┻");
      case {
          'employee': {
            'name': String name,
            'boss': {
              'name': String bossName,
              'idEmployees': List<int> idEmployees
            },
          },
        }:
        print('employee: $name, boss: $bossName, idEmployees: $idEmployees');
      default:
        print('No match');
    }
  }
}

