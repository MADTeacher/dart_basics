void main(List<String> arguments) {
  Map<String, List<int>> myMap = {
    'first': [1, 2, 3],
    'second': [4, 5, 6],
  };

  var {'first': [a, _, b]} = myMap;
  print('a: $a, b: $b'); // a: 1, b: 3

  Map<int, Map<String, int>> myMap2 = {
    1: {'a': 1, 'b': 2},
    2: {'c': 3, 'd': 4},
  };

  var {1: {'a': c, 'b': d}} = myMap2;
  print('c: $c, d: $d'); // c: 1, d: 2
}
