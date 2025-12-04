void main() {
  var myList = [
    [],
    [1],
    [1, 2, 3],
    [1, 2, 3, 4, 5],
  ];

  var myStr = '';
  for (var element in myList) {
    switch (element) {
      case [1]:
        myStr += '1 ';
      case [1, 2, 3]:
        myStr += '3 ';
      case []:
        myStr += '0 ';
      default:
        myStr += '! ';
    }
  }

  print(myStr); // 0 1 3 ! 
}
