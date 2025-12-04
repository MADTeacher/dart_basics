

void main() {
  var myList = <int>[for (var i = 0; i<= 3; i++) i];
  for (var it in myList){    
    print(it); // 0  1  2  3
  }

  var mySet = <int>{1, 2, 5, 6, 7, 8};
  for (var it in mySet){    
    print(it); // 1  2  5  6  7  8
  }

}
