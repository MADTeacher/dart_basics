import 'dart:collection';

void main() {
  // создание экземпляра HashMap и
  // его приведение к интерфейсу Map<K,V>
  final Map<String, int> myHashMap = HashMap();
  myHashMap['one'] = 1;
  myHashMap['two'] = 2;
  myHashMap['three'] = 3;

  print(myHashMap['one']); // 1
  myHashMap['one'] = 11;
  print(myHashMap['one']); // 11

  print(myHashMap); // {three: 3, one: 11, two: 2}

  myHashMap.remove('one');
  print(myHashMap); // {three: 3, two: 2}

  for (var MapEntry(:key, :value) in myHashMap.entries) {
    print('key: $key, value: $value');
  }
  // key: three, value: 3
  // key: two, value: 2
}
