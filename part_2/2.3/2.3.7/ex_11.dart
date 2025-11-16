void main() {
  var myList = [
    [],
    [3],
    [1, 5, 3],
    [1, 2, 3, 4, 5],
    [7, 2, 3, 4, 5, 8],
    [7, 2, 3, 4, 5, 8, 9],
  ];

  var myStr = '';
  for (var element in myList) {
    switch (element) {
      case [...]: // список любой длины
        myStr += '0 ';
      case [1, 2, ..., _]: 
        myStr += '5 ';
      case [1, ..., 3]:
        myStr += '3 ';
      case [..., 9]:
        myStr += '7 ';
      case [7, ...]:
        myStr += '6 '; 
    }
  }

  print(myStr); // 0 0 0 0 0 0
}
