void main() {
  var myList = <int>[0, 1, 2, 3, 4, 4, 3, 2, 1, 0];
  var sum = 0;
  for (var i = 0; i < myList.length; i++) {
    sum += myList[i];
  }

  print('sum: $sum'); // 20
}
