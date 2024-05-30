import 'dart:collection';

void main() {
  final Map<String, String> myHashMap = HashMap(
    equals: (String a, String b) => a == b,
    hashCode: (String key) => key.hashCode,
    isValidKey: (dynamic key) {
      if (key is String) {
        return key.startsWith('A');
      }
      return false;
    },
  );

  myHashMap['Alice'] = 'Developer';
  myHashMap['Bob'] = 'Designer';
  myHashMap['Anna'] = 'Manager';

  // Проверяем, содержатся ли ключи с таким значением
  print(myHashMap.containsKey('Alice')); // true
  print(myHashMap.containsKey('Bob')); // false
  print(myHashMap.containsKey('Anna')); // true
  print(myHashMap.containsKey(123)); // false

  // Использование оператора [] для доступа к элементам.
  print(myHashMap['Alice']); // Developer
  print(myHashMap['Bob']); // null
  print(myHashMap); // {Bob: Designer, Alice: Developer, Anna: Manager}
}