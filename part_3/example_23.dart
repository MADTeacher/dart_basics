Iterable<int> myGenerator(int n) sync* {
  var k = 0;
  while(k < n){
    if (k % 4 == 0){
      yield k;
    }
    k++;
  }
}

void main(List<String> arguments) {
  var result = <int>[];
  var it = myGenerator(20);
  it.forEach((element) {result.add(element);});
  var result1 = it.toList();
  print(result); // [0, 4, 8, 12, 16]
  print(result1); // [0, 4, 8, 12, 16]
}
