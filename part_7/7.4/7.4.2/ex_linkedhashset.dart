import 'dart:io';

void main() {
  final mySet = <int>{}; // экземпляр LinkedHashSet

  mySet.addAll([1, 3, 3, 5, 6, 2, 1, 7, 9, -2]);
  print(mySet);
  print(mySet.last);
  print(mySet.first);

  mySet.remove(9);
  print(mySet);

  print(mySet.where((it) => it % 2 == 0).toSet());
  print(mySet.where((it) => it > 0).toSet());

  for(var it in mySet){
    stdout.write('$it ');
  }
}
