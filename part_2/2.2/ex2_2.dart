void main() {
  // Dart 2
  final myList = [1, 2];
  var a = myList[0];
  var b = myList[1];
  print('a: $a, b: $b'); // a: 1, b: 2

  // Dart 3
  var [a1, b1] = myList; // или final [a1, b1] = myList;
  print('a1: $a1, b1: $b1'); // a1: 1, b2: 2
}
