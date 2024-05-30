import 'dart:collection';
import 'dart:io';

void main() {
  Set<int> mySet = SplayTreeSet();
  // по умолчанию элементы сортируются по возрастанию
  mySet.addAll([1, 3, 3, 5, 6, 2, 1, 7, 9, -2]);
  print(mySet);
  print(mySet.last);
  print(mySet.first);
  for (var it in mySet) {
    stdout.write('$it ');
  }
  stdout.write('\n');

  mySet = SplayTreeSet(
    (key1, key2) => key2.compareTo(key1),
  );
  mySet.addAll([1, 3, 3, 5, 6, 2, 1, 7, 9, -2]);
  print(mySet);
  print(mySet.last);
  print(mySet.first);

  for (var it in mySet) {
    stdout.write('$it ');
  }
}
