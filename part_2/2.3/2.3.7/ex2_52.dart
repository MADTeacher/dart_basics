void main() {
  var myList = [
    [1, 2, 3],
    [3, 2, 3, 4, 5],
    [7, 2, 3, 4, 5, 8],
    [7, 4, 3, 4, 5, 8, 9],
  ];

  var myStr = '';
  for (var element in myList) {
    switch (element) {
      case [1 || 3 || 7, 2 || 4, ...]: 
        myStr += '5 ';
      case [1, ..., 3]:
        myStr += '3 ';
      case [..., 9]:
      case [...]: // список любой длины
        myStr += '0 ';
    }
  }

  print(myStr); // 5 5 5 5 
}
