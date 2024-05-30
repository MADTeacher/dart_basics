import 'dart:collection';

void main() {
  // создание экземпляра SplayTreeMap и
  // его приведение к интерфейсу Map<K,V>
  final Map<int, String> mySplayTreeMap = SplayTreeMap();
  // по умолчанию узлы дерева сортируются по возрастанию ключа

  mySplayTreeMap[1] = 'one';
  mySplayTreeMap[2] = 'two';
  mySplayTreeMap[3] = 'three';
  mySplayTreeMap[33] = '??';

  print(mySplayTreeMap[1]); // one
  mySplayTreeMap[1] = '11';
  print(mySplayTreeMap[1]); // 11

  print(mySplayTreeMap); // {1: 11, 2: two, 3: three, 33: ??}

  mySplayTreeMap.remove(1);
  print(mySplayTreeMap); // {2: two, 3: three, 33: ??}

  for (var MapEntry(:key, :value) in mySplayTreeMap.entries) {
    print('key: $key, value: $value');
  }
  // key: 2, value: two
  // key: 3, value: three
  // key: 33, value: ??
}
