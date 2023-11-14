void main() {
  var myList = <int>[];
  for (var i = 0; i <= 4; i++) {
    myList.add(i);
  }
  print(myList); // [0, 1, 2, 3, 4]

  for (var i = 4; i >= 0; i--) {
    myList.add(i);
  }
  print(myList); // [0, 1, 2, 3, 4, 4, 3, 2, 1, 0]
}
