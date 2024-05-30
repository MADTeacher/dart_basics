import 'dart:collection';

void main() {
  final Map<int, String> mySplayTreeMap = SplayTreeMap(
    (key1, key2) => key2.compareTo(key1), 
  );

  mySplayTreeMap[1] = 'one';
  mySplayTreeMap[2] = 'two';
  mySplayTreeMap[3] = 'three';
  mySplayTreeMap[33] = '??';

  print(mySplayTreeMap); // {33: ??, 3: three, 2: two, 1: 11}

  mySplayTreeMap.remove(1);
  print(mySplayTreeMap); // {33: ??, 3: three, 2: two}

  for (var MapEntry(:key, :value) in mySplayTreeMap.entries) {
    print('key: $key, value: $value');
  }
  // key: 33, value: ??
  // key: 3, value: three
  // key: 2, value: two
}
