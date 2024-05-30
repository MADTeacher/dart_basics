void main() {
  final Map<String, int> myMap = {}; // экземпляр LinkedHashMap
  myMap['one'] = 1;
  myMap['two'] = 2;
  myMap['three'] = 3;

  print(myMap['one']); // 1
  myMap['one'] = 11;
  print(myMap['one']); // 11

  print(myMap); // {one: 11, two: 2, three: 3}

  myMap.remove('one');
  print(myMap); // {two: 2, three: 3}

  for (var MapEntry(:key, :value) in myMap.entries) {
    print('key: $key, value: $value');
  }
  // key: two, value: 2
  // key: three, value: 3
}
