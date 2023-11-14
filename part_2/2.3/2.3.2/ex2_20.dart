void main() {
  List<int> myList = [1, 2, 3];

  if (myList case [int x, int y]){
    print('2 значения $x и $y');
  } else if (myList case [int x, ..., int y]){
    print('3 и более значений'); // 3 и более значений
  }

  myList = [1, 2];
  if (myList case [int x, int y]){
    print('2 значения $x и $y'); // 2 значения 1 и 2
  }
}
