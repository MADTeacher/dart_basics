void main() {
  var myList = [
    [],
    [3],
    [1, 5, 3],
    [1, 2, 3, 4, 5],
  ];

  var myStr = '';
  for (var element in myList) {
    switch (element) {
      case [_]:
        myStr += '1 ';
      case [1, _, 3]:
        myStr += '3 ';
      case [_, _, _, 4, 5]:
        myStr += '0 ';
      default:
        myStr += '! ';
    }
  }

  print(myStr); // ! 1 3 0
}
