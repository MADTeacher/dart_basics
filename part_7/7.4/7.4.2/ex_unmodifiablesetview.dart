import 'dart:collection';

void main() {
  final originalSet = <String>{'Alice', 'Bob'};

  // Создание неизменяемого представления
  var unmodifiableSet = UnmodifiableSetView(originalSet);

  try {
    unmodifiableSet.remove('Alice');
  } on UnsupportedError catch (e) {
    print(e.message);
  } 

  originalSet.add('Tommy');
  print(unmodifiableSet);

  originalSet.remove('Alice');
  print(unmodifiableSet);
}
