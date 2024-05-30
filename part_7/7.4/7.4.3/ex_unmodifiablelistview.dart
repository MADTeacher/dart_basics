import 'dart:collection';

void main() {
  final originalList = <int>[2, 4, 6, 8];

  // Создание неизменяемого представления
  var unmodifiableList = UnmodifiableListView(originalList);

  try {
    unmodifiableList.remove(2);
  } on UnsupportedError catch (e) {
    print(e.message);
  } 

  try {
    unmodifiableList[0] = 3;
  } on UnsupportedError catch (e) {
    print(e.message);
  } 

  originalList.add(2);
  print(unmodifiableList);

  originalList[0] = 1;
  print(unmodifiableList);
}
