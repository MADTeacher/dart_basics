extension MyList on List<int> {
  int sum() {
    return reduce((value, element) => value + element);
  }

  int count(int value){
    return where((element) => element == value).length;
  }
}


void main(List<String> arguments) {
  var myList = [1, 2, 3, 4, 3, 5, 3];
  print(myList.sum()); // 21
  print(myList.count(3)); // 3
}
